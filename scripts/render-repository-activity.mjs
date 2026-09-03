#!/usr/bin/env node

import { spawnSync } from "node:child_process";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { basename, dirname, resolve } from "node:path";

const DAY_MS = 24 * 60 * 60 * 1000;

function fail(message) {
  process.stderr.write(`repository activity: ${message}\n`);
  process.exit(2);
}

function parseArgs(argv) {
  const values = {
    gitDir: process.cwd(),
    now: new Date(),
    output: "",
    repo: process.env.GITHUB_REPOSITORY || basename(process.cwd()),
    weeks: 12,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const name = argv[index];
    const value = argv[index + 1];

    if (!["--git-dir", "--now", "--output", "--repo", "--weeks"].includes(name)) {
      fail(`unknown argument: ${name}`);
    }
    if (value === undefined) {
      fail(`missing value for ${name}`);
    }

    if (name === "--git-dir") values.gitDir = value;
    if (name === "--now") values.now = new Date(value);
    if (name === "--output") values.output = value;
    if (name === "--repo") values.repo = value;
    if (name === "--weeks") values.weeks = Number(value);
    index += 1;
  }

  if (!values.output) fail("--output is required");
  if (!Number.isInteger(values.weeks) || values.weeks < 4 || values.weeks > 26) {
    fail("--weeks must be an integer from 4 to 26");
  }
  if (Number.isNaN(values.now.getTime())) fail("--now must be a valid date");
  if (!values.repo.trim()) fail("--repo must not be empty");

  values.gitDir = resolve(values.gitDir);
  values.output = resolve(values.output);
  return values;
}

function git(gitDir, args, { allowFailure = false } = {}) {
  const result = spawnSync("git", ["-C", gitDir, ...args], {
    encoding: "utf8",
    env: { ...process.env, LC_ALL: "C" },
  });

  if (result.status !== 0) {
    if (allowFailure) return "";
    const detail = (result.stderr || result.stdout || "git command failed").trim();
    fail(detail);
  }
  return result.stdout.trim();
}

function startOfUtcWeek(date) {
  const result = new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  );
  const daysSinceMonday = (result.getUTCDay() + 6) % 7;
  result.setUTCDate(result.getUTCDate() - daysSinceMonday);
  return result;
}

function shiftDays(date, days) {
  return new Date(date.getTime() + days * DAY_MS);
}

function isoDate(date) {
  return date.toISOString().slice(0, 10);
}

function shortDate(date) {
  return `${String(date.getUTCMonth() + 1).padStart(2, "0")}/${String(
    date.getUTCDate(),
  ).padStart(2, "0")}`;
}

function escapeXml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

function readActivity({ gitDir, now, weeks }) {
  git(gitDir, ["rev-parse", "--git-dir"]);
  const hasHead = Boolean(
    git(gitDir, ["rev-parse", "--verify", "HEAD"], { allowFailure: true }),
  );
  const currentWeek = startOfUtcWeek(now);
  const windowStart = shiftDays(currentWeek, -(weeks - 1) * 7);
  const counts = Array.from({ length: weeks }, () => 0);

  if (!hasHead) {
    return { counts, lastDate: null, windowStart };
  }

  const history = git(gitDir, [
    "log",
    "--first-parent",
    "--format=%cI",
    `--since=${windowStart.toISOString()}`,
    `--until=${now.toISOString()}`,
  ]);

  for (const line of history.split("\n").filter(Boolean)) {
    const committedAt = new Date(line);
    const bucket = Math.floor((committedAt.getTime() - windowStart.getTime()) / (7 * DAY_MS));
    if (bucket >= 0 && bucket < weeks) counts[bucket] += 1;
  }

  const lastDateText = git(gitDir, ["log", "-1", "--first-parent", "--format=%cI"]);
  return {
    counts,
    lastDate: lastDateText ? new Date(lastDateText) : null,
    windowStart,
  };
}

function renderSvg({ activity, repo, weeks }) {
  const width = 1000;
  const height = 280;
  const chartLeft = 52;
  const chartRight = 948;
  const chartBottom = 218;
  const slot = (chartRight - chartLeft) / weeks;
  const barWidth = Math.max(16, slot - 16);
  const maxCount = Math.max(1, ...activity.counts);
  const total = activity.counts.reduce((sum, count) => sum + count, 0);
  const activeWeeks = activity.counts.filter((count) => count > 0).length;
  const repoLabel = repo.replaceAll("/", " / ");
  const lastUpdate = activity.lastDate
    ? `Last update ${isoDate(activity.lastDate)} UTC`
    : "No commits yet";

  const bars = activity.counts
    .map((count, index) => {
      const week = shiftDays(activity.windowStart, index * 7);
      const ratio = count / maxCount;
      const barHeight = count === 0 ? 5 : Math.max(14, Math.round(ratio * 82));
      const x = chartLeft + index * slot + (slot - barWidth) / 2;
      const y = chartBottom - barHeight;
      const opacity = count === 0 ? 1 : (0.48 + ratio * 0.52).toFixed(2);
      const fill = count === 0
        ? "#d8d2c4"
        : index === weeks - 1
          ? "#c66a45"
          : "#3f7964";
      const dateLabel = index % 2 === 0 || index === weeks - 1 ? shortDate(week) : "";

      return `
        <g>
          <title>Week of ${isoDate(week)}: ${count} update${count === 1 ? "" : "s"}</title>
          <rect x="${x.toFixed(1)}" y="${y}" width="${barWidth.toFixed(1)}" height="${barHeight}" rx="6" fill="${fill}" opacity="${opacity}"/>
          <text x="${(x + barWidth / 2).toFixed(1)}" y="${chartBottom + 18}" text-anchor="middle" class="count">${count}</text>
          ${dateLabel ? `<text x="${(x + barWidth / 2).toFixed(1)}" y="${chartBottom + 38}" text-anchor="middle" class="date">${dateLabel}</text>` : ""}
        </g>`;
    })
    .join("");

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="title description">
  <title id="title">${escapeXml(repoLabel)} repository activity</title>
  <desc id="description">${total} first-parent updates across ${activeWeeks} active weeks in a rolling ${weeks}-week window.</desc>
  <style>
    text { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    .eyebrow { fill: #6b6a62; font-size: 15px; font-weight: 650; letter-spacing: 1.2px; }
    .title { fill: #17251f; font-size: 30px; font-weight: 720; }
    .meta { fill: #4f5d55; font-size: 16px; }
    .count { fill: #39473f; font-size: 12px; font-weight: 650; }
    .date { fill: #77766d; font-size: 11px; }
    .foot { fill: #77766d; font-size: 12px; }
  </style>
  <rect x="1" y="1" width="998" height="278" rx="22" fill="#f7f4ec" stroke="#d9d3c5" stroke-width="2"/>
  <text x="52" y="42" class="eyebrow">REPOSITORY ACTIVITY</text>
  <text x="52" y="78" class="title">${escapeXml(repoLabel)}</text>
  <text x="948" y="45" text-anchor="end" class="meta">${total} update${total === 1 ? "" : "s"} · ${activeWeeks} of ${weeks} active weeks</text>
  <text x="948" y="75" text-anchor="end" class="meta">${escapeXml(lastUpdate)}</text>
  <line x1="52" y1="218" x2="948" y2="218" stroke="#cec7b8" stroke-width="1"/>
  ${bars}
  <text x="52" y="266" class="foot">Rolling first-parent Git history · activity shows maintenance, not scientific validity</text>
</svg>
`;
}

const options = parseArgs(process.argv.slice(2));
const activity = readActivity(options);
const svg = renderSvg({ activity, repo: options.repo, weeks: options.weeks });

mkdirSync(dirname(options.output), { recursive: true });
let previous = "";
try {
  previous = readFileSync(options.output, "utf8");
} catch {
  // A first render has no previous asset.
}
if (previous !== svg) writeFileSync(options.output, svg, "utf8");

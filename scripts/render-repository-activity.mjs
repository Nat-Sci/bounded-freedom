#!/usr/bin/env node

import { spawnSync } from "node:child_process";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { basename, dirname, resolve } from "node:path";

const DAY_MS = 24 * 60 * 60 * 1000;
const MONTH_NAMES = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];

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
    maxBars: 18,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const name = argv[index];
    const value = argv[index + 1];

    if (!["--git-dir", "--now", "--output", "--repo", "--max-bars"].includes(name)) {
      fail(`unknown argument: ${name}`);
    }
    if (value === undefined) {
      fail(`missing value for ${name}`);
    }

    if (name === "--git-dir") values.gitDir = value;
    if (name === "--now") values.now = new Date(value);
    if (name === "--output") values.output = value;
    if (name === "--repo") values.repo = value;
    if (name === "--max-bars") values.maxBars = Number(value);
    index += 1;
  }

  if (!values.output) fail("--output is required");
  if (!Number.isInteger(values.maxBars) || values.maxBars < 8 || values.maxBars > 24) {
    fail("--max-bars must be an integer from 8 to 24");
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

function startOfUtcDay(date) {
  const result = new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  );
  return result;
}

function shiftDays(date, days) {
  return new Date(date.getTime() + days * DAY_MS);
}

function isoDate(date) {
  return date.toISOString().slice(0, 10);
}

function displayDate(date, includeYear = false) {
  const base = `${MONTH_NAMES[date.getUTCMonth()]} ${date.getUTCDate()}`;
  return includeYear ? `${base}, ${date.getUTCFullYear()}` : base;
}

function rangeLabel(start, end) {
  if (start.getUTCFullYear() === end.getUTCFullYear()) {
    return `${displayDate(start)} → ${displayDate(end, true)} · UTC`;
  }
  return `${displayDate(start, true)} → ${displayDate(end, true)} · UTC`;
}

function chooseBucketDays(totalDays, maxBars) {
  const usefulIntervals = [1, 7, 14, 28, 91, 182, 365];
  return usefulIntervals.find((days) => Math.ceil(totalDays / days) <= maxBars)
    || Math.ceil(totalDays / maxBars);
}

function intervalName(bucketDays) {
  if (bucketDays === 1) return "day";
  if (bucketDays === 7) return "week";
  if (bucketDays === 14) return "2-week period";
  if (bucketDays === 28) return "4-week period";
  return `${bucketDays}-day period`;
}

function escapeXml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

function readActivity({ gitDir, now, maxBars }) {
  git(gitDir, ["rev-parse", "--git-dir"]);
  const hasHead = Boolean(
    git(gitDir, ["rev-parse", "--verify", "HEAD"], { allowFailure: true }),
  );
  const throughDate = startOfUtcDay(now);

  if (!hasHead) {
    return {
      bucketDays: 1,
      counts: [0],
      firstDate: null,
      lastDate: null,
      throughDate,
      windowStart: throughDate,
    };
  }

  const history = git(gitDir, [
    "log",
    "--first-parent",
    "--format=%cI",
    `--until=${now.toISOString()}`,
  ]).split("\n").filter(Boolean).map((line) => new Date(line));

  if (history.length === 0) {
    return {
      bucketDays: 1,
      counts: [0],
      firstDate: null,
      lastDate: null,
      throughDate,
      windowStart: throughDate,
    };
  }

  const firstDate = history.at(-1);
  const lastDate = history[0];
  const windowStart = startOfUtcDay(firstDate);
  const totalDays = Math.floor((throughDate.getTime() - windowStart.getTime()) / DAY_MS) + 1;
  const bucketDays = chooseBucketDays(totalDays, maxBars);
  const bucketCount = Math.ceil(totalDays / bucketDays);
  const counts = Array.from({ length: bucketCount }, () => 0);

  for (const committedAt of history) {
    const bucket = Math.floor(
      (committedAt.getTime() - windowStart.getTime()) / (bucketDays * DAY_MS),
    );
    if (bucket >= 0 && bucket < bucketCount) counts[bucket] += 1;
  }

  return {
    bucketDays,
    counts,
    firstDate,
    lastDate,
    throughDate,
    windowStart,
  };
}

function renderSvg({ activity, repo }) {
  const width = 1000;
  const height = 270;
  const chartLeft = 52;
  const chartRight = 948;
  const chartBottom = 190;
  const bucketCount = activity.counts.length;
  const slot = (chartRight - chartLeft) / bucketCount;
  const barWidth = Math.max(14, Math.min(54, slot - 10));
  const maxCount = Math.max(1, ...activity.counts);
  const total = activity.counts.reduce((sum, count) => sum + count, 0);
  const activeBuckets = activity.counts.filter((count) => count > 0).length;
  const interval = intervalName(activity.bucketDays);
  const activeUnit = activity.bucketDays === 1 ? "day" : interval;
  const repoLabel = repo.replaceAll("/", " / ");
  const summary = activity.firstDate
    ? `${total} main update${total === 1 ? "" : "s"} · ${activeBuckets} active ${activeUnit}${activeBuckets === 1 ? "" : "s"}`
    : "No main updates yet";
  const dateRange = activity.firstDate
    ? rangeLabel(activity.windowStart, activity.throughDate)
    : `As of ${displayDate(activity.throughDate, true)} · UTC`;
  const startLabel = activity.firstDate
    ? `FIRST COMMIT · ${displayDate(activity.windowStart).toUpperCase()}`
    : "NO COMMITS YET";
  const throughLabel = `AS OF · ${displayDate(activity.throughDate).toUpperCase()}`;

  const bars = activity.counts
    .map((count, index) => {
      const periodStart = shiftDays(activity.windowStart, index * activity.bucketDays);
      const nominalEnd = shiftDays(periodStart, activity.bucketDays - 1);
      const periodEnd = nominalEnd > activity.throughDate ? activity.throughDate : nominalEnd;
      const ratio = count / maxCount;
      const barHeight = count === 0 ? 4 : Math.max(14, Math.round(ratio * 72));
      const x = chartLeft + index * slot + (slot - barWidth) / 2;
      const y = chartBottom - barHeight;
      const opacity = count === 0 ? 1 : (0.48 + ratio * 0.52).toFixed(2);
      const fill = count === 0
        ? "#d8d2c4"
        : index === bucketCount - 1
          ? "#c66a45"
          : "#3f7964";
      const titleRange = isoDate(periodStart) === isoDate(periodEnd)
        ? isoDate(periodStart)
        : `${isoDate(periodStart)} through ${isoDate(periodEnd)}`;

      return `
        <g>
          <title>${titleRange}: ${count} main update${count === 1 ? "" : "s"}</title>
          <rect x="${x.toFixed(1)}" y="${y}" width="${barWidth.toFixed(1)}" height="${barHeight}" rx="6" fill="${fill}" opacity="${opacity}"/>
          ${count > 0 ? `<text x="${(x + barWidth / 2).toFixed(1)}" y="${y - 8}" text-anchor="middle" class="count">${count}</text>` : ""}
        </g>`;
    })
    .join("");

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="title description">
  <title id="title">${escapeXml(repoLabel)} repository activity</title>
  <desc id="description">${total} first-parent updates from ${isoDate(activity.windowStart)} through ${isoDate(activity.throughDate)}, grouped by ${escapeXml(interval)}.</desc>
  <style>
    text { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    .eyebrow { fill: #6b6a62; font-size: 15px; font-weight: 650; letter-spacing: 1.2px; }
    .title { fill: #17251f; font-size: 30px; font-weight: 720; }
    .meta { fill: #4f5d55; font-size: 16px; }
    .count { fill: #39473f; font-size: 12px; font-weight: 650; }
    .axis { fill: #77766d; font-size: 11px; font-weight: 650; letter-spacing: 0.5px; }
    .foot { fill: #77766d; font-size: 12px; }
  </style>
  <rect x="1" y="1" width="998" height="268" rx="22" fill="#f7f4ec" stroke="#d9d3c5" stroke-width="2"/>
  <text x="52" y="42" class="eyebrow">REPOSITORY ACTIVITY</text>
  <text x="52" y="78" class="title">${escapeXml(repoLabel)}</text>
  <text x="948" y="45" text-anchor="end" class="meta">${escapeXml(summary)}</text>
  <text x="948" y="75" text-anchor="end" class="meta">${escapeXml(dateRange)}</text>
  <line x1="52" y1="190" x2="948" y2="190" stroke="#cec7b8" stroke-width="1"/>
  ${bars}
  <text x="52" y="215" class="axis">${escapeXml(startLabel)}</text>
  <text x="500" y="215" text-anchor="middle" class="axis">${escapeXml(interval.toUpperCase())} INTERVALS</text>
  <text x="948" y="215" text-anchor="end" class="axis">${escapeXml(throughLabel)}</text>
  <text x="52" y="250" class="foot">First-parent history on main · activity is not a measure of research quality</text>
</svg>
`;
}

const options = parseArgs(process.argv.slice(2));
const activity = readActivity(options);
const svg = renderSvg({ activity, repo: options.repo });

mkdirSync(dirname(options.output), { recursive: true });
let previous = "";
try {
  previous = readFileSync(options.output, "utf8");
} catch {
  // A first render has no previous asset.
}
if (previous !== svg) writeFileSync(options.output, svg, "utf8");

#!/usr/bin/env node

import { spawnSync } from "node:child_process";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";

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
    repo: process.env.GITHUB_REPOSITORY || "Repository",
    maxBars: 18,
    ref: "HEAD",
    timeZone: "UTC",
  };

  for (let index = 0; index < argv.length; index += 1) {
    const name = argv[index];
    const value = argv[index + 1];

    if (![
      "--git-dir", "--now", "--output", "--repo", "--max-bars", "--ref", "--time-zone",
    ].includes(name)) {
      fail(`unknown argument: ${name}`);
    }
    if (value === undefined) fail(`missing value for ${name}`);

    if (name === "--git-dir") values.gitDir = value;
    if (name === "--now") values.now = new Date(value);
    if (name === "--output") values.output = value;
    if (name === "--repo") values.repo = value;
    if (name === "--max-bars") values.maxBars = Number(value);
    if (name === "--ref") values.ref = value;
    if (name === "--time-zone") values.timeZone = value;
    index += 1;
  }

  if (!values.output) fail("--output is required");
  if (!Number.isInteger(values.maxBars) || values.maxBars < 8 || values.maxBars > 24) {
    fail("--max-bars must be an integer from 8 to 24");
  }
  if (Number.isNaN(values.now.getTime())) fail("--now must be a valid date");
  if (!values.repo.trim()) fail("--repo must not be empty");

  try {
    new Intl.DateTimeFormat("en-US", { timeZone: values.timeZone }).format(values.now);
  } catch {
    fail("--time-zone must be a valid IANA time zone");
  }

  values.gitDir = resolve(values.gitDir);
  values.output = resolve(values.output);
  return values;
}

function runGit(gitDir, args) {
  return spawnSync("git", ["-C", gitDir, ...args], {
    encoding: "utf8",
    env: { ...process.env, LC_ALL: "C" },
  });
}

function git(gitDir, args, operation) {
  const result = runGit(gitDir, args);
  if (result.status !== 0) fail(`unable to ${operation}`);
  return result.stdout.trim();
}

function zonedDate(date, timeZone) {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(date);
  const fields = Object.fromEntries(parts
    .filter(({ type }) => type !== "literal")
    .map(({ type, value }) => [type, value]));

  return new Date(Date.UTC(
    Number(fields.year),
    Number(fields.month) - 1,
    Number(fields.day),
  ));
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

function rangeLabel(start, end, timeZone) {
  if (start.getUTCFullYear() === end.getUTCFullYear()) {
    return `${displayDate(start)} → ${displayDate(end, true)} · ${timeZone}`;
  }
  return `${displayDate(start, true)} → ${displayDate(end, true)} · ${timeZone}`;
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

function resolveSource({ gitDir, ref }) {
  git(gitDir, ["rev-parse", "--git-dir"], "read the Git repository");

  const resolved = runGit(gitDir, [
    "rev-parse",
    "--verify",
    "--end-of-options",
    `${ref}^{commit}`,
  ]);
  if (resolved.status === 0) return resolved.stdout.trim();

  const noHeadCommit = runGit(gitDir, [
    "rev-parse",
    "--verify",
    "--quiet",
    "HEAD^{commit}",
  ]).status !== 0;
  if (ref === "HEAD" && noHeadCommit) return null;

  fail(`unable to resolve --ref ${JSON.stringify(ref)} to a commit`);
}

function readActivity({ gitDir, now, maxBars, ref, timeZone }) {
  const sourceSha = resolveSource({ gitDir, ref });
  const nowDate = zonedDate(now, timeZone);

  if (!sourceSha) {
    return {
      bucketDays: 1,
      counts: [0],
      firstDate: null,
      lastDate: null,
      throughDate: nowDate,
      windowStart: nowDate,
      sourceSha: null,
    };
  }

  const history = git(gitDir, ["log", "--format=%cI", sourceSha], "read commit history")
    .split("\n")
    .filter(Boolean)
    .map((line) => zonedDate(new Date(line), timeZone));
  const firstDate = history.reduce(
    (earliest, date) => date < earliest ? date : earliest,
    history[0],
  );
  const lastDate = history.reduce(
    (latest, date) => date > latest ? date : latest,
    history[0],
  );
  const throughDate = lastDate > nowDate ? lastDate : nowDate;
  const windowStart = firstDate;
  const totalDays = Math.floor(
    (throughDate.getTime() - windowStart.getTime()) / DAY_MS,
  ) + 1;
  const bucketDays = chooseBucketDays(totalDays, maxBars);
  const bucketCount = Math.ceil(totalDays / bucketDays);
  const counts = Array.from({ length: bucketCount }, () => 0);

  for (const committedDate of history) {
    const bucket = Math.floor(
      (committedDate.getTime() - windowStart.getTime()) / (bucketDays * DAY_MS),
    );
    counts[bucket] += 1;
  }

  return {
    bucketDays,
    counts,
    firstDate,
    lastDate,
    throughDate,
    windowStart,
    sourceSha,
  };
}

function renderSvg({ activity, repo, now, timeZone }) {
  const width = 1000;
  const height = 300;
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
    ? `${total} commit${total === 1 ? "" : "s"} · ${activeBuckets} active ${activeUnit}${activeBuckets === 1 ? "" : "s"}`
    : "No commits yet";
  const dateRange = activity.firstDate
    ? rangeLabel(activity.windowStart, activity.throughDate, timeZone)
    : `As of ${displayDate(activity.throughDate, true)} · ${timeZone}`;
  const startLabel = activity.firstDate
    ? `EARLIEST DATE · ${displayDate(activity.windowStart).toUpperCase()}`
    : "NO COMMITS YET";
  const throughLabel = `THROUGH · ${displayDate(activity.throughDate).toUpperCase()}`;
  const sourceLabel = activity.sourceSha ? activity.sourceSha.slice(0, 12) : "none";
  const generatedAt = now.toISOString().replace(".000Z", "Z");

  const bars = activity.counts.map((count, index) => {
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
          <title>${titleRange}: ${count} commit${count === 1 ? "" : "s"}</title>
          <rect x="${x.toFixed(1)}" y="${y}" width="${barWidth.toFixed(1)}" height="${barHeight}" rx="6" fill="${fill}" opacity="${opacity}"/>
          ${count > 0 ? `<text x="${(x + barWidth / 2).toFixed(1)}" y="${y - 8}" text-anchor="middle" class="count">${count}</text>` : ""}
        </g>`;
  }).join("");

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="title description">
  <title id="title">${escapeXml(repoLabel)} repository activity</title>
  <desc id="description">${total} commits reachable from ${activity.sourceSha || "no source"}, from ${isoDate(activity.windowStart)} through ${isoDate(activity.throughDate)}, grouped by ${escapeXml(interval)} using committer-date ${escapeXml(timeZone)} civil dates.</desc>
  <style>
    text { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    .eyebrow { fill: #6b6a62; font-size: 15px; font-weight: 650; letter-spacing: 1.2px; }
    .title { fill: #17251f; font-size: 30px; font-weight: 720; }
    .meta { fill: #4f5d55; font-size: 16px; }
    .count { fill: #39473f; font-size: 12px; font-weight: 650; }
    .axis { fill: #77766d; font-size: 11px; font-weight: 650; letter-spacing: 0.5px; }
    .foot { fill: #77766d; font-size: 12px; }
  </style>
  <rect x="1" y="1" width="998" height="298" rx="22" fill="#f7f4ec" stroke="#d9d3c5" stroke-width="2"/>
  <text x="52" y="42" class="eyebrow">REPOSITORY ACTIVITY</text>
  <text x="52" y="78" class="title">${escapeXml(repoLabel)}</text>
  <text x="948" y="45" text-anchor="end" class="meta">${escapeXml(summary)}</text>
  <text x="948" y="75" text-anchor="end" class="meta">${escapeXml(dateRange)}</text>
  <line x1="52" y1="190" x2="948" y2="190" stroke="#cec7b8" stroke-width="1"/>${bars}
  <text x="52" y="215" class="axis">${escapeXml(startLabel)}</text>
  <text x="500" y="215" text-anchor="middle" class="axis">${escapeXml(interval.toUpperCase())} INTERVALS</text>
  <text x="948" y="215" text-anchor="end" class="axis">${escapeXml(throughLabel)}</text>
  <text x="52" y="248" class="foot">Source · ${sourceLabel} · all reachable commits</text>
  <text x="948" y="248" text-anchor="end" class="foot">Generated · ${generatedAt} (UTC)</text>
  <text x="52" y="272" class="foot">Date basis · committer-date ${escapeXml(timeZone)} civil calendar · activity is not a measure of research quality</text>
</svg>
`;
}

const options = parseArgs(process.argv.slice(2));
const activity = readActivity(options);
const svg = renderSvg({
  activity,
  repo: options.repo,
  now: options.now,
  timeZone: options.timeZone,
});

try {
  mkdirSync(dirname(options.output), { recursive: true });
  let previous = "";
  try {
    previous = readFileSync(options.output, "utf8");
  } catch {
    // A first render has no previous asset.
  }
  if (previous !== svg) writeFileSync(options.output, svg, "utf8");
} catch {
  fail("unable to write output");
}

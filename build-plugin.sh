#!/usr/bin/env bash
#
# Rebuilds the bundled Qualtrics MCP server that ships inside the plugin.
#
# Run this after merging changes from upstream (yrvelez/qualtrics-mcp-server),
# then commit the updated plugins/qualtrics/dist/qualtrics-mcp.mjs and bump the
# version in both .claude-plugin/marketplace.json and
# plugins/qualtrics/.claude-plugin/plugin.json so the team receives the update.
#
# Usage:  bash scripts/build-plugin.sh
#
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Installing dependencies"
npm install --no-audit --no-fund

echo "==> Bundling server to a single file"
npx -y esbuild@0.24 src/index.ts \
  --bundle \
  --platform=node \
  --target=node22 \
  --format=esm \
  --outfile=plugins/qualtrics/dist/qualtrics-mcp.mjs \
  --banner:js="import{createRequire}from'module';const require=createRequire(import.meta.url);"

echo "==> Smoke testing the bundle"
QUALTRICS_API_TOKEN=smoketest \
QUALTRICS_DATA_CENTER=yul1 \
QUALTRICS_READ_ONLY=true \
node -e '
const {spawn} = require("child_process");
const p = spawn("node", ["plugins/qualtrics/dist/qualtrics-mcp.mjs"], { env: process.env });
let out = "";
p.stdout.on("data", d => out += d);
p.stdin.write(JSON.stringify({jsonrpc:"2.0",id:1,method:"initialize",params:{protocolVersion:"2024-11-05",capabilities:{},clientInfo:{name:"build",version:"1"}}}) + "\n");
setTimeout(() => p.stdin.write(JSON.stringify({jsonrpc:"2.0",id:2,method:"tools/list"}) + "\n"), 800);
setTimeout(() => {
  let tools = 0;
  for (const line of out.trim().split("\n").filter(Boolean)) {
    try { const j = JSON.parse(line); if (j.id === 2) tools = j.result?.tools?.length ?? 0; } catch {}
  }
  p.kill();
  if (tools > 0) { console.log(`    OK: server started and exposed ${tools} tools`); process.exit(0); }
  console.error("    FAILED: server did not list any tools"); process.exit(1);
}, 3500);
'

echo
echo "Done. Bundle written to plugins/qualtrics/dist/qualtrics-mcp.mjs"
echo "Remember to bump the version in both .claude-plugin files before publishing."

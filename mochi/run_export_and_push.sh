#!/bin/bash
set -e

cd /Users/williamguffey/workspace/cross/mochi || exit 1
source /Users/williamguffey/workspace/cross/mochi-venv/bin/activate

# 1. Run exporter (JSON lands in ./public_site/stats)
python -m mochi_analytics.export_stats

# 2. Push that JSON to website repo
cd public_site        # this is a git clone of your website repo
git add stats/mochi_daily.json
if ! git diff --cached --quiet; then
  git config user.name  "mochi bot"
  git config user.email "bot@example.com"
  git commit -m "Update Mochi stats $(date '+%Y-%m-%d')"
  git push https://$PAGES_PAT@github.com/you/your-website.git main
fi

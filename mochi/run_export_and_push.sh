#!/bin/bash
set -e
{
  echo
  echo "$(date '+%Y-%m-%d %H:%M:%S')  —  running run_export_and_push.sh"
} >> export.log

cd /Users/williamguffey/workspace/cross/mochi || exit 1
source ~/.mochi_env
source /Users/williamguffey/.pyenv/versions/mochi-venv/bin/activate

/Users/williamguffey/miniconda3/bin/poetry run mochi-export 2>&1 | /opt/homebrew/bin/ts '[%Y-%m-%d %H:%M:%S]' >> export.log

cd ~/workspace/wguffey-website
git add stats/mochi_daily.json
if ! git diff --cached --quiet; then
  git config user.name  "mochi bot"
  git config user.email "guffeywilliam@gmail.com"
  git commit -m "Update Mochi stats $(date '+%Y-%m-%d')"
  git push "https://$WEBSITE_PAT@github.com/wguffey/wguffey-website.git" main
  git fetch -p
fi

#!/bin/bash
set -e
{
  echo
  echo "$(date '+%Y-%m-%d %H:%M:%S')  —  running run_mochi_etl.sh"
} >> etl.log

cd /Users/williamguffey/workspace/cross/mochi || exit 1
source ~/.mochi_env
source /Users/williamguffey/.pyenv/versions/mochi-venv/bin/activate

/Users/williamguffey/miniconda3/bin/poetry run mochi-etl 2>&1 | /opt/homebrew/bin/ts '[%Y-%m-%d %H:%M:%S]' >> etl.log

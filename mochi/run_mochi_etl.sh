#!/bin/bash
cd /Users/williamguffey/workspace/cross/mochi || exit 1

# find Poetry once
POETRY_BIN=$(command -v poetry)
if [[ -z $POETRY_BIN ]]; then
  echo "Poetry not found in PATH" >&2
  exit 2
fi

# echo "$(date '+%Y-%m-%d %H:%M:%S')  —  cron launch" >> etl.log
{
  echo                          # <── adds a newline
  echo "$(date '+%Y-%m-%d %H:%M:%S')  —  cron launch"
} >> etl.log

"$POETRY_BIN" run mochi-etl >> etl.log 2>&1

#!/bin/bash
cd /Users/williamguffey/workspace/cross/mochi || exit 1
/opt/homebrew/bin/poetry run mochi-etl >> etl.log 2>&1

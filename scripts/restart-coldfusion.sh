#!/bin/bash
set -euo pipefail

CF_BIN=/opt/coldfusion2025/cfusion/bin
LOG_FILE=/var/log/coldfusion-restart.log

nohup "${CF_BIN}/coldfusion" restart 
</dev/null >>"${LOG_FILE}" 2>&1 &

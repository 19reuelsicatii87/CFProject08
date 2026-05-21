#!/bin/bash
# CodeDeploy ApplicationStart hook — paths match cf-ec2-instance-commands.txt
set -euo pipefail

CF_HOME=/opt/coldfusion2025
CF_WEBROOT="${CF_HOME}/cfusion/wwwroot"
CF_BIN="${CF_HOME}/cfusion/bin"
CODEDEPLOY_STAGING=/opt/codedeploy/cf-app
CF_RESTART_LOG=/var/log/cf-codedeploy-restart.log

# Copy ColdBox app from CodeDeploy staging into ColdFusion wwwroot (not appspec/scripts)
rsync -a --delete \
  --exclude 'appspec.yml' \
  --exclude 'scripts/' \
  "${CODEDEPLOY_STAGING}/" "${CF_WEBROOT}/"

chown -R cf_svc:cf_svc "${CF_WEBROOT}"

# CodeDeploy hooks must close stdout/stderr on exit; CF restart can leave them open.
# Hook runs as root — no sudo. Restart is detached with fds redirected.
if [[ -x "${CF_BIN}/coldfusion" ]]; then
  nohup "${CF_BIN}/coldfusion" restart </dev/null >>"${CF_RESTART_LOG}" 2>&1 &
fi

exec 1>&- 2>&-

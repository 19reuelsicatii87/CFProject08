#!/bin/bash
# CodeDeploy ApplicationStart hook — paths match cf-ec2-instance-commands.txt
set -euo pipefail

CF_HOME=/opt/coldfusion2025
CF_WEBROOT="${CF_HOME}/cfusion/wwwroot"
CF_BIN="${CF_HOME}/cfusion/bin"
CODEDEPLOY_STAGING=/opt/codedeploy/cf-app

# Copy ColdBox app from CodeDeploy staging into ColdFusion wwwroot (not appspec/scripts)
rsync -a --delete \
  --exclude 'appspec.yml' \
  --exclude 'scripts/' \
  "${CODEDEPLOY_STAGING}/" "${CF_WEBROOT}/"

chown -R cf_svc:cf_svc "${CF_WEBROOT}"
sudo "${CF_BIN}/coldfusion" restart

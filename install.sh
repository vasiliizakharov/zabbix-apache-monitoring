#!/usr/bin/env bash
# Idempotent installer for zabbix-apache-monitoring.
# Author: Vasilii Zakharov <vasiliiazakharov@gmail.com>

set -euo pipefail

if ! id zabbix >/dev/null 2>&1; then
  echo "ERROR: user 'zabbix' not found. Install zabbix-agent(2) first." >&2
  exit 1
fi

CONF_DIR=/etc/zabbix/zabbix_agentd.d
SCRIPT_DIR=/usr/local/bin
SELF=$(cd "$(dirname "$0")" && pwd)

install -d -m 0755 "$CONF_DIR"
install -m 0644 "$SELF/userparameter_apache.conf" -t "$CONF_DIR/"
install -m 0755 "$SELF/scripts/zbx_apache_scoreboard.sh" -t "$SCRIPT_DIR/"

if systemctl restart zabbix-agent2 2>/dev/null; then
  echo "Restarted zabbix-agent2"
elif systemctl restart zabbix-agent 2>/dev/null; then
  echo "Restarted zabbix-agent"
else
  echo "WARNING: could not restart any zabbix agent service" >&2
fi

cat <<'NOTE'

Make sure mod_status is enabled and reachable on 127.0.0.1:

    <Location /server-status>
        SetHandler server-status
        Require local
    </Location>
    ExtendedStatus On

Then:

    zabbix_get -s 127.0.0.1 -k 'apache.busy_workers[127.0.0.1]'

NOTE

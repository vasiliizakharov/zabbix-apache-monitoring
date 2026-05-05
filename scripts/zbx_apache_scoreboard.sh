#!/usr/bin/env bash
# Counts scoreboard slots in a given state.
# Usage: zbx_apache_scoreboard.sh <host:port> <slot-letter>
# Author: Vasilii Zakharov <vasiliiazakharov@gmail.com>

set -euo pipefail

endpoint="${1:-127.0.0.1}"
slot="${2:-W}"

if [[ ${#slot} -ne 1 ]]; then
  echo 0
  exit 0
fi

board=$(curl -s -f -m 5 "http://${endpoint}/server-status?auto" 2>/dev/null | awk -F': ' '/^Scoreboard:/{print $2}')

[[ -z "$board" ]] && { echo 0; exit 0; }

# Count occurrences of the requested character.
echo -n "$board" | tr -cd "$slot" | wc -c

#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTS_FILE="${1:-$SCRIPT_DIR/tomcat_hosts.txt}"
SSH_USER="${SSH_USER:-devops}"
SSH_OPTS=(-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)

if [[ ! -f "$HOSTS_FILE" ]]; then
  echo "Hosts file not found: $HOSTS_FILE" >&2
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  trimmed="${line%%#*}"
  trimmed="${trimmed//[[:space:]]/}"

  [[ -z "$trimmed" ]] && continue

  if [[ "$trimmed" == *"@"* ]]; then
    target="$trimmed"
  else
    target="$SSH_USER@$trimmed"
  fi

  echo "============================================================"
  echo "Deploying Tomcat setup to $target"
  echo "============================================================"

  scp "${SSH_OPTS[@]}" "$SCRIPT_DIR/tomcat_setup.sh" "$SCRIPT_DIR/tomcat_rpm.sh" "$SCRIPT_DIR/tomcat_ubuntu.sh" "$target:/tmp/"
  ssh "${SSH_OPTS[@]}" "$target" 'sudo bash /tmp/tomcat_setup.sh'
  ssh "${SSH_OPTS[@]}" "$target" 'sudo rm -f /tmp/tomcat_setup.sh /tmp/tomcat_rpm.sh /tmp/tomcat_ubuntu.sh'
done < "$HOSTS_FILE"

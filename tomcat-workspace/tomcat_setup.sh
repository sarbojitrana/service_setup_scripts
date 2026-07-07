#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v yum >/dev/null 2>&1; then
  bash "$SCRIPT_DIR/tomcat_rpm.sh"
elif command -v apt-get >/dev/null 2>&1; then
  bash "$SCRIPT_DIR/tomcat_ubuntu.sh"
else
  echo "Unsupported operating system. Expected yum or apt-get." >&2
  exit 1
fi

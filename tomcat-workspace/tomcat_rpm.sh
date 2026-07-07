#!/bin/bash
set -euo pipefail

TOMCAT_VERSION="${TOMCAT_VERSION:-9.0.95}"
TOMCAT_USER="${TOMCAT_USER:-tomcat}"
TOMCAT_HOME="/opt/tomcat"
TOMCAT_INSTALL_DIR="${TOMCAT_HOME}/apache-tomcat-${TOMCAT_VERSION}"
TOMCAT_ARCHIVE="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_URL="${TOMCAT_URL:-https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/${TOMCAT_ARCHIVE}}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

require_root() {
  if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo." >&2
    exit 1
  fi
}

install_java() {
  if ! command -v java >/dev/null 2>&1; then
    log "Installing OpenJDK for RPM-based systems"
    yum install -y java-17-openjdk-devel wget tar >/dev/null
  else
    log "Java is already available"
  fi
}

create_tomcat_user() {
  if ! id "$TOMCAT_USER" >/dev/null 2>&1; then
    log "Creating tomcat system user"
    useradd --system --create-home --home-dir "$TOMCAT_HOME" --shell /bin/bash "$TOMCAT_USER"
  fi
}

install_tomcat() {
  mkdir -p "$TOMCAT_HOME"
  cd "$TOMCAT_HOME"

  if [[ ! -d "$TOMCAT_INSTALL_DIR" ]]; then
    log "Downloading Tomcat ${TOMCAT_VERSION}"
    wget -q "$TOMCAT_URL" -O "$TOMCAT_ARCHIVE"
    tar -xzf "$TOMCAT_ARCHIVE"
    rm -f "$TOMCAT_ARCHIVE"
  else
    log "Tomcat ${TOMCAT_VERSION} is already installed"
  fi

  chown -R "$TOMCAT_USER":"$TOMCAT_USER" "$TOMCAT_HOME"
  chmod +x "$TOMCAT_INSTALL_DIR/bin"/*.sh
}

create_systemd_service() {
  JAVA_BIN="$(command -v java)"
  JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$JAVA_BIN")")")"

  cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking
User=$TOMCAT_USER
Group=$TOMCAT_USER
Environment=JAVA_HOME=$JAVA_HOME
Environment=CATALINA_PID=$TOMCAT_INSTALL_DIR/temp/tomcat.pid
Environment=CATALINA_HOME=$TOMCAT_INSTALL_DIR
Environment=CATALINA_BASE=$TOMCAT_INSTALL_DIR
ExecStart=$TOMCAT_INSTALL_DIR/bin/startup.sh
ExecStop=$TOMCAT_INSTALL_DIR/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable tomcat >/dev/null 2>&1 || true
}

start_tomcat() {
  log "Starting Tomcat service"
  systemctl start tomcat >/dev/null 2>&1 || true
  systemctl status tomcat --no-pager | head -20 || true
}

main() {
  require_root
  install_java
  create_tomcat_user
  install_tomcat
  create_systemd_service
  start_tomcat
  log "Tomcat setup completed"
}

main "$@"

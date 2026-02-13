#!/usr/bin/env bash
set -euo pipefail

# Show all databases and dump all rows from users table in DB_NAME

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$ROOT_DIR/.env" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$ROOT_DIR/.env"
  set +a
fi

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-}"
DB_SOCKET="${DB_SOCKET:-/var/run/mysqld/mysqld.sock}"

mysql_args=(
  --protocol=TCP
  --host="$DB_HOST"
  --port="$DB_PORT"
  --user="$DB_USER"
  --connect-timeout=5
  --default-character-set=utf8mb4
)

env_prefix=()
if [ -n "$DB_PASSWORD" ]; then
  env_prefix=(env "MYSQL_PWD=$DB_PASSWORD")
fi

run_mysql_tcp() {
  "${env_prefix[@]}" mysql "${mysql_args[@]}" "$@"
}

run_mysql_socket() {
  sudo mysql --protocol=SOCKET --socket="$DB_SOCKET" "$@"
}

run_mysql() {
  run_mysql_tcp "$@"
}

show_all() {
  echo "== Databases =="
  run_mysql -e "SHOW DATABASES;"

  if [ -n "$DB_NAME" ]; then
    echo "== Tables in $DB_NAME =="
    run_mysql "$DB_NAME" -e "SHOW TABLES;"

    echo "== Data from $DB_NAME.users =="
    run_mysql "$DB_NAME" -e "SELECT * FROM users;"
  else
    echo "DB_NAME is empty. Set it in .env to show table data."
  fi
}

# Decide auth method without printing errors
if ! run_mysql_tcp -e "SELECT 1;" >/dev/null 2>&1; then
  if [ "$DB_USER" = "root" ]; then
    echo "WARN: TCP auth failed for root; using socket auth with sudo..." >&2
    run_mysql() { run_mysql_socket "$@"; }
  else
    echo "ERROR: Cannot connect to MySQL with TCP credentials." >&2
    exit 1
  fi
fi

show_all

#!/usr/bin/env bash
set -euo pipefail

# Create users table in DB_NAME
# Columns: id (auto), name, email, address

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

if [ -z "$DB_NAME" ]; then
  echo "ERROR: DB_NAME is required. Set it in .env or export DB_NAME=<name>" >&2
  exit 1
fi

mysql_args=(
  --protocol=TCP
  --host="$DB_HOST"
  --port="$DB_PORT"
  --user="$DB_USER"
  --connect-timeout=5
  --default-character-set=utf8mb4
  "$DB_NAME"
)

env_prefix=()
if [ -n "$DB_PASSWORD" ]; then
  env_prefix=(env "MYSQL_PWD=$DB_PASSWORD")
fi

create_sql=$(cat <<'SQL'
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
SQL
)

if ! "${env_prefix[@]}" mysql "${mysql_args[@]}" -e "$create_sql"; then
  if [ "$DB_USER" = "root" ]; then
    echo "WARN: TCP auth failed for root; trying socket auth with sudo..." >&2
    sudo mysql --protocol=SOCKET --socket="$DB_SOCKET" "$DB_NAME" -e "$create_sql"
  else
    exit 1
  fi
fi

echo "OK: users table is ready in $DB_NAME"

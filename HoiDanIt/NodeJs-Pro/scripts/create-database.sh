#!/usr/bin/env bash
set -euo pipefail

# Create MySQL database using values from .env (or env vars).
# Required: DB_NAME
# Optional: DB_HOST (default 127.0.0.1), DB_PORT (default 3306),
#           DB_USER (default root), DB_PASSWORD (default empty),
#           DB_SOCKET (default /var/run/mysqld/mysqld.sock)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load .env if present
if [[ -f "$ROOT_DIR/.env" ]]; then
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

if [[ -z "$DB_NAME" ]]; then
  echo "ERROR: DB_NAME is required. Set it in .env or export DB_NAME=<name>" >&2
  exit 1
fi

# Basic DB name validation: allow letters, numbers, underscore, dash.
# (MySQL allows more, but this prevents injection and surprise quoting issues.)
if [[ ! "$DB_NAME" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "ERROR: DB_NAME '$DB_NAME' contains invalid characters. Allowed: [A-Za-z0-9_-]" >&2
  exit 1
fi

# Build mysql command args
mysql_args=(
  --protocol=TCP
  --host="$DB_HOST"
  --port="$DB_PORT"
  --user="$DB_USER"
  --connect-timeout=5
  --default-character-set=utf8mb4
)

# Only set MYSQL_PWD if password is non-empty (avoid env var noise / edge behavior)
env_prefix=()
if [[ -n "$DB_PASSWORD" ]]; then
  env_prefix=(env "MYSQL_PWD=$DB_PASSWORD")
fi

# Create DB via TCP first
if ! "${env_prefix[@]}" mysql "${mysql_args[@]}" \
  --batch --skip-column-names \
  -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
then
  # Fallback for Ubuntu auth_socket (root via unix socket)
  if [[ "$DB_USER" == "root" ]]; then
    echo "WARN: TCP auth failed for root; trying socket auth with sudo..." >&2
    sudo mysql --protocol=SOCKET --socket="$DB_SOCKET" \
      --batch --skip-column-names \
      -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  else
    exit 1
  fi
fi

echo "OK: Database '$DB_NAME' is ready on ${DB_HOST}:${DB_PORT}"

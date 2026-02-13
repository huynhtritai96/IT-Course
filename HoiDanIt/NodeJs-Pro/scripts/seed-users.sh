#!/usr/bin/env bash
set -euo pipefail

# Insert fake users into DB_NAME.users
# Expects columns: id (auto), name, email, address

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
  echo "DB_NAME is required. Set it in .env or export DB_NAME=<name>" >&2
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
if [[ -n "$DB_PASSWORD" ]]; then
  env_prefix=(env "MYSQL_PWD=$DB_PASSWORD")
fi

seed_sql=$(cat <<'SQL'
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (name, email, address) VALUES
  ('Alice Nguyen', 'alice.nguyen@example.com', 'Hanoi'),
  ('Bao Tran', 'bao.tran@example.com', 'Ho Chi Minh City'),
  ('Chi Pham', 'chi.pham@example.com', 'Da Nang'),
  ('Duc Le', 'duc.le@example.com', 'Can Tho'),
  ('Emi Vo', 'emi.vo@example.com', 'Hai Phong'),
  ('Gia Bui', 'gia.bui@example.com', 'Hue'),
  ('Huy Dao', 'huy.dao@example.com', 'Nha Trang'),
  ('Ivy Phan', 'ivy.phan@example.com', 'Vung Tau'),
  ('Khanh Truong', 'khanh.truong@example.com', 'Bien Hoa'),
  ('Linh Ho', 'linh.ho@example.com', 'Quang Ninh'),
  ('Minh Nguyen', 'minh.nguyen@example.com', 'Bac Ninh'),
  ('Nga Tran', 'nga.tran@example.com', 'Da Lat'),
  ('Oanh Le', 'oanh.le@example.com', 'Binh Duong'),
  ('Phuc Vo', 'phuc.vo@example.com', 'Hai Duong'),
  ('Quang Pham', 'quang.pham@example.com', 'Thanh Hoa');
SQL
)

if ! "${env_prefix[@]}" mysql "${mysql_args[@]}" -e "$seed_sql"; then
  if [[ "$DB_USER" == "root" ]]; then
    echo "WARN: TCP auth failed for root; trying socket auth with sudo..." >&2
    sudo mysql --protocol=SOCKET --socket="$DB_SOCKET" "$DB_NAME" -e "$seed_sql"
  else
    exit 1
  fi
fi

echo "Seeded users into $DB_NAME.users"

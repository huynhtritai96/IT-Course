Here’s exactly what that command does and how to use it **properly** in a Node.js + MySQL setup (senior-dev view).

---

## 1. The command itself

```bash
npm i --save-exact mysql2@3.12.0
```

### Meaning, piece by piece

* `npm i` → install a package
* `mysql2` → MySQL client for Node.js (faster, Promise support)
* `@3.12.0` → **pin to this exact version**
* `--save-exact` → writes **exact version**, no `^` or `~`

### Result in `package.json`

```json
"dependencies": {
  "mysql2": "3.12.0"
}
```

✅ No accidental upgrades
✅ Reproducible builds
✅ Good for production & CI

---

## 2. When you SHOULD use `--save-exact`

* Backend services
* Production APIs
* Regulated or embedded environments
* You already tested that version

When you **shouldn’t**:

* Quick prototypes
* Throwaway scripts

---

## 3. Verify installation

```bash
npm ls mysql2
```

Expected:

```
└── mysql2@3.12.0
```

---

## 4. Basic usage (callback style)

```js
const mysql = require('mysql2');

const conn = mysql.createConnection({
  host: 'localhost',
  user: 'app_user',
  password: 'AppPass123!',
  database: 'app_db'
});

conn.query('SELECT 1 + 1 AS result', (err, rows) => {
  if (err) throw err;
  console.log(rows);
  conn.end();
});
```

---

## 5. Recommended usage (Promise API)

```js
const mysql = require('mysql2/promise');

async function main() {
  const conn = await mysql.createConnection({
    host: 'localhost',
    user: 'app_user',
    password: 'AppPass123!',
    database: 'app_db'
  });

  const [rows] = await conn.execute('SELECT NOW() AS now');
  console.log(rows);

  await conn.end();
}

main().catch(console.error);
```

✔ Cleaner
✔ `async/await`
✔ Easier error handling

---

## 6. Connection pool (production best practice)

```js
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'app_user',
  password: 'AppPass123!',
  database: 'app_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

async function getUsers() {
  const [rows] = await pool.query('SELECT * FROM users');
  return rows;
}

module.exports = pool;
```

---

## 7. Common pitfalls (important)

### ❌ Using root user

Don’t.

```text
root is for admin, not apps
```

### ❌ Not closing connections

Leads to:

```
ER_CON_COUNT_ERROR
```

### ❌ Mixing callbacks + promises

Pick one style.

---

## 8. MySQL auth compatibility (Ubuntu/MySQL 8)

If you see:

```
ER_NOT_SUPPORTED_AUTH_MODE
```

Fix MySQL user:

```sql
ALTER USER 'app_user'@'localhost'
IDENTIFIED WITH mysql_native_password
BY 'AppPass123!';
FLUSH PRIVILEGES;
```

`mysql2` fully supports MySQL 8, but legacy users can break.

---

## 9. Why `mysql2` (not `mysql`)?

| Feature             | mysql | mysql2 |
| ------------------- | ----- | ------ |
| Performance         | ❌     | ✅      |
| Promise API         | ❌     | ✅      |
| MySQL 8             | ⚠️    | ✅      |
| Actively maintained | ❌     | ✅      |

---

## TL;DR

* Your command is **correct and professional**
* `mysql2@3.12.0` + `--save-exact` = stable backend
* Use **Promise API + connection pool**
* Don’t use `root`
* Match MySQL auth plugin

If you want, I can:

* Wire this into **Express/NestJS**
* Show **transaction handling**
* Show **prepared statements vs execute**
* Benchmark vs C/MySQL client

Just say the next step.


---
## 1. Check MySQL status on Ubuntu
### Check service status (systemd)

```bash
sudo systemctl status mysql

● mysql.service - MySQL Community Server
     Loaded: loaded (/lib/systemd/system/mysql.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2026-02-09 08:02:26 PST; 11min ago <--------------
    Process: 921 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code=exited, status=0/SUCCESS)
   Main PID: 1185 (mysqld)
     Status: "Server is operational"
      Tasks: 37 (limit: 9365)
     Memory: 430.0M
     CGroup: /system.slice/mysql.service
             └─1185 /usr/sbin/mysqld

Feb 09 08:01:34 ubuntu systemd[1]: Starting MySQL Community Server...
Feb 09 08:02:26 ubuntu systemd[1]: Started MySQL Community Server.
```
Typical meanings:
* **active (running)** → MySQL is up
* **inactive / failed** → MySQL is down or crashed

### Start / Stop / Restart
```bash
sudo systemctl start mysql
sudo systemctl stop mysql
sudo systemctl restart mysql
```

### Check if MySQL is listening
```bash
ss -lntp | grep 3306

LISTEN    0         151              127.0.0.1:3306             0.0.0.0:*
LISTEN    0         70               127.0.0.1:33060            0.0.0.0:*
```

### Check version & connection
```sql
mysql --version
mysql -u root -p

mysql  Ver 8.0.42-0ubuntu0.20.04.1 for Linux on x86_64 ((Ubuntu))


mysql -u nodeapp  -p
Enter password: nodeapp123 <--------------------
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.42-0ubuntu0.20.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

---
## 2. How MySQL works (senior-level mental model)
Think of MySQL as **layers**, not just “a database”.
### High-level architecture

```sql
Client
  ↓
SQL Parser
  ↓
Optimizer
  ↓
Executor
  ↓
Storage Engine (InnoDB)
  ↓
Disk / Buffer Pool
```

### Key components you should know
#### 1️⃣ MySQL Server (mysqld)
* Handles **SQL parsing**
* Builds **execution plans**
* Manages **connections, threads, permissions**

#### 2️⃣ Storage Engine (InnoDB – default)
* Manages:
  * Tables
  * Indexes (B+Tree)
  * Transactions
  * Row-level locking
  * Crash recovery
* Uses **Redo Log + Undo Log** for ACID

#### 3️⃣ Buffer Pool (Performance critical)
* In-memory cache for:
  * Data pages
  * Index pages
* If data is in buffer pool → **fast**
* If not → disk I/O → **slow**

Check it:

```sql
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';

+-------------------------+-----------+
| Variable_name           | Value     |
+-------------------------+-----------+
| innodb_buffer_pool_size | 134217728 |
+-------------------------+-----------+
1 row in set (1.17 sec)
```

#### 4️⃣ Transactions & ACID
```sql
START TRANSACTION;
INSERT ...
COMMIT;
ROLLBACK;
```

Isolation levels:

```sql
SHOW VARIABLES LIKE 'transaction_isolation';

+-----------------------+-----------------+
| Variable_name         | Value           |
+-----------------------+-----------------+
| transaction_isolation | REPEATABLE-READ |
+-----------------------+-----------------+
1 row in set (0.00 sec)
```

-------------------------------------------------------------------------------

## Correct mental model (VERY IMPORTANT)
```sql
MySQL Server
 ├── Users (with passwords)
 │    └── nodeapp / nodeapp123
 │
 ├── Databases
 │    └── nodejspro1
 │
 └── Permissions
      └── nodeapp → nodejspro1.*
```

---
## Correct way to set password & access
### 1️⃣ Create user (THIS is where password is set)

```sql
sudo mysql

CREATE USER 'nodeapp'@'localhost'
IDENTIFIED BY 'user@test';
```
### 2️⃣ Create database
```sql
CREATE DATABASE nodejspro1
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

### 3️⃣ Grant access
```sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON nodejspro1.*
TO 'nodeapp'@'localhost';
```

### 4️⃣ Apply
```sql
FLUSH PRIVILEGES;
```

---
## Verify (important habit)
### Check user exists
```sql
SELECT user, host FROM mysql.user;
```

### Check grants
```sql
SHOW GRANTS FOR 'nodeapp'@'localhost';
```

Output: --------------------------------------------------------------
```sql
$ sudo mysql
[sudo] password for htritai: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.42-0ubuntu0.20.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE USER 'user_test'@'localhost'
    -> IDENTIFIED BY 'user@test';
Query OK, 0 rows affected (0.50 sec)

mysql> CREATE DATABASE nodejspro1_test
    ->   CHARACTER SET utf8mb4
    ->   COLLATE utf8mb4_unicode_ci;
Query OK, 1 row affected (0.11 sec)

mysql> GRANT SELECT, INSERT, UPDATE, DELETE
    -> ON nodejspro1.*
    -> TO 'user_test'@'localhost';
Query OK, 0 rows affected (0.06 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.16 sec)

mysql> SELECT user, host FROM mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| debian-sys-maint | localhost |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| nodeapp          | localhost |
| root             | localhost |
| user_test        | localhost |
+------------------+-----------+
7 rows in set (0.00 sec)

mysql> SHOW GRANTS FOR 'user_test'@'localhost';
+-----------------------------------------------------------------------------------+
| Grants for user_test@localhost                                                    |
+-----------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `user_test`@`localhost`                                     |
| GRANT SELECT, INSERT, UPDATE, DELETE ON `nodejspro1`.* TO `user_test`@`localhost` |
+-----------------------------------------------------------------------------------+
2 rows in set (0.00 sec)

mysql> 
```

---------------------------------------------------------------
## 3. Create database & table (proper structure)
### Create database
```sql
CREATE DATABASE nodejspro1
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Use it:
```sql
USE nodejspro1;
```

---
### Production-style table (MATCHES your current data)

```sql
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(255),

    UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB;
```

✅ Matches:
* `id`
* `name`
* `email`
* `address`

---
## 4. Add an entry (INSERT)
### Simple insert

```sql
INSERT INTO users (name, email, address)
VALUES ('John Doe', 'john.doe@example.com', 'Hanoi');

Query OK, 1 row affected (0.00 sec)
```

### Insert multiple rows (better performance)
```sql
INSERT INTO users (name, email, address)
VALUES
  ('Alice Nguyen HI', 'aliceHi.nguyen@example.com', 'Hanoi'),
  ('Bao Tran HI', 'baoHi.tran@example.com', 'Ho Chi Minh City'),
  ('Chi Pham HI', 'chiHi.pham@example.com', 'Da Nang');

Query OK, 3 rows affected (0.45 sec)
Records: 3  Duplicates: 0  Warnings: 0
```

---
## 5. Verify data
```sql
SELECT * FROM users;
```

Result:
```sql
+----+-----------------+----------------------------+------------------+
| id | name            | email                      | address          |
+----+-----------------+----------------------------+------------------+
|  1 | Alice Nguyen    | alice.nguyen@example.com   | Hanoi            |
|  2 | Bao Tran        | bao.tran@example.com       | Ho Chi Minh City |
|  3 | Chi Pham        | chi.pham@example.com       | Da Nang          |
|  4 | Duc Le          | duc.le@example.com         | Can Tho          |
|  5 | Emi Vo          | emi.vo@example.com         | Hai Phong        |
|  6 | Gia Bui         | gia.bui@example.com        | Hue              |
|  7 | Huy Dao         | huy.dao@example.com        | Nha Trang        |
|  8 | Ivy Phan        | ivy.phan@example.com       | Vung Tau         |
|  9 | Khanh Truong    | khanh.truong@example.com   | Bien Hoa         |
| 10 | Linh Ho         | linh.ho@example.com        | Quang Ninh       |
| 11 | Minh Nguyen     | minh.nguyen@example.com    | Bac Ninh         |
| 12 | Nga Tran        | nga.tran@example.com       | Da Lat           |
| 13 | Oanh Le         | oanh.le@example.com        | Binh Duong       |
| 14 | Phuc Vo         | phuc.vo@example.com        | Hai Duong        |
| 15 | Quang Pham      | quang.pham@example.com     | Thanh Hoa        |
| 16 | Alice Nguyen HI | aliceHi.nguyen@example.com | Hanoi            |
| 17 | Bao Tran HI     | baoHi.tran@example.com     | Ho Chi Minh City |
| 18 | Chi Pham HI     | chiHi.pham@example.com     | Da Nang          |
| 19 | John Doe        | john.doe@example.com       | Hanoi            |
+----+-----------------+----------------------------+------------------+
```

---
## 6. Query with conditions
### Find one user by email

```sql
SELECT id, name, address
FROM users
WHERE email = 'alice.nguyen@example.com';

+----+--------------+---------+
| id | name         | address |
+----+--------------+---------+
|  1 | Alice Nguyen | Hanoi   |
+----+--------------+---------+
1 row in set (0.01 sec)
```

### Find users in a city
```sql
SELECT name, email
FROM users
WHERE address = 'Hanoi';

+--------------+--------------------------+
| name         | email                    |
+--------------+--------------------------+
| Alice Nguyen | alice.nguyen@example.com |
+--------------+--------------------------+
1 row in set (0.00 sec)
```

----------------------------------------------------------------------------
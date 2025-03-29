---
title: SQLite使用基础以及在R中操作数据库
author: Peng Chen
date: '2025-03-26'
slug: sqlite-r
categories:
  - R
  - utils
tags:
  - R
  - utils
  - database
description: 在生物信息学分析中经常会碰到db文件，掌握数据库的基本操作，不仅有助于数据存储，还能提高数据查询和处理的效率。
image: images/R-C.png
math: ~
license: ~
hidden: no
comments: yes
---

## Introduction

在生物信息学分析中，许多软件的中间文件或输出结果是数据库格式，例如 `.db` 文件。同时，很多生物数据库的存储和下载格式也是数据库格式。因此，掌握数据库的基本操作，不仅有助于数据存储，还能提高数据查询和处理的效率。

SQLite 是一款轻量级的嵌入式关系型数据库管理系统，它不需要单独的服务器进程，而是直接将数据库存储在单个文件中。SQLite 具有以下特点：

1. **零配置**：无需安装或管理，直接使用。
2. **跨平台**：支持 Windows、Linux、Mac 等主流操作系统。
3. **高性能**：对于单机应用场景，SQLite 处理速度比 MySQL 和 PostgreSQL 更快。
4. **小体积**：核心库只需几百 KB 内存，适用于资源受限的环境。

在数据分析领域，R 语言与 SQLite 结合可以带来以下优势：

- 处理超出内存限制的大型数据集。
- 实现数据的持久化存储。
- 利用 SQL 进行高效查询和数据操作。
- 便于不同编程语言之间的数据共享。

<img src="images/R-C.png" title=""/>

本文将介绍 SQLite 的基础使用方法，并讲解如何在 R 语言中操作 SQLite 数据库。

## SQLite 基础使用

SQLite 不需要单独安装，可以直接从[官网](https://sqlite.org/) <https://sqlite.org/>下载命令行工具，或者使用编程语言（如 Python、R）的 SQLite 接口。

SQLite 提供了一系列实用的点命令(dot commands)来管理数据库，这些命令以点(.)开头，下面介绍几个常用的命令：

### .open 命令
`.open` 命令用于打开或创建数据库文件：
- 语法：`.open 数据库文件名.db`
- 功能：
  - 如果指定的数据库文件不存在，则会创建一个新的数据库文件
  - 如果数据库已存在，则打开该数据库
- 示例：`.open test.db` 打开或创建test.db数据库

### .databases 命令
`.databases` 命令用于显示当前连接的数据库信息：
- 语法：`.databases`
- 功能：
  - 显示所有附加的数据库
  - 显示每个数据库的文件路径和名称
  - 主数据库通常名为"main"
- 示例输出：
  ```
  seq  name             file                                                      
  ---  ---------------  ----------------------------------------------------------
  0    main             /path/to/your/database.db
  ```

### 其他相关命令

1. `.exit` 命令
   - 语法：`.exit`
   - 功能：退出SQLite命令行界面

2. `.quit` 命令
   - 语法：`.quit`
   - 功能：与`.exit`相同，退出SQLite命令行界面

3. `.help` 命令
   - 语法：`.help`
   - 功能：显示所有可用的点命令及其简要说明

4. `.tables` 命令
   - 语法：`.tables [模式]`
   - 功能：列出当前数据库中的所有表，可选使用模式匹配

5. `.schema` 命令
   - 语法：`.schema [表名]`
   - 功能：显示表的创建语句(DDL)，不指定表名则显示所有表的创建语句

这些点命令为SQLite数据库的管理提供了便捷的操作方式，特别适合在命令行环境下使用。需要注意的是，这些命令不是标准SQL语句，而是SQLite特有的命令行工具命令。

#### 常用 SQL 语句

SQLite 几乎完全兼容常见的 SQL 语句规范，因此可以直接编写和执行标准的 SQL 语句。

标准 SQL (Structured Query Language) 语句具有以下主要特点：

1. 结构化与声明式
- **非过程化语言**：SQL 是声明式语言，用户只需指定"做什么"而非"如何做"
- **结构化语法**：由清晰的关键字、子句和表达式组成

2. 标准化
- **遵循 ANSI/ISO 标准**：有 SQL-86、SQL-89、SQL-92、SQL:1999、SQL:2003、SQL:2008、SQL:2011、SQL:2016 等多个标准版本
- **跨平台兼容**：基本语法在大多数关系型数据库中通用

3. 分类明确
SQL 语句主要分为几大类：

DDL (数据定义语言)
- 用于定义数据库结构
- 主要语句：`CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME`
- 示例：`CREATE TABLE employees (id INT, name VARCHAR(50));`

DML (数据操作语言)
- 用于操作数据
- 主要语句：`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `MERGE`
- 示例：`UPDATE employees SET salary = 5000 WHERE id = 101;`

DCL (数据控制语言)
- 用于权限控制
- 主要语句：`GRANT`, `REVOKE`, `DENY`
- 示例：`GRANT SELECT ON employees TO user1;`

TCL (事务控制语言)
- 用于事务管理
- 主要语句：`COMMIT`, `ROLLBACK`, `SAVEPOINT`, `SET TRANSACTION`
- 示例：`COMMIT;`

4. 语法特点
- **不区分大小写**：但通常关键字用大写，标识符用小写
- **使用分号结束**：多数数据库要求语句以分号(;)结尾
- **可嵌套子查询**：支持多层嵌套查询
- **支持注释**：单行(--)和多行(/* */)注释

5. 功能特点
- **强大的查询能力**：支持复杂条件、多表连接、聚合函数等
- **数据完整性保障**：支持主键、外键、约束等机制
- **事务支持**：ACID特性(原子性、一致性、隔离性、持久性)
- **视图支持**：可以创建虚拟表简化复杂查询


```sql
-- 创建表
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER,
    email TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入数据
INSERT INTO users (name, age, email) VALUES ('张三', 25, 'zhangsan@example.com');
INSERT INTO users (name, age, email) VALUES ('李四', 30, 'lisi@example.com');

-- 查询数据
SELECT * FROM users WHERE age > 20;
SELECT name, age FROM users ORDER BY age DESC LIMIT 5;
SELECT COUNT(*) FROM users;

-- 更新数据
UPDATE users SET age = 26 WHERE name = '张三';

-- 删除数据
DELETE FROM users WHERE id = 1;
```

#### SQLite 高级查询

```sql
-- 聚合查询
SELECT age, COUNT(*) FROM users GROUP BY age;

-- 多表连接查询
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    amount REAL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

SELECT users.name, orders.amount 
FROM users 
JOIN orders ON users.id = orders.user_id;
```

#### SQLite 导出表格


1. 使用 SQLite 命令行工具导出

导出为 CSV 格式
```bash
sqlite3 your_database.db
.headers on
.mode csv
.output data.csv
SELECT * FROM your_table;
.output stdout
```

2. 导出为 SQL 格式（包含表结构和数据）
```bash
sqlite3 your_database.db .dump your_table > output.sql
```

### 数据库管理工具

如果不习惯使用 SQL 语句操作数据库，可以使用可视化工具，如 **DB Browser for SQLite** 或 **SQLite Expert**，这些工具可以方便地：

1. 创建/删除数据库。
2. 设计表结构。
3. 执行 SQL 查询。
4. 导入/导出数据。

---

## 在 R 中操作 SQLite

在 R 语言中操作 SQLite 可以安装 `RSQLite` 和 `sqldf` 包：

```r
install.packages("RSQLite")
library(RSQLite)
install.packages("sqldf")
library(sqldf)
```

- `RSQLite`：提供 R 与 SQLite 之间的接口。
- `sqldf`：允许使用 SQL 查询 R 中的数据框。

#### 连接 SQLite 数据库

```r
# 创建/连接数据库
con <- dbConnect(SQLite(), "example.sqlite")

# 查看数据库中的表
dbListTables(con)

# 读取数据库中的表
dbReadTable(con, "table_name")
```

#### 写入数据

```r
# 创建数据框
df <- data.frame(
  id = 1:3,
  name = c("Alice", "Bob", "Charlie"),
  score = c(85, 92, 78)
)

# 写入数据库
dbWriteTable(con, "students", df, overwrite = TRUE)
```

#### 查询数据

```r
# 查询数据库内容
result <- dbGetQuery(con, "SELECT * FROM students WHERE score > 80")
print(result)

# 使用参数化查询防止 SQL 注入
query <- "SELECT * FROM students WHERE name = ?"
result <- dbGetQuery(con, query, params = list("Alice"))
```

### sqldf 直接查询

`sqldf` 允许直接使用 SQL 语句查询 R 数据框，而无需创建 SQLite 数据库。

```r
library(sqldf)

# 创建数据框
df <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(25, 30, 28),
  score = c(85, 92, 78)
)

# 直接使用 SQL 进行查询
result <- sqldf("SELECT name, score FROM df WHERE age > 26")
print(result)
```

### 关闭数据库连接

操作完成后，务必关闭数据库连接以释放资源：

```r
dbDisconnect(con)
```

SQLite 作为轻量级数据库，在数据存储和查询方面具有极高的灵活性。结合 R 语言的分析能力，可以实现高效的数据处理和自动化工作流。此外，`sqldf` 提供了一种在 R 语言环境下直接使用 SQL 查询数据框的方式，使得数据分析更加直观高效。

## References

1. https://cloud.tencent.com/developer/article/1938211
2. https://blog.51cto.com/u_16099343/13578231
3. https://blog.csdn.net/m0_73500130/article/details/142286358
4. https://www.5axxw.com/questions/simple/2jy747

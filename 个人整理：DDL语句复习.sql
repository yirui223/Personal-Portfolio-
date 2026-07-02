#------------------------------DDL语句操作数据库----------------------------------
#查看已创建的所有数据库
SHOW DATABASES;
#创建数据库
CREATE DATABASE IF NOT EXISTS TEST3 CHARSET 'gbk';
#查看某个指定的数据库的数据码表
SHOW CREATE DATABASE my_first_sql_database;
#删除数据库
DROP  DATABASE  my_first_sql_database;
#查看当前用的是哪个数据库
SELECT DATABASE();
#切换数据库
USE TEST3;
#修改数据库的码表
alter database TEST3 charset 'utf8';

#-----------------------------DDL语句， 操作数据表-------------------------------------
#1. 先切库
USE TEST3;
#查看当前数据库中所有表格
SHOW TABLES;
#创建数据表    （Control/command + enter 可以自动选择到当前写完的代码）
CREATE TABLE IF NOT EXISTS student(
    sid INT,
    name varchar(20),
    age INT,
    tmp1 int,
    tmp2 varchar(20),
    tmp3 double,
    tmp4 DATETIME
);
#修改数据表名: rename table 旧表名 to 新表明
rename table student to stu;
#删除数据表：drop table if exists 数据表名；
DROP TABLE IF EXISTS stu;
#查看表结构
DESC stu;

#-----------------------------DDL语句， 数据定义语言 操作字段---------------------------
    #在实际开发中，建表时一般都会多预留2~7个字段，当做扩展字段，将来业务扩展,因为后序直接添加，会导致一下子增加大量工作量，可能会导致添加失败
# 切表，查表
USE  TEST3;
SHOW TABLES;

# 查看表结构
DESC stu;

#给stu表添加字段 address varchar(20)
# alter table 表名 add 新列名 数据类型 [约束]
ALTER TABLE stu ADD address varchar(20) NOT NULL ;

#修改字段
#场景1：只修改数据类型 和 约束
#格式：alter table 表明 modify 新列名 数据类型 [约束] (约束没设置,null就会变成默认的yes)
ALTER  TABLE  stu MODIFY address INT;

#场景二：修改数据类型 和 约束，还修改字段名
#格式： alter table 表名 change 旧列名 新列名 新的数据类型 [新的约束]；
ALTER  TABLE stu CHANGE  address addr VARCHAR(10) NOT NULL

# 删除字段
#格式：alter table 表名 drop 旧列名；
ALTER TABLE  stu DROP addr;






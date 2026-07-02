/*
DML 语句详解：
        概述：
            它叫数据操作语言，主要是 操作 表结构， 进行 增删改操作的
            实际开发中，增删改统称为 > 更新语句
        细节：
            进行删除，修改前，一定一定要备份！ 或者记得加where条件
        添加数据：
            格式：
                insert into 数据表名（列名1，列表2，、、）values (值1，值2...);
                insert into 数据列名 values(值1，值2...);
                insert into 数据表名 values(值1，值2...), (值1，值2...)..;
            细节：
                1. 要添加的值的个数， 必须和 列名以及其类型对应
                2. 如果不写列名， 默认是：全列名
*/
# 切库，查表
USE TEST3;
SHOW TABLES;

#创建分类表，分类id,分类名，描述信息
CREATE TABLE category(
    cid int,               #分类id
    cname varchar(20),     #分类名
    info varchar(100)      #描述信息
);

#3.往表中添加数据
INSERT INTO category(cid,cname) VALUES (1,'电脑');
# INSERT INTO category VALUES (2,'手机'）会报错，因为列的个数 和值的个数不匹配
INSERT INTO category VALUES (2,'手机','小米');
INSERT INTO category VALUES (3,'汽车','小米'),(4,'平板','华为');

#查看全部表数据
SELECT  * from category;

#--------------------------------------------DML语句： 表数据 修改---------------------------------------------
# 查看表数据
SELECT  * from category;

#修改cname='空调’，info=‘格力’，cid=3
UPDATE  category SET  cname = '空调', info = '格力' WHERE cid = 3;

#--------------------------------------------DML语句： 表数据 删除---------------------------------------------
DELETE FROM category WHERE cid = 4;
DELETE FROM category; #一次性删除所有，不会重置主键id ，意思是之前id这一列到6，然后insert values id 为 null的时候回从7开始
#演示truncate table
TRUNCATE TABLE category; #一次性删除所有，会重置主键id， 相同情况，会从1 开始，相当于重新建了个新表

#--------------------------------------------DML语句： 如何备份表（小数据集）---------------------------------------------
# 查看数据表
SHOW  TABLES;
#原表
SELECT * FROM category;
#当备份表不存在的时候: CREATE TABLE IF NOT EXISTS category_tmp SELECT * from category where.....
CREATE TABLE IF NOT EXISTS category_tmp SELECT * from category;
#当备份表存在的时候:
INSERT INTO  category_tmp SELECT * from category WHERE cid <= 3;

/*
约束解释：
    概述：
        就是在数据类型上，进一步对某列值做限定
    分类：
        单表约束：
            primary key: 主键约束，特点：非空，唯一，一般结合 自增（auto_increment)一起用
            not null： 非空约束
            unique: 唯一约束
            default: 默认约束
        多表约束：
            foreign key
*/
#---------------------------------------------------演示主键约束--------------------------------------------------
USE TEST3;

#创建学生表添加主键
create table student(
    sid int PRIMARY KEY,
    name VARCHAR(20),
    age INT
);
#查看表结构
DESC student;

# 添加数据
insert into student values(1,'张三',18),(2,'张xiao',28),(3,'张da',38)

#查看
select * from student;

#删除主键约束
alter table student drop PRIMARY KEY;
# 建表后。添加主键约束，结合 自增；
alter table student add PRIMARY KEY(sid);
alter table student modify sid int AUTO_INCREMENT; #增加自增

#再次添加数据，解释自增的作用
insert into student values(4,'李四',20);
insert into student values(4,'李四',20);# 不行，主键冲突
insert into student values(null,'李四',20); #可以，因为自增， 主键列会自动加1

#但是自增的加一是根据上一个主键列
insert into student values(10,'王五',20);
insert into student values(null,'赵六',66);  # sid = 11

#删除表，然后看看自增创建表单时的添加
delete from student;
create table IF NOT EXISTS student(
    sid int PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    age INT
);

#修改王五的sid 10 改成 12， 看看赵六的 11 会不会变
update student set sid = 12 where sid = 10; #赵六没变，王五变成12.

#---------------------------------------------------演示其他约束--------------------------------------------------
#查表
show tables;
SELECT * from employee;
DROP table IF EXISTS employee;
create table if not exists employee(
    eid int PRIMARY KEY AUTO_INCREMENT,   #自增只能结合整数来用！
    name VARCHAR(10) not null,
    mobile VARCHAR(11) unique not null,
    address VARCHAR(10) DEFAULT '未知'
);

#查看表结构
DESC employee;


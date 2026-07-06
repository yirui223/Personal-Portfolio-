CREATE DATABASE IF NOT EXISTS windows CHARSET 'utf8';
USE  windows;
#---------------------------------------------窗口函数-----------------------------------------------
/*窗口函数 over(partition by 分组字段 order by 排序字段 asc|desc)
  常用的窗口函数：
  row_number(): 做行号标记 1，2，3，4
  rank(）： 坐稀疏排名     1，2，2，4
  dense_rank(): 做密集排名  1，2，2，3
  窗口函数 = 给原表新增一列，至于新增什么，取决于用哪个函数
  其他窗口函数和over()一起用
  count,max,min,sum,avg,ntile(n),lag(),lead(),first_value(),last_value()
  如果不写order by 则统计的是组内所有的数据，如果写了，则统计的是组内第一行，截止到当前行的数据
 */

# 准备数据 → 建表，添加数据。  提示：做练习用，主键不规范！
create table employee (empid int, ename varchar(20), deptid int, salary decimal(10,2));

insert into employee values(1, '刘备', 10, 5500.00);
insert into employee values(2, '赵云', 10, 4500.00);
insert into employee values(2, '张飞', 10, 3500.00);
insert into employee values(2, '关羽', 10, 4500.00);

insert into employee values(3, '曹操', 20, 1900.00);
insert into employee values(4, '许褚', 20, 4800.00);
insert into employee values(5, '张辽', 20, 6500.00);
insert into employee values(6, '徐晃', 20, 14500.00);

insert into employee values(7, '孙权', 30, 44500.00);
insert into employee values(8, '周瑜', 30, 6500.00);
insert into employee values(9, '陆逊', 30, 7500.00);

SELECT  * from employee;

# 分组排名，需求
#如何给表新增1列
select *, deptid + 10 from employee;

#场景2：引入 窗口函数
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY employee.deptid order by employee.salary) AS rn
from
    employee;
# 没写 partition by 统计全表， 与之前单独用sum不同，每个人后面都跟着所有人的工资总数
SELECT
    *,
    SUM(salary) OVER () AS total_sum
from
    employee;
#写了就是统计全组
SELECT
    *,
    SUM(salary) OVER (PARTITION BY employee.deptid) AS total_sum
from
    employee;

SELECT
    *,
    SUM(salary) OVER (PARTITION BY employee.deptid order by employee.salary DESC) AS total_sum
from
    employee;

#分组排名：按照部门id分组，按照工资降序排名
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY employee.deptid order by employee.salary DESC ) AS rn,
    RANK() OVER (PARTITION BY employee.deptid order by employee.salary DESC ) AS rk,
    DENSE_RANK() OVER(PARTITION BY employee.deptid order by employee.salary DESC ) AS dr
from
    employee;



# 分组排名求TopN, 需求：找出每组工资最高的2人信息（考虑并列）
#如下代码，思路有点小问题，语法格式不太对，SQL的语句顺序需要注意。where后面的字段必须是原表中已有的
SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY employee.deptid order by employee.salary DESC ) AS dr
from
    employee
WHERE
    dr <= 2;

# 解决方案:用子查询解决
SELECT *
FROM (
    SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY employee.deptid order by employee.salary DESC ) AS dr
from
    employee
     ) t1 where dr <= 2;

#CTE 公共表表达式, 可以把常用的数据集封装成新表，方便操作
/*
格式：
    with 表名1 as (select ......),
         表名2 as (select ...),
         表名3 as .....
    select * from t1....;      #这里正常写SQL，使用上述的表名即可。
*/
with t1 as (SELECT *, DENSE_RANK() OVER(PARTITION BY employee.deptid order by employee.salary DESC ) AS dr from employee)
SELECT * from t1 where dr <= 2;

#一个需求表示CTE的强大之处
WITH t1 as (select * from employee),
     t2 as (select * from employee where deptid = 10),
     t3 as (select * from employee where deptid = 20),
     t4 as (select * from employee where deptid = 30),
     t5 as (select *, sum(salary) OVER() as total_salary from employee )
select * from t5;

#-----------------------------------------------自关联（自链接）查询------------------------------------------------
/*
案例2：自关联（自连接）查询

解释：
表自己和自己做关联查询→自关联，自连接查询。

应用场景：
省市区（行政区域表）信息查询。

如果不考虑自连接查询，让你设计行政区域表，要求有行政区域的id和行政区域名，例如：410000→河南省，你如何设计？
大概率你会设计成3张表，分别对应省，市，区的信息，但是这样做太繁琐了，我们可以考虑把省市区合并到一张表，然后做自关联查询即可。

合并之后，表中有三个字段，分别是：
区域自身id
区域名
区域的父级id

410000    河南省    0
410100    郑州市    410000
410200    开封市    410000
410101    二七区    410100
410102    金水区    410200
*/
create table areas(
    id varchar(30) not null primary key,
    title varchar(30),
    pid varchar(30)
);
# 模拟数据，信息不全   pid可以理解为，id的父级
INSERT INTO `areas` VALUES
('110000', '北京市', NULL),
('110100', '北京市', '110000'),
('110101', '东城区', '110100'),
('110102', '西城区', '110100'),
('110103', '朝阳区', '110100'),
('110104', '丰台区', '110100'),
('110105', '石景山区', '110100'),
('110106', '海淀区', '110100'),
('110107', '门头沟区', '110100'),
('110108', '房山区', '110100'),
('110109', '通州区', '110100'),
('110110', '顺义区', '110100'),
('110111', '昌平区', '110100'),
('110112', '大兴区', '110100');

#查看所有的省，所有市和所有县区的信息
SELECT
    province.id,province.title,
    city.id,city.title,
    county.id,county.title
FROM areas as county   #县区表
join areas as city on county.pid = city.id #市级表
JOIN areas as province on city.pid = province.id; #省级表



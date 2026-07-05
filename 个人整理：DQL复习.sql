/*
总体格式：
      select
            [distinct]列名[as 别名]，名[as 别名]...
      from
            数据表名
      where
            组前筛选
      group by
            分组字段
      having
            组后筛选
      order by
            排序[asc|desc],排序[asc|desc]...
      limit
            起始索引，数据条数
查询不改变原表信息
*/
#------------------------------------------------准备数据----------------------------------------------------------
USE TEST3;
show TABLES;

create table if not exists product(
    pid int PRIMARY KEY AUTO_INCREMENT,
    pname VARCHAR(20) NOT NULL ,
    price DOUBLE NOT NULL,
    category_id VARCHAR(12)
);

INSERT INTO product VALUES (null,'联想',5000,'c001');
INSERT INTO product VALUES (null,'海尔',3000,'c001');
INSERT INTO product VALUES (null,'雷神',5000,'c001');
INSERT INTO product VALUES (null,'杰克琼斯',800,'c002');
INSERT INTO product VALUES (null,'真维斯',200,null);
INSERT INTO product VALUES (null,'花花公子',440,'c002');
INSERT INTO product VALUES (null,'劲霸',2000,'c002');
INSERT INTO product VALUES (null,'香奈儿',800,'c003');
INSERT INTO product VALUES (null,'相宜本草',200,NULL);
INSERT INTO product VALUES (null,'面霸',5,'c003');
INSERT INTO product VALUES (null,'好想你枣',56,'c004');
INSERT INTO product VALUES (null,'香飘飘奶茶',1,'c005');
INSERT INTO product VALUES (null,'海澜之家',1,'c002');

#简单查询
select pname,price + 10 as price from product;

#------------------------------------------------条件查询----------------------------------------------------------

/*
格式：
    select * from 数据表名 where 条件；
条件可以是：
    1.比较运算符。
        >,>=,<,<=,(!=,<>),=        ：：()一样的意思
    2.逻辑运算符
        and,or,not
    3. like 模糊查询
        _ 代表任意一个字符
        % 代表任意多个字符， 至少0个，至多无所谓
    4. 范围查询
        between 值1 and 值2      包左包右， 适用于 连续值的判断
        in (值1，值2，值3） 满足任意一个值即可， 适用于 非连续值的判断
    5. 空值判断
*/

#作用一样：不等于
select * from product where category_id != 'c001';
select * from product where category_id <> 'c001';

select * from product where price between 800 and 3000;
select * from product WHERE price >= 800 AND price <= 3000;  #注意两个price

#查找 第二个字 是 霸 的商品信息，商品共计2个字
select * from product where pname like '_霸';
#查找 商品名 包括 斯 字的
select * from product where pname like '%斯%';

select * from product where price in (200,800,5000);
select * from product where price = 200 or price = 800 or price = 5000;

select * from product where price not in (200,800,5000);
select * from product where price != 200 and price != 800 and price != 5000;

#查询没有分类的商品信息
select *  from product where category_id is null;

#------------------------------------------------排序查询----------------------------------------------------------
select * from product order by price desc, category_id desc;

#------------------------------------------------聚合函数---------------------------------------------------------
/*
count(*), count(1), count(列）的区别？
答案：
    1. 是否统计null值：
        count(*), count(1) 统计； count(列）不统计 [如果这一列中有null的话]
    2.效率，从高到低：
        count(主键列) > count(1) 统计 > count(列） >  count(*)  因为count(1)把所有的行都当成1.不用显示具体的数据
        主键列的底层是：主键索引
*/
select COUNT(*) from product;  # 13
select COUNT(category_id) from product; #11, count 统计列的时候会忽略 null 值。
select COUNT(pid) from product; # 13,主键列
SELECT COUNT(1) from product; # 13
SELECT
    SUM(price) as sum_price,
    MAX(price) as max_price,
    MIN(price) as min_price,
    AVG(price) as avg_price,
    CEIL(avg(price)) as ceil_avg_price,
    ROUND(AVG(price),2) as r_avg_price        #四舍五入，保留2位小数
from
    product;
#------------------------------------------------分组函数---------------------------------------------------------
/*
 1. 根据谁分组，就根据谁查询，即：分组查询的查询列 只能出现 分组字段 和 聚合函数
 2. 分组前筛选用where,分组后筛选用having。
 3. having后面可以跟聚合函数，而where不可以
 */

select COUNT(pid) from product group by category_id; #只是这样不知道这个数据啥情况，所以跟谁，谁分组
select category_id, COUNT(pid) from product group by category_id;

# 分组商品后，统计出， 商品数量在2以上的分类
select category_id, COUNT(pid) from product group by category_id having COUNT(pid) > 2;  #分组后筛选用having
select category_id, COUNT(pid) as total_count from product group by category_id having total_count > 2;

#------------------------------------------------单表查询__去重查询---------------------------------------------------------
/*
 distinct 是针对查询结果中的整行内容进行调整，不是单个字段，也就是说搜索的内容中，有一点不一样，就不会被去重
 */
select product.category_id,price from product;

#把 category_id 和 price 当做一个整体 去重
SELECT DISTINCT product.category_id,product.price from product;

#思路二：分组去重 (适合大数据集）
select product.category_id from product GROUP BY  category_id;
select product.category_id, price from product group by category_id,price;
#------------------------------------------------单表查询__分页查询--------------------------------------------------------
/*
 分页查询的好处：
        1. 提高用户体验
        2. 降低服务器端压力
        3. 降低浏览器端压力

 细节：
    1. 在SQL中，每条数据都是有索引的，且索引从0开始
    2. 关于分页， 有四个参数的计算规则：
        总页数： （数据总条数 + 每页的数据条数 -1）// 每页的数据条款         //表示整除
        每页的数据条数： 产品经理
        每页的起始索引：（想要的页数-1）* 每页的数据条数
        数据总条数：count(主键列）
 */
# 3条/页
select * from product limit 0,3; #第一页 1，2，3条
select * from product limit 3,3; #第二页 4，5，6
select * from product limit 6,3; #第三页 7，8，9

select * from product LIMIT 66,10; #没有那么多数据，但是不会报错

# 获取价格第二高的商品信息
select * from product ORDER BY price DESC limit 1,1;
# 起始是0可以省略不写
select * from product limit 3;

#------------------------------------------------SQL 执行顺序-----------------------------------------------
/*
FROM (含 JOIN、ON) →
WHERE →
GROUP BY →
聚合函数 →
HAVING →
SELECT (含窗口函数) →
DISTINCT →
ORDER BY →
LIMIT
 */
#------------------------------------------------多表建表 一对多-----------------------------------------------
# 需求：新建部门表（dept,department) 和 员工表（empy), 他们之间是一对多的关系，请用外键约束，完成限定
# 实际开发中，外键约束相对用的少一点，而是通过 代码层面， 对表数据做限定
# 在多表关系中，有外键列的表 是 从表，有主键列的表 是 主表， 从表的外键列不能出现 主表的主键列 没有的数据
# 一对多建表原则： 在多的一方新建一列，充当外键列，去关联一方的主键列

USE TEST3;
SHOW  TABLES ;

#创建 主表
CREATE table dept(
    id int PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10)
);

#创建从表 外表
create table emp(
    id int PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10),
    salary DOUBLE,
    dept_id int         #员工所属的部门id
    #设置外键约束的方式1：建表时添加 外键约束， 注意：写到外表中
    # 格式：【constraint 外键约束名】foreign key(外键列名) references 主表名（主键列）
    , CONSTRAINT fk_dept_emp FOREIGN KEY (dept_id) REFERENCES dept(id)
);

# 给部门表添加数据
INSERT into dept VALUES(null,'人事部'), (null,'财务部'),(null,'研发部'),(null,'行政部');

#给员工表添加数据
insert into emp values(null,'胡歌',33333,1);
insert into emp values(null,'刘亦菲',22222,2);
insert into emp values(null,'迪丽热巴',11111,2);
insert into emp values(null,'迪丽',11341,3);

#查看表数据
select * from dept;
select * from emp;

#删除外键约束
# alter table 外表名 drop foreign key 外键约束名
ALTER  table emp drop FOREIGN KEY fk_dept_emp;

# 建表后，添加外键约束， 前提： 表数据之间必须是合法的
# alter table 外表名 add 【constraint 外键约束名】foreign key(外键列名) references 主表名（主键列）
alter table emp add CONSTRAINT fk_dept_emp FOREIGN KEY (dept_id) references dept(id);

#------------------------------------------------多表查询 准备数据-----------------------------------------------
create table hero(
    hid int PRIMARY KEY AUTO_INCREMENT,
    hname VARCHAR(255),
    kongfu_id int
);
CREATE table kongfu(
    kid int PRIMARY KEY  AUTO_INCREMENT,
    kname VARCHAR(255)
);
INSERT into hero values(1,'鸠摩智',9),(3,'乔峰',1),(4,'虚竹',4),(5,'段誉',12);
insert into kongfu values(1,'降龙十八掌'),(2,'乾坤大挪移'),(3,'猴子偷桃'),(4,'天山折梅手');
select * from hero;
select * from kongfu;

#----------------------------------------交叉连接 cross join: A的总数 * B的总数--------------------------------------
# 格式1：select * from 表名1 ， 表名2；
# 格式2： select * from 表名1 join 表名2；
select * from hero, kongfu;
select * from hero join kongfu;

#----------------------------------------多表查询 内连接 inner join--------------------------------------------------
#查询结果：表的交集
#格式1：select * from 表名1 ， 表名2 where 关联条件；
# 格式2： select * from 表名1 inner join 表名2 on 关联条件；
#显示内连接： 推荐
select * from hero as h, kongfu as kf where h.kongfu_id = kf.kid; #标准写法
select * from hero as h INNER JOIN kongfu as kf on h.kongfu_id = kf.kid;

#----------------------------------------多表查询 外连接 outer join--------------------------------------------------
# 左外连接 = 左表全集 + 交集
# select * from 表1 left outer join 表2 on 关联条件； outer 可以省略
select * from hero h left outer join kongfu kf on h.kongfu_id = kf.kid;
select * from hero h left join kongfu kf on h.kongfu_id = kf.kid;

# 右外连接 = 右表全集 + 交集
# select * from 表1 right outer join 表2 on 关联条件； outer 可以省略
select * from hero h right outer join kongfu kf on h.kongfu_id = kf.kid;
select * from hero h right join kongfu kf on h.kongfu_id = kf.kid;

# 满外连接（全连接）= 左外连接 + 右外连接
#格式： select * from 表1 full outer join 表2 on 关联条件；
# select * from hero h full outer join kongfu kf on h.kongfu_id = kf.kid;   但是 MySQL不支持 full outer join 写法
select * from hero h left outer join kongfu kf on h.kongfu_id = kf.kid
union DISTINCT  # 合并并去重，distinct 可以省略不写
# union all   合并不去重
select * from hero h right outer join kongfu kf on h.kongfu_id = kf.kid;

#-----------------------------------------------多表查询 子查询--------------------------------------------------
/*
 一个SQL语句的查询条件，需要依赖另一个SQL语句的查询结果，这种写法就叫：子查询
 外表的查询叫：父查询（子查询）   先查子查询    但在实际开发中 一般用连接查询
 select * from 表名 where 字段 = （select 字段 from 表名 where）
 */
# 查询价格最高的商品信息
#子查询
select * from product where price = (select max(price) from product);
#连接查询
select * from product p
inner join
    (select max(price) price from product) t1
on p.price = t1.price;

#-----------------------------------------------case when--------------------------------------------------
/*
 case
    when 条件1 then 结果1
    when 条件2 then 结果2
    else 结果n
 end [as 别名]

  case 字段名
    when 值1 then 结果1
    when 值2 then 结果2
    else 结果n
 end [as 别名]
 */

# 这样子相当于新增一列
select *, 10 from product;

select *,
        CASE
            when category_id = 'c001' THEN  '电脑'
            when category_id = 'c002' THEN  '服装'
            when category_id = 'c003' THEN  '化妆品'
            when category_id = 'c004' THEN  '零食'
            when category_id = 'c005' THEN  '饮料'
            else '位置类别
'       END as category_name
from product;

select *,
        CASE category_id
            when 'c001' THEN  '电脑'
            when 'c002' THEN  '服装'
            when 'c003' THEN  '化妆品'
            when 'c004' THEN  '零食'
            when 'c005' THEN  '饮料'
            else '位置类别
'       END as category_name
from product;

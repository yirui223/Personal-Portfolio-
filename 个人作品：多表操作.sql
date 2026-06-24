create database test1;

use test1;
-- 部门表
create table dept(
    deptno int primary key, -- 部门编号
    dname varchar(14), -- 部门名称
    loc varchar(13) -- 部门地址
);

insert into dept values(10,'accounting','new york');
insert into dept values(20,'research','dallas');
insert into dept values(30,'sales','chicago');
insert into dept values(40,'operation','boston');
-- 员工表
create table emp(
    empno int primary key, -- 员工编号
    ename varchar(10),
    job varchar(9),
    mgr int, -- 员工直属领导编号
    hiredate date, -- 入职时间
    sal double, -- 工资
    comm double, -- 奖金
    deptno int -- 对应dept表的外键
);

-- 添加部门表和员工表之间的主外键关系
alter table emp add constraint foreign key emp(deptno) references dept(deptno);

insert into emp values(7369,'smith','clerk',7902,'1980-12-17',800,null,20);
insert into emp values(7499,'allen','salesman',7698,'1981-02-20',1600,300,30);
insert into emp values(7521,'ward','salesman',7698,'1981-04-02',1250,500,30);
insert into emp values(7566,'jones','manager',7839,'1981-04-20',2975,null,20);
insert into emp values(7654,'martin','salesman',7689,'1981-09-28',1250,1400,30);
insert into emp values(7698,'blake','manager',7839,'1981-05-01',2850,null,30);
insert into emp values(7782,'clark','manager',7839,'1981-06-09',2450,null,10);
insert into emp values(7788,'scott','analyst',7566,'1987-07-03',3000,null,20);
insert into emp values(7839,'king','president',null,'1981-11-17',5000,null,10);
insert into emp values(7844,'turner','salesman',7698,'1981-09-08',1500,0,30);
insert into emp values(7876,'adams','clerk',7788,'1987-07-13',1100,null,20);
insert into emp values(7900,'james','clerk',7698,'1981-12-03',950,null,30);
insert into emp values(7902,'fords','analyst',7566,'1981-12-03',3000,null,20);
insert into emp values(7934,'miller','clerk',7782,'1981-01-23',1300,null,10);

-- 工资等级表
create table salgrade(
    grade int, -- 等级
    losal double,
    hisal double
);

insert into salgrade values(1,700,1200);
insert into salgrade values(2,1201,1400);
insert into salgrade values(3,1401,2000);
insert into salgrade values(4,2001,3000);
insert into salgrade values(5,3001,9999);

-- 1. 返回拥有员工的部门名，部门号。

-- 子查询
select distinct dname, dept.deptno from dept where deptno = all(select deptno from emp  where emp.deptno is not null) ;
# 关键词选择错误，内表返回的是所有员工的部门编号 10，20，30，20， 10，30，所以对于任何一个部门编号比如10from外表不可能同时等于（10，20，30...)
select distinct dname, dept.deptno from dept where deptno in(select deptno from emp  where emp.deptno is not null) ;
# in 是等于其中一个就可以
select dname, dept.deptno from dept where deptno in(select distinct deptno from emp  where emp.deptno is not null) ;
#也可以直接在内表去重 （不相关子查询）
select dname, dept.deptno from dept where deptno in(select distinct deptno from emp where emp.deptno = dept.deptno) ;
#关联子查询
select dname, dept.deptno from dept where exists(select 1 from emp where emp.deptno = dept.deptno);
# 也可以使用 exist 效率更高

-- 内连接
select distinct dname, dept.deptno from dept inner join emp on dept.deptno = emp.deptno and emp.deptno is not null;

-- 2. 工资水平多于smith的员工信息
-- 子查询
select * from emp where sal > all(select sal from emp where emp.ename = 'smith');
-- 内连接 + 子查询 （两张表可以得出员工的全部信息）
select * from dept inner join emp on dept.deptno = emp.deptno and sal > all(select sal from emp where emp.ename = 'smith');

-- 3. 返回员工和所属经理的姓名
select  b.ename as '员工', a.ename as '经理' from emp a, emp b where a.empno = b.mgr;
select  b.ename as '员工', a.ename as '经理' from emp a join emp b on a.empno = b.mgr;

-- 4. 返回雇员的雇佣日期早于其经理的雇佣日期的员工及其经理姓名
select  b.ename as '员工',b.hiredate, a.ename,a.hiredate as '经理' from emp a, emp b where a.empno = b.mgr and b.hiredate < a.hiredate;

-- 5. 返回员工姓名以及其所在的部门名称
select emp.ename, dept.dname from dept inner join emp on dept.deptno = emp.deptno;

-- 6. 返回从事clerk工作的员工姓名和所在部门名称
select emp.ename, dept.dname,emp.job from dept inner join emp on dept.deptno = emp.deptno where emp.job = 'clerk';
select emp.ename, dept.dname,emp.job from dept inner join emp on dept.deptno = emp.deptno and emp.job = 'clerk';

-- 7.返回部门号及其本部门的最低工资
select deptno,min(sal) from emp group by deptno ;

-- 8.返回销售部（sales)所有员工的姓名
select a.ename,b.dname from emp a join dept b on a.deptno = b.deptno where b.dname = 'sales';

-- 9. 返回工资水平多于平均工资的员工
select ename from emp where sal > (select avg(sal) from emp);
/* Having 通常与groupby 配合，没有groupby不要用having
Where 后面不能加聚合函数
不需要groupby又需要聚合函数，考虑子查询 */

-- 10. 返回与scott从事相同工作的员工
select ename from emp where job = (select job from emp where ename = 'scott') and ename != 'scott';

-- 11.返回工资高于30部门所有员工工资水平的员工信息
select * from emp where sal > all(select sal from emp where deptno = 30 );

-- 12.返回员工工作及其从事此工作的最低工资
select job, min(sal) from emp group by job;

-- 13.计算出员工的年薪，并且以年薪排序
select ename, sal*12 + ifnull(comm,0) as '年薪' from emp order by sal*12 + ifnull(comm,0) desc;

-- 14. 返回工资处于第四级别的员工的姓名
#子查询
select ename from emp a where exists(select * from salgrade b where grade = 4 and (a.sal between b.losal and b.hisal));
#join
select ename from emp a join salgrade b on a.sal between b.losal and b.hisal where b.grade = 4;
#稍微没那么高级的写法
select ename from emp where sal between (select losal from salgrade where grade = 4)
              and (select hisal from salgrade where grade = 4);

-- 15.返回工资为二等级的职员名字，部门所在地
select ename, loc from emp a
join dept b on a.deptno = b.deptno
join salgrade c on a.sal between c.losal and c.hisal where c.grade = 2;

select ename, loc from emp a, dept b, salgrade c where a.deptno = b.deptno and (a.sal between c.losal and c.hisal) and c.grade = 2;

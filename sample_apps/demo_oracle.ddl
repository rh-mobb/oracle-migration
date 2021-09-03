-- DDL for WebLogic Server Examples

-- START
-- jdbc.multidatasource, wlst.online
DROP TABLE systables;
CREATE TABLE systables (test  varchar(15));

-- END

-- START
-- resadapter.simple
DROP TABLE ejbAccounts;
CREATE TABLE ejbAccounts (id varchar(15), bal float, type varchar(15));
INSERT INTO ejbAccounts (id,bal,type) VALUES ('10000',1000,'Checking');
INSERT INTO ejbAccounts (id,bal,type) VALUES ('10005',1000,'Savings');

-- END

-- START
-- webapp.jsf.basic
DROP TABLE CUSTOMER;
CREATE TABLE customer(
   custid     int not null,
   name       varchar(30),
   address    varchar(30),
   city       varchar(30),
   state      varchar(2),
   zip        varchar(5),
   area       varchar(3),
   phone      varchar(8));

insert into customer values
   (100,'Jackson','100 First St.','Pleasantville','CA','95404','707','555-1234');
insert into customer values
   (101,'Elliott','Arbor Lane, #3','Centre Town','CA','96539','415','787-5467');
insert into customer values
   (102,'Avery','14 Main','Arthur','CA','97675','510','834-7476');

DROP TABLE Customers;
create table Customers (
   cust_name varchar(50) constraint pk_cust primary key,
   acct_id varchar(50),
   cust_age integer,
   cust_level integer,
   cust_last date);

DROP TABLE CustomerTable;
CREATE TABLE CustomerTable(
   custid     int not null,
   name       varchar(30),
   address    varchar(30),
   city       varchar(30),
   state      varchar(2),
   zip        varchar(5),
   area       varchar(3),
   phone      varchar(8));

insert into CustomerTable values
   (100,'Jackson','100 First St.','Pleasantville','CA','95404','707','555-1234');
insert into CustomerTable values
   (101,'Elliott','Arbor Lane, #3','Centre Town','CA','96539','415','787-5467');
insert into CustomerTable values
   (102,'Avery','14 Main','Arthur','CA','97675','510','834-7476');

-- END

-- START
-- webapp.jsp.basic
DROP TABLE emp;
CREATE TABLE emp (
   empno      int not null,
   ename      varchar(10),
   job        varchar(9),
   mgr        int,
   hiredate   date,
   sal        float,
   comm       float,
   deptno     int);
create unique index empno on emp(empno);

insert into emp values
   (7369,'SMITH','CLERK',7902,DATE'1980-12-17',800,NULL,20);
insert into emp values
   (7499,'ALLEN','SALESMAN',7698,DATE'1981-02-20',1600,300,30);
insert into emp values
   (7521,'WARD','SALESMAN',7698,DATE'1981-02-22',1250,500,30);
insert into emp values
   (7566,'JONES','MANAGER',7839,DATE'1981-04-02',2975,NULL,20);
insert into emp values
   (7654,'MARTIN','SALESMAN',7698,DATE'1981-09-28',1250,1400,30);
insert into emp values
   (7698,'BLAKE','MANAGER',7839,DATE'1981-05-1',2850,NULL,30);
insert into emp values
   (7782,'CLARK','MANAGER',7839,DATE'1981-06-9',2450,NULL,10);
insert into emp values
   (7788,'SCOTT','ANALYST',7566,DATE'1981-06-9',3000,NULL,20);
insert into emp values
   (7839,'KING','PRESIDENT',NULL,DATE'1981-11-17',5000,NULL,10);
insert into emp values
   (7844,'TURNER','SALESMAN',7698,DATE'1981-09-8',1500,0,30);
insert into emp values
   (7876,'ADAMS','CLERK',7788,DATE'1981-06-9',1100,NULL,20);
insert into emp values
   (7900,'JAMES','CLERK',7698,DATE'1981-12-3',950,NULL,30);
insert into emp values
   (7902,'FORD','ANALYST',7566,DATE'1981-12-3',3000,NULL,20);
insert into emp values
   (7934,'MILLER','CLERK',7782,DATE'1982-01-23',1300,NULL,10);

-- END

-- START
-- webapp.pubsub.stock
DROP TABLE StockTable;
create table StockTable(
   symbol      varchar(10),
   price       float,
   yearHigh    float,
   yearLow     float,
   volume      int);

-- END

-- START
-- javaee6.jca.stockTransaction
DROP TABLE bankaccount;
create table bankaccount (
    owner varchar(30) primary key,
    balance double precision not null
);
insert into bankaccount (owner,balance) values ('Howard',10000);
insert into bankaccount (owner,balance) values ('James',8000);

DROP TABLE stockinf;
create table stockinf (
    stockname varchar(30) primary key,
    price double precision not null
);
insert into stockinf (stockname,price) values ('Real Oil Corporation',80);
insert into stockinf (stockname,price) values ('Sunshine Food Company',20);

DROP TABLE stockholding;
create table stockholding (
    owner varchar(30) not null,
    stockname varchar(30) not null,
    quantity int default 0,
    primary key(owner, stockName)
);
insert into stockholding (owner, stockname, quantity) values ('Howard', 'Real Oil Corporation', 60);
insert into stockholding (owner, stockname, quantity) values ('Howard', 'Sunshine Food Company', 20);
insert into stockholding (owner, stockname, quantity) values ('James', 'Real Oil Corporation', 30);
insert into stockholding (owner, stockname, quantity) values ('James', 'Sunshine Food Company', 50);
   
-- COMMIT;
-- END 

-- START
-- javaee6.beanvalidation
DROP TABLE JAVAEE6_USER;
CREATE TABLE JAVAEE6_USER (
		USERID VARCHAR(50) NOT NULL,
        NAME VARCHAR(50),
        PASSWORD VARCHAR(50),
		MOBILEPHONE VARCHAR(50),
		EMAIL VARCHAR(50),
		SALARY VARCHAR(50),
    CONSTRAINT JAVAEE6_USER_pk PRIMARY KEY
     (USERID));

-- END

-- START
-- javaee6.ejb
DROP TABLE JavaEE6_EjbUser;
CREATE TABLE JavaEE6_EjbUser (
    id varchar(255) primary key,
    name varchar(255));

-- END

-- START
-- javaee6.cdi
DROP TABLE JAVAEE6_CDI_USER;
CREATE TABLE JAVAEE6_CDI_USER (
		USERID VARCHAR(50) NOT NULL,
		EMAIL VARCHAR(50),
		MOBILEPHONE VARCHAR(50),
		NAME VARCHAR(50),
		PASSWORD VARCHAR(50),
		SALARY VARCHAR(50),
    CONSTRAINT JAVAEE6_CDI_USER_pk PRIMARY KEY
     (USERID));

insert into JAVAEE6_CDI_USER (USERID,PASSWORD,NAME,SALARY) values ('001','111','Jack','6880');
insert into JAVAEE6_CDI_USER (USERID,PASSWORD,NAME,SALARY) values ('002','222','Lily','30');
insert into JAVAEE6_CDI_USER (USERID,PASSWORD,NAME,SALARY) values ('003','333','Tom','3912');

-- END 

-- START
-- jdbc.multidatasource, jdbc.rowsets, webapp.jsp.tags.simple
DROP TABLE patient_seq;
CREATE TABLE patient_seq (sequence INTEGER);

DROP TABLE systables;
CREATE TABLE systables (test  varchar(15));

DROP TABLE patient;
CREATE TABLE patient    (
  id INTEGER CONSTRAINT patient_pk PRIMARY KEY,
  first_name    VARCHAR(60) NOT NULL,
  middle_name   VARCHAR(60),
  last_name VARCHAR(60) NOT NULL,
  dob   DATE NOT NULL,
  gender    VARCHAR(6) NOT NULL,
  ssn   VARCHAR(9) NOT NULL,
  address_id INTEGER NOT NULL,
  phone VARCHAR(15),
  email VARCHAR(60) NOT NULL
);

DELETE FROM patient;
INSERT INTO patient (id,first_name,middle_name,last_name,dob,gender,ssn,address_id,phone,email) VALUES (101,'Fred','I','Winner',DATE'1965-03-26','Male','123456789',101,'4151234564','fred@golf.com');
INSERT INTO patient (id,first_name,middle_name,last_name,dob,gender,ssn,address_id,phone,email) VALUES (102 ,'Larry','J','Parrot',DATE'1959-02-13','Male','777777777',101,'4151234564','larry@bball.com');
INSERT INTO patient (id,first_name,middle_name,last_name,dob,gender,ssn,address_id,phone,email) VALUES (103 ,'Charlie','E','Florida',DATE'1973-10-29','Male','444444444',102,'4151234564','charlie@star.com');
INSERT INTO patient (id,first_name,middle_name,last_name,dob,gender,ssn,address_id,phone,email) VALUES (104 ,'Gabrielle','H','Spiker',DATE'1971-08-17','Female','333333333',101,'4151234564','volley@ball.com');
INSERT INTO patient (id,first_name,middle_name,last_name,dob,gender,ssn,address_id,phone,email) VALUES (105 ,'Page','A','Trout',DATE'1972-02-18','Male','888888888',102,'4151234564','page@fish.com');

-- END

-- START jdbc.oracle.extensions
-- Structs example
DROP SEQUENCE employees_seq;
DROP TABLE employees;
DROP TYPE address_objtyp;
CREATE TYPE address_objtyp AS object (street VARCHAR(30),city VARCHAR(30),state VARCHAR(2));
CREATE SEQUENCE employees_seq START WITH 105 INCREMENT BY 1;
CREATE TABLE employees(
  id NUMBER(4) CONSTRAINT emp_pkId PRIMARY KEY,
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  address address_objtyp);
INSERT INTO employees VALUES (
    100, 'Alfred', 'Chuang',
    address_objtyp('1234 Post St', 'San Francisco', 'CA'));
INSERT INTO employees VALUES (
    101, 'Joe', 'Walker',
    address_objtyp('3321 Grand Ave', 'San Diego', 'CA'));
INSERT INTO employees VALUES (
    102, 'Tina', 'Potter',
    address_objtyp('7111 Ocala St', 'Tallahassee', 'FL'));
INSERT INTO employees VALUES (
    103, 'Fred', 'Couples',
    address_objtyp('9201 Park St', 'Alexandria', 'VA'));

-- Refs example
DROP TABLE people;
DROP TABLE address_objtab;
DROP TYPE address2_objtyp;
CREATE TYPE address2_objtyp AS object (id NUMBER(3),street VARCHAR(30),city VARCHAR(30),state VARCHAR(2));
CREATE TABLE address_objtab OF address2_objtyp;
CREATE TABLE people (
  id          NUMBER(4)   CONSTRAINT people_pkId PRIMARY KEY,
  name        VARCHAR(30),
  address_ref REF address2_objtyp SCOPE IS address_objtab);
INSERT INTO address_objtab VALUES (address2_objtyp(100, '1234 Post St', 'San Francisco', 'CA'));
INSERT INTO address_objtab VALUES (address2_objtyp(101, '3321 Grand Ave', 'San Diego', 'CA'));
INSERT INTO address_objtab VALUES (address2_objtyp(102, '9201 Park St', 'Alexandria', 'VA'));
INSERT INTO people VALUES (
   1001,
   'Alfred Chuang',
   (SELECT REF(a) FROM address_objtab a WHERE id = 100));
INSERT INTO people VALUES (
   1002,
   'Joe Walker',
   (SELECT REF(a) FROM address_objtab a WHERE id = 101));
INSERT INTO people VALUES (
   1003,
   'Fred Couples',
   (SELECT REF(a) FROM address_objtab a WHERE id = 102));

-- Arrays example
DROP TABLE students;
DROP TYPE scores;
CREATE TYPE scores AS VARRAY(5) OF VARCHAR(3);
CREATE TABLE students (
  student_id NUMBER(4) CONSTRAINT student_pkId PRIMARY KEY,
  name    VARCHAR(50),
  test_scores  scores);
INSERT INTO students VALUES (100, 'Trey Anastasio', scores('100', '87', '90', '89', '99'));
INSERT INTO students VALUES (101, 'Mike Gordon', scores('89', '76', '100', '80', '85'));
INSERT INTO students VALUES (102, 'Page McConnell', scores('100', '100', '95', '98', '75'));
INSERT INTO students VALUES (103, 'Jon Fishman', scores('55', '70', '76', '60', '75'));

-- COMMIT
-- END

-- START
-- webservices.jaxws.wsat
DROP TABLE wsat_acct_local;
DROP TABLE wsat_acct_remote;

CREATE TABLE wsat_acct_local ( acctno INTEGER, amount INTEGER);
CREATE TABLE wsat_acct_remote ( acctno INTEGER, amount INTEGER);

CREATE UNIQUE INDEX wsat_acct_local_idx ON wsat_acct_local(acctno);
CREATE UNIQUE INDEX wsat_acct_remote_idx ON wsat_acct_remote(acctno);

-- END
# Creating and droping databases
create database praveen;
show databases;
drop database praveen;
show databases;

create database praveen;
use praveen;
create table praveen.customer(id int(10), name varchar(20));
show tables;
select * from praveen.customer;
insert into praveen.customer values(1, 'Praveen');
drop table routine;

/* 
SQL NULL values
update
delete
alter
add column to the existing column
modify or alter column
alter table: drop column
*/
#drop table customer_new;
create table praveen.customer_new(
	id integer auto_increment, 
    first_name varchar(20), 
    last_name varchar(20), 
    salary int(20), 
    primary key(id)
    );
show tables;
select * from customer_new;
insert into praveen.customer_new(first_name, last_name, salary) values
	('John', 'Killer', 1000),
    ('Rock', 'Star', null);

update praveen.customer_new set salary = 2000 where id = 2;

# delete statement
delete from praveen.customer_new where id = 2;

# alter the table
## add column in existing table
alter table praveen.customer_new add email varchar(50);
select * from praveen.customer_new;
update praveen.customer_new set email = 'praveen.h397@gmail.com' where id = 1;

desc praveen.customer_new;

# alter table modify the column
alter table praveen.customer_new modify salary float;

# drop column
alter table praveen.customer_new drop column email;
select * from customer_new;

/*
sql constraints
not null
unique
primary key
foriegn key
check
default
index
*/
create table person(
	id int not null,
    first_name varchar(25) not null,
    last_name varchar(25),
    age int not null,
    unique(id)
    );
desc person;

alter table person modify age int null;
desc person;
alter table person modify age int not null;

insert into person values(1,'Praveen', 'Hosamani', 31);
select * from praveen.person;
# adding same id number, produces error
-- insert into person values(1,'Prashant', 'Hosamani',36);

# Adding unique constraints using alter statement
alter table person add unique(first_name);
desc person;

alter table person 
	add constraint uc_person unique(first_name,age);
desc person;

alter table person
	drop index uc_person;

alter table person 
add constraint uc_person1 unique(age,first_name);
desc person;
alter table person
	drop index uc_person1;
    
alter table person
	drop index first_name_2;
SHOW INDEX FROM person;

## Primay key
create table person1 (
	id int not null,
	first_name varchar(25),
    last_name varchar(25),
    age int,
    constraint primary key(id, last_name)
    );
select * from person1;
desc person1;

alter table person1
	drop primary key;
    
alter table person1
	add primary key(id);

drop table person;
drop table person1;

# foriegn key
create table person1 (
	id int not null,
	first_name varchar(25),
    last_name varchar(25),
    age int,
    primary key(id)
    );
desc person1;

create table person2 (
	id int not null,
	first_name varchar(25),
    last_name varchar(25),
    age int,
    salary int,
    primary key(age),
    constraint fk_p1p2 foreign key(id) references person1(id)
    );

desc person2;

## checking contraints
create table person3 (
	id int not null,
	first_name varchar(25),
    last_name varchar(25),
    age int,
    salary int,
    constraint check(salary<50000)
    );
insert into praveen.person3 values(1, 'Praveen', 'Hosamani',31,60000);
-- above query gives an error
insert into praveen.person3 values(1, 'Praveen', 'Hosamani',31,20000);
select * from praveen.person3;

## Default constraint
create table person4 (
	id int not null,
	first_name varchar(25) default 'Praveen',
    last_name varchar(25),
    age int,
    salary int,
    constraint check(salary<50000)
    );
desc person4;
-- drop table person4;


# Indexing

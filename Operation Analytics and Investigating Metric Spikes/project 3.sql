create database Project3;

use Project3;

create table users(
user_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50))

show variables like 'secure_file_priv';
drop table users;
-- USERS TABLE
select * from users;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- CREATED_AT Column
alter table users add column temp_created_at datetime;
update users set temp_created_at = str_to_date(created_at, '%d-%m-%Y %H:%i');

alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

-- ACTIVATED_AT Column
alter table users add column temp_activated_at datetime;
update users set temp_activated_at = str_to_date(activated_at, '%d-%m-%Y %H:%i');

alter table users drop column activated_at;
alter table users change column temp_activated_at activated_at datetime;

-- state column
alter table users add column temp_state varchar(10);
update users set temp_state = 'active';
alter table users drop column state;
alter table users change column temp_state state varchar(10);


-- EMAIL_EVENTS TABLE
create table email_events(
user_id int,
occured_at varchar (100),
action varchar(50),
user_type int);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv'
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;
-- OCCURED_AT Column
alter table email_events add column temp_occured_at datetime;

update email_events set temp_occured_at = str_to_date(occured_at, '%d-%m-%Y %H:%i');

alter table email_events drop column occured_at;
alter table email_events change column temp_occured_at occured_at datetime;

-- EVENTS table\
create table events(
user_id int,
occured_at varchar(100),
event_type varchar(50),
event_name varchar (50),
location varchar (50),
device varchar (100),
user_type int);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv'
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from events;

alter table events add column temp_occured_at datetime;

update events set temp_occured_at = str_to_date(occured_at ,'%d-%m-%Y %H:%i');

alter table events drop column occured_at ;
alter table events change column temp_occured_at occured_at datetime;


-- Objective: Measure the activeness of users on a weekly basis.
-- Your Task: Write an SQL query to calculate the weekly user engagement.

select extract(week from occured_at) as week_no, count(user_id) as total_users from events 
group by week_no
order by week_no;


-- Objective: Analyze the growth of users over time for a product.
-- Your Task: Write an SQL query to calculate the user growth for the product.
select year_number, week_number , no_of_active_users,
SUM(no_of_active_users) over( order by year_number, week_number rows between unbounded preceding and current row) as cum_active_users 
from (select extract(year from a.activated_at) as year_number, 
extract(week from a.activated_at) as week_number, count(distinct user_id) as no_of_active_users 
from users a WHERE state ='active' group by year_number, week_number
order by year_number, week_number) a;


-- Objective: Analyze the retention of users on a weekly basis after signing up for a product.
-- Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.

SELECT distinct user_id, COUNT(user_id), SUM(CASE WHEN retention_week =1 Then 1 Else 0 END) as retention_per_week 
FROM(SELECT a.user_id, a.week_of_signup, b.week_of_engagement, b.week_of_engagement -a.week_of_signup as retention_week
FROM (SELECT distinct user_id, extract(week from occured_at) as week_of_signup
from events WHERE event_type ='signup_flow' and event_name ='complete_signup' and extract(week from occured_at) =18)a 
LEFT JOIN
(SELECT distinct user_id, extract(week from occured_at) as week_of_engagement
FROM events where event_type ='engagement')b on a.user_id =b.user_id) d
group by user_id order by user_id;

-- Objective: Measure the activeness of users on a weekly basis per device.
-- Your Task: Write an SQL query to calculate the weekly engagement per device.

SELECT extract(year from occured_at) as no_of_year, extract(week from occured_at) as no_of_week , 
device,COUNT(distinct user_id)as no_of_users 
FROM events 
where event_type ='engagement' GROUP by no_of_year, no_of_week, device order by no_of_year, no_of_week, device;

-- Objective: Analyze how users are engaging with the email service.
-- Your Task: Write an SQL query to calculate the email engagement metrics.

SELECT SUM(CASE when email_cat ='email_opened' then 1 else 0 end)/SUM(CASE when email_cat ='email_sent' then 1 else 0 end) as
email_opening_rate,
 SUM(CASE when email_cat ='email_clicked' then 1 else 0 end)/SUM(CASE when email_cat ='email_sent' then 1 else 0 end) as
email_clicking_rate 
FROM (SELECT *,CASE WHEN action in ('sent_weekly_digest','sent_reengagement_email') then 'email_sent' 
WHEN action in ('email_open') then 'email_opened' 
WHEN action in ('email_clickthrough') then 'email_clicked' end as email_cat from email_events) a;

select * from email_events;
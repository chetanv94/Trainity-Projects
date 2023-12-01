create database job_data;

use job_data;

create table job_data (
job_id varchar (2) not null,
actor_id varchar(5) not null,
event varchar(20),
language varchar(20),
time_spent int,
organization varchar(2),
ds date
);
truncate table job_data;

insert into job_data (ds, job_id, actor_id, event, language, time_spent, organization)
values ('2020-11-30','21','1001','skip','English',15,'A'),
('2020-11-30','22','1006','transfer','Arabic',25,'B'),
('2020-11-29','23','1003','decision','Persian',20,'C'),
('2020-11-28','23','1005','transfer','Persian',22,'D'),
('2020-11-28','25','1002','decision','Hindi',11,'B'),
('2020-11-27','11','1007','decision','French',104,'D'),
('2020-11-26','23','1004','skip','Persian',56,'A'),
('2020-11-25','20','1008','transfer','Italian',45,'C'),
('2020-11-24','21','1009','skip','English',15,'A'),
('2020-11-23','22','1010','transfer','Arabic',25,'D'),
('2020-11-23','23','1011','decision','Persian',20,'C'),
('2020-11-22','21','1012','transfer','French',22,'A'),
('2020-11-21','25','1013','decision','Hindi',11,'B'),
('2020-11-20','11','1014','decision','French',104,'C'),
('2020-11-19','22','1015','skip','Persian',56,'A'),
('2020-11-19','20','1016','transfer','French',45,'B'),
('2020-11-18','21','1017','skip','Persian',15,'A'),
('2020-11-17','23','1018','transfer','Arabic',25,'D'),
('2020-11-17','23','1019','decision','French',20,'C'),
('2020-11-16','20','1020','transfer','Persian',22,'D'),
('2020-11-15','25','1021','decision','Hindi',11,'A'),
('2020-11-14','11','1022','decision','French',104,'D'),
('2020-11-13','23','1023','skip','Persian',56,'A'),
('2020-11-13','20','1024','transfer','Italian',45,'D'),
('2020-11-12','21','1025','skip','French',15,'C'),
('2020-11-12','25','1026','transfer','Arabic',25,'B'),
('2020-11-11','23','1027','decision','Italian',20,'C'),
('2020-11-10','23','1028','transfer','Hindi',22,'D'),
('2020-11-19','25','1029','decision','Persian',11,'A'),
('2020-11-09','11','1030','decision','French',104,'A'),
('2020-11-08','23','1032','skip','Arabic',56,'A'),
('2020-11-07','20','1031','transfer','French',60,'A'),
('2020-11-30','23','1033','skip','English',15,'D'),
('2020-11-30','25','1034','transfer','Arabic',25,'B'),
('2020-11-29','21','1035','decision','Persian',20,'A'),
('2020-11-28','22','1036','transfer','English',22,'D'),
('2020-11-28','21','1037','decision','Hindi',11,'B'),
('2020-11-27','20','1038','decision','French',104,'D'),
('2020-11-26','11','1039','skip','Persian',56,'C'),
('2020-11-25','20','1040','transfer','Italian',45,'C'),
('2020-11-24','21','1041','skip','Arabic',15,'A'),
('2020-11-23','22','1042','transfer','Persian',25,'D'),
('2020-11-23','23','1043','decision','Italian',26,'A'),
('2020-11-22','21','1044','transfer','French',20,'C'),
('2020-11-21','25','1045','decision','Hindi',9,'D'),
('2020-11-20','24','1046','decision','French',62,'A'),
('2020-11-19','11','1047','skip','Hindi',51,'C'),
('2020-11-19','25','1048','transfer','French',45,'B'),
('2020-11-18','23','1049','skip','Persian',11,'A'),
('2020-11-17','23','1050','transfer','Arabic',43,'D'),
('2020-11-17','22','1051','decision','French',55,'C'),
('2020-11-16','21','1052','transfer','Persian',27,'D'),
('2020-11-15','25','1053','decision','Hindi',91,'A'),
('2020-11-14','11','1054','decision','French',68,'D'),
('2020-11-13','23','1055','skip','Hindi',19,'A'),
('2020-11-13','11','1056','transfer','Persian',28,'B'),
('2020-11-12','21','1057','skip','French',35,'C'),
('2020-11-12','25','1058','transfer','Arabic',13,'B'),
('2020-11-11','24','1059','decision','Hindi',41,'A'),
('2020-11-10','22','1060','transfer','Arabic',57,'D'),
('2020-11-19','25','1061','decision','Persian',11,'A'),
('2020-11-09','11','1062','decision','French',24,'D'),
('2020-11-08','25','1063','skip','Arabic',15,'A'),
('2020-11-07','22','1064','transfer','Italian',45,'B');

select * from job_data;

## Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.

select ds as date , actor_id , sum(time_spent)/(3600) as 'Hours per day' from job_data
group by ds, actor_id;

##  Write an SQL query to calculate the 7-day rolling average of throughput. 
## Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.

select actor_id, ds as date ,time_spent, 
avg(time_spent) over (order by ds rows between 6 preceding and current row) as '7dayrolling_avg'
from job_data
order by ds;
         
##  Write an SQL query to calculate the percentage share of each language over the last 30 days.  
create view total_time 
as select sum(time_spent) as total_time from job_data;

select language, round((sum(time_spent)/ (select * from total_time))*100,3) as 'Percentage_share in %' from job_data
group by language;

## Write an SQL query to display duplicate rows from the job_data table. 

SELECT * FROM job_data
GROUP BY job_id, actor_id, event, language, time_spent, organization, ds
HAVING COUNT(actor_id) >1;

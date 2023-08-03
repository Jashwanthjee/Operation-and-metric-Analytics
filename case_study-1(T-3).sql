
create table job_data(
job_id int,
actors_id int,
event varchar(255),
language varchar(255),
time_spent int,
org varchar(255),
ds date);

select * from job_data;

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
       ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
       ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
       ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
       ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
       ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
       ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
       ('2020-11-25', 20, 1004, 'transfer', 'Italian', 45, 'C');


/* 1 answer Case_study - 1 */
select avg(t) as 'jobs reviewed per hour' from (select ds,(count(job_id)*3600)/sum(time_spent)as t from job_data where month(ds)=11 group by ds)two;



/* 2 answer Case_study - 1 */
select
ds,
c/t as throuput_per_day ,
avg(c/t)over(order by ds ) as throughput_7_rolling_avg
from
(select 
ds,
count(job_id) as c,
sum(time_spent) as t
from 
job_data
group by ds)a;

/* 3 answer Case_study - 1 */

select distinct
language,
(count(event) over(partition by language rows between unbounded preceding and unbounded following) /count(*) over(order by ds rows between unbounded preceding and unbounded following) ) * 100 as percentage 
 from
job_data;


/* 4 answer Case_study - 1 */
select *
from
(select 
*,
rank() over(partition by ds,actor_id,job_id) as row_num
from 
job_data) a
where row_num>1;

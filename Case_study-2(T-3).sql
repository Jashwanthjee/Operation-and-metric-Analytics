use case_study_2;
/*1 answer*/
select
week(occurred_at) as num_week,
count(distinct user_id) as no_of_distinct_user
from events
group by num_week;

/*2 answer*/
select year, quarter, num_active_users,
num_active_users-lag(num_active_users) over( order by year,quarter ) as user_growth
from
(select
year(created_at) as year, 
quarter(created_at)as quarter, 
count(distinct user_id) as num_active_users
from users
where state='active'
group by year, 2
order by year, 2)a;

/*3 answer*/
select  per_week_retention,count(per_week_retention)as count from (select user_id,sum(case when ab.retention_weeks = 1 then 1 else 0 end) as per_week_retention
from
(select a.user_id, a.sign_up_week, b.engagement_week, (b.engagement_week-a.sign_up_week)as retention_weeks from
(select distinct user_id, extract(week from occurred_at) as sign_up_week from events
where event_type = 'signup_flow'
and event_name = 'complete_signup'
and extract(week from occurred_at)=18)a
left join
(select distinct user_id, extract(week from occurred_at) as engagement_week from events
where event_type = 'engagement')b
on a.user_id = b.user_id)ab
group by user_id
order by user_id)abc
group by per_week_retention;



/*4 answer*/
select device, avg(no_of_users) from 
(select
extract(year from occurred_at) as year_num,
extract(week from occurred_at) as week_num,
device,
count(distinct user_id) as no_of_users
from events
where event_type = 'engagement'
group by 1,2,3
order by 3)a 
group by a.device ;


/*5 answer*/

select
100.0 * sum(case when email_cat = 'email_opened' then 1 else 0 end)
           /sum(case when email_cat = 'email_sent' then 1 else 0 end)
   as email_opening_rate,
100.0 * sum(case when email_cat = 'email_clicked' then 1 else 0 end) /sum(case when email_cat = 'email_sent' then 1 else 0 end)
as email_clicking_rate
       from
(select *,case when action in ('sent_weekly_digest', 'sent_reengagement_email')
then 'email_sent'
when action in ('email_open')
then 'email_opened'
when action in ('email_clickthrough')
then 'email_clicked'
end as email_cat
from email_events)a;
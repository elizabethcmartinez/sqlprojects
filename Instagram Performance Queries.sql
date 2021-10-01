
-- Downward trend on user activity: as the number of followers increases, 
-- the amount of like engagement decrease
CREATE VIEW [ACTIVITY BASED ON FOLLOWING] AS 
select followers, likes, likes * 100 / followers as 'Percentage(%)' 
from instagram_reach$ 
order by Followers ASC offset 0 rows

select * from [ACTIVITY BASED ON FOLLOWING]
	
-- Engagement activity based on the Number of Usernames 
select followers, likes, [time since posted], 
count(username) over (partition by Username) 
as TotalUsernames
from instagram_reach$

-- Percent of likes based on Hours Since Posted 
select followers, likes, [Time since posted] as [Hours Since Posted], 
convert(int, [Time since posted]) * 100 / Likes as 'percentage(%)'
from instagram_reach$
order by [percentage(%)] desc

-- Average like engagement based on the average time since posted and # of followers
select AVG([Time since posted]) as [Avg Time Since Posted], 
AVG(followers) as AvgFollowers, 
avg(Likes) as AverageLikes from instagram_reach$ 

-- Self joining Followers and Like columns from same table
select t1.Followers as Followers, 
		t2.Likes as Likes
from instagram_reach$ t1
		inner join instagram_reach$ t2
		on t1.followers = t2.Followers
	
	
	
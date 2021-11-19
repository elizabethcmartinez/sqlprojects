-- SOCIAL MEDIA DEVELOPMENT OVER RECENT DECADE SPAN : 
-- Consider that there are now more than 4.2 billion active social media users across the globe
--  83 percent of Instagram users say they discover new products on the platform

-- VIEW: INSTAGRAM LAUNCHED OCTOBER 2010, 
--THEREFORE REACHING IT'S FIRST 190 MILLION USERS BEGINNING 2013:

ALTER VIEW INSTAGRAM_LAUNCHED
AS
SELECT [YEARS BY QUARTER], [INSTAGRAM USERS (IN MILLION)] 
FROM DBO.[SOCIAL MEDIA USERS]
WHERE [INSTAGRAM USERS (IN MILLION)] = '-'
UNION all
SELECT [YEARS BY QUARTER], [INSTAGRAM USERS (IN MILLION)]
FROM DBO.[SOCIAL MEDIA USERS]
WHERE [INSTAGRAM USERS (IN MILLION)] = '190'

select * from instagram_launched 

-- PARTITION BY 
-- INCREASE OF TOTAL USERS JOINING INSTAGRAM THROUGHOUT THE YEARS
-- HIGHEST PERCENT INCREASE JUMP (32%) IN USER REGISTRATION HAPPENED ON Q4 OF 2017

SELECT YEARS, YEARS_BY_QUARTER, [INSTAGRAM USERS (IN MILLION)], 
SUM([INSTAGRAM USERS (IN MILLION)]) OVER (PARTITION BY YEARS) AS TotalIgUsersPerYr,
[instagram users (in million)]/sum([INSTAGRAM USERS (IN MILLION)]) OVER (PARTITION BY YEARS) * 100 as PERCENT_TOTAL
from DBO.[SOCIAL MEDIA USERS]
ORDER BY [PERCENT_TOTAL] DESC;

 
-- AVG SOCIAL MEDIA USERS DURING 2020!!! FB: 2710.25 MILLION, TWITTER: 339.50 MILLION, 
-- INSTAGRAM: 1033 MILLION or ONE BILLION 
-- CTE 
with CTE_SOCIALMEDIAUSERS AS (
SELECT YEARS,
AVG([FACEBOOK USERS (IN MILLION)]) AS AVG_FB_USERS_IN_MILLIONS, 
AVG([TWITTER USERS (IN MILLION)]) AS AVG_TR_USERS_IN_MILLIONS,
AVG([INSTAGRAM USERS (IN MILLION)]) AS AVG_IG_USER_IN_MILLIONS
FROM DBO.[SOCIAL MEDIA USERS]
GROUP BY YEARS)
SELECT * FROM CTE_SOCIALMEDIAUSERS

-- WAYS TO REPLACE NULL   
select 
[FACEBOOK USERS (IN MILLION)], [TWITTER USERS (IN MILLION)], 
ISNULL([INSTAGRAM USERS (IN MILLION)], 0.00) as [INSTAGRAM USERS (IN MILLION)],
coalesce([INSTAGRAM USERS (IN MILLION)], 0.00) as [INSTAGRAM USERS (IN MILLION)], 
case when [INSTAGRAM USERS (IN MILLION)] is null then 0.00 else [INSTAGRAM USERS (IN MILLION)] end
as [INSTAGRAM USERS (IN MILLION)]
FROM DBO.[SOCIAL MEDIA USERS]

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
-- HIGHEST 20-30% Range of likes based on AVG 3 Hours Past Post 
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


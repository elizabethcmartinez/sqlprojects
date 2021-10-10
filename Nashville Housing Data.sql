SELECT * FROM SocialMediaCampaign$

select ad_id, age, gender, spent, 
sum(spent) over(partition by gender) as SpendingBrokenDownInGender 
from SocialMediaCampaign$ 
group by Spent, ad_id, age, gender
order by gender, Spent desc;


select gender, sum(spent) over(partition by gender) as SpendingBrokenDownInGender 
from SocialMediaCampaign$ 
group by gender,  spent

SELECT age, gender, SUM(spent)FROM SocialMediaCampaign$  as SpendingByAge
WHERE age >= '30-34'
group by gender, Spent, age
order by spent desc;

select age, spent, gender, count(gender) over(partition by gender) as NumberofSpendingByGender 
from SocialMediaCampaign$
group by gender, spent, age
order by spent desc

select age, gender, spent, avg(spent) over(partition by gender) as AvgSpendingByGender
from SocialMediaCampaign$
group by gender, age, spent
order by spent desc;

select spent, gender, sum(spent) over(partition by gender)
from SocialMediaCampaign$

select gender, ad_id, sum(spent) over(partition by gender)
from SocialMediaCampaign$
group by ad_id, gender, spent
Data Exploration of Cyber Security Breaches: 
-- More than +1 Million, up to 4 Million individuals affected within organizations per states such as: CA, NY, FL, IL per year highest count attacks between 2011-2014.

-- MINOR cleaning
 select cast(date_of_breach as date) from CyberSecurityBreaches

 alter table cybersecuritybreaches
 alter column date_of_breach date;

 alter table cybersecuritybreaches
 drop column date_posted_or_updated

-- identify the presence of duplicate ID's : zero duplicates
select id, COUNT(ID) AS [ID COUNT]
FROM CYBERSECURITYBREACHES
group by id
having count(ID) > 1

-- Most common cyber attacks Phishing & Malware injection: Join states with different breach type
SELECT a.[State], a.Individuals_Affected, b.Type_of_Breach
from CYBERSECURITYBREACHES a
left join CyberSecurityBreaches b 
on a.[State] = b.[state]
where a.Type_of_Breach <> b.Type_of_Breach
group by a.Individuals_Affected, a.[State], b.[Type_of_Breach]
 
 -- On Average +1 MILLION employees Affected per States via CTE: VA, IL, CA, NY, FL, TN  
 with cyberattacks as 
 (select [state], avg(individuals_affected) as AVG_PPL_affected, 
 date_of_breach, type_of_breach 
 from CyberSecurityBreaches
 group by [State], date_of_breach, type_of_breach 
 ) 
 select * from cyberattacks
 order by AVG_PPL_affected desc

 --CTE: List states and people affected, where people affected > average overall people affected
 With AVG_People_Affected as (
	select  avg(individuals_affected) as Overall_AVG_PPL_Affected
	from CyberSecurityBreaches
	) 
select [state], individuals_affected, date_of_breach,
				(select * from avg_people_affected) as OVERALLAVG_PPL_AFFECTED
				from CyberSecurityBreaches
				where Individuals_Affected > (select * from AVG_People_Affected)
				order by Individuals_Affected desc

-- Create a View: list of states, number of entities, column with avg individuals affected by year

		create view AVG_PPL_AFFECTED_BY_YEAR as
				 select [year], AVG(individuals_affected) as AVG_Individuals_Affected
				 from CyberSecurityBreaches
				 group by [year]
			
	-- Joining TWO CTE to get AVERAGE INDIVIDUALS AFFECTED BY YEAR 		
		With TableOne as (
			 select 
				 [State], Individuals_Affected, [year]
			 from CyberSecurityBreaches		
			 ), 
				 TableTwo as (
				 select 
					 [year], AVG(individuals_affected) as AVG_Individuals_Affected
				 from CyberSecurityBreaches
				 group by [year]
				 )
			Select t1.*, t2.AVG_Individuals_Affected 
			from tableone as T1 
			JOIN TableTwo as T2  
				on T1.[year] = T2.[year]
				 ORDER BY AVG_Individuals_Affected DESC


	 -- Stored Procedure for Highest Count of Affected People DESC -- 4 MILLION around 2014
	create proc HighestCountAffected as 
				 select [State], max(individuals_affected) HighestCountAffected, 
				 Date_of_Breach
				 from CyberSecurityBreaches
				 group by [State], Date_of_Breach
				 order by HighestCountAffected desc
				
				EXEC HighestCountAffected ;

	-- SP for Lowest Count of Affected People searching them by their state & ID's
	-- Use PARAMETER 

	CREATE PROC LowestCountedAffected @state char(3)
	as 
		select min(individuals_affected) as LowestCountAffected 
		from CyberSecurityBreaches 
		where [State] = @state 

		exec LowestCountedAffected @state = 'NY'

	

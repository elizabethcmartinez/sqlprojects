--Looking at the TOTAL CASES vs. TOTAL DEATHS 
-- Shows the likelihood of dying if you contract covid in your Country 
-- In Mexico % 7.63 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 
as DeathPercentage
from covidproject..COVIDDeaths
where location like '%mexico%'
order by 1, 2

-- Looking at TOTAL CASES vs. Population 
-- Shows the percentage of population got Covid 
-- In Mexico %2.70

select location, date, population, total_cases, (total_cases/population)*100 
as PercentPopulationInfected from CovidProject..COVIDDeaths
where location like '%mexico%'
order by 1, 2

-- Looking at Countries with Highest Infection Rates compared to Population 

select location, population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 
as PercentPopulationInfected 
from CovidProject..COVIDDeaths
group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Deathcount per Population 

-- BREAK THINGS DOWN BY CONTINENT 
select location, max(cast(total_deaths as int)) AS TotalDeathCount
from CovidProject..COVIDDeaths 
where continent is null
group by location
order by TotalDeathCount desc;

-- Showing continents with the highest deathcount per population 
select continent, max(cast(total_deaths as int)) AS TotalDeathCount
from CovidProject..COVIDDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS 
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from covidproject..COVIDDeaths
where continent is not null 
group by date
order by 1, 2

--Looking at Total Population Vs. Vaccinations 

select *
from CovidProject..COVIDDeaths
join CovidProject..COVIDVaccinations vac dea
	on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
from CovidProject..COVIDDeaths dea
join CovidProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2, 3

--USING CTE 

With PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from CovidProject..COVIDDeaths dea
join CovidProject..COVIDVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)

select *, (RollingPeopleVaccinated/population)*100
from PopVsVac 

--GLOBAL NUMBERS REVISITED--

SELECT SUM(NEW_CASES) AS TOTAL_CASES, 
SUM(CAST(new_deaths AS int)) AS TOTAL_DEATHS, 
SUM(CAST(NEW_DEATHS AS INT))/SUM(new_cases)*100 AS DEATH_PERCENT 
FROM CovidProject..COVIDDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--TOTAL POPULATION VS. VACCINATIONS--

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..COVIDDeaths DEA
JOIN CovidProject..COVIDVaccinations VAC
	ON DEA.location = VAC.location
	AND DEA.DATE = VAC.date
WHERE dea.continent IS NOT NULL
order by 2, 3

-- USING A CTE -- TRY USING MAX FUNCTION WITHOUT DATE FOR EACH COUNTRY 

WITH POPVSVAC (CONTINENT, DATE, LOCATION, POPULATION, NEW_VACCINATIONS, RollingPeopleVaccinated)
AS (
SELECT dea.continent, DEA.DATE, dea.location, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..COVIDDeaths DEA
JOIN CovidProject..COVIDVaccinations VAC
	ON DEA.location = VAC.location
	AND DEA.DATE = VAC.date
WHERE dea.continent IS NOT NULL
--order by 2, 3
)

SELECT * , (RollingPeopleVaccinated/POPULATION)*100 AS PCNT_ROLLING_PPL_VAC
FROM POPVSVAC

--TEMP TABLE --
drop table if exists #percentpopulationvaccinated

CREATE TABLE #percentpopulationvaccinated
(CONTINENT NVARCHAR(255), 
LOCATION NVARCHAR(255), 
DATE DATETIME, 
POPULATION NUMERIC, 
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC)

INSERT INTO #percentpopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..COVIDDeaths DEA
JOIN CovidProject..COVIDVaccinations VAC
	ON DEA.location = VAC.location
	AND DEA.DATE = VAC.date
WHERE dea.continent IS NOT NULL
--order by 2, 3

SELECT * , (RollingPeopleVaccinated/POPULATION)*100 as POP_PRCNT_VACCINATED
FROM #percentpopulationvaccinated 

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS 

CREATE VIEW percentpopulationvaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..COVIDDeaths DEA
JOIN CovidProject..COVIDVaccinations VAC
	ON DEA.location = VAC.location
	AND DEA.DATE = VAC.date
WHERE dea.continent IS NOT NULL
--order by 2, 3

select * from percentpopulationvaccinated

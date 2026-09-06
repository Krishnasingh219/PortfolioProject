SELECT * 
FROM PortfoliProject..CovidDeaths
order by 3,4


--SELECT * 
--FROM PortfoliProject..CovidVaccinations
--order by 3,4

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfoliProject..CovidDeaths
WHERE location like '%india%'
ORDER BY 1,2


SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfoliProject..CovidDeaths
ORDER BY 1,2

--Looking total Cases vs population 

SELECT location,date,total_cases,population,(total_cases/population)*100 as AFFECTED
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
ORDER BY 1,2

--looking at countries with the highest infection rate compared to population 


SELECT location,population,MAX(total_cases) as highestinfectioncount,MAX((total_cases/population)*100) as AFFECTED
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
GROUP BY location,population
ORDER BY AFFECTED desc


--showing the countries with highest deathcount per population

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--LET'S BREAK THING DOWN BY CONTINENT

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Showing the continent with highest death count 

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS 
SELECT SUM(new_cases) as Total_Cases,SUM(cast(new_deaths as int)) as Total_Deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfoliProject..CovidDeaths
--WHERE location like '%india%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--Looking at total populations vs total vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
from PortfoliProject..CovidDeaths dea
join PortfoliProject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date=vac.date
where dea.continent is not null
order by 2,3

--CTE

with POPvsVAC (continent,location,date,population,new_vaccinations,RollingPeople1Vaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeople1Vaccinated
from PortfoliProject..CovidDeaths dea
join PortfoliProject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
SELECT *,(RollingPeople1Vaccinated/population)*100 
From POPvsVAC

--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeople1Vaccinated
from PortfoliProject..CovidDeaths dea
join PortfoliProject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

SELECT *,(RollingPeopleVaccinated/population)*100 
From #PercentPopulationVaccinated

--Creating view to store data for later 

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeople1Vaccinated
from PortfoliProject..CovidDeaths dea
join PortfoliProject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date=vac.date
where dea.continent is not null
--order by 2,3 

SELECT * 
FROM PercentPopulationVaccinated
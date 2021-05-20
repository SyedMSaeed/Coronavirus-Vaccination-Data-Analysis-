SELECT * 
FROM PortfolioProject..CovidDeaths


--SELECT * 
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases,total_deaths, population
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 1,2

-- What percentage of Canadian cases died due to covid 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPer
FROM PortfolioProject..CovidDeaths
where location = 'Canada' and continent is not null
ORDER BY 1,2

--Looking at every country's highest infection rate compared to ppopulation
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationEffected
FROM PortfolioProject..CovidDeaths
where continent is not null
group by population,location
ORDER BY PercentPopulationEffected desc

--Looking at Canada's highest count recorded
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/total_cases))*100 as PercentPopulationEffected
FROM PortfolioProject..CovidDeaths
where location = 'Canada'
group by population,location
ORDER BY 1,2

-- Looking at every country's total deaths
select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Looking at Global numbers each day
select date,sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, 
 sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Now joining the CovidVaccinations table
Select * 
from PortfolioProject.. CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
 on dea.location=vac.location and dea.date = vac.date

--Looking at Population percentage Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations, (vac.total_vaccinations/population)*100 as PercentPopulationVaccinated
from PortfolioProject.. CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location and dea.date = vac.date
where dea.continent is not null 
order by 2,3



----Total People vaccinated in every country in a new table

CREATE TABLE PercentPopulationVaccinated
(
Country nvarchar(255),
Population numeric,
PeopleVaccinated numeric,
PercentPeopleVaccinated numeric,
)

Insert into PercentPopulationVaccinated
select CovidDeaths.location, CovidDeaths.population, MAX(CovidVaccinations.total_vaccinations), (MAX(CovidVaccinations.total_vaccinations)/MAX(population))*100 
from PortfolioProject.. CovidDeaths 
join PortfolioProject..CovidVaccinations 
 on CovidDeaths.location=CovidVaccinations.location and CovidDeaths.date = CovidVaccinations.date 
 where CovidDeaths.continent is not null
 group by CovidDeaths.population,CovidDeaths.location
 order by 1




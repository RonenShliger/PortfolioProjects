select location, date, total_cases, new_cases, total_deaths , population
from PortfolioProject..CovidDeaths
order by 1,2

--looking at Total Cases vs total Deaths
--likelihood of deaing in israel
select location, date, total_cases,total_deaths, (total_deaths/total_cases) AS DeathPrecentage
from PortfolioProject..CovidDeaths
where location like '%ISRAEL%'
order by 1,2;


--looking at Total Cases vs total Deaths
--shows what precntage of population got covid
select location, date,population, total_cases,total_deaths, (total_deaths/total_cases)*100 AS PrecentagePopulationInfected
from PortfolioProject..CovidDeaths

where location like '%ISRAEL%'
order by 1,2;


--highest infection rate comperd to population
select location ,population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 as PrecentagePopulationInfected
from PortfolioProject..CovidDeaths
group by  location, population
order by PrecentagePopulationInfected DESC


--Showing countries with highest death count per population
select location, MAX(total_deaths ) AS TotaltDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotaltDeathCount DESC


--Showing countries with highest death count per population
Select continent, MAX(total_deaths ) AS TotaltDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NUll
Group by continent
Order by TotaltDeathCount DESC


--GLOBAL NUMBERS
select date,  sum(new_cases)as total_cases, SUM(new_deaths) as total_deaths ,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NUll
group by date 
order by 1,2 


-- Total population vs vaccinations

--USE CTE
with PopvsVac (continent, location, date, Population, new_vaccinations ,RollingPepoleVaccinated)
as
(
select dea.continent,dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by dea.location, dea.date)
as RollingPepoleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (RollingPepoleVaccinated/Population)*100 AS Vaccinated_Persentage
from PopvsVac


--TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated
(
Lontinent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinaions numeric,
RollingPepoleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by dea.location, dea.date)
as RollingPepoleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select * , (RollingPepoleVaccinated/Population)*100
from #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as 
select dea.continent,dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by dea.location, dea.date)
as RollingPepoleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated

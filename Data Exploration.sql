Select *
from PortfolioProject..CovidVaccinations$

Select *
from PortfolioProject..CovidVaccinations$
order by 3,4

Select *
from PortfolioProject..CovidDeaths$
where continent is not NULL
order by 3,4


Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%pakistan%'
and continent is not null 
order by 1,2

--Total cases vs Total Population
Select Location, date, total_cases,population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
Where location like '%pakistan%'
order by 1,2

--Countries with Highest infection rate compared to Population
Select Location,population, MAX(total_cases) as HighInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
Select Location, MAX(Cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not NULL
group by location
order by TotalDeathsCount desc

--Showing Continents with Highest Death Count per Population
Select continent, MAX(Cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not NULL
group by continent
order by TotalDeathsCount desc

--Global numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not NULL
group by date
order by 1,2

--looking at total population Vs vaccination
Select dea.date, dea.location, dea.continent, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.date= vac.date
and dea.location = vac.location
where dea.continent is not null
order by 2,3

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Select *
From portfolioproject..CovidDeaths
Where continent is not null
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From portfolioproject..CovidDeaths
Where location like '%Nigeria%' and continent is not null
order by 1,2

-- Looking at the Total Cases Vs Population
-- Shows what percentage of the population got the virus
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From portfolioproject..CovidDeaths
Where location like '%Nigeria%'and continent is not null
order by 1,2

--Looking at the countries with the highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as HighestPercentPopulation
From portfolioproject..CovidDeaths
Where continent is not null
Group by Location
order by HighestPercentPopulation desc

-- Showing the countries with the highest Death Count per population

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT



--Showing the continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_death
, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Looking at Total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
from portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE
With PopvsVac (continent, location, date, Population, new_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
from portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using TEMP Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
from portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating Views to store data for Later Visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
from portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated

Create View Totaldeathpercountry as
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by Location
--order by TotalDeathCount desc

Select *
From Totaldeathpercountry
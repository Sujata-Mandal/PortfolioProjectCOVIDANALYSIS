select *
From portfolioproject..CovidDeaths$
where continent is not null
order by 3,4
--select *
--From portfolioproject..CovidVaccinations$
--order by 3,4
select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths$
where continent is not null
order by 1,2
select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths$
where location like '%India%'
and continent is not null
order by 1,2
select Location, Date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From portfolioproject..CovidDeaths$
where location like '%India%'
and continent is not null
order by 1,2
select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
From portfolioproject..CovidDeaths$
where continent is not null
--where location like '%India%'
group by location, population
order by PercentagePopulationInfected desc 
select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths$
--where location like '%India%'
where continent is not null
group by location
order by TotalDeathCount desc
select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths$
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

select SUM (new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM (cast(new_deaths as int))/ SUM (new_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths$
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


select *
From portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (convert(int, vac.new_vaccinations)) OVER (Partition By dea.location order by dea.location, dea.date)as rollingpeoplevaccinated--/Population) *100
From portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
where dea.continent is not null
order by 2,3

--WITH CTE


With PopVsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (Int, vac.new_vaccinations)) OVER (Partition By dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
From portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/ Population)*100
From PopVsVac

--temp table

DROP Table if exists #percentpopulationvaccinated
CREATE Table #percentpopulationvaccinated
(
continent nvarchar(255)
location nvarchar(255)
Date datetime,
Population Numeric,
New_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (Int, vac.new_vaccinations)) OVER (Partition By dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
From portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
where dea.continent is not null
--order by 2,3

select*, (RollingPeopleVaccinated/ Population)*100
From #percentpopulationvaccinated

--creating view
Create view percentagepopulationvaccinated1 as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (Int, vac.new_vaccinations)) OVER (Partition By dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
From portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
where dea.continent is not null
--order by 2,3

select *
from percentagepopulationvaccinated
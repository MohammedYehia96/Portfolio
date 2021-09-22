
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolio_projects..covid_deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select location , MAx(cast(total_deaths as numeric)) as  total_deaths
From portfolio_projects..covid_deaths
where continent is  null and location not in ('World', 'European Union', 'International')	
Group by location 
Order by total_deaths desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_projects..covid_deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_projects..covid_deaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc 

Select sum(new_cases) as total_cases_world,sum(new_deaths) as total_deaths_world ,(sum(new_deaths)/sum(new_cases))*100 as death_percentage_world
From portfolio_projects..covid_deaths
where continent is not null
--Group by date
ORder by 1,2;



With pepvsvac( continent , location , date , population , new_vaccinations, rolling_people_vaccinated)
AS
(Select distinct dea.continent ,dea.location,  dea.date, dea.population , vac.people_vaccinated ,
Max(cast(vac.people_vaccinated as numeric)) Over (partition by dea.location order by dea.location , dea.date) as rolling_people_vaccinated 
From portfolio_projects..covid_deaths dea
join portfolio_projects..vaccinations vac
On dea.population = vac.population
and dea.date =vac.date
Where dea.continent is not null)
Select *, (rolling_people_vaccinated/population) *100 as percentage_vaccinated
from pepvsvac
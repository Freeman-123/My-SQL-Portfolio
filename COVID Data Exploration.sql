select *
from Covid_Project..CovidDeaths

--select *
--from Covid_Project..CovidVaccinations

select location,date,total_cases,new_cases,total_deaths,population
from Covid_Project..CovidDeaths
where continent is not null
order by 1,2

--Total cases vs Total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)* 100 as MortalityRate
from Covid_Project..CovidDeaths
where location like '%africa%'
order by 1,2


----Total cases vs population
--% population with Covid

select location,date,population, total_cases, (total_cases/population)* 100 as PercentageWithCovid
from Covid_Project..CovidDeaths
where location like '%africa%'
order by 1,2

--Countries  with the Highest infection rate compared to population

select location,population, MAX(total_cases) AS InfectionCount, max(total_cases/population)* 100 as PercentageWithCovid
from Covid_Project..CovidDeaths
--where location like '%africa%'
group by location,population
order by PercentageWithCovid desc

--Countries with the highest Deaths

select location, MAX(cast(total_deaths as int)) AS DeathCount
from Covid_Project..CovidDeaths
--where location like '%africa%'
where continent is not null
group by location
order by DeathCount desc

--Continent with highest deaths

select location, MAX(cast(total_deaths as int)) AS DeathCount
from Covid_Project..CovidDeaths
--where location like '%africa%'
where continent is null
group by location
order by DeathCount desc


select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
from Covid_Project..CovidDeaths
--where location like '%africa%'
where continent is not null
--group by date
order by 1,2 


--use cast(value as int) or convert(int, value) for conversion

select de.continent,de.location, de.date, de.population, va.new_vaccinations
, SUM(convert(int, va.new_vaccinations)) over (partition by de.location order by de.location, de.date) as RollingVaccinations
from
	Covid_Project..CovidDeaths de
join
	Covid_Project..CovidVaccinations va
	on 
		de.location = va.location
	and
		de.date = va.date
where de.continent is not null
order by 2,3


--USE CTE

With Pop_Vac (continent,location, date, population, new_vaccinations
		, RollingVaccinations)
as
(
select de.continent,de.location, de.date, de.population, va.new_vaccinations
		, SUM(cast(va.new_vaccinations as bigint)) over (partition by de.location order by de.location, de.date) as RollingVaccinations
from
	Covid_Project..CovidDeaths de
join
	Covid_Project..CovidVaccinations va
	on 
		de.location = va.location
	and
		de.date = va.date
where de.continent is not null
--order by 2,3
)

select * --(RollingVaccinations/population)*100
from Pop_Vac


-- TEMP TABLE

Drop table if exists Percent_population_vaccinated
create table Percent_population_vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_Vaccinations numeric
)

insert into Percent_population_vaccinated
select de.continent,de.location, de.date, de.population, va.new_vaccinations
		, SUM(cast(va.new_vaccinations as bigint)) over (partition by de.location order by de.location, de.date) as RollingVaccinations
from
	Covid_Project..CovidDeaths de
join
	Covid_Project..CovidVaccinations va
	on 
		de.location = va.location
	and
		de.date = va.date
where de.continent is not null

select *
from Percent_population_vaccinated
--order by 2,3

--Create View to staore data for visualizations

create view  Percent_pop_vaccinated as
select de.continent,de.location, de.date, de.population, va.new_vaccinations
		, SUM(cast(va.new_vaccinations as bigint)) over (partition by de.location order by de.location, de.date) as RollingVaccinations
from
	Covid_Project..CovidDeaths de
join
	Covid_Project..CovidVaccinations va
	on 
		de.location = va.location
	and
		de.date = va.date
where de.continent is not null

select *
from  Percent_pop_vaccinated
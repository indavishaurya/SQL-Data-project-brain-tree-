Select distinct [year],count(country_code) over(partition by [year]) as count_countries,round(sum(gdp_per_capita) over(partition by [year]),2) as sum_countries
from per_capita
where [year]<2012 and country_code in (Select country_code from per_capita where [year]=2012 and gdp_per_capita is NULL) and gdp_per_capita is not null
Select top 1 count(c.country_name) over () as count,round(sum(p.gdp_per_capita) over(),2)as [sum]
from per_capita as p
left join 
countries as c
on p.country_code=c.country_code
where p.year='2007' and country_name like '%an%'


Select top 1 count(c.country_name) over () as count,round(sum(p.gdp_per_capita) over(),2)as [sum]
from per_capita as p
left join 
countries as c
on p.country_code=c.country_code
where p.year='2007' and country_name collate Latin1_General_CS_AS like '%an%'
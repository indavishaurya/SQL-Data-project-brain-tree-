Select h1.continent_name,h1.country_code,h1.country_name,round(h1.gdp_per_capita,2) as gdp_per_capita,round(h1.running_gdp_per_capita,2) as running_gdp_per_capita
from
(Select h.*,row_number() over(partition by h.continent_name order by substring(h.country_name,2,3)) as [rank]
from
(Select cont.continent_name,pc.country_code,con.country_name,pc.gdp_per_capita,sum(pc.gdp_per_capita) over(partition by cont.continent_name order by substring(con.country_name,2,3) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as running_gdp_per_capita
from per_capita as pc
left join
countries as con
on pc.country_code=con.country_code
left join 
(Select country_code,continent_code
from
(Select country_code,continent_code,ROW_NUMBER() over (partition by country_code order by country_code) as rank_
from
(Select ISNULL(country_code,'FOO') as country_code,continent_code
from continent_map) as f) as f1
where rank_=1 ) as map
on pc.country_code=map.country_code
left join 
continents as cont
on map.continent_code=cont.continent_code
where pc.[year]='2009') as h
where h.running_gdp_per_capita>=70000 ) as h1
where h1.[rank]=1



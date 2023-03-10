Select cont.continent_name,pc.country_code,con.country_name,pc.[year],ROUND(pc.gdp_per_capita,2) as gdp_per_capita
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
Select Rank() over(order by f1.gdp_rate desc) as [rank],f1.continent_name,f1.country_code,f1.country_name,f1.gdp_rate
from
(Select *
from
(Select i.*,rank() over(partition by continent_name order by gdp_rate desc) as [rank]
from
(Select g.*,round(((g.gdp_per_capita_2012-g.gdp_per_capita_2011)/g.gdp_per_capita_2011)*100,2) as gdp_rate
from 
(Select h.country_code,h.country_name,h.continent_name,round(h.gdp_per_capita,2) as gdp_per_capita_2011,round(h1.gdp_per_capita,2) as gdp_per_capita_2012
from
(Select pc.*,con.country_name,cont.continent_name
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
where [year]='2011') as h
left join
(Select pc.*,con.country_name,cont.continent_name
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
where [year]='2012') as h1
on h.country_code=h1.country_code) as g
where g.gdp_per_capita_2011 is not null and g.gdp_per_capita_2012 is not null and g.continent_name is not null) as i) as j
where j.[rank] in (10,11,12)) as f1



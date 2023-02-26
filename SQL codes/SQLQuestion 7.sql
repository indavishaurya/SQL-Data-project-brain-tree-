Select h.[rank],h.continent_name,h.country_code,h.country_name,h.avg_per_capita
from
(Select cont.continent_name,pc.country_code,con.country_name,round(avg(pc.gdp_per_capita),2) as avg_per_capita,RANK() over(partition by cont.continent_name order by avg(pc.gdp_per_capita) desc) as [rank]
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
group by con.country_name,cont.continent_name,pc.country_code) as h
where h.[rank]=1 and h.continent_name is not null
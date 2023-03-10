Select *
from
(Select h3.category,round((h3.total_gdp_per_capita/h3.cumulative_sum)*100,2) as percentage
from
(Select h2.*,sum(h2.total_gdp_per_capita) over () as cumulative_sum
from
(Select h1.category,SUM(h1.gdp_per_capita) as total_gdp_per_capita
from
(Select h.*,(case when h.continent_name='Asia' then 'Asia' when h.continent_name='Africa' then 'Africa' else 'Rest of the World' end) as category
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
where [year]='2012') as h) as h1
group by h1.category) as h2) as h3) as h4
pivot
( sum(h4.[percentage]) for h4.category in ([Africa],[Asia],[Rest of the World])) as Pivot_table
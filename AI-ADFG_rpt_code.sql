



-- voucher_3nm (z)

select b.common_name, b.species_name, count(*) "Count", 'Age Sample' "Comment"
from racebase.specimen a, racebase.species b, racebase.haul c, ai.stations_3nm d
where a.region = 'AI'
and a.cruise = 202201
and a.cruise = c.cruise
and a.region = c.region
and a.hauljoin = c.hauljoin
and c.stationid = d.stationid
and c.stratum = d.stratum
and a.species_code = b.species_code
and a.specimen_sample_type = 1
group by b.common_name, b.species_name, 'Age Sample'
union
select b.common_name, b.species_name, sum(number_fish) "Count", 'Voucher' "Comment"
from racebase.catch a, racebase.species b, racebase.haul c, ai.stations_3nm d
where a.region = 'AI'
and a.cruise = 202201
and a.region = c.region
and a.cruise = c.cruise
and a.hauljoin = c.hauljoin
and c.stationid = d.stationid
and c.stratum = d.stratum
and a.species_code = b.species_code
and a.voucher is not null
group by b.common_name, b.species_name, 'Voucher'
order by "Comment" desc 
/


-- Voucher all (xy)

select b.common_name, b.species_name, count(*) "Count", 'Age Sample' "Comment"
from racebase.specimen a, racebase.species b
where a.region = 'AI'
and a.cruise = 202201
and a.species_code = b.species_code
and a.specimen_sample_type = 1
group by b.common_name, b.species_name, 'Age Sample'
union
select b.common_name, b.species_name, sum(number_fish) "Count", 'Voucher' "Comment"
from racebase.catch a, racebase.species b
where a.region = 'AI'
and a.cruise = 202201
and a.species_code = b.species_code
and a.voucher is not null
group by b.common_name, b.species_name, 'Voucher'
order by "Comment" desc 
/


--Weight All (y)
select c.species_code, common_name, species_name, sum(weight) total_weight_kg, sum(number_fish) total_count
from racebase.haul h, racebase.catch c, racebase.species r
where h.region = 'AI'
and h.cruise = 202201
and h.hauljoin = c.hauljoin -- shorthand join by haul
and c.species_code = r.species_code 
group by c.species_code, common_name, species_name
order by species_name
/

--Weight 3nm (x)
select r.species_code, r.common_name, r.species_name, sum(c.weight) total_weight_kg, sum(c.number_fish) total_count
from racebase.haul h, racebase.catch c, ai.stations_3nm s, racebase.species r
where h.region = 'AI'
and h.cruise = 202201
and h.hauljoin = c.hauljoin -- shorthand join by haul
and c.species_code = r.species_code 
and h.stationid = s.stationid
and h.stratum = s.stratum 
group by r.species_code, r.common_name, r.species_name
order by r.species_name
/








------------------------------------------------
-- new voucher 3nm table

select b.common_name, b.species_name, count(*) "Count", 'Age Sample' "Comment"
from racebase.specimen a, racebase.species b, racebase.haul c
where a.region = 'AI'
and a.cruise = 202201
and a.cruise = c.cruise
and a.region = c.region
and a.hauljoin = c.hauljoin
and (stationid,stratum) in ( 
select stationid, stratum
from ai.stations_3nm
where stratum != 0
)
and a.species_code = b.species_code
and a.specimen_sample_type = 1
group by b.common_name, b.species_name, 'Age Sample'
union
select b.common_name, b.species_name, sum(number_fish) "Count", 'Voucher' "Comment"
from racebase.catch a, racebase.species b, racebase.haul c
where a.region = 'AI'
and a.cruise = 202201
and a.region = c.region
and a.cruise = c.cruise
and a.hauljoin = c.hauljoin
and (stationid,stratum) in ( 
select stationid, stratum
from ai.stations_3nm
where stratum != 0
)
and a.species_code = b.species_code
and a.voucher is not null
group by b.common_name, b.species_name, 'Voucher'
order by "Comment" desc
/


-- new 3nm summary table
--Weight 3nm (x)
select r.species_code, r.common_name, r.species_name, sum(c.weight) total_weight_kg, sum(c.number_fish) total_count
from racebase.haul h, racebase.catch c, racebase.species r
where h.region = 'AI'
and h.cruise = 202201
and h.hauljoin = c.hauljoin -- shorthand join by haul
and c.species_code = r.species_code 
and (stationid,stratum) in ( 
select stationid, stratum
from ai.stations_3nm
where stratum != 0
)
group by r.species_code, r.common_name, r.species_name
order by r.species_name
/

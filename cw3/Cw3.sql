-- 1 shp2pgsql -s 4326 T2019_STREET_NODE.shp T2019_STREET_NODE | psql -U postgres -h localhost -p 5432 -d lab3


create view builtInYear as
(
select geom from t2019_kar_buildings 
except 
select geom from t2018_kar_buildings
);

select * from builtInYear;

--2

create view pois as (
select geom,type from t2019_kar_poi_table
except 
select geom, type from t2018_kar_poi_table
);

select count(pois.geom), pois.type
from pois 
join builtInYear on st_contains(st_buffer(builtInYear.geom, 0.005), pois.geom)
group by pois.type

-- 3
create table streets_reprojected as
(select * from t2019_kar_streets);

select UpdateGeometrySRID('streets_reprojected','geom', 3068)

-- 4
create table input_points(id int, geom geometry, name varchar);

insert into input_points values (1, 'POINT(8.36093 49.03174)', 'A')
								,(2, 'POINT(8.39876 49.00644)', 'B')
								
-- 5
select UpdateGeometrySRID('input_points','geom', 3068)	

-- 6
select UpdateGeometrySRID('t2019_kar_street_node','geom', 3068)	

with bufferD as(
select st_buffer(st_MakeLine(geom),0.002)
from input_points)

select s.geom
from t2019_kar_street_node s
join bufferD dist on st_intersects(dist.st_buffer, s.geom)

-- 7
create view sport as (
select * 
from t2019_kar_poi_table
where type= 'Sporting Goods Store'
);

create view park as (
select * 
from t2019_kar_land_use_a
where type like '%Park%'
);

select count(sport.geom)
from sport
join park on st_contains(st_buffer(park.geom, 0.003), sport.geom)

--8
select st_intersection(r.geom, w.geom)
into t2019_kar_bridges
from t2019_kar_railways r
join t2019_kar_water_lines w on st_intersects(r.geom, w.geom);

select * from t2019_kar_bridges
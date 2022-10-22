-- Zadanie 2
create database cwiczenia2;
-- Zadanie 3
-- CREATE EXTENSION postgis;
-- Zadanie 4
create table buildings (
    id SERIAL PRIMARY KEY,
    geom geometry,
    name varchar
);
create table roads (
    id SERIAL PRIMARY KEY,
    geom geometry,
    name varchar
);
create table poi (
    id SERIAL PRIMARY KEY,
    geom geometry,
    name varchar
);
-- Zadanie 5
insert into buildings(geom, name)
values ('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
       ('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
       ('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
       ('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
       ('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 'BuildingF');
       
      
insert into roads(geom, name)
VALUES ('LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
       ('LINESTRING(7.5 10.5,7.5 0)', 'RoadY');
       

insert into poi(geom, name)
VALUES 
       ('POINT(6 9.5)', 'K'),
       ('POINT(6.5 6)', 'J'),
       ('POINT(9.5 6)', 'I'),
       ('POINT(1 3.5)', 'G'),
       ('POINT(5.5 1.5)', 'H');
-- Zadanie 6
-- a
select sum(ST_Length(geom)) 
from roads;

-- b 
select St_AsText(geom),ST_Area(geom),ST_Perimeter(geom) 
from buildings 
where name = 'BuildingA';

-- c
select name,ST_Area(geom) 
from buildings 
order by name;

-- d
select name,ST_Perimeter(geom) as perim 
from buildings 
order by perim 
limit 2;

-- e
select ST_Distance(poi.geom, buildings.geom) as dist 
from buildings 
cross join poi 
where poi.name = 'K' and buildings.name = 'BuildingC' 
order by dist DESC 
limit 1;

-- f
select st_area(st_difference(a.geom, st_buffer(b.geom, 0.5))) 
from buildings a, buildings b
where a.name = 'BuildingC' and b.name = 'BuildingB';

-- g
select b.name 
from buildings b, roads r
where r.name = 'RoadX' and st_y(st_centroid(b.geom)) > st_y(st_centroid(r.geom));

-- h
select st_area(st_symdifference(geom,  st_geomfromtext('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) 
from buildings
where name = 'BuildingC';
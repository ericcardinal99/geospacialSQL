CREATE DATABASE geoville;
USE geoville;

CREATE TABLE parks (
    park_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    area GEOMETRY NOT NULL,
    SPATIAL INDEX(area)
);

CREATE TABLE roads (
    road_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    path LINESTRING NOT NULL,
    SPATIAL INDEX(path)
);

CREATE TABLE buildings (
    building_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    footprint POLYGON NOT NULL,
    SPATIAL INDEX(footprint)
);

INSERT INTO parks (name, area) VALUES
('Central Park', ST_GeomFromText('POLYGON((-73.973057 40.764356,-73.981898 40.768094,-73.958209 40.800621,-73.949282 40.796853,-73.973057 40.764356))')),
('Riverside Park', ST_GeomFromText('POLYGON((-74.973057 41.764356,-75.981898 42.768094,-76.958209 44.800621,-77.949282 40.796853,-63.973057 41.764356))'));


INSERT INTO roads (name, path) VALUES
('Main Street', ST_GeomFromText('LINESTRING(1,2,3,4)')),
('2nd Avenue', ST_GeomFromText('LINESTRING(7,8,9,10)'));

INSERT INTO buildings (name, footprint) VALUES
('City Hall', ST_GeomFromText('POLYGON((-73.973057 40.764356,-73.981898 40.768094,-73.958209 40.800621,-73.949282 40.796853,-73.973057 40.764356))')),
('Library', ST_GeomFromText('POLYGON((-74.973057 41.764356,-75.981898 42.768094,-76.958209 44.800621,-77.949282 40.796853,-63.973057 41.764356))'));

SELECT name, ST_AsText(area) FROM parks;

SELECT name FROM buildings
WHERE ST_Contains(ST_GeomFromText('POLYGON((-73.973057 40.764356,-73.981898 40.768094,-73.958209 40.800621,-73.949282 40.796853,-73.973057 40.764356))'), footprint);

SELECT ST_Distance(
    ST_GeomFromText('POINT(x1 y1)'),
    ST_GeomFromText('POINT(x2 y2)')
) AS distance;

SELECT p.name, ST_Distance(b.footprint, p.area) AS distance
FROM buildings b, parks p
WHERE b.name = 'City Hall'
ORDER BY distance ASC
LIMIT 1;

SELECT r.name
FROM roads r, parks p
WHERE p.name = 'Central Park' AND ST_Distance(r.path, p.area) < 0.005;

SELECT name, ST_Area(area) AS area
FROM parks;

SELECT name, ST_Perimeter(footprint) AS perimeter
FROM buildings;

SELECT b.name
FROM buildings b, roads r
WHERE ST_Intersects(b.footprint, r.path);

SELECT name
FROM parks
WHERE ST_Contains(area, ST_GeomFromText('POINT(x y)'));

SELECT name, ST_Buffer(area, 0.001) AS buffer_area
FROM parks;

SELECT b.name
FROM buildings b, parks p
WHERE ST_Contains(ST_Buffer(p.area, 0.001), b.footprint);

SELECT ST_Union(
    (SELECT area FROM parks WHERE name = 'Central Park'),
    (SELECT area FROM parks WHERE name = 'Riverside Park')
) AS combined_area;

SELECT ST_Difference(
    (SELECT area FROM parks WHERE name = 'Central Park'),
    (SELECT area FROM parks WHERE name = 'Riverside Park')
) AS difference_area;

SELECT b.name
FROM buildings b, parks p
WHERE ST_Touches(b.footprint, p.area);

SELECT b.name
FROM buildings b
WHERE ST_Within(b.footprint, ST_GeomFromText('POLYGON((-73.973057 40.764356,-73.981898 40.768094,-73.958209 40.800621,-73.949282 40.796853,-73.973057 40.764356))'));

SELECT r.name
FROM roads r, parks p
WHERE ST_Crosses(r.path, p.area);
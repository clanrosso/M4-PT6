/* 
CREATE TABLE studentStatus (
	id serial PRIMARY KEY,
	status varchar(50) NOT NULL UNIQUE
);
*/
/*
INSERT INTO studentstatus (status)
VALUES ('pending');
*/
/*
INSERT INTO studentstatus (status)
VALUES ('awaiting'),('active'),('suspended'),('droped out'),('graduated');
*/
/*
CREATE TABLE students (
	id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	surname varchar(50) NOT NULL,
	email varchar(255) NOT NULL UNIQUE,
	phone varchar(50) NOT NULL UNIQUE
)
*/
/*
ALTER TABLE students 
ADD statusid int references studentstatus (id);
*/
/*
INSERT INTO students (name, surname, email, phone, statusid)
VALUES ('Claudio','Rosso','crosso@students.soyhenry.com','+451122222222',1);
*/
/*
ALTER TABLE students
ALTER COLUMN statusid SET DEFAULT 1;
*/
/*
INSERT INTO students (name, surname, email, phone)
VALUES ('Santiago','Fernandez','sfernandez@students.soyhenry.com','+451122222221'),
('Pedro','Moran','pmoran@students.soyhenry.com','+451122222223');
*/
/*
SELECT *
FROM students;
*/
/*
SELECT *
FROM students
WHERE id = 1;
*/
/*
SELECT *
FROM students
WHERE name = 'Claudio';
*/
/*
SELECT *
FROM students
WHERE UPPER(name) = 'CLAUDIO';
*/
/*
SELECT id, name, email
FROM students
WHERE name ilike 'c%';
*/
/*
SELECT s.id as id, s.name as name, s.surname as surname, ss.status as status
FROM students as s
JOIN studentstatus as ss ON s.statusid = ss.id
ORDER BY s.surname DESC, s.name;
*/
/*
UPDATE students
SET statusid = 2
WHERE id = 1;
*/
/*
SELECT s.id as id, s.name as name, s.surname as surname, ss.status as status
FROM students as s
JOIN studentstatus as ss ON s.statusid = ss.id
WHERE ss.id = 2
ORDER BY s.surname DESC, s.name;
*/
/*
SELECT COUNT(*)
FROM students as s
JOIN studentstatus as ss ON s.statusid = ss.id
WHERE ss.id = 1;
*/
/*
SELECT status, COUNT(s.id)
FROM students as s
RIGHT JOIN studentstatus as ss ON s.statusid = ss.id
GROUP BY status, ss.id
ORDER BY ss.id;
*/
/*
DELETE FROM students WHERE id=3;

SELECT *
FROM students
WHERE statusid NOT IN (
	SELECT id
	FROM studentstatus
	WHERE id = 1
)
*/

actors     directors_genres  movies_directors  roles
directors  movies            movies_genres

#1
SELECT name, year FROM movies WHERE year=1987 LIMIT 10;

#2
SELECT COUNT(*) FROM movies WHERE year=1982;

#3
SELECT first_name, last_name FROM actors WHERE last_name like '%stack%';

#4
SELECT first_name, last_name, COUNT(*) as total
FROM actors 
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY total DESC
LIMIT 10;

#5
SELECT a.first_name, a.last_name, COUNT(*) as total
FROM actors as a  
JOIN roles as r
ON r.actor_id = a.id
GROUP BY a.id
ORDER BY total DESC
LIMIT 10;

#6
SELECT genre, COUNT(*) as total
FROM movies_genres 
GROUP BY genre
ORDER BY total
LIMIT 10;

7#
SELECT a.first_name, a.last_name, r.role 
FROM actors as a
JOIN roles as r
ON r.actor_id = a.id
JOIN movies as m
ON r.movie_id = m.id
WHERE m.name = "Braveheart" AND m.year = "1995"
ORDER BY a.last_name, a.first_name;

8#
SELECT d.first_name, m.name, m.year
FROM directors as d
JOIN movies_directors as md
ON md.director_id = d.id
JOIN movies as m
ON md.movie_id = m.id
JOIN movies_genres as mg
ON mg.movie_id = m.id
WHERE mg.genre = "Film-Noir" AND m.year % 4 = 0
ORDER BY m.name;

9#
SELECT a.first_name, a.last_name
FROM actors as a
JOIN roles as r
ON r.actor_id = a.id
JOIN movies as m
ON r.movie_id = m.id
JOIN movies_genres as mg
ON mg.movie_id = m.id
WHERE mg.genre = "Drama" AND r.movie_id IN (
    SELECT r.movie_id
    FROM roles as r
    JOIN actors as a
    ON r.actor_id = a.id
    WHERE a.first_name = "Kevin" AND a.last_name = "Bacon"
) 
AND(a.first_name || " " || a.last_name != "Kevin Bacon")
LIMIT 10;

#10

SELECT * 
FROM actors
WHERE id IN(
    SELECT r.actor_id
    FROM roles as r
    JOIN movies as m
    ON r.movie_id = m.id
    WHERE m.year < 1900)
AND id IN(
    SELECT r.actor_id
    FROM roles as r
    JOIN movies as m
    ON r.movie_id = m.id
    WHERE m.year > 2000);

#11
SELECT a.first_name, a.last_name, COUNT(DISTINCT(r.role)) as total
FROM actors as a 
JOIN roles as r
ON r.actor_id = a.id
JOIN movies as m
ON r.movie_id = m.id
WHERE m.year > 1990
GROUP BY r.movie_id, r.actor_id
HAVING total > 5;

#12
SELECT m.year, COUNT(DISTINCT(m.id)) as total
FROM movies as m
WHERE m.id NOT IN (
    SELECT r.movie_id
    FROM roles as r
    JOIN actors as a
    ON r.actor_id = a.id
    WHERE a.gender = "M"
)
GROUP BY m.year;





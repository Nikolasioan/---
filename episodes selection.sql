use project;

create table ran_nationalities as
select name "nationality" from nationality order by rand() limit 10;
#check
select * from ran_nationalities;
#drop table ran_nationalities;

#select 10 random nationalities
create view random_nationalities as
select name "nationality" from nationality order by rand() limit 10 ;
#drop view random_nationalities;

select * from random_nationalities;
#select * from nationality;

#find all the recipies for each of the 10 random nationalities
create view random_nationality_recipies as
select rnat.nationality "nationality" , rec.name "recipe" from
ran_nationalities rnat inner join recipies rec
on rnat.nationality = rec.nationality
order by rec.nationality;

select * from random_nationality_recipies;
#drop view random_nationality_recipies;

#give random order to the recipies of each nationality
create view random_recipies as
select nationality, recipe , row_number() over (partition by nationality order by rand()) as ro
from random_nationality_recipies;

select * from random_recipies;
drop view random_recipies;

#choose randomly one recipe for each nationality
create view selected_recipies as
select nationality, recipe
from random_recipies where ro=1;

select * from selected_recipies;

#COOKS CHECK AGAAAINNNN (maybe you need to create a temporary table for random nationalities)

#find all the cooks for each of the 10 random nationalities
create view random_nationality_cook as
select rnat.nationality "nationality" , cs.cook_id "cook_id" from
ran_nationalities rnat join cook_specialty cs
on rnat.nationality = cs.cuisine_nationality
order by cs.cuisine_nationality;

select * from random_nationality_cook;
#drop view random_nationality_cook;
select * from cook_specialty order by cuisine_nationality;

#give random order to the cooks of each nationality
create view rand_nat_cook as
select nationality, cook_id , row_number() over (partition by nationality order by rand()) as ro
from random_nationality_cook;

select * from rand_nat_cook;
#drop view rand_nat_cook;

#choose randomly one cook for each nationality
create view selected_cooks as
select nationality, cook_id
from rand_nat_cook where ro=1;

select * from selected_cooks;

create view data as
select sc.cook_id, sc.nationality, sr.recipe
from selected_cooks sc join selected_recipies sr
on sc.nationality = sr.nationality;

select * from data;

#CREATE 100 episodes, 10 for each year
DELIMITER //
CREATE PROCEDURE insert_episodes()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE s INT DEFAULT 1;
    WHILE i <= 100 DO
        IF i % 10 = 1 THEN
            SET s = CEIL(i / 10);
        END IF;
        INSERT INTO episode (season) VALUES (s);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- Call the stored procedure to insert the episodes
CALL insert_episodes();
select * from episode;


use project;
#show tables;

#select * from ran_nationalities rn join cook_specialty cs
#on rn.nationality=cs.cuisine_nationality
#order by rn.nationality;

#select * from nationality join cook_specialty cs
#on nationality.name = cs.cuisine_nationality;

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

# Call the stored procedure to insert the episodes
CALL insert_episodes();

DELIMITER //
create procedure episodes_random_fill()
begin
	declare i int default 1;
    while i <=100 do
		insert into ep_data (ep_id,cook_id,recipe_name)
		with 
		#choose randomly 10 nationalities
		random_nationalities as (
		select name "nationality" from nationality order by rand() limit 10
        ),
		#find all the cooks for each nationality
		ranked_cooks as (
			select
				cs.cook_id "cook_id",
				cs.cuisine_nationality "nationality",
				ROW_NUMBER() OVER (PARTITION BY cs.cuisine_nationality ORDER BY RAND()) AS ro
			from 
				cook_specialty cs
			join 
				random_nationalities rnat on cs.cuisine_nationality = rnat.nationality
		),
		#choose randomly one cook for each nationality
		selected_cooks as (
			select
				cook_id,
				nationality
			from
				ranked_cooks
			WHERE 
				ro = 1
		),
		#find all recipies for each nationality
		ranked_recipies as (
			select
				recipies.name "recipe",
				recipies.nationality "nationality",
				row_number() over (partition by recipies.nationality order by rand()) as roo
			from
				recipies join random_nationalities rnat on rnat.nationality=recipies.nationality
		),
		#randomly choose one recipe for each nationality
		selected_recipies as (
			select rr.recipe, rr.nationality
			from ranked_recipies rr
			where roo=1
		)
		#insert into ep_data (ep_id,cook_id,recipe_name)
		#create temporary table temp as
		select i,sc.cook_id, sr.recipe
		from selected_cooks sc join selected_recipies sr
		on sc.nationality = sr.nationality;
        
        set i=i+1;
	end while;
end //
DELMITER ;

DELIMITER ;
#drop procedure episodes_random_fill;
call episodes_random_fill();
#truncate table ep_data;
select * from ep_data;

#CHOOSE JUJDES AND RATING FOR EACH COOK AND EACH EPISODE

#fill the rating table
insert into rating
#find which cooks can take the role of judge at each episode
with possible_judges as(
select ed.ep_id "ep_id", cook.id "judge", count(*), ROW_NUMBER() OVER (PARTITION BY ed.ep_id ORDER BY RAND()) AS ro from
ep_data ed join cook
on ed.cook_id<>cook.id
group by ep_id,cook.id
having count(*)=10),
#select randomly 3 judges (from the 90 possible) for each episode
ep_judges as(
select pj.ep_id, pj.judge from possible_judges pj where pj.ro=1 or pj.ro=2 or pj.ro=3)
#insert data into rating table
select ed.ep_id, ed.cook_id, ej.judge, floor(1+5*rand()) "rate" from ep_judges ej join ep_data ed on ej.ep_id=ed.ep_id
;

#select * from rating;
#truncate table rating;
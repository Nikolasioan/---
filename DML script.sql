#drop database project;
use project;
#show tables;

#use the following commands to help you check if you can load data from files
#SHOW VARIABLES LIKE "secure_file_priv";
#SHOW VARIABLES LIKE 'local_infile';

#CATEGORIES
load data local infile 'C:/MARIOS/data/categories.csv'
into table categories
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#for checking purposes
#select * from categories;
#truncate table categories;

#COOKS
load data local infile 'C:/MARIOS/data/cooks.csv'
into table cook
fields terminated by ','
lines terminated by '\r\n'
ignore 0 rows;

#for checking purposes
#truncate table cook;
#select * from cook;

#NATIONALITY
load data local infile 'C:/MARIOS/data/nationality.csv'
into table nationality
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
#select * from nationality;
#truncate table nationality;

#COOK_SPECIALTY
load data local infile 'C:/MARIOS/data/cook_specialty.csv'
into table cook_specialty
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
#select * from cook_specialty order by cook_id;
#truncate table cook_specialty;
#show warnings;

/*
create temporary table temp_cook_specialty(
cook_id int not null,
cuisine_nationality varchar(40) not null,
primary key (cook_id, cuisine_nationality)
);
select * from temp_cook_specialty;
truncate table temp_cook_specialty;

load data local infile 'C:/MARIOS/data/cook_specialty.csv'
into table temp_cook_specialty
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

select temp.*
from temp_cook_specialty temp left join cook_specialty original
on temp.cook_id=original.cook_id and temp.cuisine_nationality=original.cuisine_nationality
where original.cook_id is null;
*/

#INGREDIENTS

load data local infile 'C:/MARIOS/data/ingredients.csv'
into table ingredients
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#select * from ingredients where category="Fish & Their Products";
#truncate table ingredients;
#show warnings;

#LABELS
load data local infile 'C:/MARIOS/data/labels.csv'
into table labels
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
#select * from labels;

#RECIPIES
#desc recipies;

load data local infile 'C:/MARIOS/data/recipes.csv'
into table recipies
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
#select * from recipies;
select  distinct base_ingredient from recipies;
show warnings;
#truncate table recipies;

#TOOLS
load data local infile 'C:/MARIOS/data/toolssheet.csv'
into table tools
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#select * from tools;
#truncate table tools;

#TIPS
load data local infile 'C:/MARIOS/data/tips.csv'
into table tips
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#select * from tips;
#truncate table tips;


#THEMES
load data local infile 'C:/MARIOS/data/themes.csv'
into table themes
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#select * from themes;
#truncate table themes;

#STEPS
load data local infile 'C:/MARIOS/data/steps.csv'
into table steps
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#check
#select * from steps;
#truncate table steps;

#STEPS
load data local infile 'C:/MARIOS/data/meal_type.csv'
into table meal_type
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#select * from meal_type;

/*
#RECIPE_MEAL_TYPE
load data local infile 'C:/MARIOS/data/recipe_meal_type.csv'
into table recipies_meal_type
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

show warnings;*/
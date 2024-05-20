#drop database project;
use project;
show tables;

#use the following commands to help you check if you can load data from files
#SHOW VARIABLES LIKE "secure_file_priv";
#SHOW VARIABLES LIKE 'local_infile';

#CATEGORIES
load data local infile 'C:/MARIOS/DB csv files/categories.csv'
into table categories
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#for checking purposes
select * from categories;
#truncate table categories;

#COOKS
load data local infile 'C:/MARIOS/DB csv files/cooks.csv'
into table cook
fields terminated by ','
lines terminated by '\n'
ignore 0 rows;

#for checking purposes
#truncate table cook;
select * from cook;

#NATIONALITY
load data local infile 'C:/MARIOS/DB csv files/nationality.csv'
into table nationality
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
#select * from nationality;
#truncate table nationality;

#COOK_SPECIALTY
load data local infile 'C:/MARIOS/DB csv files/cook_specialty.csv'
into table cook_specialty
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
select * from cook_specialty;
#truncate table cook_specialty;

#INGREDIENTS
desc ingredients;

load data local infile 'C:/MARIOS/DB csv files/ingredients_datasheets.csv'
into table ingredients
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

select * from ingredients;
truncate table ingredients;
#show warnings;

#LABELS
load data local infile 'C:/MARIOS/DB csv files/labels.csv'
into table labels
fields terminated by ','
#enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
select * from labels;

#RECIPIES
#desc recipies;

load data local infile 'C:/MARIOS/DB csv files/recipessheet.csv'
into table recipies
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 0 rows;

#check
select * from recipies;
#truncate table recipies;

#TOOLS
load data local infile 'C:/MARIOS/DB csv files/toolssheet.csv'
into table tools
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

select * from tools;
#truncate table tools;

#TIPS
load data local infile 'C:/MARIOS/DB csv files/tips.csv'
into table tips
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

select * from tips;
#truncate table tips;


#THEMES
load data local infile 'C:/MARIOS/DB csv files/themes.csv'
into table themes
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

select * from themes;
#truncate table themes;

#STEPS
load data local infile 'C:/MARIOS/DB csv files/dirtysteps.csv'
into table steps
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 0 rows;

#check
select * from steps;
#truncate table steps;



create database project;
show databases;
use project;
show tables;

create table recipies(
name varchar(50) not null,
type enum('cookery','pastry') not null,
difficulty int not null check (difficulty between 1 and 5),
description varchar(100) not null,
meal_type enum ('breakfast','brunch','meal','snack','dinner') not null,
portions int not null,
primary key(name)
);

desc recipies;

create table nationality(
name varchar(40) not null,
primary key(name)
);

desc nationality;

create table labels(
id int auto_increment,
name varchar(100) not null,
primary key (id)
);

create table tips(
id int auto_increment primary key,
name varchar(100) not null
);

create table tools(
name varchar(50) not null primary key,
use_instructions varchar(150) not null
);

create table themes(
name varchar(50) not null primary key,
description varchar(100) not null
);

create table cook(
id int not null primary key,
name varchar(50) not null,
surname varchar(50) not null,
tel_number varchar(15),
date_of_birth date not null,
level enum('Cook C','Cook B','Cook A','Chef Assistant','Chef')
);

show databases;
use project;
show tables;
desc recipies;
alter table recipies modify portions int not null check (portions > 0);
desc recipies;

create table steps(
id int auto_increment primary key,
description varchar(150) not null,
time_in_minutes int not null check (time_in_minutes >= 0),
prep_or_cook enum('prep','cook') not null
);

create table ingredients(
name varchar(50) not null primary key,
protein_per_100g int not null check (protein_per_100g between 0 and 100),
carbs_per_100g int not null check (carbs_per_100g between 0 and 100),
fats_per_100g int not null check (fats_per_100g between 0 and 100),
calories int not null
);

create table food_category(
name varchar(50) not null primary key,
description varchar(200) not null
);

create table recipe_nationality(
rname varchar(50) not null primary key,
nname varchar(40) not null,
foreign key (rname) references recipies(name),
foreign key (nname) references nationality(name)
);

desc recipe_nationality;

create table recipe_label(
rname varchar(50) not null,
label_id int not null,
primary key (rname,label_id),
foreign key (rname) references recipies(name),
foreign key (label_id) references labels(id)
);

create table recipe_tip(
rname varchar(50) not null,
tip_id int not null,
primary key (rname,tip_id),
foreign key (rname) references recipies(name),
foreign key (tip_id) references tips(id)
);

create table recipe_tool(
rname varchar(50) not null,
tname varchar(50) not null,
primary key (rname,tname),
foreign key (rname) references recipies(name),
foreign key (tname) references tools(name)
);

create table recipe_step(
rname varchar(50) not null,
step_id int not null,
primary key (rname,step_id),
foreign key (rname) references recipies(name),
foreign key (step_id) references steps(id)
);

create table recipe_ingredient(
rname varchar(50) not null,
iname varchar(50) not null,
quantity varchar(50),
quantity_in_grams int check (quantity_in_grams > 0),
primary key (rname,iname),
foreign key (rname) references recipies(name),
foreign key (iname) references ingredients(name)
);

create table recipe_base_ingredient(
rname varchar(50) not null primary key,
iname varchar(50) not null,
foreign key (rname) references recipies(name),
foreign key (iname) references ingredients(name)
);

create table ingredient_category(
iname varchar(50) not null primary key,
category varchar(50) not null,
foreign key (iname) references ingredients(name),
foreign key (category) references food_category(name)
);

create table cook_specialty(
cook_id int not null,
cuisine_nationality varchar(40) not null,
primary key (cook_id, cuisine_nationality),
foreign key (cook_id) references cook(id),
foreign key (cuisine_nationality) references nationality(name)
);

create table recipe_theme(
rname varchar(50) not null,
tname varchar(50) not null,
primary key (rname,tname),
foreign key (rname) references recipies(name),
foreign key (tname) references themes(name)
);

alter table recipies
add column base_ingredient varchar(50) not null;
alter table recipies
add column nationality varchar(40) not null;
alter table recipies
add constraint foreign key (base_ingredient) references ingredients(name);
alter table recipies
add constraint foreign key (nationality) references nationality(name);

drop table recipe_nationality;
drop table recipe_base_ingredient;

desc ingredients;
alter table ingredients
add column category varchar(50) not null;
alter table ingredients
add constraint foreign key (category) references food_category(name);
desc ingredient_category;
drop table ingredient_category;
rename table food_category to categories;

use project;
show tables;

alter table recipies
add constraint fk_recipies_nationality foreign key (nationality) references nationality(name)
on delete restrict on update cascade;

alter table recipies
add constraint fk_recipies_ingredients foreign key (base_ingredient) references ingredients(name)
on delete restrict on update cascade;

show create table recipies;
alter table recipies drop constraint recipies_ibfk_1;
alter table recipies drop constraint recipies_ibfk_2;

show create table ingredients;
alter table ingredients
add constraint fk_ingredients_categories foreign key (category) references categories(name) 
on delete restrict on update cascade;
alter table ingredients drop constraint ingredients_ibfk_1;

show create table recipe_tool;
alter table recipe_tool
add constraint fk_recipe_tool_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_tool drop constraint recipe_tool_ibfk_1;
alter table recipe_tool
add constraint fk_recipe_tool_tools foreign key (tname) references tools(name)
on delete restrict on update cascade;
alter table recipe_tool drop constraint recipe_tool_ibfk_2;

show create table recipe_theme;
alter table recipe_theme
add constraint fk_recipe_theme_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_theme
add constraint fk_recipe_theme_themes foreign key(tname) references themes(name)
on delete restrict on update cascade;
alter table recipe_theme drop constraint recipe_theme_ibfk_1;
alter table recipe_theme drop constraint recipe_theme_ibfk_2;

show create table recipe_step;
alter table recipe_step
add constraint fk_recipe_step_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_step drop constraint recipe_step_ibfk_1;
alter table recipe_step
add constraint fk_recipe_step_steps foreign key(step_id) references steps(id)
on delete restrict on update cascade;
alter table recipe_step drop constraint recipe_step_ibfk_2;

show create table recipe_tip;
alter table recipe_tip 
add constraint fk_recipe_tip_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_tip drop constraint recipe_tip_ibfk_1;
alter table recipe_tip 
add constraint fk_recipe_tip_tips foreign key (tip_id) references tips(id)
on delete restrict on update cascade;
alter table recipe_tip drop constraint recipe_tip_ibfk_2;

show create table recipe_ingredient;
alter table recipe_ingredient
add constraint fk_recipe_ingredient_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_ingredient drop constraint recipe_ingredient_ibfk_1;
alter table recipe_ingredient
add constraint fk_recipe_ingredient_ingredients foreign key(iname) references ingredients(name)
on delete restrict on update cascade;
alter table recipe_ingredient drop constraint recipe_ingredient_ibfk_2;
alter table recipe_ingredient add constraint chk_pos_quantity check (quantity_in_grams>0);
alter table recipe_ingredient drop constraint recipe_ingredient_chk_1;

show create table cook_specialty;
alter table cook_specialty
add constraint fk_cook_specialty_cook foreign key (cook_id) references cook(id)
on delete restrict on update cascade;
alter table cook_specialty drop constraint cook_specialty_ibfk_1;
alter table cook_specialty
add constraint fk_cook_specialty_nationality foreign key (cuisine_nationality) references nationality(name)
on delete restrict on update cascade;
alter table cook_specialty drop constraint cook_specialty_ibfk_2;

show create table recipe_label;
alter table recipe_label
add constraint fk_recipe_label_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_label drop constraint recipe_label_ibfk_1;
alter table recipe_label
add constraint fk_recipe_label_labels foreign key (label_id) references labels(id)
on delete restrict on update cascade;
alter table recipe_label drop constraint recipe_label_ibfk_2;

show create table cook;
show create table nationality;
show create table cook_specialty;
#insert into nationality values ("Greek");
#select * from nationality;
#select * from cook;
#insert into cook_specialty values(1,"Greek");
#select * from cook_specialty;
#select * from recipies;
#truncate table cook_specialty;
#truncate table nationality;
#truncate table cook;
#delete from cook where id<100;
#select * from cook order by rand() limit 10;

create table ep_data(
ep_id int unsigned not null,
cook_id int not null,
recipe_name varchar(40) not null,
primary key(ep_id,cook_id));

create table rating(
ep_id int unsigned not null,
cook_id int not null,
judge_id int not null,
rate int not null,
check(rate between 1 and 5),
primary key(ep_id,cook_id,judge_id));

create table episode(
ep_id int unsigned auto_increment,
season int not null,
check(season > 0),
primary key(ep_id));

alter table ep_data
modify column recipe_name varchar(50) not null;

alter table episode
modify column ep_id int unsigned not null auto_increment;

alter table ep_data 
add constraint fk1_ep_data_episode foreign key(ep_id) references episode(ep_id) on delete restrict on update cascade,
add constraint fk1_ep_data_cook foreign key(cook_id) references cook(id) on delete restrict on update cascade,
add constraint fk1_ep_data_recipies foreign key(recipe_name) references recipies(name) on delete restrict on update cascade;

alter table rating
add constraint fk1_rating_episode foreign key(ep_id) references episode(ep_id) on delete restrict on update cascade,
add constraint fk1_rating_cook foreign key(cook_id) references cook(id) on delete restrict on update cascade,
add constraint fk2_rating_cook foreign key(judge_id) references cook(id) on delete restrict on update cascade;

ALTER TABLE cook
ADD COLUMN years_of_working_experience int check(years_of_working_experience>=0);

alter table recipies
drop column meal_type;

create table meal_type(
name enum ('breakfast','brunch','meal','snack','dinner') not null,
primary key(name));

create table recipies_meal_type(
rname varchar(50) not null,
mtname enum ('breakfast','brunch','meal','snack','dinner') not null,
primary key(rname,mtname),
constraint fk1_recipies_meal_type_recipies foreign key(rname) references recipies(name),
constraint fk1_recipies_meal_type_meal_type foreign key(mtname) references meal_type(name));

show create table ingredients;

alter table recipe_step
add column step_number int check(step_number > 0);

show create table recipe_step;

alter table recipe_step
drop constraint fk_recipe_step_recipies,
drop constraint fk_recipe_step_steps;

ALTER TABLE recipe_step
DROP PRIMARY KEY,
add primary key(step_number,rname,step_id);

alter table recipe_step
add constraint fk_recipe_step_recipies foreign key(rname) references recipies(name),
add constraint fk_recipe_step_steps foreign key(step_id) references steps(id);

show create table recipe_step;

show create table cook;

ALTER TABLE cook
modify COLUMN years_of_working_experience int not null check(years_of_working_experience>=0);

show create table cook;

create table cook_recipies(
cook_id int not null,
rname varchar(50) not null,
primary key(cook_id,rname),
constraint fk1_cook_recipies_recipies foreign key(rname) references recipies(name) on delete restrict on update cascade,
constraint fk1_cook_recipies_cook foreign key(cook_id) references cook(id) on delete restrict on update cascade);

alter table recipe_step
drop constraint fk_recipe_step_recipies,
drop constraint fk_recipe_step_steps;

ALTER TABLE recipe_step
DROP PRIMARY KEY,
add primary key(step_number,rname,step_id);

alter table recipe_step
add constraint fk_recipe_step_recipies foreign key(rname) references recipies(name) on delete restrict on update cascade,
add constraint fk_recipe_step_steps foreign key(step_id) references steps(id) on delete restrict on update cascade;

drop table recipies_meal_type;

create table recipies_meal_type(
rname varchar(50) not null,
mtname enum ('breakfast','brunch','meal','snack','dinner') not null,
primary key(rname,mtname),
constraint fk1_recipies_meal_type_recipies foreign key(rname) references recipies(name) on delete restrict on update cascade,
constraint fk1_recipies_meal_type_meal_type foreign key(mtname) references meal_type(name) on delete restrict on update cascade);

alter table ingredients
add column typification varchar(50);

alter table recipe_step
add constraint fk1_recipe_step_recipies foreign key(rname) references recipies(name),
add constraint fk1_recipe_step_steps foreign key(step_id) references steps(id);

show create table ep_data;
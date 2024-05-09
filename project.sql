use project;
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

show create table ep_data;

alter table recipe_step
add constraint fk1_recipe_step_recipies foreign key(rname) references recipies(name),
add constraint fk1_recipe_step_steps foreign key(step_id) references steps(id);

alter table ep_data
add constraint fk1_ep_data_episode foreign key(ep_id) references episode(ep_id),
add constraint fk1_ep_data_cook foreign key(cook_id) references cook(id);
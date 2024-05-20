create database project;
use project;

create table recipies(
name varchar(50) not null,
type enum('cookery','pastry') not null,
difficulty int not null check (difficulty between 1 and 5),
description varchar(200) not null,
portions int not null check (portions > 0),
base_ingredient varchar(50) not null,
nationality varchar(40) not null,
primary key(name)
);

create table meal_type(
name enum ('breakfast','brunch','meal','snack','dinner') not null,
primary key(name));

create table nationality(
name varchar(40) not null,
primary key(name)
);

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
description varchar(200) not null
);

create table cook(
id int not null primary key,
name varchar(50) not null,
surname varchar(50) not null,
tel_number varchar(15),
date_of_birth date not null,
level enum('Cook C','Cook B','Cook A','Chef Assistant','Chef'),
years_of_working_experience int check(years_of_working_experience>=0),
age int
);

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
calories int not null check (calories>=0),
category varchar(50) not null,
typification varchar(50)
);

create table categories(
name varchar(50) not null primary key,
description varchar(200) not null
);

create table recipe_label(
rname varchar(50) not null,
label_id int not null,
primary key (rname,label_id)
);

create table recipe_tip(
rname varchar(50) not null,
tip_id int not null,
primary key (rname,tip_id)
);

create table recipe_tool(
rname varchar(50) not null,
tname varchar(50) not null,
primary key (rname,tname)
);

create table recipe_step(
rname varchar(50) not null,
step_id int not null,
step_number int check(step_number > 0),
primary key (rname,step_number,step_id)
);

create table recipe_ingredient(
rname varchar(50) not null,
iname varchar(50) not null,
quantity varchar(50),
quantity_in_grams int check (quantity_in_grams > 0),
primary key (rname,iname)
);

create table cook_specialty(
cook_id int not null,
cuisine_nationality varchar(40) not null,
primary key (cook_id, cuisine_nationality)
);

create table recipe_theme(
rname varchar(50) not null,
tname varchar(50) not null,
primary key (rname,tname)
);

create table recipies_meal_type(
rname varchar(50) not null,
mtname enum ('breakfast','brunch','meal','snack','dinner') not null,
primary key(rname,mtname)
);

create table cook_recipies(
cook_id int not null,
rname varchar(50) not null,
primary key(cook_id,rname)
);

#FOREIGN KEYS

alter table cook
add constraint yowe_constraint check(age-years_of_working_experience>0);

alter table recipies
add constraint fk_recipies_nationality foreign key (nationality) references nationality(name)
on delete restrict on update cascade;

alter table recipies
add constraint fk_recipies_ingredients foreign key (base_ingredient) references ingredients(name)
on delete restrict on update cascade;

alter table ingredients
add constraint fk_ingredients_categories foreign key (category) references categories(name) 
on delete restrict on update cascade;

alter table recipe_tool
add constraint fk_recipe_tool_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_tool
add constraint fk_recipe_tool_tools foreign key (tname) references tools(name)
on delete restrict on update cascade;

alter table recipe_theme
add constraint fk_recipe_theme_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_theme
add constraint fk_recipe_theme_themes foreign key(tname) references themes(name)
on delete restrict on update cascade;

alter table recipe_step
add constraint fk_recipe_step_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_step
add constraint fk_recipe_step_steps foreign key(step_id) references steps(id)
on delete restrict on update cascade;

alter table recipe_tip 
add constraint fk_recipe_tip_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_tip 
add constraint fk_recipe_tip_tips foreign key (tip_id) references tips(id)
on delete restrict on update cascade;

alter table recipe_ingredient
add constraint fk_recipe_ingredient_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_ingredient
add constraint fk_recipe_ingredient_ingredients foreign key(iname) references ingredients(name)
on delete restrict on update cascade;
alter table recipe_ingredient add constraint chk_pos_quantity check (quantity_in_grams>0);

alter table cook_specialty
add constraint fk_cook_specialty_cook foreign key (cook_id) references cook(id)
on delete restrict on update cascade;
alter table cook_specialty
add constraint fk_cook_specialty_nationality foreign key (cuisine_nationality) references nationality(name)
on delete restrict on update cascade;

alter table recipe_label
add constraint fk_recipe_label_recipies foreign key (rname) references recipies(name)
on delete restrict on update cascade;
alter table recipe_label
add constraint fk_recipe_label_labels foreign key (label_id) references labels(id)
on delete restrict on update cascade;

alter table recipies_meal_type
add constraint fk1_recipies_meal_type_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table recipies_meal_type
add constraint fk1_recipies_meal_type_meal_type foreign key(mtname) references meal_type(name)
on delete restrict on update cascade;

alter table cook_recipies
add constraint fk1_cook_recipies_recipies foreign key(rname) references recipies(name)
on delete restrict on update cascade;
alter table cook_recipies
add constraint fk1_cook_recipies_cook foreign key(cook_id) references cook(id)
on delete restrict on update cascade;

#select * from cook order by rand() limit 10;

#TABLES FOR EPISODES

create table ep_data(
ep_id int unsigned not null,
cook_id int not null,
recipe_name varchar(50) not null,
primary key(ep_id,cook_id));

create table rating(
ep_id int unsigned not null,
cook_id int not null,
judge_id int not null,
rate int not null,
check(rate between 1 and 5),
primary key(ep_id,cook_id,judge_id));

create table episode(
ep_id int unsigned not null auto_increment,
season int not null,
check(season > 0),
primary key(ep_id));

#FOREIGN KEYS FOR THE NEW TABLES 

alter table ep_data 
add constraint fk1_ep_data_episode foreign key(ep_id) references episode(ep_id) on delete restrict on update cascade,
add constraint fk1_ep_data_cook foreign key(cook_id) references cook(id) on delete restrict on update cascade,
add constraint fk1_ep_data_recipies foreign key(recipe_name) references recipies(name) on delete restrict on update cascade;

alter table rating
add constraint fk1_rating_episode foreign key(ep_id) references episode(ep_id) on delete restrict on update cascade,
add constraint fk1_rating_cook foreign key(cook_id) references cook(id) on delete restrict on update cascade,
add constraint fk2_rating_cook foreign key(judge_id) references cook(id) on delete restrict on update cascade;

#TRIGGERS

DELIMITER //
create trigger cook_id_notequal_judge_id
before insert on rating
for each row
begin
    if new.cook_id = new.judge_id then
        SIGNAL sqlstate "45000" set message_text = 'Cook ID cannot be equal to Judge ID.';
    end if;
end;
//
DELIMITER ;

DELIMITER //
create trigger cook_id_notequal_judge_id_update
before update on rating
for each row
begin
    if new.cook_id = new.judge_id then
        SIGNAL sqlstate "45000" set message_text = 'Cook ID cannot be equal to Judge ID.';
    end if;
end;
//
DELIMITER ;

DELIMITER //
create trigger three_tips_max_per_recipe
before insert on recipe_tip
for each row
begin
	declare tip_count int;
    select count(*) into tip_count
    from recipe_tip where rname=new.rname;
    if tip_count>=3 then
        SIGNAL sqlstate "45000" set message_text = 'Each recipe can have maximum 3 tips.';
    end if;
end;
//
DELIMITER ;

DELIMITER //
create trigger three_tips_max_per_recipe_update
before update on recipe_tip
for each row
begin
	declare tip_count int;
    select count(*) into tip_count
    from recipe_tip where rname=new.rname;
    if tip_count>=3 then
        SIGNAL sqlstate "45000" set message_text = 'Each recipe can have maximum 3 tips.';
    end if;
end;
//
DELIMITER ;
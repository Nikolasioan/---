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
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
name enum ('breakfast','brunch','lunch','snack','dinner') not null,
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
use_instructions varchar(300) not null
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
description varchar(250) not null,
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
mtname enum ('breakfast','brunch','lunch','snack','dinner') not null,
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

alter table recipies
add column preparation_time_in_min int,
add column cooking_time_in_min int;

#new lines

#show create table recipe_ingredient;
alter table recipe_ingredient
modify column quantity_in_grams int;

alter table recipies
add column protein_per_portion float,
add column carbs_per_portion float,
add column fats_per_portion float,
add column calories_per_portion float;


DELIMITER //
CREATE TRIGGER cook_age
BEFORE INSERT ON cook
FOR EACH ROW
BEGIN
    DECLARE cage INT;
    DECLARE cookd INT;
    DECLARE cookm INT;
    DECLARE cooky INT;
    DECLARE cd INT;
    DECLARE cm INT;
    DECLARE cy INT;

    -- Extract date components of the cook's birth date
    SET cookd = DAY(NEW.date_of_birth);
    SET cookm = MONTH(NEW.date_of_birth);
    SET cooky = YEAR(NEW.date_of_birth);

    -- Extract date components of the current date
    SET cd = DAY(CURDATE());
    SET cm = MONTH(CURDATE());
    SET cy = YEAR(CURDATE());

    -- Calculate the age
    IF (cm > cookm) OR (cm = cookm AND cd > cookd) THEN
        SET cage = cy - cooky;
    ELSE
        SET cage = cy - cooky - 1;
    END IF;

    -- Set the age directly in the NEW record
    SET NEW.age = cage;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER cook_age_update
BEFORE UPDATE ON cook
FOR EACH ROW
BEGIN
    DECLARE cage INT;
    DECLARE cookd INT;
    DECLARE cookm INT;
    DECLARE cooky INT;
    DECLARE cd INT;
    DECLARE cm INT;
    DECLARE cy INT;

    -- Extract date components of the cook's birth date
    SET cookd = DAY(NEW.date_of_birth);
    SET cookm = MONTH(NEW.date_of_birth);
    SET cooky = YEAR(NEW.date_of_birth);

    -- Extract date components of the current date
    SET cd = DAY(CURDATE());
    SET cm = MONTH(CURDATE());
    SET cy = YEAR(CURDATE());

    -- Calculate the age
    IF (cm > cookm) OR (cm = cookm AND cd > cookd) THEN
        SET cage = cy - cooky;
    ELSE
        SET cage = cy - cooky - 1;
    END IF;

    -- Set the age directly in the NEW record
    SET NEW.age = cage;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_recipies(
    IN recipe_name VARCHAR(255),
    IN total_calories FLOAT
)
BEGIN
    update recipies set calories=total_calories/portions where name=recipe_name;
END;
//
DELIMITER ;

DELIMITER //
create trigger calories_calculation_update
after update on recipe_ingredient
for each row
begin
declare rcalories float;
    select sum into rcalories from(
    select c.rname,sum(c.calories) as sum from (select a.rname,b.calories
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name) as c order by c.rname) as d where rname=new.rname;
   
    call update_recipies(new.rname,rcalories);
end;
//
DELIMITER ;

DELIMITER //
create trigger calories_calculation
after insert on recipe_ingredient
for each row
begin
declare rcalories float;
    select sum into rcalories from(
    select c.rname,sum(c.calories) as sum from (select a.rname,b.calories
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name) as c order by c.rname) as d where rname=new.rname;
   
    call update_recipies(new.rname,rcalories);
end;
//
DELIMITER ;

DELIMITER //
create trigger protein_calculation
before insert on recipies
for each row
begin
	declare protein float;
    select sum((a.quantity_in_grams/100)*b.protein_per_100g) into protein
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.protein_per_portion = protein/new.portions;
end;
//
DELIMITER ;

DELIMITER //
create trigger protein_calculation_update
before update on recipies
for each row
begin
	declare protein float;
    select sum((a.quantity_in_grams/100)*b.protein_per_100g) into protein
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.protein_per_portion = protein/new.portions;
end;
//
DELIMITER ;

DELIMITER //
create trigger carbs_calculation
before insert on recipies
for each row
begin
	declare carbs float;
    select sum((a.quantity_in_grams/100)*b.carbs_per_100g) into carbs
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.carbs_per_portion = carbs/new.portions;
end;
//
DELIMITER ;

DELIMITER //
create trigger carbs_calculation_update
before update on recipies
for each row
begin
	declare carbs float;
    select sum((a.quantity_in_grams/100)*b.carbs_per_100g) into carbs
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.carbs_per_portion = carbs/new.portions;
end;
//
DELIMITER ;

DELIMITER //
create trigger fats_calculation
before insert on recipies
for each row
begin
	declare fats float;
    select sum((a.quantity_in_grams/100)*b.fats_per_100g) into fats
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.fats_per_portion = fats/new.portions;
end;
//
DELIMITER ;

DELIMITER //
create trigger fats_calculation_update
before update on recipies
for each row
begin
	declare fats float;
    select sum((a.quantity_in_grams/100)*b.fats_per_100g) into fats
    from recipe_ingredient as a inner join ingredients as b on a.iname=b.name where a.rname=new.name;
    set new.fats_per_portion = fats/new.portions;
end;
//
DELIMITER ;

#SELECT user, host FROM mysql.user WHERE user = 'Admin';
#create user 'Admin'@'%' identified by 'Admin1234';
#grant insert,update on project.* to 'Admin'@'%';
#grant select, lock tables, reload on *.* to 'Admin'@'%';

CREATE USER 'cook_1'@'%' IDENTIFIED BY 'pass1';
CREATE USER 'cook_2'@'%' IDENTIFIED BY 'word2';
CREATE USER 'cook_3'@'%' IDENTIFIED BY 'key3';
CREATE USER 'cook_4'@'%' IDENTIFIED BY 'code4';
CREATE USER 'cook_5'@'%' IDENTIFIED BY 'lock5';
CREATE USER 'cook_6'@'%' IDENTIFIED BY 'data6';
CREATE USER 'cook_7'@'%' IDENTIFIED BY 'test7';
CREATE USER 'cook_8'@'%' IDENTIFIED BY 'user8';
CREATE USER 'cook_9'@'%' IDENTIFIED BY 'file9';
CREATE USER 'cook_10'@'%' IDENTIFIED BY 'line10';
CREATE USER 'cook_11'@'%' IDENTIFIED BY 'work11';
CREATE USER 'cook_12'@'%' IDENTIFIED BY 'note12';
CREATE USER 'cook_13'@'%' IDENTIFIED BY 'base13';
CREATE USER 'cook_14'@'%' IDENTIFIED BY 'view14';
CREATE USER 'cook_15'@'%' IDENTIFIED BY 'save15';
CREATE USER 'cook_16'@'%' IDENTIFIED BY 'info16';
CREATE USER 'cook_17'@'%' IDENTIFIED BY 'edit17';
CREATE USER 'cook_18'@'%' IDENTIFIED BY 'task18';
CREATE USER 'cook_19'@'%' IDENTIFIED BY 'post19';
CREATE USER 'cook_20'@'%' IDENTIFIED BY 'form20';
CREATE USER 'cook_21'@'%' IDENTIFIED BY 'plan21';
CREATE USER 'cook_22'@'%' IDENTIFIED BY 'rule22';
CREATE USER 'cook_23'@'%' IDENTIFIED BY 'time23';
CREATE USER 'cook_24'@'%' IDENTIFIED BY 'text24';
CREATE USER 'cook_25'@'%' IDENTIFIED BY 'port25';
CREATE USER 'cook_26'@'%' IDENTIFIED BY 'data26';
CREATE USER 'cook_27'@'%' IDENTIFIED BY 'test27';
CREATE USER 'cook_28'@'%' IDENTIFIED BY 'user28';
CREATE USER 'cook_29'@'%' IDENTIFIED BY 'file29';
CREATE USER 'cook_30'@'%' IDENTIFIED BY 'work30';
CREATE USER 'cook_31'@'%' IDENTIFIED BY 'line31';
CREATE USER 'cook_32'@'%' IDENTIFIED BY 'note32';
CREATE USER 'cook_33'@'%' IDENTIFIED BY 'base33';
CREATE USER 'cook_34'@'%' IDENTIFIED BY 'view34';
CREATE USER 'cook_35'@'%' IDENTIFIED BY 'save35';
CREATE USER 'cook_36'@'%' IDENTIFIED BY 'info36';
CREATE USER 'cook_37'@'%' IDENTIFIED BY 'edit37';
CREATE USER 'cook_38'@'%' IDENTIFIED BY 'task38';
CREATE USER 'cook_39'@'%' IDENTIFIED BY 'post39';
CREATE USER 'cook_40'@'%' IDENTIFIED BY 'form40';
CREATE USER 'cook_41'@'%' IDENTIFIED BY 'plan41';
CREATE USER 'cook_42'@'%' IDENTIFIED BY 'rule42';
CREATE USER 'cook_43'@'%' IDENTIFIED BY 'time43';
CREATE USER 'cook_44'@'%' IDENTIFIED BY 'text44';
CREATE USER 'cook_45'@'%' IDENTIFIED BY 'port45';
CREATE USER 'cook_46'@'%' IDENTIFIED BY 'data46';
CREATE USER 'cook_47'@'%' IDENTIFIED BY 'test47';
CREATE USER 'cook_48'@'%' IDENTIFIED BY 'user48';
CREATE USER 'cook_49'@'%' IDENTIFIED BY 'file49';
CREATE USER 'cook_50'@'%' IDENTIFIED BY 'work50';
CREATE USER 'cook_51'@'%' IDENTIFIED BY 'line51';
CREATE USER 'cook_52'@'%' IDENTIFIED BY 'note52';
CREATE USER 'cook_53'@'%' IDENTIFIED BY 'base53';
CREATE USER 'cook_54'@'%' IDENTIFIED BY 'view54';
CREATE USER 'cook_55'@'%' IDENTIFIED BY 'save55';
CREATE USER 'cook_56'@'%' IDENTIFIED BY 'info56';
CREATE USER 'cook_57'@'%' IDENTIFIED BY 'edit57';
CREATE USER 'cook_58'@'%' IDENTIFIED BY 'task58';
CREATE USER 'cook_59'@'%' IDENTIFIED BY 'post59';
CREATE USER 'cook_60'@'%' IDENTIFIED BY 'form60';
CREATE USER 'cook_61'@'%' IDENTIFIED BY 'plan61';
CREATE USER 'cook_62'@'%' IDENTIFIED BY 'rule62';
CREATE USER 'cook_63'@'%' IDENTIFIED BY 'time63';
CREATE USER 'cook_64'@'%' IDENTIFIED BY 'text64';
CREATE USER 'cook_65'@'%' IDENTIFIED BY 'port65';
CREATE USER 'cook_66'@'%' IDENTIFIED BY 'data66';
CREATE USER 'cook_67'@'%' IDENTIFIED BY 'test67';
CREATE USER 'cook_68'@'%' IDENTIFIED BY 'user68';
CREATE USER 'cook_69'@'%' IDENTIFIED BY 'file69';
CREATE USER 'cook_70'@'%' IDENTIFIED BY 'work70';
CREATE USER 'cook_71'@'%' IDENTIFIED BY 'note71';
CREATE USER 'cook_72'@'%' IDENTIFIED BY 'base72';
CREATE USER 'cook_73'@'%' IDENTIFIED BY 'view73';
CREATE USER 'cook_74'@'%' IDENTIFIED BY 'save74';
CREATE USER 'cook_75'@'%' IDENTIFIED BY 'info75';
CREATE USER 'cook_76'@'%' IDENTIFIED BY 'edit76';
CREATE USER 'cook_77'@'%' IDENTIFIED BY 'task77';
CREATE USER 'cook_78'@'%' IDENTIFIED BY 'post78';
CREATE USER 'cook_79'@'%' IDENTIFIED BY 'form79';
CREATE USER 'cook_80'@'%' IDENTIFIED BY 'plan80';
CREATE USER 'cook_81'@'%' IDENTIFIED BY 'rule81';
CREATE USER 'cook_82'@'%' IDENTIFIED BY 'time82';
CREATE USER 'cook_83'@'%' IDENTIFIED BY 'text83';
CREATE USER 'cook_84'@'%' IDENTIFIED BY 'port84';
CREATE USER 'cook_85'@'%' IDENTIFIED BY 'data85';
CREATE USER 'cook_86'@'%' IDENTIFIED BY 'test86';
CREATE USER 'cook_87'@'%' IDENTIFIED BY 'user87';
CREATE USER 'cook_88'@'%' IDENTIFIED BY 'file88';
CREATE USER 'cook_89'@'%' IDENTIFIED BY 'work89';
CREATE USER 'cook_90'@'%' IDENTIFIED BY 'line90';
CREATE USER 'cook_91'@'%' IDENTIFIED BY 'note91';
CREATE USER 'cook_92'@'%' IDENTIFIED BY 'base92';
CREATE USER 'cook_93'@'%' IDENTIFIED BY 'view93';
CREATE USER 'cook_94'@'%' IDENTIFIED BY 'save94';
CREATE USER 'cook_95'@'%' IDENTIFIED BY 'info95';
CREATE USER 'cook_96'@'%' IDENTIFIED BY 'edit96';
CREATE USER 'cook_97'@'%' IDENTIFIED BY 'task97';
CREATE USER 'cook_98'@'%' IDENTIFIED BY 'post98';
CREATE USER 'cook_99'@'%' IDENTIFIED BY 'form99';
CREATE USER 'cook_100'@'%' IDENTIFIED BY 'plan100';

DELIMITER //
create procedure change_tel(in identity varchar(50),in telephone_number varchar(15))
begin
declare user_id varchar(50);
    set user_id = substring_index(user(), '@', 1);
    if(user_id=identity) then
    update cook
    set tel_number=telephone_number where id=cast(substring(user_id from 6) as unsigned);
    else
    signal sqlstate '45000' set message_text = 'Unauthorized update for this user';
    end if;
end //
DELIMITER ;

GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_1'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_2'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_3'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_4'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_5'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_6'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_7'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_8'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_9'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_10'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_11'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_12'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_13'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_14'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_15'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_16'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_17'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_18'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_19'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_20'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_21'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_22'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_23'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_24'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_25'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_26'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_27'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_28'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_29'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_30'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_31'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_32'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_33'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_34'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_35'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_36'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_37'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_38'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_39'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_40'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_41'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_42'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_43'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_44'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_45'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_46'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_47'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_48'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_49'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_50'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_51'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_52'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_53'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_54'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_55'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_56'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_57'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_58'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_59'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_60'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_61'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_62'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_63'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_64'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_65'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_66'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_67'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_68'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_69'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_70'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_71'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_72'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_73'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_74'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_75'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_76'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_77'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_78'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_79'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_80'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_81'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_82'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_83'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_84'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_85'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_86'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_87'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_88'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_89'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_90'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_91'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_92'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_93'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_94'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_95'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_96'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_97'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_98'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_99'@'%';
GRANT EXECUTE ON PROCEDURE project.change_tel TO 'cook_100'@'%';
#show warnings;
#drop database project;
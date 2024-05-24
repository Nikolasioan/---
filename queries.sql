drop database project;

#QUERY 3.2.a
create view q32a as
select ck.id"cook_id",ck.name"cook_name", ck.surname "cook_surname", cs.cuisine_nationality "nationality"
from cook_specialty cs join cook ck
on ck.id=cs.cook_id and cs.cuisine_nationality="Brazilian cuisine";
select * from q32a;
#drop view q32a;

#QUERY 3.2.b
select q32a.cook_id "cook id", q32a.cook_name, q32a.cook_surname, count(*) from
q32a join rating
on q32a.cook_id = rating.cook_id
group by q32a.cook_id;

#QUERY 3.3

with youngsters as(
select ck.id "id",ck.name "name",ck.surname "surname" from cook ck join cook_recipies cr
on ck.id=cr.cook_id and ck.age<30),
no_of_recipies as(
select count(*) "count" from youngsters
group by youngsters.id)
select youngsters.id, youngsters.name, youngsters.surname,count(*) from youngsters
group by youngsters.id
having count(*)=(select max(count) from no_of_recipies);

#QUERY 3.5
with ep_same_year as(
select r.judge_id "judge_id", ep.season "season" ,count(*) "count" from episode ep join rating r
on ep.ep_id = r.ep_id group by r.judge_id,ep.ep_id)
select esy.judge_id,esy.season,count(*) from ep_same_year esy
group by esy.judge_id,esy.season having count(*)>1;

/*
with je as(
select judge.id "judge_id",rt.ep_id "ep_id",judge.name "name", judge.surname "surname"
from cook judge join rating rt
on judge.id=rt.judge_id
group by judge.id,rt.ep_id)
select je.judge_id, je.name, je.surname, count(*) from je
group by je.judge_id having count(*)>3
order by count(*)
;*/
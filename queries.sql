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

select day(curdate());

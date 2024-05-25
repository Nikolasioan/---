#QUERY 3.1

#a
select a.cook_id,b.name,b.surname,a.Average_rate from
(select cook_id,sum(rate)/count(ep_id) as Average_rate 
from rating group by cook_id) as a inner join cook as b on a.cook_id=b.id;
#b
select e.nationality,sum(e.rate)/count(e.nationality) as nationality_score from
(select d.nationality,c.rate from (select b.recipe_name,a.rate from rating as a 
inner join ep_data as b on (a.ep_id=b.ep_id and a.cook_id=b.cook_id)) as c
inner join recipies as d on c.recipe_name=d.name) as e group by nationality;

#QUERY 3.2.

#a
create view q32a as
select ck.id"cook_id",ck.name"cook_name", ck.surname "cook_surname",
cs.cuisine_nationality "nationality"
from cook_specialty cs join cook ck
#Croatian cuisine below is used as an example. It can be replaced by any other cuisine
on ck.id=cs.cook_id and cs.cuisine_nationality="Croatian cuisine";
select * from q32a;
#drop view q32a;

#b
#cooks specialized in Croatian cuisine that took part in episodes of season 1
select distinct q32a.cook_id, q32a.cook_name, q32a.cook_surname from
q32a join rating
on q32a.cook_id = rating.cook_id
join episode ep
on ep.ep_id = rating.ep_id and ep.season=2
#group by q32a.cook_id
;

#QUERY 3.3

#find the cooks that are younger than 30 years old and their recipies
with youngsters as(
select ck.id "id",ck.name "name",ck.surname "surname" from cook ck join cook_recipies cr
on ck.id=cr.cook_id and ck.age<30),
#find the number of recipies per young cook
no_of_recipies as(
select count(*) "count" from youngsters
group by youngsters.id)
#find the young cooks with the max number of recipies
select youngsters.id, youngsters.name, youngsters.surname,count(*) from youngsters
group by youngsters.id
having count(*)=(select max(count) from no_of_recipies);

#QUERY 3.4

select a.id,b.name,b.surname from
(select id from cook where id not in(select judge_id from rating)) as a 
inner join cook as b on a.id=b.id;

#QUERY 3.5

#find the episodes that each judge has participated
with ep_same_year as(
select distinct r.judge_id "judge_id", ep.season "season", ep.ep_id 
from episode ep join rating r
on ep.ep_id = r.ep_id group by r.judge_id,ep.ep_id)
#find the number of episodes each judge took part per season
select esy.judge_id,esy.season,count(*) from ep_same_year esy
group by esy.judge_id,esy.season having count(*)>3
#order by 1 
;

#QUERY 3.6

#find all the label pairs that refer to the same recipe and the recipe
with label_pair_recipe as(
select l1.id "l1_id",l2.id "l2_id",rl1.rname "recipe"
from labels l1 join labels l2 on l1.id<l2.id
join recipe_label rl1 on rl1.label_id=l1.id 
join recipe_label rl2
on rl1.rname=rl2.rname and rl2.label_id=l2.id)
#for each label_pair, count how many times its recipes were used in episodes
select lpc.l1_id,lpc.l2_id,count(*) from label_pair_recipe lpc join ep_data ed
on lpc.recipe=ed.recipe_name
group by lpc.l1_id,lpc.l2_id
order by count(*) desc limit 3;

#QUERY 3.7
select e.id,e.name,e.surname
from cook as e inner join
(select d.cook_id from(
select cook_id,sum(count) as count 
from (select cook_id,count(*)/3 as count from rating as a group by cook_id
union all
select judge_id as cook_id,count(*)/10 as count from 
rating as b group by judge_id) as c 
group by cook_id having count<=(select max(count) as count 
from (select cook_id,count(*)/3 as count from rating as a 
group by cook_id
union all
select judge_id as cook_id,count(*)/10 as count from rating as b group by judge_id) as c)) as d) as f on f.cook_id=e.id;


#QUERY 3.8

#find the number of tools used in each episode
with episode_tool as(
select ed.ep_id "ep_id",count(*) "countt" from ep_data ed join recipe_tool rt
on ed.recipe_name = rt.rname
group by ed.ep_id)
#select the ones with the max number of tools
select et.ep_id, et.countt from episode_tool et
where et.countt=(select max(countt) from episode_tool);

#QUERY 3.9

								#carbs per recipe
select ep.season "season", avg(r.carbs_per_portion*r.portions) "carbs" 
from ep_data ed join recipies r
on ed.recipe_name=r.name
join episode ep
on ep.ep_id=ed.ep_id
group by season;

#QUERY 3.10

select distinct f.nationality from ((select season,nationality,count(*) as count
from (select d.season,c.nationality from (select a.ep_id,b.nationality
from ep_data as a inner join recipies as b on b.name=a.recipe_name) as c 
inner join episode as d on c.ep_id=d.ep_id) as e
group by season,nationality having count>=3) as f
inner join (select season,nationality,count(*) as count
from (select d.season,c.nationality from (select a.ep_id,b.nationality
from ep_data as a inner join recipies as b on b.name=a.recipe_name) as c
inner join episode as d on c.ep_id=d.ep_id) as e
group by season,nationality having count>=3) as g
on (f.nationality=g.nationality and f.season=g.season-1 and f.count=g.count));

#QUERY 3.11

#find the total rating that each judge put to each cook and rank the ratings per judge
with judge_rates as(
select judge.id "judge_id",judge.name "judge_name",ck.id "cook_id",ck.name "cook_name",
sum(r.rate) "total",
row_number() over (partition by judge.id order by sum(r.rate) desc) "rn"
from rating r join cook judge
on r.judge_id=judge.id
join cook ck
on ck.id=r.cook_id
group by r.judge_id,r.cook_id)
#select the highest total rate of the top 5 judges
select jr.judge_id,jr.judge_name,jr.cook_id,jr.cook_name,jr.total
from judge_rates jr
where rn=1
order by total desc limit 5
;

#QUERY 3.12

#compute the total difficulty for each episode
with ep_diff as(
select ep.season "season",ed.ep_id "ep_id",sum(r.difficulty) "total_difficulty"
from ep_data ed join recipies r
on ed.recipe_name=r.name
join episode ep on ed.ep_id=ep.ep_id
group by ed.ep_id)
#compute the max episode difficulty for each season
,season_max as(
select ed.season,max(ed.total_difficulty) "max_difficulty"
from ep_diff ed group by ed.season)
#select the episodes from each season that have max difficulty
select ed.season,ed.ep_id,ed.total_difficulty
from ep_diff ed join season_max sm
on ed.season=sm.season and ed.total_difficulty=sm.max_difficulty;

#QUERY 3.13

select ep_id from (
select ep_id,sum(score) as score from (
(select distinct a.ep_id,a.cook_id,b.score from rating as a inner join (
select id,
    case
        when level='Cook C' then 11
        when level='Cook B' then 12
        when level='Cook A' then 13
        when level='Chef Assistant' then 14
        else 15
    end as score
from cook
) as b on (b.id=a.cook_id))
union(
select distinct a.ep_id,a.judge_id,b.score from rating as a inner join (
select id,
    CASE
        when level='Cook C' then 11
        when level='Cook B' then 12
        when level='Cook A' then 13
        when level='Chef Assistant' then 14
        else 15
    end as score
from cook
) as b on (b.id=a.judge_id))) as g group by ep_id) as h where score=
( select max(score) from (
select ep_id,sum(score) as score from (
(select distinct a.ep_id,a.cook_id,b.score from rating as a inner join (
select id,
    CASE
        when level='Cook C' then 11
        when level='Cook B' then 12
        when level='Cook A' then 13
        when level='Chef Assistant' then 14
        else 15
    end as score
from cook
) as b on (b.id=a.cook_id))
union(
select distinct a.ep_id,a.judge_id,b.score from rating as a inner join (
select id,
    case
        when level='Cook C' then 11
        when level='Cook B' then 12
        when level='Cook A' then 13
        when level='Chef Assistant' then 14
        else 15
    end as score
from cook
) as b on (b.id=a.judge_id))) as g group by ep_id) as i
);

#QUERY 3.14

#find the total participation of each theme in episodes
select rt.tname, count(*)
from ep_data ed join recipe_theme rt
on ed.recipe_name=rt.rname
group by rt.tname
#select the one with the highest number of episodes
order by count(*) desc limit 1;

#QUERY 3.15
#find how many times each category was used in episodes
with categories_participated as(
select i.category "category",count(*) from ep_data ed join recipe_ingredient ri
on ed.recipe_name=ri.rname
join ingredients i
on ri.iname=i.name
group by i.category)
#use left join to find which categories are not in the table above
select c.name from categories c left join categories_participated cp
on c.name=cp.category
where cp.category is null;
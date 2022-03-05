select *
from[dbo].['Edge10_gsp $'];

select *
from[dbo].[Edge10_wellness$];


--AVG Player_load per Postion--------------------------------------------
select avg(p1.[Player_load]) as avg_player_load ,p2.[Player_pos]
from [dbo].['Edge10_gsp $'] as p1
inner join [dbo].[Edge10_wellness$] as p2
on p1.player_name= p2.player_name and p1.Date = p2.Date
group by p2.[Player_pos] ;
---------------------QUERY-END--------------------------------------------------


--QUERY FOR MAX SORENESS----------------------------------------------
SELECT ROW_NUMBER() OVER (PARTITION BY DATEPART(dw,a.Date) ORDER BY a.DAte) [Set]
,DATENAme(dw,a.Date) DayOfWeek,a.Date,a.Soreness
INTO output1
 FROM (select date,avg(Soreness) Soreness from Edge10_wellness$ 
 group by Date)
 as a order by a.Date
 
SELECT * 
INTO output2
from(SELECT MAX(b.Soreness) Soreness,b.[Set] FROM output1 b group by b.[Set] )c


--select * from output1 
--select * from output2

--THIS GIVES MAX SORENESS DAY OF THE WEEK (TO EXECUTE THIS RUN ABOVE QUERIES FIRST)
SELECT CONVERT(VARCHAR(MAX),a.Date,103) Date,a.DayOfWeek,a.Soreness from output1 a
 join output2 b on a.[Set]=b.[Set] and a.Soreness=b.Soreness
 order by a.[Set]
 ---------------------------------QUERY-END---------------------------------------------


 --proportion of centre forwards that cover more than 5000m in training 75% --
select * from ['Edge10_gsp $'] a join Edge10_wellness$ b
on a.player_name=b.player_name and a.Date=b.Date
where b.Player_pos='CF'
and b.Player_name not in (
select DISTINCT b.player_name from ['Edge10_gsp $'] a join Edge10_wellness$ b
on a.player_name=b.player_name and a.Date=b.Date
where b.Player_pos='CF' and Total_distance>5000 and Session_duration>=CAST((75*90)/100 as decimal(17,2)))


--OverAll Output FOR PROPORTIONS OF CF
select DISTINCT * from ['Edge10_gsp $'] a join Edge10_wellness$ b
on a.player_name=b.player_name and a.Date=b.Date
where b.Player_pos='CF' and Total_distance>5000 and Session_duration>=CAST((75*90)/100 as decimal(17,2))

--DayWise OUtPUt FOR PROPORTIONS OF CF distance>5000 (75%)

select ROW_NUMBER () OVER (ORDER BY a.DAte ) SrNo,CONVERT(NVARCHAR(100),a.Date,103) Date,a.player_name,Session_duration,Total_distance from ['Edge10_gsp $'] a join Edge10_wellness$ b
on a.player_name=b.player_name and a.Date=b.Date
where b.Player_pos='CF' and Total_distance>5000 and Session_duration>=CAST((75*90)/100 as decimal(17,2))

---------------------------QUERY-END------------------------------------------------------



--To investigate the effect of sleep on RPE, create another table (a subquery)
select DISTINCT a.Date,a.player_name,b.Player_pos,b.Sleep_Hours,a.RPE
into Investigation_Sleep_On_RPE_1
from ['Edge10_gsp $'] a
join
Edge10_wellness$ b 
on a.Date=b.Date and a.player_name=b.player_name

----
SELECT * 
FROM Investigation_Sleep_On_RPE_1


----------------------QUERY-END--------------------------------------------------
select a.Date, a.Session_duration,a.Player_load,a.Number_of_ACC,a.Total_distance,a.RPE,
a.player_name,b.Motivation,b.Player_pos,b.Sleep_Hours,b.Soreness
into anything_interesting
from [dbo].['Edge10_gsp $'] as a
inner join [dbo].[Edge10_wellness$] as b
on a.Date= b.Date and a.player_name = b.player_name
--------------------------------

select  player_name,Sleep_Hours,Motivation,Soreness
from [dbo].[anything_interesting]




               

USE HI361

select top 10 * from dbo.icd
select top 10 * from dbo.claims
select top 10 * from dbo.ptid

select table_name
from information_schema.tables
where table_type = 'base table';

--- identify patients with diabetes
select distinct a.PTID into #diabetes
from dbo.claims a
join dbo.icd b
on a.DIGNSS_C = b.column1
where b.column2 LIKE 'diabetes%';

select * from #diabetes;

-- average cost of each diagnosis

select DIGNSS_C, AVG(BLLD_AMT) AS AvgB
from dbo.claims
where BLLD_AMT > 0
group by DIGNSS_C
order by AvgB DESC;

-- are men more likely to have diabetes than women?
SELECT
    b.PAT_SEX,
    COUNT(a.PTID) AS PatFreq
FROM #diabetes a
JOIN dbo.ptid b
ON a.PTID = b.PTID
GROUP BY b.PAT_SEX;

select
    pat_sex,
    count(distinct PTID) as TotalPatients
from dbo.ptid
group by pat_sex;

-- which month has the most diagnoses
select
    month(SVC_FROM) as M,
    count(*) as FreqDiag
from dbo.claims
group by month(SVC_FROM)
order by FreqDiag DESC;

-- find the five icd-9 errors
select
    column1,
    count(distinct column2) as DescriptionCount
from dbo.icd
group by column1
having count(distinct column2) > 1;

select top 20 * from dbo.icd;

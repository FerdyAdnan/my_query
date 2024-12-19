select a.*,
CASE 
	when a.pct_total <= 50 then '<= 50%'
	when a.pct_total > 50 and a.pct_total <=60 then '51-60%'
	when a.pct_total > 60  and a.pct_total <=70 then '61-70%'
	when a.pct_total > 70 and a.pct_total <=80 then '71-80%'
	when a.pct_total > 80 and a.pct_total <=90 then '81-90%'
	when a.pct_total > 91 and a.pct_total <=100 then '91-100%'
	else '>100%'
END as pct,
CASE 
	when o.companycode = 'pak' and o.code in('022','018') then 'PRIVE'
	when o.companycode = 'pak' and  o.code not in ('022','018') then 'PASSION'
	when o.companycode = 'bak' or a.Outlet = '627' then 'DNC'
	else 0
END as compnaycode_new,
CASE 
	when a.yearmonth = '2022-01' then 'January'
	when a.yearmonth = '2022-02' then 'February'
	when a.yearmonth = '2022-03' then 'March'
	when a.yearmonth = '2022-04' then 'April'
	when a.yearmonth = '2022-05' then 'May'
	when a.yearmonth = '2022-06' then 'June'
	when a.yearmonth = '2022-07' then 'July'
	when a.yearmonth = '2022-08' then 'Augusts'
	when a.yearmonth = '2022-09' then 'September'
	when a.yearmonth = '2022-10' then 'October'
	when a.yearmonth = '2022-11' then 'November'
	when a.yearmonth = '2022-12' then 'December'
	when a.yearmonth = '2023-01' then 'January'
	when a.yearmonth = '2023-02' then 'February'
	when a.yearmonth = '2023-03' then 'March'
	when a.yearmonth = '2023-04' then 'April'
	when a.yearmonth = '2023-05' then 'May'
	when a.yearmonth = '2023-06' then 'June'
	when a.yearmonth = '2023-07' then 'July'
	when a.yearmonth = '2023-08' then 'August '
	when a.yearmonth = '2023-09' then 'September'
	when a.yearmonth = '2023-10' then 'October'
	when a.yearmonth = '2023-11' then 'November'
	when a.yearmonth = '2023-12' then 'December'
	when a.yearmonth = '2024-01' then 'January'
	when a.yearmonth = '2024-02' then 'February'
	when a.yearmonth = '2024-03' then 'March'
	when a.yearmonth = '2024-04' then 'April'
	when a.yearmonth = '2024-05' then 'May'
	when a.yearmonth = '2024-06' then 'June'
	when a.yearmonth = '2024-07' then 'July'
	when a.yearmonth = '2024-08' then 'Augusts'
	when a.yearmonth = '2024-09' then 'September'
	when a.yearmonth = '2024-10' then 'October'
	when a.yearmonth = '2024-11' then 'November'
	when a.yearmonth = '2024-12' then 'December'
END as bulan,
substring(rtrim(a.yearmonth),1,LENGTH (a.yearmonth)-3) as Tahun
from (select ja.Outlet ,ja.Accname,ja."JC Name" ,ja.Target ,ja."Total NET" ,ja."Total %" ,
(CAST(replace( ja."Total NET" , ',', '.')as float)/ ja.Target)*100 as pct_total, 
CAST(replace( ja."Total NET" , ',', '.')as float)/ ja.Target as pct_total_new, yearmonth
from jc_achivement ja ) as a
left join outlet o 
on a.Outlet = o.code
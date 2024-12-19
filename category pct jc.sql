select a.yearmonth,a.companycode,a.outlet,a.jc ,sum(a.plan) as Plan,sum(a.real)as Target,sum(a.real)/sum(a.plan)*100 as pct_yearmonth ,CASE 
	when sum(a.real)/sum(a.plan)*100 <= 50 then '<= 50%'
	when sum(a.real)/sum(a.plan)*100 between 51 and 60 then '51-60%'
	when sum(a.real)/sum(a.plan)*100 BETWEEN 61 and 70 then '61-70%'
	when sum(a.real)/sum(a.plan)*100 BETWEEN 71 and 80 then '71-80%'
	when sum(a.real)/sum(a.plan)*100 BETWEEN  81 and 90 then '81-90%'
	when sum(a.real)/sum(a.plan)*100 BETWEEN 91 and 100 then '91-100%'
	else '>100'
END category
from (SELECT
    t.outlet,
    c.name as customer,
    e.name as jc,
    date(t.createdt) as plan_date,
    t.plan,
    t.real,
    t.realdt,
    replace((t.real / gt.total_plan), '.', ',') AS real_percentage, DATE_FORMAT(date(t.createdt), '%Y-%m') as yearmonth, case 
	when t.outlet in ('018', '022') then 'PRIVE'
	when o.companycode = 'pak' and t.outlet not in ('018', '022') then 'PASSION'
	when o.companycode = 'bak' then 'DNC'
end as companycode
FROM
    salesplan t
JOIN
    (SELECT
        s.outlet,
        DATE_FORMAT(date(s.createdt), '%Y-%m') AS yearmonth,
        SUM(plan) AS total_plan 
    FROM
        salesplan s 
    GROUP BY
        s.outlet, DATE_FORMAT(date(s.createdt), '%Y-%m')) gt
    ON t.outlet = gt.outlet
    AND DATE_FORMAT(date(t.createdt), '%Y-%m') = gt.yearmonth
left join customer c 
on t.customerid = c.id 
left join employee e 
on t.employeeid = e.id
left join outlet o 
on t.outlet = o.code
where date(t.createdt) >= '2024-08-01'
and o.store = 1
and o.code != '201'
and t.status != 2
and e.active = 'Y'
ORDER BY
    t.outlet,
    date(t.createdt)
   ) a
 group by yearmonth,companycode,outlet,jc
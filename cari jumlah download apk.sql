
select b.yearmonth, b.outlet, b.companycode, b.total_cust - c2.install_count as install_count, 'BELUM INSTALL' install_status
from (select DATE_FORMAT(date(c.createdate), '%Y-%m') as yearmonth, c.outlet, case 
	when c.outlet in ('018', '022') then 'PRIVE'
	when o.companycode = 'pak' and c.outlet not in ('018', '022') then 'PASSION'
	when o.companycode = 'bak' then 'DNC'
end as companycode, COUNT(c.code) as total_cust
from customer c 
left join outlet o 
on c.outlet = o.code 
where o.store = 1
and date(c.createdate) >= '2023-01-01'
group by DATE_FORMAT(date(c.createdate), '%Y-%m'), c.outlet)b
left join (select yearmonth, outlet, case 
	when outlet in ('018', '022') then 'PRIVE'
	when companycode = 'pak' and outlet not in ('018', '022') then 'PASSION'
	when companycode = 'bak' then 'DNC'
end as companycode, sum(ps_status) + SUM(dnc_status) as install_count, 'SUDAH INSTALL' as install_status
from (select yearmonth, code, outlet, case 
	when passion_userid is null then 0
	else 1
end as ps_status, case 
	when dnc_userid is null then 0
	else 1
end as dnc_status, companycode
from (select DATE_FORMAT(date(c.createdate), '%Y-%m') as yearmonth, c.code, c.outlet,case 
	when c.companycode = 'pak' and c.passion_userid is not null and c.dnc_userid is not null then c.passion_userid
	when c.companycode = 'bak' and c.passion_userid is not null then NULL 
	else c.passion_userid
end as passion_userid, case 
	when c.companycode = 'bak' and c.dnc_userid is not null and c.passion_userid is not null then c.dnc_userid
	when c.companycode = 'pak' and c.dnc_userid is not null then NULL 
	else c.dnc_userid 
end as dnc_userid, o.companycode
from customer c 
left join outlet o 
on c.outlet = o.code 
where o.store = 1
and date(c.createdate) >= '2023-01-01') a)c2
group by yearmonth, outlet) = c2
on b.yearmonth = c2.yearmonth and b.outlet = c2.outlet
union all 
select c2.yearmonth, c2.outlet, c2.companycode, c2.install_count, c2.install_status
from (select yearmonth, outlet, case 
	when outlet in ('018', '022') then 'PRIVE'
	when companycode = 'pak' and outlet not in ('018', '022') then 'PASSION'
	when companycode = 'bak' then 'DNC'
end as companycode, sum(ps_status) + SUM(dnc_status) as install_count, 'SUDAH INSTALL' as install_status
from (select yearmonth, code, outlet, case 
	when passion_userid is null then 0
	else 1
end as ps_status, case 
	when dnc_userid is null then 0
	else 1
end as dnc_status, companycode
from (select DATE_FORMAT(date(c.createdate), '%Y-%m') as yearmonth, c.code, c.outlet,case 
	when c.companycode = 'pak' and c.passion_userid is not null and c.dnc_userid is not null then c.passion_userid
	when c.companycode = 'bak' and c.passion_userid is not null then NULL 
	else c.passion_userid
end as passion_userid, case 
	when c.companycode = 'bak' and c.dnc_userid is not null and c.passion_userid is not null then c.dnc_userid
	when c.companycode = 'pak' and c.dnc_userid is not null then NULL 
	else c.dnc_userid 
end as dnc_userid, o.companycode
from customer c 
left join outlet o 
on c.outlet = o.code 
where o.store = 1
and date(c.createdate) >= '2023-01-01') a)c2
group by yearmonth, outlet) c2
order by outlet,yearmonth , install_status
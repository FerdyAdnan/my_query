-- cara hitung total voucher yang didapat berdasarkan dealprice
select s.salesdt , s.outlet, c.code ,c.name as customer_name, e.name as  JC_name  , sp.dealprice , floor(sp.dealprice/1999000) as total_voucher 
from sales s 
left join sales_product sp 
on s.code  = sp.salescode 
left join employee e 
on s.server  = e.id
left join customer c 
on s.customer = c.code 
where s.salesdt >='2023-01-01'
and sp.product = 'DJ'
and sp.status  = 0 
and s.is_cancel  = 0 
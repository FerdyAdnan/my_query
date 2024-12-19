select cb.createdate, cb.name ,dm.transaksi as transaksi,dm.qty ,cb.nett,cb.companycode, cb.code , cb.outlet ,cb. tanggal_terakhir, mo.membershipid , mo.nama_member_now,
   mo.member_pertama ,mo.member_old
 from (
 select c.name , c.createdate  , c.code  , s.outlet ,max( s.salesdt) as tanggal_terakhir , c.companycode , sum(dd.dealprice) as nett
 from customer c 
 right join sales s 
 on c.code  = s.customer 
 inner join (select sp.dealprice,sp.salescode
    from sales_product sp
    inner join sales s 
    on sp.salescode  = s.code 
    where sp.dealprice != 1)dd
    on s.code = dd.salescode
  where s.outlet not in('D98','D99')
 and s.outlet not in (201)
  and c.outlet  is not null
  group by c.name 
    )cb
    left join ( SELECT  sum(aa.transaksi) as transaksi, sum(aa.qty) as qty  ,aa.customer from(
SELECT 
    COUNT(DISTINCT s.code) AS transaksi,   -- Hitung jumlah transaksi
    count(DISTINCT sp.productcode) as qty,
    s.code,
    s.customer
FROM 
    sales s
LEFT JOIN 
    sales_product sp ON s.code = sp.salescode
 left join ( 
 select sp.dealprice ,sp.salescode 
 from sales_product sp 
 )B2
 on s.code = B2.salescode
WHERE  
     s.is_cancel != 1
    group by s.code
 )aa
 group by aa.customer)dm
 on cb.code = dm.customer
 left join ( SELECT 
        c.createdate,
        c.code,
        c.membershipid,
        c.outlet,
        c.companycode,
        CASE 
            WHEN c.companycode = 'pak' and c.membershipid is not NULL THEN m.name
            WHEN c.companycode = 'bak' and c.membershipid is not null then m.dname
            ELSE NULL
        END AS nama_member_now,
        gg.member_pertama , gg.member_old
    FROM 
        customer c
    LEFT JOIN 
        membership m ON c.membershipid = m.id
    left join(
      SELECT DISTINCT
    nm.code,
    nm.companycode,
    nm.member_pertama,
    CASE 
        WHEN nm.companycode = 'pak' THEN mo.name
        WHEN nm.companycode = 'bak' THEN mo.dname
        ELSE NULL
    END AS member_old
FROM (
    SELECT 
        c.code,
        c.companycode,
        CASE 
            WHEN s.amembershipid < s.fmembershipid THEN s.fmembershipid
            WHEN s.amembershipid < s.membershipid THEN s.membershipid
            WHEN s.membershipid IS NOT NULL AND s.amembershipid IS NULL AND s.fmembershipid IS NULL THEN s.membershipid
            ELSE s.amembershipid
        END AS member_pertama
    FROM 
        sales s
    INNER JOIN 
        customer c ON s.customer = c.code
    WHERE 
        c.companycode != 'sakura'
) nm
LEFT JOIN membership mo ON nm.member_pertama = mo.id)gg
        on c.code = gg.code )mo 
        on cb.code = mo.code
        where transaksi is not null
    group by cb.createdate,cb.name , cb.code , cb.outlet
SELECT 
    a.name,
    a.tanggal_terakhir,
    a.transaksi,
    a.qty,
    a.nett,
    a.outlet,
    a.companycode,
    a.code,
    CASE 
        WHEN b.tanggal_aktif IS NULL AND b.transaksi IS NULL AND b.qty IS NULL AND b.outlet IS NULL THEN 'N'
        ELSE 'Y'
    END AS status,
    b.tanggal_aktif,
    b.transaksi,
    b.qty,
    b.nett,
    b.outlet
FROM (
    SELECT 
        cb.name,
        cb.tanggal_terakhir,
        COALESCE(dm.transaksi, 0) AS transaksi,
        COALESCE(dm.qty, 0) AS qty,
        cb.nett,
        cb.companycode,
        cb.code,
        cb.outlet
    FROM (
        SELECT 
            c.name,
            MAX(s.salesdt) AS tanggal_terakhir,
            c.code,
            c.companycode,
            s.outlet,
            SUM(dd.dealprice) AS nett
        FROM customer c
        RIGHT JOIN sales s ON c.code = s.customer
        INNER JOIN (
            SELECT 
                sp.dealprice, 
                sp.salescode
            FROM sales_product sp
            WHERE sp.dealprice != 1
        ) dd ON s.code = dd.salescode
        WHERE 
            s.outlet NOT IN ('D98', 'D99', '201')
            AND s.salesdt <= '2023-11-01'
            AND c.outlet IS NOT NULL
            AND c.code NOT IN (
                SELECT DISTINCT s.customer
                FROM sales s
                WHERE s.salesdt BETWEEN DATE_SUB('2024-11-01', INTERVAL 1 YEAR) AND '2024-11-01'
            )
        GROUP BY c.name, c.code, c.companycode, s.outlet
    ) cb
    LEFT JOIN (
        SELECT 
            COUNT(DISTINCT s.code) AS transaksi,
            COUNT(DISTINCT sp.productcode) AS qty,
            s.customer
        FROM sales s
        LEFT JOIN sales_product sp ON s.code = sp.salescode
        WHERE 
            s.is_cancel != 1
            AND s.salesdt <= '2023-11-01'
        GROUP BY s.customer
    ) dm ON cb.code = dm.customer
) a
LEFT JOIN (
    SELECT 
        cb.name,
        cb.tanggal_aktif,
        COALESCE(dm.transaksi, 0) AS transaksi,
        COALESCE(dm.qty, 0) AS qty,
        cb.nett,
        cb.companycode,
        cb.code,
        cb.outlet
    FROM (
        SELECT 
            c.name,
            MIN(s.salesdt) AS tanggal_aktif,
            c.code,
            c.companycode,
            s.outlet,
            SUM(dd.dealprice) AS nett
        FROM customer c
        RIGHT JOIN sales s ON c.code = s.customer
        INNER JOIN (
            SELECT 
                sp.dealprice, 
                sp.salescode
            FROM sales_product sp
            WHERE sp.dealprice != 1
        ) dd ON s.code = dd.salescode
        WHERE 
            s.outlet NOT IN ('D98', 'D99', '201')
            AND s.salesdt BETWEEN '2024-11-01' AND CURDATE()
            AND c.outlet IS NOT NULL
        GROUP BY c.name, c.code, c.companycode, s.outlet
    ) cb
    LEFT JOIN (
        SELECT 
            COUNT(DISTINCT s.code) AS transaksi,
            COUNT(DISTINCT sp.productcode) AS qty,
            s.customer
        FROM sales s
        LEFT JOIN sales_product sp ON s.code = sp.salescode
        WHERE 
            s.is_cancel != 1
            AND s.salesdt BETWEEN '2024-11-01' AND CURDATE()
        GROUP BY s.customer
    ) dm ON cb.code = dm.customer
) b ON a.code = b.code
CREATE VIEW v_penjualan AS
SELECT o.order_id, o.order_date,
       CAST(strftime('%m', o.order_date) AS INTEGER) AS bulan,
       o.customer_id, o.customer_age, o.gender, o.city,
       p.product_name, p.category, o.order_status, o.payment_method,
       o.quantity,
       p.unit_price * o.quantity * (1 - o.discount_pct / 100.0) AS total_penjualan,
       CASE WHEN o.customer_age IS NULL THEN 'Tidak diketahui'
            WHEN o.customer_age <= 25 THEN '18-25'
            WHEN o.customer_age <= 35 THEN '26-35'
            WHEN o.customer_age <= 45 THEN '36-45'
            ELSE '46+' END AS kelompok_usia
FROM orders o
JOIN products p ON p.product_id = o.product_id;

SELECT SUM(total_penjualan)                       AS total_omzet,
       COUNT(*)                                   AS order_selesai,
       SUM(total_penjualan) * 1.0 / COUNT(*)      AS rata_per_order
FROM v_penjualan
WHERE order_status = 'Selesai';


SELECT bulan, SUM(total_penjualan) AS omzet
FROM v_penjualan
WHERE order_status = 'Selesai'
GROUP BY bulan
ORDER BY bulan;


SELECT category,
       SUM(total_penjualan) AS omzet,
       ROUND(100.0 * SUM(total_penjualan) / SUM(SUM(total_penjualan)) OVER (), 1) AS persen
FROM v_penjualan
WHERE order_status = 'Selesai'
GROUP BY category
ORDER BY omzet DESC;


SELECT product_name, SUM(total_penjualan) AS omzet
FROM v_penjualan
WHERE order_status = 'Selesai'
GROUP BY product_name
ORDER BY omzet DESC
LIMIT 5;


SELECT order_status,
       COUNT(*) AS jumlah,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS persen
FROM v_penjualan
GROUP BY order_status;


WITH bulanan AS (
    SELECT bulan, SUM(total_penjualan) AS omzet
    FROM v_penjualan
    WHERE order_status = 'Selesai'
    GROUP BY bulan
)
SELECT bulan, omzet,
       LAG(omzet) OVER (ORDER BY bulan) AS omzet_bulan_lalu,
       ROUND(100.0 * (omzet - LAG(omzet) OVER (ORDER BY bulan))
             / LAG(omzet) OVER (ORDER BY bulan), 1) AS growth_persen
FROM bulanan;


SELECT * FROM (
    SELECT category, product_name, SUM(total_penjualan) AS omzet,
           RANK() OVER (PARTITION BY category ORDER BY SUM(total_penjualan) DESC) AS peringkat
    FROM v_penjualan
    WHERE order_status = 'Selesai'
    GROUP BY category, product_name
)
WHERE peringkat <= 3;
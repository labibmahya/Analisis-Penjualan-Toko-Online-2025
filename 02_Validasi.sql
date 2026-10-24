-- 1. Harus 500 baris dan 25 produk
SELECT (SELECT COUNT(*) FROM orders)   AS jumlah_order,
       (SELECT COUNT(*) FROM products) AS jumlah_produk;

-- 2. Harus 18 usia NULL (15 kosong + 3 yang kamu kosongkan)
SELECT COUNT(*) FROM orders WHERE customer_age IS NULL;

-- 3. Cek apakah atribut pelanggan konsisten (hasil kosong = konsisten)
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT gender) > 1 OR COUNT(DISTINCT city) > 1;

-- 4. Cek satu nama produk hanya punya satu kategori (hasil kosong = aman)
SELECT product_name FROM products
GROUP BY product_name HAVING COUNT(DISTINCT category) > 1;
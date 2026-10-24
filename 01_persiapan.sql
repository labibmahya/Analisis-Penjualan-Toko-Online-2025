CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT NOT NULL UNIQUE,
    category     TEXT NOT NULL,
    unit_price   INTEGER NOT NULL
);

CREATE TABLE orders (
    order_id       TEXT PRIMARY KEY,
    order_date     TEXT NOT NULL,
    customer_id    TEXT NOT NULL,
    customer_age   INTEGER,
    gender         TEXT,
    city           TEXT,
    product_id     INTEGER NOT NULL REFERENCES products(product_id),
    quantity       INTEGER NOT NULL,
    discount_pct   INTEGER NOT NULL,
    payment_method TEXT,
    order_status   TEXT NOT NULL
);

INSERT INTO products (product_name, category, unit_price)
SELECT DISTINCT Product_Name, Product_Category, Unit_Price
FROM stg_penjualan;

INSERT INTO orders
SELECT s.Order_ID, s.Order_Date, s.Customer_ID,
       NULLIF(s.Customer_Age, ''),      -- usia kosong jadi NULL
       s.Gender, s.City, p.product_id,
       s.Quantity, s.Discount_Pct, s.Payment_Method, s.Order_Status
FROM stg_penjualan s
JOIN products p ON p.product_name = s.Product_Name;
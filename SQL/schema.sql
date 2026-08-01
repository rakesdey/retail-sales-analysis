-- Customers table
CREATE TABLE customers (
    customer_id     VARCHAR(20) PRIMARY KEY,
    customer_name   VARCHAR(100),
    segment         VARCHAR(30),
    country         VARCHAR(50)
);

-- Products table
CREATE TABLE products (
    product_id      VARCHAR(30) PRIMARY KEY,
    category        VARCHAR(30),
    sub_category    VARCHAR(30),
    product_name    VARCHAR(200)
);

-- Orders table (order-level shipping/geo info here, not on customers)
CREATE TABLE orders (
    row_id             INT PRIMARY KEY,
    order_id            VARCHAR(20) NOT NULL,
    order_date          DATE NOT NULL,
    ship_date            DATE NOT NULL,
    ship_mode            VARCHAR(20),
    customer_id          VARCHAR(20) REFERENCES customers(customer_id),
    product_id            VARCHAR(30) REFERENCES products(product_id),
    city                VARCHAR(50),
    state                VARCHAR(50),
    postal_code          VARCHAR(10),
    region               VARCHAR(20),
    sales                NUMERIC(10,2),
    quantity              INT,
    discount              NUMERIC(4,2),
    profit                NUMERIC(10,2),
    shipping_days         INT,
    profit_margin_pct     NUMERIC(6,2)
);

-- Indexes for common filter/join columns
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_product ON orders(product_id);
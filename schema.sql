-- Drop existing tables in correct dependency order (optional, for reruns)
DROP TABLE IF EXISTS ORDER_LINE CASCADE;
DROP TABLE IF EXISTS "ORDER" CASCADE;
DROP TABLE IF EXISTS PRODUCT CASCADE;
DROP TABLE IF EXISTS PRODUCT_CATEGORY CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;
DROP TABLE IF EXISTS EMPLOYEE CASCADE;
DROP TABLE IF EXISTS TEAM CASCADE;
DROP TABLE IF EXISTS REGION CASCADE;
DROP TABLE IF EXISTS COUNTRY CASCADE;

-- 1. COUNTRY
CREATE TABLE COUNTRY (
    country_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 2. REGION
CREATE TABLE REGION (
    region_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES COUNTRY(country_id)
);

-- 3. TEAM
CREATE TABLE TEAM (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 4. EMPLOYEE
CREATE TABLE EMPLOYEE (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) UNIQUE NOT NULL,
    team_id INT NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES TEAM(team_id),
    FOREIGN KEY (region_id) REFERENCES REGION(region_id)
);

-- 5. CUSTOMER
CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    segment VARCHAR(20) CHECK (segment IN ('Corporate', 'SME', 'Retail'))
);

-- 6. PRODUCT_CATEGORY
CREATE TABLE PRODUCT_CATEGORY (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 7. PRODUCT
CREATE TABLE PRODUCT (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) UNIQUE NOT NULL,
    sku VARCHAR(100),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES PRODUCT_CATEGORY(category_id)
);

-- 8. ORDER (SALE)
CREATE TABLE "ORDER" (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    region_id INT NOT NULL,
    country_id INT NOT NULL,
    stage VARCHAR(20) CHECK (stage IN ('Won', 'Lost', 'Opportunity')),
    revenue NUMERIC(12, 2),
    target NUMERIC(12, 2),
    deal_size NUMERIC(12, 2),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (region_id) REFERENCES REGION(region_id),
    FOREIGN KEY (country_id) REFERENCES COUNTRY(country_id)
);

-- 9. ORDER_LINE (SALE_LINE)
CREATE TABLE ORDER_LINE (
    order_id INT NOT NULL,
    line_no INT NOT NULL,
    product_id INT NOT NULL,
    units_sold INT,
    line_revenue NUMERIC(12, 2),
    PRIMARY KEY (order_id, line_no),
    FOREIGN KEY (order_id) REFERENCES "ORDER"(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

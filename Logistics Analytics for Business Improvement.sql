CREATE TABLE customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    acquisition_date DATE,
    acquisition_cost_usd DECIMAL(10,2),
    market_segment VARCHAR(50),
    supplier_id VARCHAR(10),
    order_id VARCHAR(20),
    order_date DATE,
    order_value_usd DECIMAL(12,2),
    payment_date DATE,
    satisfaction_score INT,
    support_tickets INT,
    lead_time_days INT
);

DESCRIBE logistics_performance;
DROP TABLE IF EXISTS logistics_perf;

CREATE TABLE logistics_perf (
    shipment_id VARCHAR(30) PRIMARY KEY,
    type VARCHAR(20),
    date DATE,
    product_category VARCHAR(50),
    origin VARCHAR(50),
    O_Country VARCHAR(50),
    destination VARCHAR(50),
    D_Country VARCHAR(50),
    value DECIMAL(12,2),
    freight_cost DECIMAL(10,2),
    customs_clearance_time_days DECIMAL(5,2),
    delivery_status VARCHAR(20)
);

DESCRIBE logistics_perf;
DROP TABLE IF EXISTS logistics_performance;

SHOW TABLES;

SELECT 'customer' AS table_name, COUNT(*) AS total_rows FROM customer
UNION ALL
SELECT 'shipment', COUNT(*) FROM shipment
UNION ALL
SELECT 'logistics_perf', COUNT(*) FROM logistics_perf;

USE `2 ke`;

SELECT 'customer' AS table_name, COUNT(*) AS total_rows FROM customer
UNION ALL
SELECT 'shipment', COUNT(*) FROM shipment
UNION ALL
SELECT 'logistics_perf', COUNT(*) FROM logistics_perf;
USE `2 ke`;

DROP TABLE IF EXISTS logistics_performance;
DROP TABLE IF EXISTS logistics_perf;

SHOW TABLES;
USE `2 ke`;

DROP TABLE IF EXISTS logistics_performance;

SHOW TABLES;

SHOW TABLES;
USE `2 ke`;

SELECT 'customer' AS table_name, COUNT(*) AS total_rows FROM customer
UNION ALL
SELECT 'shipment', COUNT(*) FROM shipment
UNION ALL
SELECT 'logistics_perf', COUNT(*) FROM logistics_perf;

USE `2 ke`;

SELECT 
    market_segment,
    COUNT(*) AS jumlah_customer,
    ROUND(SUM(order_value_usd), 0) AS total_order_value,
    ROUND(AVG(order_value_usd), 0) AS rata2_order_value,
    ROUND(AVG(satisfaction_score), 2) AS rata2_kepuasan
FROM customer
GROUP BY market_segment
ORDER BY total_order_value DESC;

SELECT 
    region,
    ROUND(AVG(delay_hours_avg), 2) AS rata_delay_jam,
    SUM(damage_claims_count) AS total_klaim_kerusakan,
    ROUND(AVG(shipments_processed), 0) AS rata_pengiriman
FROM shipment
GROUP BY region
ORDER BY rata_delay_jam DESC;

SELECT 
    product_category,
    delivery_status,
    COUNT(*) AS jumlah,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY product_category), 2) AS persentase
FROM logistics_perf
GROUP BY product_category, delivery_status
ORDER BY product_category, jumlah DESC;

SELECT 
    supplier_id,
    COUNT(*) AS total_order,
    SUM(order_value_usd) AS total_nilai,
    AVG(satisfaction_score) AS rata_kepuasan,
    AVG(lead_time_days) AS rata_lead_time
FROM customer
GROUP BY supplier_id
ORDER BY rata_kepuasan DESC, total_nilai DESC
LIMIT 5;

SELECT 
    supplier_id,
    COUNT(*) AS total_order,
    SUM(order_value_usd) AS total_nilai,
    AVG(satisfaction_score) AS rata_kepuasan,
    AVG(lead_time_days) AS rata_lead_time
FROM customer
GROUP BY supplier_id
ORDER BY rata_kepuasan ASC, total_nilai ASC
LIMIT 5;

-- Show Table Schema


-- Show First 10 Rows
SELECT * FROM retail limit 10;

-- Number of Records
SELECT COUNT(*) FROM retail;

-- Number of Clients (e.g. unique client ID)
SELECT COUNT(*) FROM (SELECT DISTINCT customer_id FROM retail WHERE customer_id IS NOT null) AS customers;

-- Invoice Data Range (e.g. max/min dates)
SELECT MAX(invoice_date) AS max, MIN(invoice_date) AS min FROM retail;

-- Number of SKU/Merchants (e.g. unique stock codes)
SELECT COUNT(*) FROM (SELECT DISTINCT stock_code FROM retail WHERE stock_code IS NOT null) AS merchants;

-- Average Invoice Amount (Excluding negative amounts)
SELECT AVG(sum) AS avg FROM (SELECT invoice_no, SUM(amount) AS sum FROM (SELECT invoice_no, (unit_price * quantity) AS amount FROM retail WHERE unit_price  > 0 AND quantity > 0) AS amounts GROUP BY invoice_no) AS sums;

-- Total Revenue (e.g. sume of unit_price * quantity)
SELECT SUM(unit_price * quantity) AS sum FROM retail;

-- Total Revenue by YYYY MM
SELECT yyyymm, SUM(amount) AS sum FROM (SELECT (EXTRACT(year FROM invoice_date) || LPAD(EXTRACT(month FROM invoice_date)::text, 2, '0')) AS yyyymm, (unit_price * quantity) AS amount FROM retail) AS amounts GROUP BY yyyymm ORDER BY yyyymm;

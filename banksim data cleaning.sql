-- BANKSIM DATA CLEANING --

 # Description: Cleaning and preparing the BankSim dataset by fixing incorrect values, standardizing formats, and creating additional columns like age group and transaction day for better analysis.

CREATE TABLE banksim_db (
    step INT,
    customer VARCHAR(20),
    age INT,
    gender CHAR(1),
    zipcodeOri VARCHAR(20),
    merchant VARCHAR(20),
    zipMerchant VARCHAR(10),
    category VARCHAR(50),
    amount DOUBLE,
    fraud TINYINT
);

LOAD DATA LOCAL INFILE 'C:/Users/Janvi/OneDrive/Desktop/banksim_dataset.csv'
INTO TABLE banksim_dbbanksim_dbbanksim_db
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE banksim_db
MODIFY age VARCHAR(2);

ALTER TABLE banksim_db
ADD COLUMN transaction_time datetime,
ADD COLUMN transation_date date;

ALTER TABLE banksim_db
CHANGE COLUMN transation_date transaction_date DATE;

UPDATE banksim_db
SET
	transaction_time = DATE_ADD('2024-01-01 00:00:00', INTERVAL step HOUR),
    transaction_date = DATE_ADD('2024-01-01', INTERVAL FLOOR(step/24)DAY);
    
CREATE TABLE banksim_staging AS
SELECT * FROM banksim_db;

ALTER TABLE banksim_staging
ADD COLUMN transaction_dayname VARCHAR(10),
ADD COLUMN age_group VARCHAR(20);

UPDATE banksim_staging 
SET
  transaction_dayname = DAYNAME(DATE_ADD('2024-01-01 00:00:00', INTERVAL step HOUR));

UPDATE banksim_staging
SET age_group = CASE
  WHEN age = 0 THEN '<25'
  WHEN age = 1 THEN '25–34'
  WHEN age = 2 THEN '35–44'
  WHEN age = 3 THEN '45–54'
  WHEN age = 4 THEN '55–64'
  WHEN age = 5 THEN '65–74'
  WHEN age = 6 THEN '75+'
  ELSE 'Unknown'
END;

SELECT customer, step, amount, COUNT(*) AS dup_count
FROM banksim_staging
GROUP BY customer, step, amount
HAVING COUNT(*) > 1;

WITH ranked_transactions AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY customer, step, amount
           ORDER BY transaction_time
         ) AS row_num
  FROM banksim_staging
)
DELETE FROM banksim_staging
WHERE (customer, step, amount, transaction_time) IN (
  SELECT customer, step, amount, transaction_time
  FROM ranked_transactions
  WHERE row_num > 1
);

SELECT 
  SUM(customer IS NULL) AS null_customer,
  SUM(age IS NULL) AS null_age,
  SUM(age_group IS NULL) AS null_age_group,
  SUM(amount IS NULL) AS null_amount,
  SUM(step IS NULL) AS null_step,
  SUM(transaction_time IS NULL) AS null_transaction_time,
  SUM(transaction_date IS NULL) AS null_transaction_date,
  SUM(transaction_dayname IS NULL) AS null_dayname,
  SUM(category IS NULL) AS null_category,
  SUM(merchant IS NULL) AS null_merchant,
  SUM(gender IS NULL) AS null_gender
FROM banksim_staging;

SELECT MIN(amount), MAX(amount), AVG(amount)
FROM banksim_staging;

SELECT DISTINCT gender FROM banksim_staging;

SELECT gender, COUNT(*) AS count
FROM banksim_staging
GROUP BY gender;

ALTER TABLE banksim_staging
MODIFY gender VARCHAR(15);

UPDATE banksim_staging
SET gender = CASE
    WHEN gender = 'M' THEN 'Male'
    WHEN gender = 'F' THEN 'Female'
    WHEN gender = 'U' THEN 'Unknown'
    WHEN gender = 'E' THEN 'Error'
    ELSE 'Unknown'
END;

SELECT DISTINCT category FROM banksim_staging;
UPDATE banksim_staging
SET category = REPLACE(category, 'es_', '');

SELECT LENGTH(customer), COUNT(*) 
FROM banksim_staging
GROUP BY LENGTH(customer)
ORDER BY COUNT(*) DESC;

SELECT customer 
FROM banksim_staging
WHERE LENGTH(customer) = 6;

DELETE FROM banksim_staging
WHERE customer = 'C95356';

SELECT DISTINCT zipMerchant FROM banksim_staging;
SELECT DISTINCT zipcodeOri FROM banksim_staging;

ALTER TABLE banksim_staging
DROP COLUMN zipcodeOri,
DROP COLUMN zipMerchant;

CREATE TABLE banksim_clean AS
SELECT
    transaction_time,
    transaction_dayname,
    customer,                   
	gender,     
    age_group,               
	category,
    amount,
    fraud
FROM banksim_staging
WHERE LENGTH(customer) >= 10;

SELECT *
from banksim_clean;

-- --------------- ----------
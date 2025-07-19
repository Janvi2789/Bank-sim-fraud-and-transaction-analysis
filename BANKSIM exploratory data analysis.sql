-- BANKSIM DATA ANALYSIS --

# Description: Analyzing customer transactions to understand spending behavior and detect fraud patterns.
# The goal is to find trends by gender, age group, day of week, and transaction category, and identify top spenders and high-risk customers.

-- SUMMARY KPIs --

-- Total Number of Transactions
SELECT COUNT(*) AS total_transactions
FROM banksim_clean;

-- Total Amount Transacted
SELECT ROUND(SUM(amount), 2) AS total_amount
FROM banksim_clean;

-- Unique Customers
SELECT COUNT(DISTINCT customer) AS unique_customers
FROM banksim_clean;

-- Average Transaction Amount
SELECT ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM banksim_clean;

-- Average Number of Transactions per Customer
SELECT ROUND(AVG(tn_count), 2) AS avg_transactions_per_customer
FROM (
    SELECT customer, COUNT(*) AS tn_count
    FROM banksim_clean
    GROUP BY customer
) AS tns_per_customer;

-- Average Spend per Customer
SELECT ROUND(AVG(total_spend), 2) AS avg_spend_per_customer
FROM (
    SELECT customer, SUM(amount) AS total_spend
    FROM banksim_clean
    GROUP BY customer
) AS customer_spending;

------------------------------------------------
-- Gender-wise Transaction Analysis

SELECT 
    gender, 
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_spend,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM banksim_clean
GROUP BY gender;

-------------------------------------------------
-- Age Group-wise Transaction Analysis

SELECT 
    age_group,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_spend,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM banksim_clean
GROUP BY age_group
ORDER BY age_group;

----------------------------------------------
-- Transaction Count by Day of the Week

SELECT 
    transaction_dayname,
    COUNT(*) AS transaction_count
FROM banksim_clean
GROUP BY transaction_dayname
ORDER BY FIELD(transaction_dayname, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

---------------------------------------------
-- Fraud Overview

-- Total Fraud Transactions and Fraud Rate
SELECT 
    COUNT(*) AS total_transactions,
    SUM(fraud) AS fraud_transactions,
    ROUND(SUM(fraud)/COUNT(*) * 100, 2) AS fraud_rate_percentage
FROM banksim_clean;

-- Fraud by Category
SELECT 
    category, 
    COUNT(*) AS transaction_count,
    SUM(fraud) AS fraud_transactions,
    ROUND(SUM(fraud)/COUNT(*) * 100, 2) AS fraud_rate_percentage
FROM banksim_clean
GROUP BY category
ORDER BY fraud_rate_percentage DESC;

-- Fraud by Gender
SELECT 
    gender,
    COUNT(*) AS transaction_count,
    SUM(fraud) AS fraud_transactions,
    ROUND(SUM(fraud)/COUNT(*) * 100, 2) AS fraud_rate_percentage
FROM banksim_clean
GROUP BY gender;

-- Fraud by Age Group
SELECT 
    age_group,
    COUNT(*) AS transaction_count,
    SUM(fraud) AS fraud_transactions,
    ROUND(SUM(fraud)/COUNT(*) * 100, 2) AS fraud_rate_percentage
FROM banksim_clean
GROUP BY age_group
ORDER BY age_group;

------------------------------------------
-- Top 10 High-Spending Customers

SELECT 
    customer,
    ROUND(SUM(amount), 2) AS total_spend,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM banksim_clean
GROUP BY customer
ORDER BY total_spend DESC
LIMIT 10;

------------------------------------------
-- Fraud Rate by Day of the Week

SELECT 
    transaction_dayname,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS fraud_rate_percentage
FROM banksim_clean
GROUP BY transaction_dayname
ORDER BY FIELD(transaction_dayname, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-----------------------------------------------------
-- Fraud and Spend Analysis by Category

SELECT 
    category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_spend,
    SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
ROUND(SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS fraud_rate_percentage,
	ROUND(SUM(CASE WHEN fraud = 1 THEN amount ELSE 0 END), 2) AS fraud_amount
FROM banksim_clean
GROUP BY category
ORDER BY transaction_count DESC;

-------------------------------------------------
-- Top 10 Customers with Most Fraud

SELECT 
    customer,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS fraud_rate_percentage,
    ROUND(SUM(amount), 2) AS total_spend
FROM banksim_clean
GROUP BY customer
HAVING fraud_transactions > 0
ORDER BY fraud_transactions DESC
LIMIT 10;

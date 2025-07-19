# Transaction and Fraud Analysis

## Overview:
This project analyzes patterns in synthetic banking transaction data to better understand how fraud appears across different customer groups and transaction types. Using SQL for data cleaning and exploration, and Power BI for visualization, the goal was to uncover trends—not predict fraud, but to make sense of how and where it tends to happen. The dataset is fully synthetic, sourced from Kaggle.

## Problem Objective:
 Fraud in banking is a major concern. This project focuses on:
   * Which types of transactions are more likely to be fraudulent?
   * How does fraud vary by age, gender, or transaction category?
   * Are certain days more fraud-prone?
   * Who are the top spenders and most affected customers?
   * Analyze overall transaction patterns across different user segments.
The goal is to understand both fraud behavior and transaction patterns across different segments and customer groups through structured, visual analysis.

## DATASET USED:
* Synthetic BankSim Dataset
* Source: Publicly available simulation dataset (not real customer data) from Kaggle.

## Data Cleaning (MySQL)
* Imported the synthetic BankSim dataset from Kaggle into MySQL and organized it into a clean schema.
* Created new date and time columns like transaction_time, transaction_date, and transaction_dayname from the original step column for easy visualisations.
* Added an age_group column to group users by age for clearer analysis.
* Cleaned messy values in gender and category columns.
* Removed duplicate transactions using a window function (ROW_NUMBER) based on customer ID, step, and amount.
* Dropped unnecessary columns like zipcodeOri and zipMerchant, and filtered out invalid customer entries.

## Exploratory Data Analysis (MySQL)
* Calculated key stats:
   * Total transactions, unique customers
   * Total and average amounts spent
   * Average spend per customer

* Analyzed spending by:
   * Gender: number of transactions and spending per group
   * Age group – grouped into ranges like 25–34, 35–44, etc.
   * Day of the week – to find when people transact most

* Explored fraud patterns:
   * Fraud frequency across categories
   * Which genders and age groups were more affected
   * Days with the highest fraud percentage

* For a quick overview, identified:
   * Top 10 spenders
   * Top 10 most fraud-affected customers
   * Categories with the highest fraud amount
 
## Power-Bi
* Imported the cleaned synthetic data into Power BI.
* Created DAX measures to calculate key fraud metrics like fraud percentage, total fraud amount, and affected customers.
* Built visuals to explore transaction and fraud patterns by weekday, age group, gender, and transaction category.
* Added slicers for easy filtering and comparison across segments.
* Used DAX to create dynamic titles that update based on filter selections.
* Included a reset filters button for smoother navigation.

## Insights:
* High Transaction Volume, Low Fraud Rate:
  * Over 565K transactions processed, with a low fraud rate of 1.24%.
  * Suggests a relatively secure system, though fraud still exists in key segments.

* Top-Spending Customers Are Fraudulent
  * Among the 20 highest-spending customers, 10 have at least one fraudulent transaction, suggesting high spenders may be more frequently targeted or involved in fraud.

* Fraud Rate Peaks Early in the Week:
  * Monday has the highest fraud %, gradually dropping through the week.

* Vulnerable Age Groups:
  * <25 age group has highest fraud rate (1.52%), followed by 55–64 (1.35%) and 45–54 (1.29%).
  * Younger users may be more prone to fraud risks or less cautious during digital transactions.

* Gender-Based Distribution
  * Males (54.8%) transact more than females (45%), very few undisclosed.
  * It can be seen that females are targeted more than males, with a fraud rate of 66.35%, compared to 33% for males.

* Risky Categories:
 * Transportation shows very high fraud count despite moderate spending.
 * Other categories like Food, Fashion, and Health also have notable fraud cases.
 * Indicates that fraud doesn’t always happen in categories with high spending categories, some categories just face more fraud because they’re used more often.

## Conclusion:
* Fraud isn’t happening randomly, there are patterns based on time, user type, and what people are spending on.
* Since most fraud happens on Mondays and among users under 25:
  * Banks can watch closely for fraud at the start of the week
  * Organize awareness workshops and send alerts to young users about safe banking
* The fact that many top spenders are linked to fraud could mean there’s some repeated fraud behavior going on. This calls for stronger background checks and keeping an eye on suspicious activity.
* Some categories like Transport and Food have more fraud, these should have stricter fraud checks or use smart alerts based on user behavior.
* Instead of treating every customer the same, banks can now build smarter, targeted fraud prevention strategies.

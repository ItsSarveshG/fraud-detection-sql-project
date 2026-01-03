# Fraud Detection & Transaction Risk Analysis using SQL

**Project Overview**

1.  This project focuses on analyzing financial transaction data to detect fraudulent and suspicious activities using SQL.
2.  The goal is to simulate real-world fraud detection logic used in banking, audit, and risk analytics teams.
3.  Multiple SQL techniques such as CTEs, window functions, joins, and conditional logic are used to identify abnormal transaction behavior.


**Dataset Description**

The dataset contains transaction-level data with the following key fields:

1.  nameOrig – Sender account
2.  nameDest – Receiver account
3.  step – Transaction time step
4.  amount – Transaction amount
5.  oldbalanceOrg / newbalanceOrig – Sender balance before & after
6.  oldbalanceDest / newbalanceDest – Receiver balance before & after
7.  isFraud – Confirmed fraud indicator
8.  isFlaggedFraud – System-flagged suspicious transactions
9.  type – Transaction type (TRANSFER, CASH_OUT, etc.)


**Key Objectives**

1.  Detect fraudulent transactions
2.  Identify suspicious account behavior
3.  Validate balance consistency
4.  Apply rolling window analysis
5.  Use multi-condition risk logic


**SQL Techniques Used**

1.  Common Table Expressions (CTEs)
2.  Window Functions (SUM() OVER)
3.  Recursive & non-recursive CTEs
4.  Conditional filtering (CASE, WHERE)
5.  Multi-CTE joins
6.  Data validation checks


**Key Analysis Performed**

1️⃣ Rolling Fraud Detection

1.  Calculated rolling fraud indicators over the last 5 transactions per account
2.  Used window functions to identify recent fraudulent behavior

2️⃣ High-Risk Transaction Identification

1.  Detected large transfers
2.  Identified transactions with no balance change
3.  Flagged system-marked fraudulent transactions
4.  Combined multiple red flags using joins

3️⃣ Balance Validation Checks

1.  Verified whether computed balances matched system balances
2.  Identified inconsistencies in destination account balances

4️⃣ Zero-Balance Risk Detection

1.  Identified destination accounts with zero balance before or after transactions
2.  Highlighted potential mule or pass-through accounts


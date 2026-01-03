use bank;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT *
FROM transactions;

-- 1. Detecting Recursive Fraudulent Transactions

WITH RECURSIVE fraud_chain AS 
-- 	Anchor: first fraudulent transfer
(
SELECT nameOrig AS intial_account,
	   nameDest AS next_account,
       step,
       amount,
       newbalanceOrig
FROM transactions
WHERE isFraud = 1 AND type = 'TRANSFER'

UNION ALL

-- Recursive: follow the money

SELECT fc.intial_account, t.nameDest, t.step, t.amount, t.newbalanceOrig
FROM fraud_chain AS fc
JOIN transactions AS t
	ON fc.next_account = t.nameOrig AND fc.step < t.step
    WHERE t.isfraud = 1 AND t.type = 'TRANSFER'
)

SELECT *
FROM fraud_chain;


-- 2. Analyzing Fraudulent Activity over Time
-- How many fraudulent transactions happened in the last 5 steps

WITH rolling_fraud AS (
SELECT nameOrig, step,
SUM(isFraud) OVER (PARTITION BY nameOrig ORDER BY STEP ROWS BETWEEN 4 PRECEDING and CURRENT ROW ) AS fraud_rolling
FROM transactions
)

SELECT	* 
FROM rolling_fraud
WHERE fraud_rolling > 0;

-- How much money has fradulently moved in last 5 steps
WITH fraud_txn AS
(
SELECT nameOrig AS initial_account,
	   step,
       amount
FROM transactions
WHERE isfraud = 1)
SELECT initial_account,
       step,
       amount,
SUM(amount) OVER(PARTITION BY initial_account ORDER BY step ROW BETWEEN 4 PRECEDING and CURRENT ROW) AS rolling_fraud_amount_last_5_step
FROM fraud_txn
ORDER BY initial_account, step;


-- 3. Complex Fraud Detection Using Multiple CTEs
-- Find accounts that show ANY suspicious behavior
WITH large_transfers AS (
SELECT nameOrig AS initial_account, step, amount, 'LARGE_TRANSFER' AS reason
FROM transactions
WHERE type = 'TRANSFER' AND amount > 200000 ),

no_balance_change AS (
SELECT nameOrig AS initial_account, step, amount, 'NO BALANCE CHANGE' AS reason
FROM transactions
WHERE newbalanceOrig = oldbalanceOrig
AND amount >= 0),

flagged_fraud AS (
SELECT nameOrig AS initial_account, step, amount, 'FLAGGED FRAUD' AS reason
FROM transactions
WHERE isFraud = 1)

Select *
FROM large_tranfers
UNION ALL
SELECT *
FROM no_balance_change
UNION ALL
SELECT *
FROM flagged_fraud
ORDER BY initial_account, step;

-- Find accounts where the (same transaction + same account + same step) show ANY suspicious behavior
WITH large_transfers as (
SELECT nameOrig, step, amount 
FROM transactions 
WHERE type = 'TRANSFER' and amount >500000),

no_balance_change as (
SELECT nameOrig, step, oldbalanceOrg, newbalanceOrig 
FROM transactions 
WHERE oldbalanceOrg=newbalanceOrig),

flagged_transactions as (
SELECT nameOrig, step 
FROM transactions 
WHERE  isflaggedfraud = 1) 

SELECT lt.nameOrig, amount
FROM large_transfers lt
JOIN no_balance_change nbc 
	ON lt.nameOrig = nbc.nameOrig 
    AND lt.step = nbc.step
JOIN flagged_transactions ft 
	ON lt.nameOrig = ft.nameOrig 
    AND lt.step = ft.step;
    
    
--  Write me a query that checks if the computed new_updated_Balance is the same as the actual newbalanceDest in the table. If they are equal, it returns those rows    
WITH CTE AS (
SELECT nameOrig, nameDest, amount, oldbalanceDest, newbalanceDest, (oldbalanceDest + amount) AS new_updated_balance
FROM transactions)

SELECT *
FROM CTE
WHERE new_updated_balance = newbalanceDest;


-- Detect Transactions with Zero Balance Before or After
SELECT step, type ,amount, nameOrig, oldbalanceOrg, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest
FROM transactions
WHERE oldbalanceDest = 0 OR newbalanceDest = 0;


 
    
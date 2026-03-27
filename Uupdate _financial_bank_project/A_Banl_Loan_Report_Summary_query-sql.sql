-- A .Bank loan Report
-- 1. kpi
/*  1) Number of Applications  */

USE financial_db;
-- a. Toatl no loan Application
SELECT 
    COUNT(id) AS Total_Loan_App
FROM
    financial_loan;

    

-- b) MTD Loan Applications (current month by issue_date)
-- update code 
SELECT 
    COUNT(*) AS mtd_loan_applications
FROM financial_loan
WHERE YEAR(issue_date) = 2021
  AND MONTH(issue_date) = MONTH(CURDATE());
        
-- ------------------------------------------------------------------
        
        

-- c) PMTD Loan Applications (previous month)
-- update code 

SELECT 
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(*) AS pmtd_loan_app
FROM financial_loan
WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY MONTHNAME(issue_date);


--   ---------------------------------------------------------------
/* 2) Funded Amount (Total Loan Amount approved) */
-- ----------------------------------------------------------------- 

-- a). a) Total Funded Amount
SELECT 
    SUM(loan_amount) AS total_funded_Amount
FROM
    financial_loan;
  
-- b) MTD Total Funded Amount
  -- update code 
  SELECT 
   sum(loan_Amount) as mtd_Total_funded_amount
FROM financial_loan
WHERE MONTH(issue_date) = MONTH(curdate());
  
  
  -- ---------------------------------
  
  -- c) PMTD Total Funded Amount
-- Update code 
Select 
   monthname(issue_date) as month_name,
   SUM(loan_amount) as pmtd_total_funded_amount
from
    financial_loan
where
month(issue_date) = month(date_sub(curdate(), interval 1 month ))
group by monthname(issue_date)


-- ---------------------------------------------------------------
/* 3) Amount Received(Loan Amount paid) */
-- ---------------------------------------------------------------

-- a) Total Amount Received

SELECT  SUM(total_payment) AS total_amount_received
FROm  financial_loan;


-- b) MTD Total Amount Received
 -- update code- 
SELECT 
    SUM(total_payment) AS mtd_total_amount_received
FROM financial_loan
WHERE  MONTH(issue_date) = MONTH(CURDATE());
  
  
  
--  -------------------------------------
-- c) PMTD Total Amount Received
SELECT 
    SUM(total_Payment) AS pmtd_total_amount_received
FROM
    financial_loan
WHERE
    MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
  
-- ----------------------------------------------------------
/* Interest Rate */
-- ----------------------------------------------------------
-- a) Average Interest Rate
SELECT 
    AVG(int_rate) * 100 AS avg_int_rate
FROM
    financial_loan;

-- b) MTD Average Interest Rate
SELECT 
   ROUND( AVG(int_rate) * 100,2) AS mtd_avg_interest_rate
FROM
    financial_loan
WHERE
    MONTH(issue_date) = MONTH(curdate());
    
-- c)	PMTD Average Interest.
-- update code
select
      ROUND(avg(int_rate) * 100,2)  as pmtd_avg_interest_rate
      from financial_loan
      where month(issue_date) = month(date_sub(curdate(), interval 1 month));
								
-- -----------------------------------------------------------------
/* 5) DTI (Debt to Income ratio) */ 
-- a). Avg DTI
SELECT 
    Round(AVG(dti) * 100,2) AS avg_dti
FROM
    financial_loan;

-- b) MTD Avg DTI
-- update code 
select 
  round(avg(dti) *100,2) as mtd_avg_dti
from financial_loan 
where month(issue_date) = month(curdate());

-- c) PMTD Avg DTI
-- update code 
SELECT 
    ROUND(AVG(dti) * 100,2) AS pmtd_avg_dti
FROM financial_loan
WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));


-- ---------------------------------------------------------------------------------------------
/* 2. GOOD LOAN ISSUED */
-- ---------------------------------------------------------------------------------------------
 
-- 1). Good Loan Percentage
SELECT 
    (COUNT(CASE
        WHEN
            loan_status = 'Fully Paid'
                OR loan_status = 'Current'
        THEN
            id
    END) * 100.0) / COUNT(id) AS Good_Loan_Percentage
FROM
    financial_loan;

-- 2). Good Loan Applications
SELECT 
    COUNT(id) AS Good_Loan_Application
FROM
    financial_loan
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';

-- 3). Good Loan Funded Amount
SELECT 
    SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM
    financial_loan
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';
 

-- 4). Good Loan Amount Received
SELECT 
    SUM(total_payment) AS Good_Loan_Amount_Received
FROM
    financial_loan
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';

-- ----------------------------------------------------------------------------------------------------------------
/* 3. BAD LOAN ISSUED */
-- ----------------------------------------------------------------------------------------------------------------
USE financial_db;
-- 1). Bad Loan Percentage

SELECT 
    (COUNT(CASE
        WHEN loan_status = 'Charged Off' THEN id
    END) * 100.0) / COUNT(id) AS Bad_Loan_Percentage
FROM
    financial_loan;

-- 2). Bad Loan Applications
select * from financial_loan;
SELECT 
    COUNT(id) AS Bad_Loan_Application
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';


-- 3). Bad Loan Funded Amount
SELECT 
    SUM(loan_amount) AS Bad_loan_Funded_Amount
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';

-- 4). Bad Loan Amount Received
SELECT 
    SUM(total_payment) AS Bad_Loan_Amount_Received
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';

-- ---------------------------------------------------------------------------------------------------------------------
/* 4. LOAN STATUS */
-- ---------------------------------------------------------------------------------------------------------------------
-- 1. Complete Loan Status Summary
SELECT 
    loan_status,
    COUNT(id) AS Total_Loan_Applications,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    ROUND(AVG(int_rate * 100),2) AS Interest_Rate,
    ROUND(AVG(dti * 100),2) AS DTI
FROM
    financial_loan
GROUP BY loan_status;
    
-- 2. MTD Loan Status Summary 
SELECT 
    loan_Status,
    SUM(loan_amount) AS MTD_Loan_Amount_Received,
    SUM(total_payment) AS MTD_Loan_funded_Amound
FROM
    financial_loan
WHERE
    MONTH(issue_date) = MONTH(CURDATE())
GROUP BY loan_status;
     
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------

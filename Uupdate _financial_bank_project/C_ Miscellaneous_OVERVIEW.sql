-- C. Miscellaneous | OVERVIEW
-- 1. MoM Loan Application growth rate
USE financial_db;
-- update code change according to current month
SELECT 
ROUND((
   (
     SELECT COUNT(id)
     FROM financial_loan
     WHERE MONTH(issue_date) = MONTH(CURDATE())
   )
   -
   (
     SELECT COUNT(id)
     FROM financial_loan
     WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
   )
) / NULLIF(
   (
     SELECT COUNT(id)
     FROM financial_loan
     WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
   ), 0
) * 100,2) AS `MoM Total Applications Change (%)`;
-- ----------------------------------------------------------------------------------------------


-- 2. Mom Loan Amount Disbursed growth rate
-- update code dynamic data according to the month
SELECT
ROUND((
   (SELECT SUM(loan_amount) 
    FROM financial_loan
    WHERE MONTH(issue_date) = MONTH(CURDATE()))
   -
   (SELECT SUM(loan_amount) 
    FROM financial_loan
    WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)))
) / NULLIF(
   (SELECT SUM(loan_amount) 
    FROM financial_loan
    WHERE MONTH(issue_date) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))), 0
) * 100 ,2)AS `MoM Loan Amount Disbursed Growth Rate (%)`;
-- --------------------------------------------------------------------------------------------------------


-- 3. Interest rate for various subgrade and grade loan type
--  update code 
SELECT 
    a.grade,
    ROUND(b.avg_grade_rate * 100, 2) AS Grade_interest,
    a.sub_grade,
    ROUND(AVG(a.int_rate) * 100, 2) AS Sub_Grade_interest
FROM financial_loan a
JOIN (
        SELECT grade, AVG(int_rate) AS avg_grade_rate
        FROM financial_loan
        GROUP BY grade
     ) b
ON a.grade = b.grade
GROUP BY a.grade, a.sub_grade
ORDER BY a.grade, a.sub_grade;

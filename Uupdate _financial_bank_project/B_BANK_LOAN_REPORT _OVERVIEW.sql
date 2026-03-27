--  B. BANK LOAN REPORT | OVERVIEW
use financial_db;
-- Showcase total number of applications, total loan amount and total amount received for the following parameters.
-- a. MONTH
SELECT 
     month(issue_date) as Month_Number,
     monthname(issue_date) as Month_Name,
     count(id) as Total_Loan_Application,
     sum(loan_amount) as Total_Loan_Funded_Amount,
     sum(total_payment) as Total_Loan_Amount_Received
from financial_loan
group by  month(issue_date), monthname(issue_date)
order by   Month_Number;

-- b. STATE 

select address_state as state,
   count(id) as Total_Loan_Application,
   sum(loan_amount) as Total_Loan_Funded_Amount,
    sum(total_payment) as Total_Loan_Amount_Received
from financial_loan 
group by address_state
order by address_state;

-- c. TERM
select 
  term as Term,
  count(id) as Total_Loan_Application,
   sum(loan_amount) as Total_Loan_Funded_Amount,
    sum(total_payment) as Total_Loan_Amount_Received
from financial_loan
group by term
order by term;

-- d. EMPLOYEE LENGTH
select 
  emp_length as Employee_Length,
  count(id) as Total_Loan_Application,
   sum(loan_amount) as Total_Loan_Funded_Amount,
    sum(total_payment) as Total_Loan_Amount_Received
from financial_loan
group by emp_length
order by emp_length;

-- e. PURPOSE
select 
  purpose as Purpose,
  count(id) as Total_Loan_Application,
   sum(loan_amount) as Total_Loan_Funded_Amount,
    sum(total_payment) as Total_Loan_Amount_Received
from financial_loan
group by purpose
order by purpose ;


-- f. HOME OWNERSHIP

select 
   home_ownership as Home_Ownership,
  count(id) as Total_Loan_Application,
   sum(loan_amount) as Total_Loan_Funded_Amount,
    sum(total_payment) as Total_Loan_Amount_Received
from financial_loan
group by home_ownership
order by home_ownership asc;


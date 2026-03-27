-- ----------------SQL Project - Netflix Data Analysis ----------------------------------------
-- Task
use netflix;
-- 1. Using the Viewing History table, identify the top 3 most-watched movies based on viewing hours.
select 
content.TitleName , count(viewinghistory.ContentID) as total_Views  , 
sum(viewinghistory.Runtime) as Total_Viewing_Hours 
from content 
join viewinghistory
on content.ContentID =viewinghistory.ContentID
group by content.TitleName 
order by Total_Viewing_Hours desc limit 3;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 2. Partition the viewing hours by category and genre to find the top genre in each category. 
-- Use the rank function to rank genres within each category. 
-- update code 
with ranked_genres as (
    select 
        c.category,
        c.genre,
        sum(v.runtime) as total_viewing_hours,
        rank() over (partition by c.category order by sum(v.runtime) desc) as genre_rank
    from content c
    join viewinghistory v 
        on c.contentid = v.contentid
    group by c.category, c.genre
)
select category, genre, total_viewing_hours
from ranked_genres
where genre_rank = 1
order by category;
-- --------------------------------------------------------------------------------------------------------------------- 
-- 3.Determine the number of subscriptions for each plan. Display Plan ID,
--  Plan Name and Subscriber count in descending order of Subscriber count.
select plans.PlanID ,plans.PlanName, Count(subscribes.CustID) as Number_of_subscription from 
plans join subscribes 
on plans.PlanID = subscribes.PlanID
group by plans.PlanID, plans.PlanName
order by Number_of_subscription desc;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 4. Which device type is most commonly used to access Netflix content? Provide the Device Type and count of accesses.
-- update code
select devices.DeviceType,
count(uses.DeviceID) as Total_No_Device 
from uses
join devices 
on uses.DeviceID = devices.DeviceID
group by devices.DeviceType
order by Total_No_Device desc limit 1 ;


-- --------------------------------------------------------------------------------------------------------------------- 
-- 5. Compare the viewing trends of movies versus TV shows. What is the average viewing time for movies and TV shows separately?
select  content.Category ,
  COUNT(viewinghistory.ContentID) AS Total_Views,
 avg(viewinghistory.Runtime) as Avg_Total_Viewing_Hours from
content 
join viewinghistory 
on content.ContentID = viewinghistory.ContentID 
group by content.Category 
order  by Avg_Total_Viewing_Hours desc ;

-- --------------------------------------------------------------------------------------------------------------------- 

-- 6.Identify the most preferred language by customers. Provide the number of customers, and language.
-- update code
select customerslanguagepreferred.Language , count(customers.CUSTID ) as Total_Number_OF_Customers from
customerslanguagepreferred join 
customers on customerslanguagepreferred.CustID = customers.CUSTID
group by customerslanguagepreferred.Language 
order by  Total_Number_OF_Customers desc  limit 1;

-- ----------------------------------------------------------------------------------------------------------------------
-- 7. How many customers have adult accounts versus child accounts? Provide the count for each type.
 select  'Adult' as Type_Of_Customer,COUNT(adultacc.ProfileID) AS Total_Accounts from adultacc 
 union all
 select  'Child'  as Type_Of_Customer , count(childacc.ProfileID) as Total_Accounts from childacc ;


-- --------------------------------------------------------------------------------------------------------------------- 
-- 8. Determine the average number of profiles created per customer account.

SELECT
  AVG(profile_count) AS avg_profiles_per_customer
FROM (
  SELECT
    COUNT(*) AS profile_count
  FROM profiles
  GROUP BY CustID
) AS t;


-- --------------------------------------------------------------------------------------------------------------------- 
-- 9. Identify the content that has the lowest average viewing time per user. Provide the titles and their average viewing time.
-- update code
select content.TitleName,
   round(avg(viewinghistory.Runtime),0) as Avg_Viewing_Time
from content
join viewinghistory
on content.ContentID = viewinghistory.ContentID
group by content.TitleName
order by Avg_Viewing_Time asc limit 1 ;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 10. Determine the count for each content type.
select Category as Each_Content_Type , count(ContentID) from content
group by Category;

-- ---------------------------------------------------------------------------------------------------------------------   
-- 11. Compare the number of customers that have unlimited access and who do not.
 use netflix;
SELECT 
    CASE
        WHEN plans.ContentAccess = 'unlimited' THEN 'Unlimited Access'
        ELSE 'Limited/Standard Access'
    END AS AccessType,
    subscribes.Status,
    COUNT(DISTINCT subscribes.CustID) AS Number_of_Customers
FROM
    Plans 
        JOIN
    Subscribes  ON plans.PlanID = subscribes.PlanID
GROUP BY AccessType, subscribes.Status;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 12. Find Average monthly price for plans with Content Access as "unlimited".
SELECT  
round(avg(plans.MonthlyPrice),2) as Avg_Monthly_Price_Unlimited_Access
from plans
where ContentAccess = 'Unlimited';  

-- --------------------------------------------------------------------------------------------------------------------- 
-- 13. List all the customers who have taken the plan for till 2028 and later. Display
-- CustomerID, Customer name and Expiration Date of the plan, ordered by Expiration
-- Date in descending order first, and then by Customer Name. 

SELECT 
    C.CUSTID AS CustomerID, concat( C.FNAME,' ',C.LNAME) as  customer_name, S.EndDate
FROM
    Customers C
        JOIN
    Subscribes S ON C.CUSTID = S.CustID
WHERE
    YEAR(S.EndDate) >= 2025
ORDER BY S.EndDate DESC , customer_name ASC;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 14. Display Average Revenue generated from each city (using COUNTRY as city proxy). Rank city based on average revenue.

SELECT 
    paymentmethod.City,
    AVG(paymenthistory.PaymentAmount) AS Average_Revenue,
    DENSE_RANK() OVER (ORDER BY AVG(paymenthistory.PaymentAmount) DESC) AS Revenue_Rank
FROM  paymentmethod
JOIN paymenthistory
    ON  paymentmethod.CardID = paymenthistory.CardID
GROUP BY  paymentmethod.City
ORDER BY Revenue_Rank;

-- --------------------------------------------------------------------------------------------------------------------- 
-- 15. Display most frequently viewed genre among adults for each category

WITH Ranked AS (SELECT 
    content.Category AS Category,
    content.Genre AS Genre,
    SUM(viewinghistory.Runtime) AS most_Freq_view_genreby_Adult_,
    rank() over(partition by content.Category order by sum(viewinghistory.Runtime)  desc ) as Most_Rank
FROM
    adultacc
        JOIN
    viewinghistory ON adultacc.ProfileID = viewinghistory.ProfileID
        JOIN
    content ON content.ContentID = viewinghistory.ContentID
GROUP BY Category , Genre
 )
select Category,
    Genre,
    most_Freq_view_genreby_Adult_,
    Most_Rank from Ranked 
where Most_Rank = 1
order by Category ; 

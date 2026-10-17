-- Derived variables (report section A). Age, Age Bucket and Income Bucket were
-- built in SQL; the others were Excel formulas in the original work and are
-- written here as SQL CASE expressions with the same logic.
-- Run on the joined table "customers" created by 01_checks.sql.

-- 1. Age, as of the analysis date (the original used CURRENT_DATE)
ALTER TABLE customers ADD COLUMN "Age" INTEGER;
UPDATE customers SET "Age" = EXTRACT(YEAR FROM {AS_OF}) - "Year_Birth";

-- Age Bucket (original thresholds and labels)
ALTER TABLE customers ADD COLUMN "Age Bucket" VARCHAR;
UPDATE customers SET "Age Bucket" = CASE
    WHEN "Age" BETWEEN 27 AND 45 THEN '27-45'
    WHEN "Age" BETWEEN 46 AND 65 THEN '45-65'
    ELSE '66 +'
END;

-- 2. Income Bucket on the 37th and 66th percentiles (the version in the report)
ALTER TABLE customers ADD COLUMN "Income Bucket" VARCHAR;
WITH Income_Perc AS (
    SELECT PERCENTILE_CONT(0.37) WITHIN GROUP (ORDER BY "Income") AS Perc_37,
           PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY "Income") AS Perc_66
    FROM customers
)
UPDATE customers SET "Income Bucket" = CASE
    WHEN "Income" <= (SELECT Perc_37 FROM Income_Perc) THEN 'Low Income'
    WHEN "Income" <= (SELECT Perc_66 FROM Income_Perc) THEN 'Middle Income'
    ELSE 'High Income'
END;

-- 3. Child_Type and No_Kids
--    Excel: =IF(AND(E2>0, F2>0), "Kid & Teen", IF(E2>0, "Kid", IF(F2>0, "Teen", "No Child")))
ALTER TABLE customers ADD COLUMN "Child_Type" VARCHAR;
UPDATE customers SET "Child_Type" = CASE
    WHEN "Kidhome" > 0 AND "Teenhome" > 0 THEN 'Kid & Teen'
    WHEN "Kidhome" > 0 THEN 'Kid'
    WHEN "Teenhome" > 0 THEN 'Teen'
    ELSE 'No child'
END;
ALTER TABLE customers ADD COLUMN "No_Kids" INTEGER;
UPDATE customers SET "No_Kids" = "Kidhome" + "Teenhome";

-- 4. Recent Response
--    Excel: =IF(T2=0, "No Response", IF(U2=1, "Negative Response", "Positive Response"))
ALTER TABLE customers ADD COLUMN "Recent Response" VARCHAR;
UPDATE customers SET "Recent Response" = CASE
    WHEN "Response" = 0 THEN 'No Response'
    WHEN "Complain" = 1 THEN 'Negative Response'
    ELSE 'Positive Response'
END;

-- 5. Marketing Conversion Bucket (propensity), on Count_success
--    Excel: 0 / 1-2 / 3+ lead conversions; renamed in Tableau
ALTER TABLE customers ADD COLUMN "Propensity" VARCHAR;
UPDATE customers SET "Propensity" = CASE
    WHEN "Count_success" = 0 THEN 'Hard-to-convert'
    WHEN "Count_success" <= 2 THEN 'On-the-fence'
    ELSE 'Ready-to-buy'
END;

-- 7. Country names (ME is Montenegro in the metadata and on the dashboard)
ALTER TABLE customers ADD COLUMN "Country Name" VARCHAR;
UPDATE customers SET "Country Name" = CASE "Country"
    WHEN 'AUS' THEN 'Australia' WHEN 'CA' THEN 'Canada' WHEN 'GER' THEN 'Germany'
    WHEN 'IND' THEN 'India' WHEN 'ME' THEN 'Montenegro' WHEN 'SA' THEN 'South Africa'
    WHEN 'SP' THEN 'Spain' WHEN 'US' THEN 'United States'
END;

-- 8. Recency Bucket
--    Excel: =IF(H2<=14, "Engaged Customers", IF(AND(H2>=15, H2<=45), "At-Risk Customers", IF(H2>45, "Lapsing Customers", "")))
ALTER TABLE customers ADD COLUMN "Recency Bucket" VARCHAR;
UPDATE customers SET "Recency Bucket" = CASE
    WHEN "Recency" <= 14 THEN 'Engaged'
    WHEN "Recency" <= 45 THEN 'At-risk'
    ELSE 'Lapsing'
END;

-- Spend and purchases per customer, used throughout
ALTER TABLE customers ADD COLUMN "Total Spend" INTEGER;
UPDATE customers SET "Total Spend" = "AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm";
ALTER TABLE customers ADD COLUMN "Purchases" INTEGER;
UPDATE customers SET "Purchases" = "NumWebBuy" + "NumWalkinPur" + "NumDeals";

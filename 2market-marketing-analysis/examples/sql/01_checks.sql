-- Data checks and integration (report sections B-C).
-- Adapted from code/original/cleaning_up.sql: the trimming step there inserted
-- only the four trimmed columns into the *_clean tables, leaving the rest
-- empty; here every column is carried over.

-- Rows and distinct IDs in each table
SELECT 'marketing_data' AS "table", count(*) AS "rows", count(DISTINCT "ID") AS "distinct IDs" FROM marketing_data
UNION ALL
SELECT 'ad_data', count(*), count(DISTINCT "ID") FROM ad_data;

-- Removing leading and trailing spaces
CREATE TABLE marketing_data_clean AS
SELECT * REPLACE (TRIM("Education") AS "Education",
                  TRIM("Marital_Status") AS "Marital_Status",
                  TRIM("Country") AS "Country")
FROM marketing_data;

CREATE TABLE ad_data_clean AS SELECT * FROM ad_data;

-- Did trimming change anything?
SELECT count(*) AS "values changed by TRIM"
FROM marketing_data m JOIN marketing_data_clean c USING ("ID")
WHERE m."Education" <> c."Education" OR m."Marital_Status" <> c."Marital_Status" OR m."Country" <> c."Country";

-- Check for duplicates in the primary key
SELECT "ID", count(*) FROM marketing_data_clean GROUP BY "ID" HAVING count(*) > 1;

-- Duplicates the ID check cannot see: rows identical in every column except ID
SELECT CAST(sum(n - 1) AS INTEGER) AS "rows repeating another customer except for ID"
FROM (SELECT * EXCLUDE ("ID"), count(*) AS n FROM marketing_data_clean GROUP BY ALL);

-- Check for correctness in date values
SELECT min("Dt_Customer") AS "first registration", max("Dt_Customer") AS "last registration",
       count(DISTINCT extract('year' FROM "Dt_Customer")) AS "years",
       count(DISTINCT extract('month' FROM "Dt_Customer")) AS "months",
       count(DISTINCT extract('day' FROM "Dt_Customer")) AS "days"
FROM marketing_data_clean;

-- Checking distinct values
SELECT "Education", count(*) AS "customers" FROM marketing_data_clean GROUP BY 1 ORDER BY 2 DESC;
SELECT "Marital_Status", count(*) AS "customers" FROM marketing_data_clean GROUP BY 1 ORDER BY 2 DESC;
SELECT "Country", count(*) AS "customers" FROM marketing_data_clean GROUP BY 1 ORDER BY 2 DESC;

-- Joining marketing and advertisement data
CREATE TABLE customers AS
SELECT * FROM marketing_data_clean INNER JOIN ad_data_clean USING ("ID");

SELECT count(*) AS "joined rows", count(*) FILTER (WHERE "Count_success" = "Total No of Succesful Conversions") AS "rows where Count_success equals the ad total"
FROM customers;

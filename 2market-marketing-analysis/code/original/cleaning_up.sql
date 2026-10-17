/* Creating Age variable */

ALTER TABLE marketing_data
ADD "Age" INTEGER;

UPDATE marketing_data
SET "Age" = EXTRACT(YEAR FROM CURRENT_DATE) - "Year_Birth";

Select * from marketing_data;

/* Creating Age Bucket variable */

-- Observing the Age Distribution--
SELECT "Age", count("Age")
FROM marketing_data
GROUP BY "Age"
ORDER BY "Age" ASC

--Creating Buckets--

ALTER TABLE marketing_data
ADD COLUMN "Age Bucket" VARCHAR(15);

UPDATE marketing_data
SET "Age Bucket" = CASE
	WHEN "Age" BETWEEN 27 AND 45 THEN '27-45'
	WHEN "Age" BETWEEN 46 AND 65 THEN '45-65'
	ELSE '66 +'
END;

/* Creating Income Bucket variable */

-- Observing the Income Distribution--
SELECT Max("Income") as "Max Income", min("Income") as "Min Income"
FROM marketing_data

--Creating Buckets--

ALTER TABLE marketing_data
ADD COLUMN "Income Bucket" VARCHAR(15);

UPDATE marketing_data
SET "Income Bucket" = CASE
	WHEN "Income" BETWEEN 1730 AND 15000 THEN 'Low Income'
	WHEN "Income" BETWEEN 15001 AND 40000 THEN 'Middle Income'
	ELSE 'High Income'
END;
	

Select * from marketing_data;

	
	
CREATE TABLE marketing_data_clean (LIKE marketing_data);

CREATE TABLE ad_data_clean (LIKE ad_data);

/* Removing Trailing & Leading Spaces */

INSERT INTO PUBLIC.marketing_data_clean (
	"ID"
	,"Education"
	,"Marital_Status"
	,"Country"
	)
SELECT TRIM("ID") AS "ID"
	,TRIM("Education") AS "Education"
	,TRIM("Marital_Status") AS "Marital_Status"
	,TRIM("Country") AS "Country"
FROM marketing_data;

SELECT *
FROM PUBLIC.marketing_data_clean;

INSERT INTO PUBLIC.ad_data_clean ("ID")
SELECT TRIM("ID") AS "ID"
FROM ad_data;

SELECT *
FROM PUBLIC.ad_data_clean;

/* Check for duplicates in PK */

SELECT "ID"
	,count(*)
FROM ad_data_clean
GROUP BY "ID"
HAVING count(*) > 1;

SELECT "ID"
	,count(*)
FROM marketing_data_clean
GROUP BY "ID"
HAVING count(*) > 1;

/* Check for correctness in date values */

SELECT DISTINCT "year"
FROM (
	SELECT "Dt_Customer"
		,extract('year' FROM "Dt_Customer") AS year
	FROM marketing_data
	);

SELECT DISTINCT "month"
FROM (
	SELECT "Dt_Customer"
		,extract('month' FROM "Dt_Customer") AS month
	FROM marketing_data
	);

SELECT DISTINCT "day"
FROM (
	SELECT "Dt_Customer"
		,extract('day' FROM "Dt_Customer") AS day
	FROM marketing_data
	);

/* Checking Distinct Values */

SELECT DISTINCT column1 AS value
	,'column1' AS column_name
FROM your_table

SELECT DISTINCT column2 AS value
	,'column2' AS column_name
FROM your_table

SELECT DISTINCT column3 AS value
	,'column3' AS column_name
FROM your_table;

/* Total Expenditure per Country */

SELECT "Country"
	,sum("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS "Total Amt per Country"
FROM marketing_data
GROUP BY "Country"

/* Total Expenditure per Product */

SELECT sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data;
	
	
/* Total Expenditure per Product by Country */
	
SELECT "Country"
	,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data
GROUP BY "Country";

/* Total Expenditure per Product by Marital Status */
	
SELECT "Marital_Status"
	,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data
GROUP BY "Marital_Status";

/* Total Expenditure per Product by Child Type */
	
SELECT "Child Type"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM (
		SELECT "AmtLiq"
			,"AmtVege"
			,"AmtNonVeg"
			,"AmtPes"
			,"AmtChocolates"
			,"AmtComm"
			,CASE 
				WHEN "Kidhome" > 0
					THEN 'Kids'
				WHEN "Teenhome" > 0
					THEN 'Teens'
				ELSE 'Adults'
				END AS "Child Type"
		FROM marketing_data
		)
GROUP BY "Child Type";

/* Total Expenditure per Product by Education */
	
SELECT "Education"
	,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data
GROUP BY "Education";

/* Total Expenditure per Product by Age Bucket */
	
SELECT "Age Bucket"
	,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data
GROUP BY "Age Bucket";

/* Total Expenditure per Product by Income Bucket */
	
SELECT "Income Bucket"
	,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
	,sum("AmtVege") AS "Total Expenditure on Vegetables"
	,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
	,sum("AmtPes") AS "Total Expenditure on Fish Products"
	,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
	,sum("AmtComm") AS "Total Expenditure on Commodities"
FROM marketing_data
GROUP BY "Income Bucket";

/* Most Popular Product by Country */

SELECT "Country","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
FROM(SELECT "Country", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Country"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM marketing_data
	GROUP BY "Country"
	));

/* Most Popular Product by Marital Status */

SELECT "Marital_Status","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
FROM(SELECT "Marital_Status", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Marital_Status"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM marketing_data
	GROUP BY "Marital_Status"
	));

/* Most Popular Product by Child/Teen Home */

SELECT "Child Type","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
FROM(SELECT "Child Type", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Child Type"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM (
		SELECT "AmtLiq"
			,"AmtVege"
			,"AmtNonVeg"
			,"AmtPes"
			,"AmtChocolates"
			,"AmtComm"
			,CASE 
				WHEN "Kidhome" > 0
					THEN 'Kids'
				WHEN "Teenhome" > 0
					THEN 'Teens'
				ELSE 'Adults'
				END AS "Child Type"
		FROM marketing_data
		)
	GROUP BY "Child Type"
	));

/* Most Popular Product by Education */

SELECT "Education","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
FROM(SELECT "Education", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Education"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM marketing_data
	GROUP BY "Education"
	));

/* Most Popular Product by Age Bucket */

SELECT "Age Bucket","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
	FROM(SELECT "Age Bucket", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Age Bucket"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM marketing_data
	GROUP BY "Age Bucket"
	))

/* Most Popular & 2nd Most Product by Income Bucket */



SELECT "Income Bucket","Most Popular Product", 

	CASE 
        WHEN "Most Popular Product" = 'Alcoholic Beverages' THEN
            CASE 
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Vegetables' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Meat Items' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Fish Products' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Chocolates'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Chocolates", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Chocolates' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Fish Products'
                WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Commodities") THEN 'Commodities'
            END
        WHEN "Most Popular Product" = 'Commodities' THEN
            CASE 
                WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Alcoholic Beverages'
                WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Vegetables'
                WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Meat Items'
                WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Fish Products'
                WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates") THEN 'Chocolates'
            END
    END AS "2nd Most Popular Product"
FROM(SELECT "Income Bucket", "Total Expenditure on Alcoholic Beverages","Total Expenditure on Vegetables","Total Expenditure on Meat items","Total Expenditure on Fish Products","Total Expenditure on Chocolates","Total Expenditure on Commodities"
	,CASE 
		WHEN "Total Expenditure on Alcoholic Beverages" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Alcoholic Beverages'
		WHEN "Total Expenditure on Vegetables" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Vegetables'
		WHEN "Total Expenditure on Meat items" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Meat Items'
		WHEN "Total Expenditure on Fish Products" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Fish Products'
		WHEN "Total Expenditure on Chocolates" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Chocolates'
		WHEN "Total Expenditure on Commodities" = GREATEST("Total Expenditure on Alcoholic Beverages", "Total Expenditure on Vegetables", "Total Expenditure on Meat items", "Total Expenditure on Fish Products", "Total Expenditure on Chocolates", "Total Expenditure on Commodities")
			THEN 'Commodities'
		END AS "Most Popular Product"
FROM (
	SELECT "Income Bucket"
		,sum("AmtLiq") AS "Total Expenditure on Alcoholic Beverages"
		,sum("AmtVege") AS "Total Expenditure on Vegetables"
		,sum("AmtNonVeg") AS "Total Expenditure on Meat items"
		,sum("AmtPes") AS "Total Expenditure on Fish Products"
		,sum("AmtChocolates") AS "Total Expenditure on Chocolates"
		,sum("AmtComm") AS "Total Expenditure on Commodities"
	FROM marketing_data
	GROUP BY "Income Bucket"
	));
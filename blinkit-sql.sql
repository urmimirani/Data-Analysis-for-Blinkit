-- Display all rows from the Data table
SELECT * 
FROM blinkitDB.dbo.BlinkITData;

-- Get total number of records in the dataset
SELECT COUNT(*) 
FROM blinkitDB.dbo.BlinkITData;

-- Data Cleaning: Check for inconsistencies in Item_Fat_Content
SELECT DISTINCT Item_Fat_Content, COUNT(*) AS count
FROM blinkitDB.dbo.BlinkITData
GROUP BY Item_Fat_Content
ORDER BY count DESC;

-- Data Cleaning Step: Standardize Item_Fat_Content values
UPDATE blinkitDB.dbo.BlinkITData
SET Item_Fat_Content = 
CASE 
    WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN Item_Fat_Content = 'reg' THEN 'Regular'
    ELSE Item_Fat_Content
END;

-- Total sales across all products (in millions)
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS total_sales_in_Million 
FROM blinkitDB.dbo.BlinkITData;

-- Average sales per product
SELECT CAST(AVG(Sales) AS DECIMAL(10,0)) AS avg_Sales 
FROM blinkitDB.dbo.BlinkITData;

-- Count of items from outlets established in the year 2022
SELECT COUNT(*) AS no_of_items 
FROM blinkitDB.dbo.BlinkITData
WHERE Outlet_Establishment_Year = 2022;

-- Average rating across all products
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating 
FROM blinkitDB.dbo.BlinkITData;

-- Sales distribution by fat content
SELECT Item_Fat_Content, 
       CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_of_items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkitDB.dbo.BlinkITData
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- Sales analysis by item type
SELECT Item_Type, 
       CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS total_sales_thousand,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkitDB.dbo.BlinkITData
GROUP BY Item_Type
ORDER BY total_sales_thousand DESC;

-- Sales distribution by outlet location and fat content (pivoted format)
SELECT Outlet_Location_Type,
       ISNULL([Low Fat], 0) AS Low_Fat,
       ISNULL([Regular], 0) AS Regular
FROM (
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales
    FROM blinkitDB.dbo.BlinkITData
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS sourceTable
PIVOT (
    SUM(total_sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- Sales performance by outlet establishment year
SELECT Outlet_Establishment_Year, 
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkitDB.dbo.BlinkITData
GROUP BY Outlet_Establishment_Year
ORDER BY total_sales DESC;

-- Percentage share of sales by outlet size
SELECT Outlet_Size, 
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM blinkitDB.dbo.BlinkITData
GROUP BY Outlet_Size
ORDER BY total_sales DESC;

-- Sales performance by outlet location type
SELECT Outlet_Location_Type, 
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkitDB.dbo.BlinkITData
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

-- Sales performance by outlet type
SELECT Outlet_Type, 
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkitDB.dbo.BlinkITData
GROUP BY Outlet_Type
ORDER BY total_sales DESC;
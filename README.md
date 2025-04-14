# 📈 Global Layoffs Analysis (2020-2023) - SQL Project

## 📖 Overview
This SQL project analyzes global layoffs data from March 2020 to March 2023, covering:
- 1,800+ layoff events
- 30 industries
- 50+ countries

## 🛠️ Technical Details
Database: MySQL

Key Techniques:

Window functions (ROW_NUMBER, RANK)

Common Table Expressions (CTEs)

Advanced joins and subqueries

Date/time manipulation

## 🗂️ Project Structure
layoffs-analysis: 
<pre>
- dataset/                                 # Original dataset file
- 1_data_cleaning.sql                      # Data standardization & preparation
- 2_layoff_trends_analysis.sql             # EDA and basic trends
- 3_advanced_queries.sql                   # Complex analytical queries
</pre>
## 🔍 Key Analyses Performed

### 🧹 Data Cleaning
- Removed  duplicate entries
- Standardized  inconsistent company names
- Fixed missing industry classifications
- Converted text dates to DATE format

### 🏭 Industry Impact

Top 5 Most Affected:

Consumer (12%)

Retail (11%)

Transportation (9%)

Finance (7%)

Healthcare (7%)


### 📅 Time Trends
```sql
-- Yearly layoffs (Peak in 2022)
SELECT YEAR(date) AS year, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY year;
``` 


### 🌎 Geographic Trends
```sql
-- Countries with most layoffs
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country 
ORDER BY 2 DESC 
LIMIT 5;


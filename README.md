# 📈 Global Layoffs Analysis (2020-2023) - SQL Project

## 📖 Overview
This SQL project analyzes global layoffs data from March 2020 to March 2023, covering:
- 1,800+ layoff events
- 30+ industries
- 50+ countries
- $0-100M funding ranges

## 🛠️ Technical Details
Database: MySQL

Key Techniques:

Window functions (ROW_NUMBER, RANK)

Common Table Expressions (CTEs)

Advanced joins and subqueries

Date/time manipulation

## 🗂️ Project Structure
layoffs-analysis: 
├── dataset/ # Original dataset files
├── 1_data_cleaning.sql # Data standardization & preparation
├── 2_layoff_trends_analysis.sql # EDA and basic trends
└── 3_advanced_queries.sql # Complex analytical queries

## 🔍 Key Analyses Performed

### 🧹 Data Cleaning
- Removed 142 duplicate entries
- Standardized 30+ inconsistent company names
- Fixed 67 missing industry classifications
- Converted text dates to DATE format

### 🏭 Industry Impact

Top 5 Most Affected:

Consumer (32%)

Retail (19%)

Transportation (12%)

Finance (9%)

Healthcare (7%)


### 📅 Time Trends
```sql
-- Yearly layoffs (Peak in 2022)
SELECT YEAR(date) AS year, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY year; 

### 🌎 Geographic Trends
```sql
-- Countries with most layoffs
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country 
ORDER BY 2 DESC 
LIMIT 5;


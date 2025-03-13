-- 0. Descover the data
-- 1. layoff Trends Over Time
-- 2. Industry Impact
-- 3. Country Impact
-- 4. Stage Impact
-- 5. Layoffs Severity 

USE world_layoffs;

-- 0. Descover the data :
SELECT * 
FROM layoffs_staging2;

SELECT MIN(date), MAX(date) 
FROM layoffs_staging2;

SELECT COUNT(*)
FROM layoffs_staging2;


-- Summary of missing values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN company IS NULL OR company = '' THEN 1 ELSE 0 END) AS missing_company,
    SUM(CASE WHEN location IS NULL OR location='' THEN 1 ELSE 0 END)missing_location,
    SUM(CASE WHEN industry IS NULL OR industry = '' THEN 1 ELSE 0 END) AS missing_industry,
    SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_total_laid_off,
    SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_percentage_laid_off,
    SUM(CASE WHEN `date` IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN stage IS NULL OR stage ='' THEN 1 ELSE 0 END) AS missing_stage,
    SUM(CASE WHEN country IS NULL OR country='' THEN 1 ELSE 0 END)AS missing_country,
    SUM(CASE WHEN funds_raised_millions IS NULL THEN 1 ELSE 0 END)AS missing_funds_raised_millions
FROM layoffs_staging2;

-- 1. layoff Trends Over Time
SELECT year(`date`) AS `year` , SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY `year`
ORDER BY total_layoff DESC;

SELECT year(`date`) AS `year`, MONTH(`date`)AS `month`,  SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY year(`date`), MONTH(`date`)
ORDER BY total_layoff DESC;

-- 2. Industry Impact
SELECT industry, SUM(total_laid_off)AS total_layoff
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoff DESC;

SELECT industry, SUM(total_laid_off)AS total_layoff,ROUND(SUM(total_laid_off)*100/(SELECT SUM(total_laid_off)FROM layoffs_staging2)) AS percentage_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY percentage_layoffs DESC;

-- 3. Country Impact

SELECT country, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoff DESC;

SELECT country, location, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY country, location 
ORDER BY total_layoff DESC;

-- 4. Stage Impact

SELECT stage, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoff DESC;

-- 5. Layoffs Severity 

SELECT company, SUM(total_laid_off)AS total_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoff DESC;

SELECT company, funds_raised_millions, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE funds_raised_millions IS NOT NULL
GROUP BY company, funds_raised_millions
ORDER BY total_laid_off DESC, funds_raised_millions DESC
LIMIT 10;

SELECT company, industry, percentage_laid_off
FROM layoffs_staging2
ORDER BY percentage_laid_off DESC;


 

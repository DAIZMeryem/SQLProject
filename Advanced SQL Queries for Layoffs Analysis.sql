-- 1. Rolling sum of layoffs
-- 2. Year-Over-Year percentage change in layoffs
-- 3. Quarter-Over-Quarter layoff trend 
-- 4. Which industry laid off the highest percentage of its workforce?
-- 5. Which companies had multiple layoff rounds?
-- 6. Find the worst month for layoffs
-- 7. Country vs. Industry layoff Heatmap
-- 8. Predicting layoffs ( Are funding & stage indicators of layoffs)
-- 9. What percentage of startups laid off employees

-- 1. Rolling sum of layoffs
SELECT company,`date`,
       SUM(total_laid_off) OVER (PARTITION BY `date` ORDER BY total_laid_off) AS cumulative_trend_over_time
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
ORDER BY `date`;

-- 2. Year-Over-Year percentage change in layoffs
WITH previous_year AS (
 SELECT YEAR(`date`) AS layoff_year, SUM(total_laid_off) AS total_layoff
 FROM layoffs_staging2
 GROUP BY layoff_year
)
SELECT layoff_year,
	    total_layoff,
        LAG(total_layoff) OVER(ORDER BY layoff_year) AS previous_year_layoff,
        ROUND((total_layoff-LAG(total_layoff) OVER (ORDER BY layoff_year))/ LAG(total_layoff) OVER (ORDER BY layoff_year)*100,2) AS yoy_percentage_change
FROM previous_year;


-- 3. Quarter-Over-Quarter layoff trend 
WITH quarter_layoffs AS(
SELECT CONCAT(YEAR(`date`),'-Q', quarter(`date`))AS quarter_layoff, SUM(total_laid_off)AS total_layoff
FROM layoffs_staging2
GROUP BY quarter_layoff
)
SELECT quarter_layoff, 
	   total_layoff,
	   LAG(total_layoff)OVER (ORDER BY quarter_layoff)AS previous_quarter_layoffs,
       ROUND(((total_layoff-LAG(total_layoff) OVER (ORDER BY quarter_layoff)) /LAG(total_layoff)OVER (ORDER BY quarter_layoff))*100,2) AS QoQ_growth_percentage
FROM quarter_layoffs;

-- 4. Which industry laid off the highest percentage of its workforce?
SELECT industry,
       COUNT(DISTINCT(company)),
	   ROUND(AVG(percentage_laid_off),2) AS average_percentage_layoffs,
       RANK() OVER   (ORDER BY ROUND(AVG(percentage_laid_off),2) DESC ) AS industry_range
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY average_percentage_layoffs DESC;

-- 5. Which companies had multiple layoff rounds?
SELECT company,
	   SUM(total_laid_off),
       COUNT(*) AS num_event
FROM layoffs_staging2
GROUP BY company
HAVING num_event>1
ORDER BY num_event DESC, SUM(total_laid_off) DESC;

-- 6. Find the worst month for layoffs

SELECT MONTH(`date`)AS layoff_month,
        SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY MONTH(`date`)
ORDER BY total_layoff DESC;

-- 7. Country vs. Industry layoff Heatmap
WITH industry_layoffs AS (
    SELECT 
        country, 
        industry, 
        SUM(total_laid_off) AS total_layoff,
        RANK() OVER (PARTITION BY country ORDER BY SUM(total_laid_off) DESC) AS rnk
    FROM layoffs_staging2
    GROUP BY country, industry
)
SELECT country, industry, total_layoff
FROM industry_layoffs
WHERE rnk = 1
ORDER BY total_layoff DESC;

-- 8. Predicting layoffs ( Are funding & stage indicators of layoffs)
SELECT company,funds_raised_millions,total_laid_off AS total_layoff, ROUND((total_laid_off / funds_raised_millions) , 2) AS layoffs_per_million_dollars
FROM layoffs_staging2
WHERE funds_raised_millions IS NOT NULL AND total_laid_off IS NOT NULL 
ORDER BY layoffs_per_million_dollars DESC;

-- 9. What percentage of company laid off employees per stage 
WITH company_counts AS (
    SELECT 
        stage, 
        COUNT(DISTINCT company) AS total_companies
    FROM layoffs_staging2
    GROUP BY stage
), layoffs_counts AS (
    SELECT 
        stage, 
        COUNT(DISTINCT company) AS companies_with_layoffs
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    GROUP BY stage
)
SELECT 
    cc.stage, 
    cc.total_companies, 
    lc.companies_with_layoffs,
    ROUND((lc.companies_with_layoffs / cc.total_companies) * 100, 2) AS percentage_of_companies_laid_off
FROM company_counts cc
LEFT JOIN layoffs_counts lc 
ON cc.stage = lc.stage
ORDER BY percentage_of_companies_laid_off DESC;


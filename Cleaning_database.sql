-- DATA Cleaning : 
-- 0. Duplicate the Table to preserve the data
-- 1. Delete the duplications
-- 2. Standardize the DATA
-- 3. Null values or Blank values
-- 4. Remove Any columns 

USE world_layoffs;

-- 0. Duplicate the Table to preserve the data

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Delete the duplications

WITH duplicate_cte AS(
SELECT *,
  ROW_NUMBER() OVER(PARTITION BY company, industry,total_laid_off,percentage_laid_off,`date`,stage, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num>1;

-- Create a new table like layoffs_staging with an additional columns row_num to delete the duplications

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT layoffs_staging2
SELECT *,
  ROW_NUMBER() OVER(PARTITION BY company, industry,total_laid_off,percentage_laid_off,`date`,stage, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- delete the duplications
DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT * 
FROM layoffs_staging2
WHERE row_num>1;

-- 2. Standardize the DATA
SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company= TRIM(company);

SELECT DISTINCT(location)
FROM layoffs_staging2;

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(percentage_laid_off)
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off DECIMAL(10,4);

SELECT `date`
FROM layoffs_staging2;

SELECT `date`, STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT DISTINCT(stage)
FROM layoffs_staging2;

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT (funds_raised_millions)
FROM layoffs_staging2;


-- 3. Null values or Blank values

SELECT company
FROM layoffs_staging2
WHERE industry IS NULL OR industry='';

SELECT *
FROM layoffs_staging2
WHERE company='Airbnb';

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry='';

SELECT t1.company,t1. industry,t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON t1.company= t2.company
WHERE t1. industry IS NULL AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON t1.company= t2.company
SET t1.industry=t2.industry 
WHERE t1. industry IS NULL AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off='') 
AND (percentage_laid_off IS NULL OR percentage_laid_off ='');

DELETE 
FROM layoffs_staging2
WHERE (total_laid_off IS NULL ) 
AND (percentage_laid_off IS NULL );


SELECT *
FROM layoffs_staging2;

-- 4. Remove Any columns 
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

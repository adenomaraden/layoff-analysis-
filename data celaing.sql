
SELECT * 
FROM layoffs;



-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
CREATE TABLE `standralising`
LIKE layoffs;

INSERT `standralising`
SELECT * FROM layoffs;

-----  knowing duplicates
SELECT *
FROM `standralising`
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		`standralising`;



SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`, percentage_laid_off,stage, country,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		`standralising`
) duplicates
WHERE 
	row_num > 1;
    
    
    -- deleting duplicates 
    SET SQL_SAFE_UPDATES = 0;

    
DELETE FROM standralising
WHERE (company, industry, total_laid_off, `date`, percentage_laid_off, stage, country) IN (
  SELECT company, industry, total_laid_off, `date`, percentage_laid_off, stage, country
  FROM (
    SELECT 
      company,
      industry,
      total_laid_off,
      `date`,
      percentage_laid_off,
      stage,
      country,
      ROW_NUMBER() OVER (
        PARTITION BY company, industry, total_laid_off, `date`
        ORDER BY company
      ) AS row_num
    FROM standralising
  ) AS ranked
  WHERE row_num > 1
);

SET SQL_SAFE_UPDATES = 1;


    











----- 

----
SELECT *
FROM `standralising`
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		`standralising`;
        
        
	/*lets just look at oda  confirm*/

SELECT *
FROM standralising
WHERE company = 'Amazon'
;


-- standralizing 
select company, trim(company)
from standralising;





SET SQL_SAFE_UPDATES = 0;

UPDATE standralising
SET company = TRIM(company);


select distinct industry
from standralising 
order by 1;




select *
from standralising 
where  industry like "crypto%";

-- to date format
select `date`
from standralising;




SET SQL_SAFE_UPDATES = 0;

UPDATE standralising
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SET SQL_SAFE_UPDATES = 1;


--- knowing the missing valuess



SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM standralising
WHERE total_laid_off IS NULL or '' and  funds_raised is null or '';


SET SQL_SAFE_UPDATES = 1;  -- (Optional) turn it back on





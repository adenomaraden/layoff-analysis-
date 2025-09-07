📊 Layoffs Data Cleaning & Analysis
�
�
�
�
This project focuses on cleaning and analyzing layoffs data using SQL (MySQL).
The dataset contains records of global layoffs across industries, companies, and countries.
The main objective is to standardize, clean, and prepare the data for meaningful insights.
🚀 Project Workflow
🔹 1. Create Staging Table
We work in a staging table (standralising) to preserve the raw dataset.
Copy code
Sql
CREATE TABLE `standralising` LIKE layoffs;
INSERT `standralising` SELECT * FROM layoffs;
🔹 2. Remove Duplicates
Detect duplicates with ROW_NUMBER()
Delete duplicate rows while keeping unique entries
Copy code
Sql
DELETE FROM standralising
WHERE (company, industry, total_laid_off, `date`, percentage_laid_off, stage, country) IN (
  SELECT company, industry, total_laid_off, `date`, percentage_laid_off, stage, country
  FROM (
    SELECT company, industry, total_laid_off, `date`, percentage_laid_off, stage, country,
           ROW_NUMBER() OVER (
             PARTITION BY company, industry, total_laid_off, `date`
             ORDER BY company
           ) AS row_num
    FROM standralising
  ) ranked
  WHERE row_num > 1
);
🔹 3. Standardize Data
Trim extra spaces from company names
Clean inconsistent industry labels
Convert date strings → proper SQL DATE
Copy code
Sql
UPDATE standralising SET company = TRIM(company);
UPDATE standralising SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
🔹 4. Handle Missing Values
Check for missing layoffs or funds raised:
Copy code
Sql
SELECT *
FROM standralising
WHERE total_laid_off IS NULL OR total_laid_off = ''
   OR funds_raised IS NULL OR funds_raised = '';
📈 Exploratory Data Analysis (EDA)
After cleaning, we can analyze key trends:
🔸 Layoffs by Year
Copy code
Sql
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_offs
FROM standralising
GROUP BY year
ORDER BY year;
🔸 Top 10 Companies by Layoffs
Copy code
Sql
SELECT company, SUM(total_laid_off) AS total
FROM standralising
GROUP BY company
ORDER BY total DESC
LIMIT 10;
🔸 Layoffs by Industry
Copy code
Sql
SELECT industry, SUM(total_laid_off) AS total
FROM standralising
GROUP BY industry
ORDER BY total DESC;
🛠️ Tools Used
MySQL – SQL queries & cleaning
GitHub – version control & documentation
Data Cleaning + EDA – foundation for visualization
📂 Project Structure
Copy code

├── layoffs_raw.sql          # Original dataset
├── standralising.sql        # Cleaned dataset
├── cleaning_steps.sql       # All cleaning queries
├── eda_queries.sql          # EDA queries for analysis
└── README.md                # Project documentation
👨‍💻 Author
Aden Omar Aden
📧 Email: adenomaraden1@gmail.com
📍 Mogadishu, Somalia

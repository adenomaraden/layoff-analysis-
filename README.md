Here’s your polished README.md:

# 🧼 SQL Data Cleaning & Exploration

This project focuses on **cleaning and analyzing layoffs data using SQL**.  
It demonstrates how to take a raw dataset, clean and standardize it, and then run queries to uncover insights about layoffs across companies, industries, and countries.

The repository contains two SQL scripts:  
- [`sql_data_cleaning.sql`](./sql_data_cleaning.sql) → Data cleaning and preparation  
- [`data_exploring.sql`](./data_exploring.sql) → Exploration and analysis  

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)  
2. [Dataset](#-dataset)  
3. [Data Cleaning](#-data-cleaning)  
4. [Exploration Queries](#-exploration-queries)  
5. [Insights You Can Extract](#-insights-you-can-extract)  
6. [Tech Stack](#-tech-stack)  
7. [How to Use](#-how-to-use)  
8. [Future Improvements](#-future-improvements)  
9. [License](#-license)  

---

## 📖 Project Overview

The goal of this project is twofold:  

1. **SQL Data Cleaning**  
   - Create a staging table to preserve raw data  
   - Remove duplicates  
   - Trim whitespace from company names  
   - Convert text-based dates into proper `DATE` format  
   - Identify missing values  

2. **SQL Data Exploration**  
   - Summarize layoffs by company, industry, country, and year  
   - Identify companies with **100% workforce layoffs**  
   - Calculate rolling totals and cumulative layoffs over time  
   - Find the **Top 3 companies per year** with the most layoffs  

---

## 📂 Dataset

The dataset is stored in a table named **`standralising`**, containing:  

- `company`  
- `industry`  
- `location`  
- `country`  
- `stage`  
- `date`  
- `total_laid_off`  
- `percentage_laid_off`  
- `funds_raised`  

---

## 🧼 Data Cleaning

### 1) Create a staging table
```sql
CREATE TABLE `standralising` LIKE layoffs;
INSERT `standralising` SELECT * FROM layoffs;

2) Detect duplicates
SELECT company, industry, total_laid_off, `date`,
       ROW_NUMBER() OVER (
         PARTITION BY company, industry, total_laid_off, `date`
       ) AS row_num
FROM standralising;

3) Delete duplicates
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
  ) AS ranked
  WHERE row_num > 1
);

4) Trim whitespace from company names
UPDATE standralising
SET company = TRIM(company);

5) Format dates properly
UPDATE standralising
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

6) Check for missing values
SELECT *
FROM standralising
WHERE total_laid_off IS NULL
   OR funds_raised IS NULL;

🛠 Exploration Queries
🔹 Easier Queries

Maximum layoffs

Companies with 100% layoffs

Min/Max layoff percentages

SELECT MAX(total_laid_off) FROM standralising;
SELECT * FROM standralising WHERE percentage_laid_off = 1;

🔹 Aggregated Insights

Layoffs by company, location, country, year, industry, stage

SELECT country, SUM(total_laid_off) AS total_laid_off
FROM standralising
GROUP BY country
ORDER BY total_laid_off DESC;

🔹 Advanced Queries

Top 3 companies per year by layoffs

Rolling monthly totals

Cumulative layoffs over time

WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
  FROM standralising
  GROUP BY dates
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE;

📈 Insights You Can Extract

📌 Top companies with largest layoffs (single day & cumulative)

📌 Industries & countries most affected

📌 Yearly and monthly layoff trends

📌 Companies that laid off their entire workforce

📌 Cumulative layoffs over time

🧑‍💻 Tech Stack

SQL (MySQL / PostgreSQL compatible)

Relational database for structured data analysis

🌟 How to Use

Clone the repo:

git clone https://github.com/your-username/sql-data-cleaning.git


Import the dataset into your SQL database.

Run:

sql_data_cleaning.sql → Clean and prepare the data

data_exploring.sql → Explore and analyze the cleaned data

📌 Future Improvements

Automate cleaning with stored procedures.

Add visual dashboards (Tableau, Power BI, or Python).

Perform predictive modeling using machine learning.

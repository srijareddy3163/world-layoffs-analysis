select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

#highest layoffs per country

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

#highest layoffs per industry

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc ;

#highest layoffs per year

select YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc ;

WITH rolling_total as (
SELECT SUBSTRING(`DATE`,1,7) as Month, SUM(TOTAL_laid_off) as total_laid
from layoffs_staging2
where SUBSTRING(`DATE`,1,7) is not null
group by month
order by 1 asc )
select month,total_laid, sum(total_laid) over(order by `month`) as rolling_total
from rolling_total;

with company_year ( company,years, total_laid_off ) as 
(
select company,YEAR(`date`),sum(Total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by company asc), company_year_rank as (
select *, dense_rank() over (partition by years order by total_laid_off desc ) as ranking
from company_year
where years is  not null)
select *
from company_year_rank
where ranking<=5;


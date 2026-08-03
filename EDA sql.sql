-- -- EDA exploratory data analysis

select* 
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select*
from layoffs_staging2
where percentage_laid_off = 1;

select*
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select*
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;



--- group by

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select*
from layoffs_staging2;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

-------------------------------------------------------------------------------------------------------------------------------------


-- Rolling Total of Layoffs Per Month

Select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- now use it in a CTE 

with rolling_total as 
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_off
, sum(total_off) over(order by `month` asc) as rolling_total
from rolling_total;


-------------------------------------------------------------------------------------------------------------------

select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;       ------- 3 is col no.


with Company_Year (company,year,total_laid_off) as
(
 select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),
company_year_rank as
(select*,
dense_rank() over(
partition by year
order by total_laid_off desc
) as ranking
from Company_Year
where year is not null
)
select*
FROM Company_Year_Rank
where ranking <= 5
;

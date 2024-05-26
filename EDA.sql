-- Exploratory Data Analysis

select * from layoffs_staging;

-- MAX and MIN of people laid_off and Percentage 

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging;

select *
from layoffs_staging
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- SUM of laid_off People By Company (Using Group By)

select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc;

-- laid off people by Date

select min(`date`), max(`date`)
from layoffs_staging;

-- laid off people by Industry

select industry, sum(total_laid_off)
from layoffs_staging
group by industry
order by 2 desc;

-- laid off people by Country

select country, sum(total_laid_off)
from layoffs_staging
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging
group by year(`date`)
order by 1 desc;

-- Rolling the total peole laid-off by Month

select substring(`date`, 1,7) as `Month`, sum(total_laid_off)
from layoffs_staging
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc;

-- now use it in a CTE so I can query off of it

with Rolling_Total as 
(
select substring(`date`, 1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc
)
select `Month` , total_off,
sum(total_off) over(order by `Month` ) as rollong_total
from Rolling_Total;

select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
order by company asc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
order by 3 desc;


with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
), Company_Year_Rank as
(select *, dense_rank() over ( partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null)
select * from Company_Year_Rank
where Ranking <= 5;









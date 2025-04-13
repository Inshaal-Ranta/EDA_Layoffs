-- Exploratory data analysis
select * from layoffs_staging2;

select company, sum(total_laid_off) from layoffs_staging2 group by company order by sum(total_laid_off) desc;


select min(total_laid_off), max(total_laid_off) from layoffs_staging2  ;


select company, country, sum(total_laid_off) , count(company) from layoffs_staging2 where country = 'United States' group by company order by sum(total_laid_off) desc ;


-- what industry was most affected

select industry, sum(total_laid_off), count(industry) as num_businesses from layoffs_staging2 group by industry order by sum(total_laid_off) desc;

-- what city had most businesses affected 
select location, count(location) as freq_of_city from layoffs_staging2 group by location order by count(location) desc;

## total layoffs each year
select year(`date`), sum(total_laid_off) as annual_layoffs from layoffs_staging2 
group by year(`date`)
order by year(`date`) desc;


## what stages of company were hit the most

select stage, sum(total_laid_off) as sum_layoffs from layoffs_staging2 group by stage order by sum_layoffs desc;

## just checking if we can get an estimates of total employee as a column 
select company, total_laid_off, percentage_laid_off,
round(total_laid_off/ percentage_laid_off,0) as total_employees
 from layoffs_staging2
 where total_laid_off is not null and percentage_laid_off is not null
 order by total_employees desc;


#look at the progression of these layoffs ... could use rolling sum to do that 

select substring(`date`, 1,7) as `MONTH`, sum(total_laid_off) 
from layoffs_staging2 
where substring(`date`, 1,7) is not null
group by `MONTH`
order by `MONTH` ;


-- apply rolling total can use cte

with Rolling_total as (
select substring(`date`, 1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2 
where substring(`date`, 1,7) is not null
group by `MONTH`
order by `MONTH`)
select `MONTH` , total_off,sum(total_off) over(order by `MONTH`) as rolling_month
from Rolling_total;





select company, sum(total_laid_off) from layoffs_staging2 group by company order by sum(total_laid_off) desc ;


### ranking companies based on biggest laid off each year
select company, year(`date`),sum(total_laid_off) from layoffs_staging2 group by company, year(`date`) order by company asc;

with company_years(Company, Years, Total_laid_off) as
(
select company, year(`date`),sum(total_laid_off) from layoffs_staging2 group by company, year(`date`)
)
select *, dense_rank() over(partition by Years order by Total_laid_off desc) as Rankings 
from company_years
where years is not null
order by Rankings ;

## top 6 biggest layoff companies year wise
with company_years(Company, Years, Total_laid_off) as
(
select company, year(`date`),sum(total_laid_off) from layoffs_staging2 group by company, year(`date`)
), Company_year_rank as (
select *, dense_rank() over(partition by Years order by Total_laid_off desc) as Rankings 
from company_years
where years is not null)
 select * from Company_year_rank
 where Rankings <= 6;


## we can use similar logic to check the top industry to layoff yearwise





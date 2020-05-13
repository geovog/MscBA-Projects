/* Question a */

select idlease,pickuploc 
from lease 
where DATE(since)='20150520';

/* Question b */

select distinct custfirstname, custlastname, phone 
from lease
inner join customer using(idcustomer)
inner join cars using(VIN)
inner join category using(idcategory)
where category.label='luxury';
 
/* Question c */
 
select pickuploc as 'Location Id', sum(amount)as 'Total Amount'
from lease
group by pickuploc;
 
/* Question d */
 
select idcategory,monthname(since) as month, sum(amount) as 'Total Amount' from lease 
inner join cars using(VIN)
inner join category using(idcategory)
group by  idcategory, month(since);
 
/* Question e */
 
create view clabels (occurences, label, state) as
select count(*), label, locstate	
from category, cars ,lease, location 
where category.idcategory = cars.idcategory and lease.VIN= cars.VIN and lease.pickuploc = location.idlocation
group by locstate,label;
    
select   label, state
from clabels
where occurences=(select max(occurences)
from clabels as  mlabels
where mlabels.state=clabels.state);

/* Question f */
 
select (sum(if(lease.pickuploc=location.idlocation and location.locstate='NY' and year(since)=2015 and month(since)=05, 1, 0))) NY,
(sum(if(lease.pickuploc=location.idlocation and location.locstate='NJ' and year(since)=2015 and month(since)=05, 1, 0))) NJ,
(sum(if(lease.pickuploc=location.idlocation and location.locstate='CA' and year(since)=2015 and month(since)=05, 1, 0))) CA
from lease,location;

/* Question g */

create view monthaverage (monthavg, month) as
select avg(amount), monthname(since)
from lease
where year(since)=2015
group by monthname(since);

select count(idlease) as countId, month
from lease, monthaverage
where amount>monthavg and year(since)=2015 and month=monthname(since)
group by month;
 
/* Question h */
  
select lease2015.month, 100.0 * (lease2015.sum2015-lease2014.sum2014)/lease2014.sum2014 as pct_change
from (select sum(amount) as sum2014, monthname(since) as month 
	 from lease 
	 where YEAR(since) = 2014  
	 group by  monthname(since)) as lease2014
	inner join 
	(select sum(amount) as sum2015, monthname(since) as month 
	from lease 
	where year(since) = 2015 
	group by  monthname(since)) as lease2015
	using(month)
	
/* Question i */	

create view monthlySums (month, amount) as
select month(since), sum(amount)
from lease
where year(since)=2015
group by month(since);

select t2.month, (sum(if(t1.month<t2.month, t1.amount, 0))) previous_months,
(sum(if(t1.month=t2.month, t1.amount, 0))) current_month,
(sum(if(t1.month>t2.month, t1.amount, 0))) following_months
from monthlySums as t1, monthlySums as t2
group by t2.month;
	
	
	
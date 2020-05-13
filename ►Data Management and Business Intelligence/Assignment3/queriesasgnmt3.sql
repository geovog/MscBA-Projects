--1
select count(*) 
into output
from input
inner join cars
on input.vehicleTypeID = cars.id
where input.spotType = 'Toll_Station'
and cars.CAR_MAKE = 'Audi'
group by TumblingWindow(second,60)

--2
select
count(*),colors.color_name
into output
from input
inner join colors
on input.colorID = colors.color_code
where input.spotType =  'Speed_Limit_Camera' 
group by colors.color_name, HoppingWindow(second,180,90)

--3
select colors.color_name,min(cars.CAR_MODEL_YEAR),cars.CAR_MAKE,cars.CAR_MODEL
into output
from input 
inner join colors
on input.colorID = colors.color_code
inner join cars
on input.vehicleTypeID = cars.id
where input.spotType =  'Toll_Station' 
group by  colors.color_name, cars.CAR_MAKE, cars.CAR_MODEL, TumblingWindow(second,20)

--4
with 
subq as ( 
select count(*) as violcount,input.checkpointID as chkpntid
from input
inner join spots
on input.checkpointID = spots.id
where cast(input.speed as bigint) > cast(spots.SPEED_LIMIT as bigint)
group by SlidingWindow(second,60),input.checkpointID)
select max(violcount),chkpntid
from subq
group by chkpntid,SlidingWindow(second,60)

--5
select colors.color_name,cars.CAR_MODEL,count(*)
into output 
from input
inner join cars 
on input.vehicleTypeID = cars.id
inner join colors
on input.colorID = colors.color_code
inner join spots
on input.checkpointID = spots.id
where cast(input.speed as bigint) > cast(spots.SPEED_LIMIT as bigint)
group by colors.color_name,cars.CAR_MODEL,SlidingWindow(second,300)

--6 
select input.vehicletypeid,input.licensePlate, cars.car_model,count(*)
into output
from input
inner join wanted on input.licensePlate = wanted.wanted_plate
inner join cars on input.vehicletypeid = cars.id
where input.licensePlate = wanted.wanted_plate 
group by SlidingWindow (second, 60), input.vehicletypeid, input.licensePlate, cars.car_model

--7
select temp1.licensePlate ,count(*) as countTimesPassed
into output
from input as temp1
join input as temp2 
on datediff(minute, temp1, temp2) 
between 0 and 1
where temp1.licensePlate = temp2.licensePlate
 and temp1.vehicletypeid != temp2.vehicletypeid
 and temp1.checkpointID != temp2.checkpointid
 and temp1.EventProcessedUtcTime = temp2.EventProcessedUtcTime
group by SlidingWindow (second, 60), temp1.licensePlate
having count(*) > 1

--8
with
wantedcars as
    (select count(*) as bmwcount
	from input 
	inner join cars on  input.vehicletypeid = cars.id
	where cars.car_make = 'BMW' and input.spotType = 'Speed_Limit_Camera'
	group by TumblingWindow(second,120)),
abovelimit as 
	(select  count(*)as bmwviolations
	from
    input 
    inner join cars on input.vehicletypeid = cars.id
    inner join spots on input.checkpointID = spots.id
	where cars.car_make = 'BMW' and input.spotType = 'Speed_Limit_Camera'
	and cast(input.speed as bigint) > cast(spots.speed_limit as bigint)
	group by TumblingWindow(second,120))
select case when abovelimit.bmwviolations is null then 0 else abovelimit.bmwviolations end as bmwviolations,
wantedcars.bmwcount,
case when ((abovelimit.bmwviolations)*100)/(wantedcars.bmwcount) is null then 0 else ((abovelimit.bmwviolations)*100)/(wantedcars.bmwcount) end as percentage 
from wantedcars 
left join abovelimit  
on datediff(minute, wantedcars, abovelimit) 
between 0 AND 2


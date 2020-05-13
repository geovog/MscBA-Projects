alter table ny_collisions
add Date_id nvarchar(100);

alter table ny_collisions
add Time_id nvarchar(100);

alter table ny_collisions
add Factor_id1 nvarchar(100);
alter table ny_collisions
add Factor_id2 nvarchar(100);
alter table ny_collisions
add Factor_id3 nvarchar(100);
alter table ny_collisions
add Factor_id4 nvarchar(100);
alter table ny_collisions
add Factor_id5 nvarchar(100);

alter table ny_collisions
add Vtype_id1 nvarchar(100);
alter table ny_collisions
add Vtype_id2 nvarchar(100);
alter table ny_collisions
add Vtype_id3 nvarchar(100);
alter table ny_collisions
add Vtype_id4 nvarchar(100);
alter table ny_collisions
add Vtype_id5 nvarchar(100);

alter table ny_collisions
add Location_id nvarchar(100);


update ny_collisions
set ny_collisions.Date_id = Accident_Date.Date_id
from Accident_Date
where ny_collisions.DATE = Accident_Date.Acc_Date

update ny_collisions
set ny_collisions.Time_id = Accident_Time.Time_id
from Accident_Time
where ny_collisions.TIME = Accident_Time.Acc_Time

update ny_collisions
set ny_collisions.Factor_id1 = Accident_factor.factor_id
from Accident_factor
where ny_collisions.CONTRIBUTING_FACTOR_VEHICLE_1 = Accident_factor.factor

update ny_collisions
set ny_collisions.Factor_id2 = Accident_factor.factor_id
from Accident_factor
where ny_collisions.CONTRIBUTING_FACTOR_VEHICLE_2 = Accident_factor.factor

update ny_collisions
set ny_collisions.Factor_id3 = Accident_factor.factor_id
from Accident_factor
where ny_collisions.CONTRIBUTING_FACTOR_VEHICLE_3 = Accident_factor.factor

update ny_collisions
set ny_collisions.Factor_id4 = Accident_factor.factor_id
from Accident_factor
where ny_collisions.CONTRIBUTING_FACTOR_VEHICLE_4 = Accident_factor.factor

update ny_collisions
set ny_collisions.Factor_id5 = Accident_factor.factor_id
from Accident_factor
where ny_collisions.CONTRIBUTING_FACTOR_VEHICLE_5 = Accident_factor.factor


update ny_collisions
set ny_collisions.Vtype_id1 = Vehicle_type.vtype_id
from Vehicle_type
where ny_collisions.VEHICLE_TYPE_CODE_1 = Vehicle_type.vtype

update ny_collisions
set ny_collisions.Vtype_id2 = Vehicle_type.vtype_id
from Vehicle_type
where ny_collisions.VEHICLE_TYPE_CODE_2 = Vehicle_type.vtype

update ny_collisions
set ny_collisions.Vtype_id3 = Vehicle_type.vtype_id
from Vehicle_type
where ny_collisions.VEHICLE_TYPE_CODE_3 = Vehicle_type.vtype

update ny_collisions
set ny_collisions.Vtype_id4 = Vehicle_type.vtype_id
from Vehicle_type
where ny_collisions.VEHICLE_TYPE_CODE_4 = Vehicle_type.vtype

update ny_collisions
set ny_collisions.Vtype_id5 = Vehicle_type.vtype_id
from Vehicle_type
where ny_collisions.VEHICLE_TYPE_CODE_5 = Vehicle_type.vtype

update ny_collisions
set ny_collisions.Location_id = Location.location_id
from Location
where ny_collisions.BOROUGH = Location.borough and
ny_collisions.ZIP_CODE = Location.zip_code and
ny_collisions.LONGITUDE = Location.longitude and
ny_collisions.LATITUDE = Location.latitude;


create table fact_table
(
unique_key nvarchar(50),
time_id nvarchar(100),
date_id nvarchar(100),
location_id nvarchar(100),
persons_injured int,
persons_killed int,
pedestrians_injured int,
pedestrians_killed int,
cyclists_injured int,
cyclists_killed int,
motorists_injured int,
motorists_killed int,
factor_vehicle1_id nvarchar(100),
factor_vehicle2_id nvarchar(100),
factor_vehicle3_id nvarchar(100),
factor_vehicle4_id nvarchar(100),
factor_vehicle5_id nvarchar(100),
vtype1_id nvarchar(100),
vtype2_id nvarchar(100),
vtype3_id nvarchar(100),
vtype4_id nvarchar(100),
vtype5_id nvarchar(100),
foreign key(time_id) references Accident_Time(Time_id),
foreign key(date_id) references Accident_Date(Date_id),
foreign key(location_id) references Location(location_id),
foreign key(factor_vehicle1_id) references Accident_factor(factor_id),
foreign key(factor_vehicle2_id) references Accident_factor(factor_id),
foreign key(factor_vehicle3_id) references Accident_factor(factor_id),
foreign key(factor_vehicle4_id) references Accident_factor(factor_id),
foreign key(factor_vehicle5_id) references Accident_factor(factor_id),
foreign key(vtype1_id) references Vehicle_type(vtype_id),
foreign key(vtype2_id) references Vehicle_type(vtype_id),
foreign key(vtype3_id) references Vehicle_type(vtype_id),
foreign key(vtype4_id) references Vehicle_type(vtype_id),
foreign key(vtype5_id) references Vehicle_type(vtype_id)
)


insert into fact_table (unique_key,time_id,date_id,location_id,persons_injured,persons_killed,pedestrians_injured,pedestrians_killed,cyclists_injured,cyclists_killed,motorists_injured,motorists_killed,factor_vehicle1_id,factor_vehicle2_id,factor_vehicle3_id,factor_vehicle4_id,factor_vehicle5_id,vtype1_id,vtype2_id,vtype3_id,vtype4_id,vtype5_id )
select UNIQUE_KEY,Time_id,Date_id,Location_id,NUMBER_OF_PERSONS_INJURED,NUMBER_OF_PERSONS_KILLED,NUMBER_OF_PEDESTRIANS_INJURED,NUMBER_OF_PEDESTRIANS_KILLED,NUMBER_OF_CYCLIST_INJURED,NUMBER_OF_CYCLIST_KILLED,NUMBER_OF_MOTORIST_INJURED,NUMBER_OF_MOTORIST_KILLED,Factor_id1,Factor_id2,Factor_id3,Factor_id4,Factor_id5,Vtype_id1,Vtype_id2,Vtype_id3,Vtype_id4,Vtype_id5
from ny_collisions


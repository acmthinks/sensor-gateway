#!/bin/bash

export PATH=$PATH:.

#UTC
dt=`date -u +"%Y-%m-%d %H:%M:%S.00000"`
# non-UTC
dt=`date  +"%Y-%m-%d %H:%M:%S.00000"`



dbaccess sysmaster - <<!

drop database if exists sensordb;
create database sensordb in datadbs1 with buffered log ;
!

dbaccess sensordb - <<!

drop table if exists sensor;
drop table if exists sensor_vti;
drop row type if exists sensor_row_t restrict;


insert into calendartable(c_name, c_calendar)
     values ("ts_5sec", 'startdate($dt), pattstart($dt), pattern( {5 on} second)' );


create row type sensor_row_t
(
   tstamp       datetime year to fraction(5),
   json_data     bson
);

create table sensor
(
   id           varchar(255) not null primary key,
   data         timeseries(sensor_row_t)

);




execute procedure tscontainercreate('sens_cont1','datadbs1','sensor_row_t', 1024, 1024);






execute procedure tscreatevirtualtab('sensor_vti',
        'sensor',
        'calendar(ts_5sec), origin($dt), irregular'
        );


{
insert into sensor values ('1',tscreateirr('ts_5sec','$dt', 0,0,0,'sens_cont1'));
}

!

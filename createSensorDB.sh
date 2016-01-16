#!/bin/bash

export PATH=$PATH:.

dbaccess sysmaster - <<!
  -- Create database
drop database if exists sensordb;
create database sensordb in rootdbs with buffered log;
!

dbaccess sensordb - <<!

drop table if exists thermometer;
drop table if exists thermometer_vti;

  -- Create generic calendar pattern for regular intervals: daily, every 15 minutes
INSERT INTO CalendarPatterns values ( 'Daily_15min', '{1 on , 14 off}, minute');

  -- Create calendar (to be used with TimeSeries database) with the pattern defined above
insert into CalendarTable(c_name, c_calendar) values ('Daily_15min', 'startdate(2016-01-14 14:00:00), pattstart(2016-01-14 14:00:00), pattname(Daily_15min)');

  -- Create TimeSeries row type for sensor data
create row type temp_reading(timestamp datetime year to fraction(5), Temp real);

  -- Create table to store sensor data
create table thermometer(
sensor_id int,
sensor_data TimeSeries(temp_reading));

  -- Create a dedicated container to optimally store and retrieve sensor data
execute procedure TSContainerCreate
('TSContainer', 'rootdbs','temp_reading', 1024, 1024);

  -- Initialize a TimeSeries record for *each* sensor 
INSERT INTO thermometer VALUES(101, "origin(2016-01-14 14:00:00.00000), calendar(Daily_15min), container(TSContainer), threshold(0),regular,[]");

  -- Create a virtual table 
execute procedure tscreatevirtualtab('thermometer_vti','thermometer');

  -- Create sample data 
insert into thermometer_vti values( 101, "2016-01-14 14:00:00"::DATETIME YEAR TO FRACTION(5),78);
insert into thermometer_vti values( 101, "2016-01-14 14:15:00"::DATETIME YEAR TO FRACTION(5),79);
insert into thermometer_vti values( 101, "2016-01-14 14:30:00"::DATETIME YEAR TO FRACTION(5),78);
insert into thermometer_vti values( 101, "2016-01-14 14:45:00"::DATETIME YEAR TO FRACTION(5),80);

 GRANT RESOURCE TO PUBLIC;
 GRANT ALL PRIVILEGES ON thermometer TO root, informix;
 GRANT ALL PRIVILEGES ON thermometer_vti TO root, informix;
!

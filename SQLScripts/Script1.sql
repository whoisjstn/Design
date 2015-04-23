TRUNCATE TABLE readings;
SELECT * FROM readings;
ALTER TABLE readings MODIFY timeslot DATE;

UPDATE readings
SET timeslot = str_to_date(timeslot, '%m/%d/%Y');

SELECT * FROM readings WHERE home_id=999;

SELECT * FROM homes;

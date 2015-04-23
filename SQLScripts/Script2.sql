USE gbtest;
LOAD DATA LOCAL INFILE '/Users/justinpostlewaite/4450/Electricity Usage Data CSV.csv' INTO TABLE readings
FIELDS TERMINATED BY  ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
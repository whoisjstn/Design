USE gbtest;
# The following queries generate the tables required for the Hydro Analytics Platform MySQL Database.
    
CREATE TABLE `homes` (
  `user_id` int(10) unsigned NOT NULL,
  `home_id` varchar(30) NOT NULL,
  `neighborhood` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`home_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `homes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `readings` (
  `home_id` varchar(30) NOT NULL,
  `period` datetime NOT NULL,
  `consumption` decimal(7,5) NOT NULL,
  PRIMARY KEY (`home_id`,`period`),
  CONSTRAINT `readings_ibfk_1` FOREIGN KEY (`home_id`) REFERENCES `homes` (`home_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


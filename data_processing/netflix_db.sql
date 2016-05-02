/* SQL Structure - should work on all versions */

DROP DATABASE IF EXISTS `netflix`;
CREATE DATABASE `netflix` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `netflix`;

CREATE TABLE `movies` (
	  `id` int(5) NOT NULL DEFAULT '0',
	  `year` int(4) DEFAULT '0',
	  `title` varchar(255) NOT NULL DEFAULT '',
	  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `probe` (
	  `movie_id` int(5) NOT NULL DEFAULT '0',
	  `customer_id` int(6) NOT NULL DEFAULT '0',
	  KEY `movie_id` (`movie_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `qualifying` (
	  `customer_id` int(6) NOT NULL DEFAULT '0',
	  `date` date NOT NULL DEFAULT '0000-00-00',
	  `movie_id` int(5) NOT NULL DEFAULT '0',
	  KEY `movie_id` (`movie_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `ratings` (
	  `movie_id` int(5) NOT NULL DEFAULT '0',
	  `customer_id` int(6) NOT NULL DEFAULT '0',
	  `rating` int(1) NOT NULL DEFAULT '0',
	  `date` date NOT NULL DEFAULT '0000-00-00',
	  PRIMARY KEY  (`movie_id`,`customer_id`),
	  KEY `date` (`date`),
	  KEY `movie_id` (`movie_id`),
	  KEY `customer_id` (`customer_id`),
	  KEY `rating` (`rating`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

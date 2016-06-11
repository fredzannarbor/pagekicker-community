-- phpMyAdmin SQL Dump
-- version 3.4.4
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Jul 17, 2013 at 06:24 PM
-- Server version: 5.1.56
-- PHP Version: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sfb-jobs`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE IF NOT EXISTS `books` (
  `SKU` int(11) NOT NULL,
  `Booktype` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `uuid` text CHARACTER SET latin1 NOT NULL,
  `seed` text CHARACTER SET latin1 NOT NULL,
  `graph` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `graph nodes`
--

CREATE TABLE IF NOT EXISTS `graph nodes` (
  `URL` text NOT NULL,
  `DOI` text NOT NULL,
  `Title` int(11) NOT NULL,
  `Source` int(11) NOT NULL,
  `nodeid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nodeid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `graphs`
--

CREATE TABLE IF NOT EXISTS `graphs` (
  `graphid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`graphid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `isbns`
--

CREATE TABLE IF NOT EXISTS `isbns` (
  `ISBN` mediumtext NOT NULL,
  `Title` mediumtext NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='manage ISBNs' AUTO_INCREMENT=91 ;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE IF NOT EXISTS `jobs` (
  `SFB_revision_no` int(11) NOT NULL,
  `uuid` mediumtext NOT NULL,
  `job_created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `PRIMARY` int(11) NOT NULL AUTO_INCREMENT,
  `LANG` enum('en_US.UTF-8','cs_CZ.UTF-8','it_IT.UTF-8') NOT NULL DEFAULT 'en_US.UTF-8' COMMENT 'environment variable value',
  PRIMARY KEY (`PRIMARY`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=184 ;

-- --------------------------------------------------------

--
-- Table structure for table `robots`
--

CREATE TABLE IF NOT EXISTS `robots` (
  `robot_id` int(11) NOT NULL AUTO_INCREMENT,
  `robot_name` text NOT NULL,
  `robot_bio` text NOT NULL,
  `robot_dedication` text NOT NULL,
  `robot_summary_seed` text NOT NULL,
  `robot_summary_seed_weight` int(11) NOT NULL,
  `robot_coverfont` text NOT NULL,
  `robot_covercolor` text NOT NULL,
  `robot_first_name` text NOT NULL,
  `robot_middle_name` text NOT NULL,
  `robot_last_name` text NOT NULL,
  `robot_fortune_db` text NOT NULL,
  `robot_ngram_threshold` int(11) NOT NULL DEFAULT '2',
  PRIMARY KEY (`robot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `seeds`
--

CREATE TABLE IF NOT EXISTS `seeds` (
  `uuid` mediumtext NOT NULL,
  `seed` mediumtext NOT NULL,
  `seedsource` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `skus`
--

CREATE TABLE IF NOT EXISTS `skus` (
  `sku` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `standalone_print_cover_builds`
--

CREATE TABLE IF NOT EXISTS `standalone_print_cover_builds` (
  `ISBN` mediumtext NOT NULL,
  `covertitle` mediumtext NOT NULL,
  `shorttitle` mediumtext NOT NULL,
  `editedby` mediumtext NOT NULL,
  `spinepixels` int(11) NOT NULL,
  `covercolor` mediumtext NOT NULL,
  `coverfontcolor` mediumtext NOT NULL,
  `coverfont` mediumtext NOT NULL,
  `submitted_to_LSI` tinyint(1) NOT NULL DEFAULT '0',
  `uuid` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='to track cover build jobs';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

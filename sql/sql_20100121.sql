-- phpMyAdmin SQL Dump
-- version 2.11.9.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 21, 2010 at 09:03 AM
-- Server version: 5.0.77
-- PHP Version: 4.4.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ushahi1_haiti`
--

-- --------------------------------------------------------

--
-- Table structure for table `alert`
--

CREATE TABLE IF NOT EXISTS `alert` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `alert_type` tinyint(4) NOT NULL COMMENT '1 - MOBILE, 2 - EMAIL',
  `alert_recipient` varchar(200) default NULL,
  `alert_code` varchar(30) default NULL,
  `alert_confirmed` tinyint(4) NOT NULL default '0',
  `alert_lat` varchar(150) default NULL,
  `alert_lon` varchar(150) default NULL,
  `alert_radius` tinyint(4) NOT NULL default '20',
  `alert_ip` varchar(100) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_alert_code` (`alert_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `alert_sent`
--

CREATE TABLE IF NOT EXISTS `alert_sent` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) NOT NULL,
  `alert_id` bigint(20) NOT NULL,
  `alert_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE IF NOT EXISTS `category` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `parent_id` int(11) NOT NULL default '0',
  `locale` varchar(10) NOT NULL default 'en_US',
  `category_type` tinyint(4) default NULL,
  `category_title` varchar(255) default NULL,
  `category_description` text,
  `category_color` varchar(20) default NULL,
  `category_image` varchar(100) default NULL,
  `category_image_shadow` varchar(100) default NULL,
  `category_visible` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `category_visible` (`category_visible`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `category_lang`
--

CREATE TABLE IF NOT EXISTS `category_lang` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `category_id` int(11) NOT NULL,
  `locale` varchar(10) default NULL,
  `category_title` varchar(255) default NULL,
  `category_description` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE IF NOT EXISTS `city` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `country_id` int(11) default NULL,
  `city` varchar(200) default NULL,
  `city_lat` varchar(150) default NULL,
  `city_lon` varchar(200) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cluster`
--

CREATE TABLE IF NOT EXISTS `cluster` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `latitude` double NOT NULL default '0',
  `longitude` double NOT NULL default '0',
  `cluster_count` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cluster_incident`
--

CREATE TABLE IF NOT EXISTS `cluster_incident` (
  `id` int(11) NOT NULL auto_increment,
  `cluster_id` bigint(20) NOT NULL default '0',
  `incident_id` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `command`
--

CREATE TABLE IF NOT EXISTS `command` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `command_phrase` varchar(50) NOT NULL,
  `command_action` tinyint(4) NOT NULL,
  `command_description` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE IF NOT EXISTS `comment` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) NOT NULL,
  `user_id` int(11) default '0',
  `comment_author` varchar(100) default NULL,
  `comment_email` varchar(120) default NULL,
  `comment_description` text,
  `comment_ip` varchar(100) default NULL,
  `comment_rating` varchar(15) NOT NULL default '0',
  `comment_spam` tinyint(4) NOT NULL default '0',
  `comment_active` tinyint(4) NOT NULL default '0',
  `comment_date` datetime default NULL,
  `comment_date_gmt` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE IF NOT EXISTS `country` (
  `id` int(11) NOT NULL auto_increment,
  `iso` varchar(10) default NULL,
  `country` varchar(100) default NULL,
  `capital` varchar(100) default NULL,
  `cities` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `feed`
--

CREATE TABLE IF NOT EXISTS `feed` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `feed_name` varchar(255) default NULL,
  `feed_url` varchar(255) default NULL,
  `feed_cache` text,
  `feed_active` tinyint(4) default '1',
  `feed_update` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE IF NOT EXISTS `feedback` (
  `id` tinyint(11) NOT NULL auto_increment,
  `feedback_mesg` text NOT NULL,
  `feedback_status` tinyint(3) NOT NULL,
  `feedback_dateadd` datetime default NULL,
  `feedback_datemodify` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `feedback_person`
--

CREATE TABLE IF NOT EXISTS `feedback_person` (
  `id` tinyint(11) NOT NULL auto_increment,
  `feedback_id` tinyint(11) NOT NULL,
  `person_email` varchar(30) NOT NULL,
  `person_date` datetime default NULL,
  `person_ip` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `feed_item`
--

CREATE TABLE IF NOT EXISTS `feed_item` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `feed_id` int(11) NOT NULL,
  `location_id` bigint(20) default '0',
  `incident_id` int(11) NOT NULL default '0',
  `item_title` varchar(255) default NULL,
  `item_description` text,
  `item_link` varchar(255) default NULL,
  `item_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `form`
--

CREATE TABLE IF NOT EXISTS `form` (
  `id` int(11) NOT NULL auto_increment,
  `form_title` varchar(200) NOT NULL,
  `form_description` text,
  `form_active` tinyint(4) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `form_field`
--

CREATE TABLE IF NOT EXISTS `form_field` (
  `id` int(11) NOT NULL auto_increment,
  `form_id` int(11) NOT NULL default '0',
  `field_name` varchar(200) default NULL,
  `field_type` tinyint(4) NOT NULL default '1' COMMENT '1 - TEXTFIELD, 2 - TEXTAREA (FREETEXT), 3 - DATE, 4 - PASSWORD, 5 - RADIO, 6 - CHECKBOX',
  `field_required` tinyint(4) default '0',
  `field_options` text,
  `field_position` tinyint(4) NOT NULL default '0',
  `field_default` varchar(200) default NULL,
  `field_maxlength` int(11) NOT NULL default '0',
  `field_width` smallint(6) NOT NULL default '0',
  `field_height` tinyint(4) default '5',
  `field_isdate` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_form_id` (`form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `form_response`
--

CREATE TABLE IF NOT EXISTS `form_response` (
  `id` bigint(20) NOT NULL auto_increment,
  `form_field_id` int(11) NOT NULL,
  `incident_id` bigint(20) NOT NULL,
  `form_response` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_form_field_id` (`form_field_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `idp`
--

CREATE TABLE IF NOT EXISTS `idp` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) NOT NULL,
  `verified_id` bigint(20) default NULL,
  `idp_idnumber` varchar(100) default NULL,
  `idp_orig_idnumber` varchar(100) default NULL,
  `idp_fname` varchar(50) default NULL,
  `idp_lname` varchar(50) default NULL,
  `idp_email` varchar(100) default NULL,
  `idp_phone` varchar(50) default NULL,
  `current_location_id` bigint(20) default NULL,
  `displacedfrom_location_id` bigint(20) default NULL,
  `movedto_location_id` bigint(20) default NULL,
  `idp_move_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `incident`
--

CREATE TABLE IF NOT EXISTS `incident` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `location_id` bigint(20) NOT NULL,
  `form_id` int(11) NOT NULL default '1',
  `locale` varchar(10) NOT NULL default 'en_US',
  `user_id` bigint(20) default NULL,
  `incident_title` varchar(255) default NULL,
  `incident_description` longtext,
  `incident_date` datetime default NULL,
  `incident_mode` tinyint(4) NOT NULL default '1' COMMENT '1 - WEB, 2 - SMS, 3 - EMAIL, 4 - TWITTER',
  `incident_active` tinyint(4) NOT NULL default '0',
  `incident_verified` tinyint(4) NOT NULL default '0',
  `incident_source` varchar(5) default NULL,
  `incident_information` varchar(5) default NULL,
  `incident_rating` varchar(15) NOT NULL default '0',
  `incident_dateadd` datetime default NULL,
  `incident_dateadd_gmt` datetime default NULL,
  `incident_datemodify` datetime default NULL,
  `incident_alert_status` tinyint(4) NOT NULL default '0' COMMENT '0 - Not Tagged for Sending, 1 - Tagged for Sending, 2 - Alerts Have Been Sent',
  `incident_action_taken` tinyint(4) NOT NULL default '0',
  `incident_action_summary` text character set utf8 collate utf8_unicode_ci,
  `incident_actionable` tinyint(4) default NULL,
  `incident_custom_phone` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `location_id` (`location_id`),
  KEY `incident_active` (`incident_active`),
  KEY `incident_date` (`incident_date`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `incident_category`
--

CREATE TABLE IF NOT EXISTS `incident_category` (
  `id` int(11) NOT NULL auto_increment,
  `incident_id` bigint(20) NOT NULL default '0',
  `category_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `incident_category_ids` (`incident_id`,`category_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `incident_lang`
--

CREATE TABLE IF NOT EXISTS `incident_lang` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) NOT NULL,
  `locale` varchar(10) default NULL,
  `incident_title` varchar(255) default NULL,
  `incident_description` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `incident_person`
--

CREATE TABLE IF NOT EXISTS `incident_person` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) default NULL,
  `location_id` bigint(20) default NULL,
  `person_first` varchar(200) default NULL,
  `person_last` varchar(200) default NULL,
  `person_email` varchar(120) default NULL,
  `person_phone` varchar(60) default NULL,
  `person_ip` varchar(50) default NULL,
  `person_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `json`
--

CREATE TABLE IF NOT EXISTS `json` (
  `id` int(11) NOT NULL auto_increment,
  `json` longtext NOT NULL,
  `zoom` tinyint(4) NOT NULL default '1',
  `category_id` int(11) NOT NULL default '0',
  `start_date` int(11) NOT NULL default '0',
  `end_date` int(11) NOT NULL default '0',
  `media` tinyint(4) NOT NULL default '0',
  `southwest` varchar(50) default NULL,
  `northeast` varchar(50) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `start_date` (`start_date`),
  KEY `end_date` (`end_date`),
  KEY `southwest` (`southwest`),
  KEY `northeast` (`northeast`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `laconica`
--

CREATE TABLE IF NOT EXISTS `laconica` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` int(11) default '0',
  `laconica_mesg_from` varchar(100) default NULL,
  `laconica_mesg_to` varchar(100) default NULL,
  `laconica_mesg_link` varchar(100) default NULL,
  `laconica_mesg` varchar(255) default NULL,
  `laconica_mesg_type` tinyint(4) default '1' COMMENT '1 - INBOX, 2 - OUTBOX (From Admin)',
  `laconica_mesg_date` datetime default NULL,
  `hide` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `layer`
--

CREATE TABLE IF NOT EXISTS `layer` (
  `id` int(11) NOT NULL auto_increment,
  `layer_name` varchar(255) default NULL,
  `layer_url` varchar(255) default NULL,
  `layer_file` varchar(100) default NULL,
  `layer_color` varchar(20) default NULL,
  `layer_visible` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `level`
--

CREATE TABLE IF NOT EXISTS `level` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `level_title` varchar(200) default NULL,
  `level_description` varchar(200) default NULL,
  `level_weight` tinyint(4) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE IF NOT EXISTS `location` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `location_name` varchar(255) default NULL,
  `country_id` int(11) default NULL,
  `latitude` double NOT NULL default '0',
  `longitude` double NOT NULL default '0',
  `location_visible` tinyint(4) NOT NULL default '1',
  `location_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE IF NOT EXISTS `media` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `location_id` bigint(20) default NULL,
  `incident_id` bigint(20) default NULL,
  `media_type` tinyint(4) default NULL COMMENT '1 - IMAGES, 2 - VIDEO, 3 - AUDIO, 4 - NEWS, 5 - PODCAST',
  `media_title` varchar(255) default NULL,
  `media_description` longtext,
  `media_link` varchar(255) default NULL,
  `media_thumb` varchar(255) default NULL,
  `media_date` datetime default NULL,
  `media_active` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `parent_id` bigint(20) default '0',
  `incident_id` int(11) default '0',
  `location_id` bigint(20) default '0',
  `user_id` int(11) default '0',
  `reporter_id` bigint(20) default NULL,
  `service_messageid` varchar(100) NOT NULL default '0',
  `message_from` varchar(100) default NULL,
  `message_to` varchar(100) default NULL,
  `message` text,
  `message_detail` text,
  `message_type` tinyint(4) default '1' COMMENT '1 - INBOX, 2 - OUTBOX (From Admin)',
  `message_date` datetime default NULL,
  `message_reply` tinyint(4) NOT NULL default '0',
  `message_level` tinyint(4) NOT NULL default '0',
  `message_trash` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `message_lock`
--

CREATE TABLE IF NOT EXISTS `message_lock` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `message_id` bigint(20) default NULL,
  `lock_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `missing_people`
--

CREATE TABLE IF NOT EXISTS `missing_people` (
  `missingid` bigint(20) NOT NULL,
  `missing_name` varchar(80) NOT NULL,
  `missing_photo` blob NOT NULL,
  `missing_lastseen` varchar(255) NOT NULL,
  `missing_details` text NOT NULL,
  `looking_name` varchar(80) NOT NULL,
  `looking_phone` varchar(20) NOT NULL,
  `looking_email` varchar(80) NOT NULL,
  PRIMARY KEY  (`missingid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `organization`
--

CREATE TABLE IF NOT EXISTS `organization` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `organization_name` varchar(255) default NULL,
  `organization_description` longtext,
  `organization_website` varchar(255) default NULL,
  `organization_email` varchar(120) default NULL,
  `organization_phone1` varchar(50) default NULL,
  `organization_phone2` varchar(50) default NULL,
  `organization_address` varchar(255) default NULL,
  `organization_country` varchar(100) default NULL,
  `organization_active` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `organization_incident`
--

CREATE TABLE IF NOT EXISTS `organization_incident` (
  `organization_id` bigint(20) default NULL,
  `incident_id` bigint(20) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `page`
--

CREATE TABLE IF NOT EXISTS `page` (
  `id` int(11) NOT NULL auto_increment,
  `page_title` varchar(255) NOT NULL,
  `page_description` longtext,
  `page_tab` varchar(100) NOT NULL,
  `page_active` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pending_users`
--

CREATE TABLE IF NOT EXISTS `pending_users` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `key` varchar(32) NOT NULL,
  `email` varchar(127) NOT NULL,
  `username` varchar(31) NOT NULL default '',
  `password` char(50) default NULL,
  `created` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE IF NOT EXISTS `rating` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) default NULL,
  `comment_id` bigint(20) default NULL,
  `rating` tinyint(4) default '0',
  `rating_ip` varchar(100) default NULL,
  `rating_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `reporter`
--

CREATE TABLE IF NOT EXISTS `reporter` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) default NULL,
  `location_id` bigint(20) default NULL,
  `user_id` int(11) default NULL,
  `service_id` int(11) default NULL,
  `level_id` int(11) default NULL,
  `service_userid` varchar(255) default NULL,
  `service_account` varchar(255) default NULL,
  `reporter_first` varchar(200) default NULL,
  `reporter_last` varchar(200) default NULL,
  `reporter_email` varchar(120) default NULL,
  `reporter_phone` varchar(60) default NULL,
  `reporter_ip` varchar(50) default NULL,
  `reporter_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `roles_users`
--

CREATE TABLE IF NOT EXISTS `roles_users` (
  `user_id` int(11) unsigned NOT NULL,
  `role_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `scheduler`
--

CREATE TABLE IF NOT EXISTS `scheduler` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `scheduler_name` varchar(100) NOT NULL,
  `scheduler_last` int(10) unsigned NOT NULL default '0',
  `scheduler_weekday` smallint(6) NOT NULL default '-1',
  `scheduler_day` smallint(6) NOT NULL default '-1',
  `scheduler_hour` smallint(6) NOT NULL default '-1',
  `scheduler_minute` smallint(6) NOT NULL,
  `scheduler_controller` varchar(100) NOT NULL,
  `scheduler_active` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `scheduler_log`
--

CREATE TABLE IF NOT EXISTS `scheduler_log` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `scheduler_id` int(11) NOT NULL,
  `scheduler_name` varchar(100) NOT NULL,
  `scheduler_status` varchar(20) default NULL,
  `scheduler_date` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE IF NOT EXISTS `service` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `service_name` varchar(100) default NULL,
  `service_description` varchar(255) default NULL,
  `service_url` varchar(255) default NULL,
  `service_api` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(40) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL,
  `data` text NOT NULL,
  PRIMARY KEY  (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `site_name` varchar(255) default NULL,
  `site_tagline` varchar(255) default NULL,
  `site_email` varchar(120) default NULL,
  `site_key` varchar(100) default NULL,
  `site_language` varchar(10) NOT NULL default 'en_US',
  `site_style` varchar(50) NOT NULL default 'default',
  `site_timezone` varchar(80) default NULL,
  `site_contact_page` tinyint(4) NOT NULL default '1',
  `site_help_page` tinyint(4) NOT NULL default '1',
  `allow_reports` tinyint(4) NOT NULL default '1',
  `allow_comments` tinyint(4) NOT NULL default '1',
  `allow_feed` tinyint(4) NOT NULL default '1',
  `allow_stat_sharing` tinyint(4) NOT NULL default '1',
  `allow_clustering` tinyint(4) NOT NULL default '1',
  `default_map` tinyint(4) NOT NULL default '1' COMMENT '1 - GOOGLE MAPS, 2 - LIVE MAPS, 3 - YAHOO MAPS, 4 - OPEN STREET MAPS',
  `default_map_all` varchar(20) NOT NULL default 'CC0000',
  `api_google` varchar(200) default NULL,
  `api_yahoo` varchar(200) default NULL,
  `api_live` varchar(200) default NULL,
  `api_akismet` varchar(200) default NULL,
  `default_country` int(11) default NULL,
  `multi_country` tinyint(4) NOT NULL default '0',
  `default_city` varchar(150) default NULL,
  `default_lat` varchar(100) default NULL,
  `default_lon` varchar(100) default NULL,
  `default_zoom` tinyint(4) NOT NULL default '10',
  `items_per_page` smallint(6) NOT NULL default '20',
  `items_per_page_admin` smallint(6) NOT NULL default '20',
  `sms_no1` varchar(100) default NULL,
  `sms_no2` varchar(100) default NULL,
  `sms_no3` varchar(100) default NULL,
  `frontlinesms_key` varchar(30) default NULL,
  `clickatell_api` varchar(30) default NULL,
  `clickatell_username` varchar(100) default NULL,
  `clickatell_password` varchar(100) default NULL,
  `google_analytics` text,
  `twitter_hashtags` text,
  `twitter_username` varchar(50) default NULL,
  `twitter_password` varchar(50) default NULL,
  `laconica_username` varchar(50) default NULL,
  `laconica_password` varchar(50) default NULL,
  `laconica_site` varchar(30) default NULL COMMENT 'a laconica site',
  `date_modify` datetime default NULL,
  `stat_id` bigint(20) default NULL COMMENT 'comes from centralized stats',
  `stat_key` varchar(30) NOT NULL,
  `email_username` varchar(100) NOT NULL,
  `email_password` varchar(100) NOT NULL,
  `email_port` int(11) NOT NULL,
  `email_host` varchar(100) NOT NULL,
  `email_servertype` varchar(100) NOT NULL,
  `email_ssl` int(5) NOT NULL,
  `email_smtp` tinyint(4) NOT NULL default '0',
  `email_smtp_username` varchar(100) NOT NULL,
  `email_smtp_password` varchar(100) NOT NULL,
  `email_port_smtp` int(11) default NULL,
  `email_host_smtp` varchar(100) default NULL,
  `alerts_email` varchar(120) NOT NULL,
  `alerts_username` varchar(100) default NULL,
  `alerts_password` varchar(100) default NULL,
  `alerts_port` int(11) default NULL,
  `alerts_host` varchar(100) default NULL,
  `alerts_servertype` varchar(100) default NULL,
  `alerts_ssl` tinyint(4) default NULL,
  `georss_feed` varchar(200) default NULL,
  `db_version` varchar(20) default NULL,
  `ushahidi_version` varchar(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sharing`
--

CREATE TABLE IF NOT EXISTS `sharing` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `sharing_type` tinyint(4) default '1' COMMENT '1 - PULLing Data, 2 - PUSHing Data, 3 - TWO way',
  `sharing_limits` tinyint(4) NOT NULL default '1' COMMENT '1 - Once Per Hour, 2 - Once Every 6 Hours, 3 - Once Every 12 Hours, 4 - Once Daily',
  `sharing_color` varchar(20) default NULL,
  `sharing_site_name` varchar(255) default NULL,
  `sharing_email` varchar(255) default NULL,
  `sharing_url` varchar(255) default NULL,
  `sharing_key` varchar(50) default NULL,
  `sharing_ushahidi` tinyint(4) NOT NULL default '1',
  `sharing_report` tinyint(4) NOT NULL default '1',
  `sharing_media` tinyint(4) NOT NULL default '1',
  `sharing_category` tinyint(4) NOT NULL default '1',
  `sharing_personaldata` tinyint(4) NOT NULL default '0',
  `sharing_active` tinyint(4) NOT NULL default '0',
  `sharing_date` datetime NOT NULL,
  `sharing_dateaccess` int(10) unsigned default '0',
  PRIMARY KEY  (`id`),
  KEY `sharing_key` (`sharing_key`),
  KEY `sharing_url` (`sharing_url`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sharing_log`
--

CREATE TABLE IF NOT EXISTS `sharing_log` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `sharing_id` int(11) NOT NULL,
  `sharing_log_date` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `twitter`
--

CREATE TABLE IF NOT EXISTS `twitter` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` int(11) default '0',
  `tweet_from` varchar(100) default NULL,
  `tweet_to` varchar(100) default NULL,
  `tweet_hashtag` varchar(50) default NULL,
  `tweet_link` varchar(100) default NULL,
  `tweet` varchar(255) default NULL,
  `tweet_type` tinyint(4) default '1' COMMENT '1 - INBOX, 2 - OUTBOX (From Admin)',
  `tweet_date` datetime default NULL,
  `hide` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(200) default NULL,
  `email` varchar(127) NOT NULL,
  `username` varchar(31) NOT NULL default '',
  `password` char(50) NOT NULL,
  `logins` int(10) unsigned NOT NULL default '0',
  `last_login` int(10) unsigned default NULL,
  `notify` tinyint(1) NOT NULL default '0' COMMENT 'Flag incase admin opts in for email notifications',
  `updated` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE IF NOT EXISTS `user_tokens` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(32) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `verified`
--

CREATE TABLE IF NOT EXISTS `verified` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `incident_id` bigint(20) default NULL,
  `idp_id` bigint(20) default NULL,
  `user_id` int(11) default NULL,
  `verified_comment` longtext,
  `verified_date` datetime default NULL,
  `verified_status` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Table structure for table `api_banned`
--

CREATE TABLE IF NOT EXISTS `api_banned` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `banned_ipaddress` varchar(50) NOT NULL,
  `banned_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='For logging banned API IP addresses' AUTO_INCREMENT=8 ;


--
-- Table structure for table `api_log`
--

CREATE TABLE IF NOT EXISTS `api_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `api_task` varchar(10) NOT NULL,
  `api_parameters` varchar(50) NOT NULL,
  `api_records` tinyint(11) NOT NULL,
  `api_ipaddress` varchar(50) NOT NULL,
  `api_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='For logging API activities' AUTO_INCREMENT=19 ;

--
-- Dumping data for table `api_log`
--

--
-- Constraints for table `roles_users`
--
ALTER TABLE `roles_users`
  ADD CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

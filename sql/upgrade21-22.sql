ALTER TABLE `incident` ADD `incident_action_taken` TINYINT NOT NULL DEFAULT '0',
ADD `incident_action_summary` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL ;

UPDATE `settings` SET `db_version` = '22' WHERE `id` =1 LIMIT 1 ;

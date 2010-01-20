ALTER TABLE `incident` CHANGE `incident_action_summary` `incident_action_summary` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL ;

UPDATE `settings` SET `db_version` = '23' WHERE `id` =1 LIMIT 1 ;

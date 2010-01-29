<?php defined('SYSPATH') or die('No direct script access.');

// Set Timezone
date_default_timezone_set('America/New_York');

/**
* Default Settings From Database
*/

// Retrieve Cached Settings
$cache = Cache::instance();
$settings = $cache->get('settings');
if ($settings == NULL)
{ // Cache is Empty so Re-Cache
	$settings = ORM::factory('settings', 1);
	$cache->set('settings', $settings, array('settings'), 604800); // 1 Week
}

// Set Site Language
Kohana::config_set('locale.language', $settings->site_language);

// Main Site Settings
Kohana::config_set('settings.site_name', $settings->site_name);
Kohana::config_set('settings.site_email', $settings->site_email);
Kohana::config_set('settings.site_tagline', $settings->site_tagline);
Kohana::config_set('settings.site_style', $settings->site_style);
Kohana::config_set('settings.site_contact_page', $settings->site_contact_page);
Kohana::config_set('settings.site_help_page', $settings->site_help_page);
Kohana::config_set('settings.allow_feed', $settings->allow_feed);
Kohana::config_set('settings.allow_stat_sharing', $settings->allow_stat_sharing);
Kohana::config_set('settings.allow_clustering', $settings->allow_clustering);
Kohana::config_set('settings.sms_no1', $settings->sms_no1);
Kohana::config_set('settings.sms_no2', $settings->sms_no2);
Kohana::config_set('settings.sms_no3', $settings->sms_no3);
Kohana::config_set('settings.default_map', $settings->default_map);
Kohana::config_set('settings.default_map_all', $settings->default_map_all);
Kohana::config_set('settings.api_google', $settings->api_google);
Kohana::config_set('settings.api_yahoo', $settings->api_yahoo);
Kohana::config_set('settings.api_akismet', $settings->api_akismet);
Kohana::config_set('settings.default_city', $settings->default_city);
Kohana::config_set('settings.default_country', $settings->default_country);
Kohana::config_set('settings.multi_country', $settings->multi_country);
Kohana::config_set('settings.default_lat', $settings->default_lat);
Kohana::config_set('settings.default_lon', $settings->default_lon);
Kohana::config_set('settings.default_zoom', $settings->default_zoom);
Kohana::config_set('settings.items_per_page', $settings->items_per_page);
Kohana::config_set('settings.items_per_page_admin', $settings->items_per_page_admin);
Kohana::config_set('settings.google_analytics', $settings->google_analytics);
Kohana::config_set('settings.twitter_hashtags', $settings->twitter_hashtags);
Kohana::config_set('settings.email_smtp', $settings->email_smtp);
Kohana::config_set('settings.email_username', $settings->email_username);
Kohana::config_set('settings.email_password', $settings->email_password);
Kohana::config_set('settings.email_port', $settings->email_port);
Kohana::config_set('settings.email_host', $settings->email_host);
Kohana::config_set('settings.email_servertype', $settings->email_servertype);
Kohana::config_set('settings.email_ssl', $settings->email_ssl);
Kohana::config_set('settings.alerts_email', $settings->alerts_email);


// Email Settings
if ($settings->email_smtp)
{ // Configure SMTP Settings
	Kohana::config_set('email.driver', 'smtp');
	Kohana::config_set('email.options',
		 array(
			'hostname'=>$settings->email_host_smtp, 
			'port'=>$settings->email_port_smtp, 
			'username'=>$settings->email_smtp_username, 
			'password'=>$settings->email_smtp_password
			//'encryption' => 'tls'	// Secure
		));
}


$default_map = $settings->default_map;
$api_google = $settings->api_google;
$api_yahoo = $settings->api_yahoo;

// Google/OSM/MapBOX Combo
Kohana::config_set('settings.api_url', '<script src="http://maps.google.com/maps?file=api&v=2&key=' . $api_google . '" type="text/javascript"></script><script src="http://www.openstreetmap.org/openlayers/OpenStreetMap.js"></script><script src="http://js.mapbox.com/ol/2.8/mapbox.js" type="text/javascript"></script>');

// And in case you want to display all maps on one page...
Kohana::config_set('settings.api_url_all', '<script src="http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6"></script><script type="text/javascript" src="http://api.maps.yahoo.com/ajaxymap?v=3.0&appid=' . $api_yahoo . '"></script><script src="http://maps.google.com/maps?file=api&v=2&key=' . $api_google . '" type="text/javascript"></script>'.html::script('media/js/OpenStreetMap'));

// Additional Mime Types (KMZ/KML)
Kohana::config_set('mimes.kml', array('text/xml'));
Kohana::config_set('mimes.kmz', array('text/xml'));
<?php defined('SYSPATH') or die('No direct script access.');
/**
 * Json Controller
 * Generates Map GeoJSON File
 *
 * PHP version 5
 * LICENSE: This source file is subject to LGPL license 
 * that is available through the world-wide-web at the following URI:
 * http://www.gnu.org/copyleft/lesser.html
 * @author     Ushahidi Team <team@ushahidi.com> 
 * @package    Ushahidi - http://source.ushahididev.com
 * @module     JSON Controller  
 * @copyright  Ushahidi - http://www.ushahidi.com
 * @license    http://www.gnu.org/copyleft/lesser.html GNU Lesser General Public License (LGPL) 
 */

class Json_Cluster_Controller extends Template_Controller
{
    public $auto_render = TRUE;

	// Cache this controller
	public $is_cachable = TRUE;

    // Main template
    public $template = 'json';

	public function __construct()
	{
		parent::__construct();
		
		set_time_limit(60);
	}
	
	public function index()
    {
		// Database
		$db = new Database();
		
		$cache = "";
		$json = "";
        $json_item = "";
        $json_array = array();

		$color = Kohana::config('settings.default_map_all');
		$icon = "";
		
		// Get Zoom Level
		$zoomLevel = (isset($_GET['z']) && !empty($_GET['z'])) ?
			$_GET['z'] : 8;
			
		$distance = (10000000 >> $zoomLevel) / 100000;	
		
		// Category ID
		$category_id = (isset($_GET['c']) && !empty($_GET['c']) && 
			is_numeric($_GET['c']) && $_GET['c'] != 0) ?
			$_GET['c'] : 0;
		
		// Start Date
		$start_date = (isset($_GET['s']) && !empty($_GET['s'])) ?
			$_GET['s'] : "0";
		
		// End Date
		$end_date = (isset($_GET['e']) && !empty($_GET['e'])) ?
			$_GET['e'] : "0";
			
		// SouthWest Bound
		$southwest = (isset($_GET['sw']) && !empty($_GET['sw'])) ?
			$_GET['sw'] : "0";
		
		$northeast = (isset($_GET['ne']) && !empty($_GET['ne'])) ?
			$_GET['ne'] : "0";			
			
		$filter = "";
		$filter .= ($category_id !=0) ? " AND ( category.id=".$category_id
			." OR category.parent_id=".$category_id.") " : "";
		$filter .= ($start_date && $end_date) ? 
			" AND incident.incident_date >= '" . date("Y-m-d H:i:s", $start_date) . "'".
			" AND incident.incident_date <= '" . date("Y-m-d H:i:s", $end_date) . "'" : "";
			
		if ($southwest && $northeast)
		{
			list($latitude_min, $longitude_min) = explode(',', $southwest);
			list($latitude_max, $longitude_max) = explode(',', $northeast);
			
			$filter .= " AND location.latitude >=".$latitude_min.
				" AND location.latitude <=".$latitude_max;
			$filter .= " AND location.longitude >=".$longitude_min.
				" AND location.longitude <=".$longitude_max;
		}
		
		if ($category_id > 0)
		{
			$query_cat = $db->query("SELECT `category_color`, `category_image` FROM `category` WHERE id=$category_id");
			foreach ($query_cat as $cat)
			{
				$color = $cat->category_color;
				$icon = $cat->category_image;
			}
		}
		
		
		// Do we have Database cached JSON?
		$query_json = $db->query("SELECT `json` FROM `json` WHERE zoom=$zoomLevel AND category_id=$category_id AND 
			start_date=$start_date AND end_date=$end_date AND southwest='$southwest' AND northeast='$northeast'");
		
		foreach ($query_json as $json_cache)
		{
			$cache = $json_cache->json;
		}
		
		// Cache exists
		if ($cache)
		{
			$json = $cache;
		}
		else
		{ // No Cache
			
	//		$query = ORM::factory('incident')
	//			->select('incident.*, location.latitude, location.longitude, incident_category.category_id')
	//			->join('location', 'location.id', 'incident.location_id','INNER')
	//			->join('incident_category', 'incident.id', 'incident_category.incident_id','INNER')
	//			->join('category', 'category.id', 'incident_category.category_id','INNER')
	//			->where('incident.incident_active=1'.$filter)
	//			->find_all();

			$query = $db->query("SELECT DISTINCT `incident`.id, `location`.`latitude`, `location`.`longitude` FROM `incident` INNER JOIN `location` ON (`location`.`id` = `incident`.`location_id`) INNER JOIN `incident_category` ON (`incident`.`id` = `incident_category`.`incident_id`) INNER JOIN `category` ON (`incident_category`.`category_id` = `category`.`id`) WHERE incident.incident_active=1 $filter ORDER BY `incident`.`id` ASC ");	
			$query->result(FALSE, MYSQL_ASSOC);
	//		echo count($query);

			//*** There has to be a more efficient way to do this than to
			// create a whole other array - to be examined later
			$markers = array();
			foreach ($query as $row)
			{
				$markers[] = $row;
			}

			$clusters = array();	// Clustered
			$singles = array();		// Non Clustered

			// Loop until all markers have been compared
			while (count($markers))
			{
				$marker  = array_pop($markers);
				$cluster = array();

				// Compare marker against all remaining markers.
				foreach ($markers as $key => $target)
				{
					// This function returns the distance between two markers, at a defined zoom level.
					$pixels = abs($marker['longitude']-$target['longitude']) + 
						abs($marker['latitude']-$target['latitude']);
					// echo $pixels."<BR>";
					// If two markers are closer than defined distance, remove compareMarker from array and add to cluster.
					if ($pixels < $distance)
					{
						unset($markers[$key]);
						$cluster[] = $target;
					}
				}

				// If a marker was added to cluster, also add the marker we were comparing to.
				if (count($cluster) > 0)
				{
					$cluster[] = $marker;
					$clusters[] = $cluster;
				}
				else
				{
					$singles[] = $marker;
				}
			}

			//print_r($clusters);
			//print_r($singles);

			// Create Json
			foreach ($clusters as $cluster)
			{
				// Calculate cluster center
				$cluster_center = $this->_calculateCenter($cluster);
				
				// Save Cluster to DB
				$cluster_latlon = explode(",", $cluster_center);
				$save_cluster = ORM::factory('cluster');
				$save_cluster->latitude = $cluster_latlon[1];
				$save_cluster->longitude = $cluster_latlon[0];
				$save_cluster->cluster_count = count($cluster);
				$save_cluster->save();
				
				// Link Incident to This Cluster
				foreach ($cluster as $marker)
				{				
					$save_marker = ORM::factory('cluster_incident');
					$save_marker->cluster_id = $save_cluster->id;
					$save_marker->incident_id = $marker['id'];
					$save_marker->save();
				}

				$json_item = "{";
			    $json_item .= "\"type\":\"Feature\",";
			    $json_item .= "\"properties\": {";
				$json_item .= "\"name\":\"" . str_replace(chr(10), ' ', str_replace(chr(13), ' ', "<a href=" . url::base() . "reports/index/". $save_cluster->id ."/>" . count($cluster) . " Reports</a>")) . "\",";			
			    $json_item .= "\"category\":[0], ";
				$json_item .= "\"color\": \"".$color."\", ";
				$json_item .= "\"icon\": \"".$icon."\", \n";
			    $json_item .= "\"timestamp\": \"0\", ";
				$json_item .= "\"count\": \"" . count($cluster) . "\"";
			    $json_item .= "},";
			    $json_item .= "\"geometry\": {";
			    $json_item .= "\"type\":\"Point\", ";
			    $json_item .= "\"coordinates\":[" . $cluster_center . "]";
			    $json_item .= "}";
			    $json_item .= "}";

			    array_push($json_array, $json_item);
			}

			foreach ($singles as $single)
			{
				$json_item = "{";
			    $json_item .= "\"type\":\"Feature\",";
			    $json_item .= "\"properties\": {";
				$json_item .= "\"name\":\"" . str_replace(chr(10), ' ', str_replace(chr(13), ' ', "<a href=" . url::base() . "reports/view/" . $marker['id'] . "/>1 Report</a>")) . "\",";	
			    $json_item .= "\"category\":[0], ";
				$json_item .= "\"color\": \"".$color."\", ";
				$json_item .= "\"icon\": \"".$icon."\", \n";
			    $json_item .= "\"timestamp\": \"0\", ";
				$json_item .= "\"count\": \"" . 1 . "\"";
			    $json_item .= "},";
			    $json_item .= "\"geometry\": {";
			    $json_item .= "\"type\":\"Point\", ";
			    $json_item .= "\"coordinates\":[" . $single['longitude'] . ", " . $single['latitude'] . "]";
			    $json_item .= "}";
			    $json_item .= "}";

			    array_push($json_array, $json_item);
			}

			$json = implode(",", $json_array);

			// Cache JSON results
			$db->query("INSERT INTO `json` (`json`,`zoom`,`category_id`,`start_date`,`end_date`,`southwest`,`northeast`)
			 	VALUES ('$json', '$zoomLevel', '$category_id', '$start_date', '$end_date', '$southwest', '$northeast') ");
		}

		//header('Content-type: application/json');
		$this->template->json = $json;
		
	}
	
	
	/* Retrieve Single Marker */
	public function single($incident_id = 0)
	{
		$json = "";
		$json_item = "";
		$json_array = array();	
		
		
		$marker = ORM::factory('incident')
			->where('id', $incident_id)
			->find();
			
		if ($marker->loaded)
		{
			/* First We'll get all neighboring reports */
			$incident_date = date('Y-m', strtotime($marker->incident_date));
			$latitude = $marker->location->latitude;
			$longitude = $marker->location->longitude;
			
			$filter = " AND incident.incident_date LIKE '$incident_date%' ";
			$filter .= " AND incident.id <>".$marker->id;
			
			// Database
			$db = new Database();
			
			// Get Neighboring Markers From The Same Month Within A Mile
			$query = $db->query("SELECT DISTINCT `incident`.*, `location`.`latitude`, `location`.`longitude`, 
			((ACOS(SIN($latitude * PI() / 180) * SIN(`location`.`latitude` * PI() / 180) + COS($latitude * PI() / 180) * COS(`location`.`latitude` * PI() / 180) * COS(($longitude - `location`.`longitude`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance 
			 FROM `incident` INNER JOIN `location` ON (`location`.`id` = `incident`.`location_id`) INNER JOIN `incident_category` ON (`incident`.`id` = `incident_category`.`incident_id`) INNER JOIN `category` ON (`incident_category`.`category_id` = `category`.`id`) WHERE incident.incident_active=1 $filter 
			HAVING distance<='1'
			 ORDER BY `incident`.`id` ASC ");
			
			foreach ($query as $row)
			{
				$json_item = "{";
	            $json_item .= "\"type\":\"Feature\",";
	            $json_item .= "\"properties\": {";
				$json_item .= "\"id\": \"".$row->id."\", \n";
	            $json_item .= "\"name\":\"" . str_replace(chr(10), ' ', str_replace(chr(13), ' ', "<a href='" . url::base() . "reports/view/" . $row->id . "'>" . htmlentities($row->incident_title) . "</a>")) . "\",";
				$json_item .= "\"category\":[0], ";
	            $json_item .= "\"timestamp\": \"" . strtotime($row->incident_date) . "\"";
	            $json_item .= "},";
	            $json_item .= "\"geometry\": {";
	            $json_item .= "\"type\":\"Point\", ";
	            $json_item .= "\"coordinates\":[" . $row->longitude . ", " . $row->latitude . "]";
	            $json_item .= "}";
	            $json_item .= "}";
	
				array_push($json_array, $json_item);
			}
			
			$json_item = "{";
            $json_item .= "\"type\":\"Feature\",";
            $json_item .= "\"properties\": {";
			$json_item .= "\"id\": \"".$marker->id."\", \n";
            $json_item .= "\"name\":\"" . str_replace(chr(10), ' ', str_replace(chr(13), ' ', "<a href='" . url::base() . "reports/view/" . $marker->id . "'>" . htmlentities($marker->incident_title) . "</a>")) . "\",";
			$json_item .= "\"category\":[0], ";
            $json_item .= "\"timestamp\": \"" . strtotime($marker->incident_date) . "\"";
            $json_item .= "},";
            $json_item .= "\"geometry\": {";
            $json_item .= "\"type\":\"Point\", ";
            $json_item .= "\"coordinates\":[" . $marker->location->longitude . ", " . $marker->location->latitude . "]";
            $json_item .= "}";
            $json_item .= "}";

			array_push($json_array, $json_item);
		}
		
		
		$json = implode(",", $json_array);
		
		//header('Content-type: application/json');
		$this->template->json = $json;
	}
	
	
	public function timeline()
	{
        $this->auto_render = FALSE;
        $this->template = new View('json/timeline');
        //$this->template->content = new View('json/timeline');
        
        $interval = 'day';
        $start_date = NULL;
        $end_date = NULL;
        $active = 'true';
        if (isset($_GET['i'])) {
            $interval = $_GET['i'];
        }
        if (isset($_GET['s'])) {
            $start_date = $_GET['s'];
        }
        if (isset($_GET['e'])) {
            $end_date = $_GET['e'];
        }
        if (isset($_GET['active'])) {
            $active = $_GET['active'];
        }
        
        // get graph data
        $graph_data = array();
        $all_graphs = Incident_Model::get_incidents_by_interval($interval,$start_date,$end_date,$active);
	    echo $all_graphs;
   	}

	/* Read the Layer IN via file_get_contents */
	public function layer($layer_id = 0)
	{
		$this->template = "";
		$this->auto_render = FALSE;
		
		$layer = ORM::factory('layer')
			->where('layer_visible', 1)
			->find($layer_id);
		
		if ($layer->loaded)
		{
			$layer_url = $layer->layer_url;
			$layer_file = $layer->layer_file;
			
			$layer_link = (!$layer_url) ?
				url::base().'media/uploads/'.$layer_file :
				$layer_url;
			
			$content = file_get_contents($layer_url);
			
			if ($content !== false)
			{
				echo $content;
			}
			else
			{
				echo "";
			}
		}
		else
		{
			echo "";
		}
	}
	
	
	private function _pixelDistance($lat1, $lon1, $lat2, $lon2, $zoom)
	{
		$x1 = $lon1;
		$y1 = $lat1;
		$x2 = $lon2;
		$y2 = $lat2;

		//return sqrt(pow(($x1-$x2),2) + pow(($y1-$y2),2)) >> (21 - $zoom); //21 is the max zoom level
		return ($x1-$x2) + ($y1-$y2) >> (21 - $zoom);
		
//	    $x1 = $lon1;
//	    $y1 = $lat1;
//	    $x2 = $lon2;
//	    $y2 = $lat2;
//
//		return sqrt(pow(($x1-$x2),2) + pow(($y1-$y2),2)) >> (21 - $zoom); //21 is the max zoom level
	}
	
	
    private function _calculateCenter($cluster)
	{
        // Calculate average lat and lon of clustered items
        $lat_sum = $lon_sum = 0;
        foreach ($cluster as $marker)
		{
			$lat_sum += $marker['latitude'];
			$lon_sum += $marker['longitude'];
        }
		$lat_avg = $lat_sum / count($cluster);
		$lon_avg = $lon_sum / count($cluster);
		
		return $lon_avg.", ".$lat_avg;
    }
	
	
}
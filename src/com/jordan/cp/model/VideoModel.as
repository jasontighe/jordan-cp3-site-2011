package com.jordan.cp.model {
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.dto.VideoDTO;
	import com.jordan.cp.players.TimeTracker;

	import mx.collections.ArrayCollection;

	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;

	/**
	 * @author jason.tighe
	 */
	public class VideoModel extends EventDispatcher 
	{
		protected var _sampleDTO : VideoDTO;
		protected var _vids : Dictionary;
		protected var _nc : NetConnection;

		private var _allVideos : Array;
		private var _scenes : Array;
		private var _speeds : Array;
		private var _cams : Array;


		public function VideoModel()
		{
			setup();
		}

		private function setup() : void 
		{
			_allVideos = new Array();
			_scenes = new Array();
			_speeds = new Array();
			_cams = new Array();
		}

		public function addToArray(arrayCollection : ArrayCollection) : void 
		{
			var scene : String;
			var speed : String;
			var cam : String;
			var dto : VideoDTO;
			var i : uint = 0;
			var I : uint = arrayCollection.length;
			for( i;i < I;i++ )
			{
				dto = new VideoDTO(arrayCollection.getItemAt(i) as Object);
//				trace("VideoModel.addToArray(arrayCollection) : dto:", this, (dto));
				_allVideos.push(dto);

				scene = dto.name.split('_')[1];
				speed = dto.name.split('_')[2];
				cam = dto.name.split('_')[3];

				if(_scenes.indexOf(scene) == -1) _scenes.push(scene);
				if(_speeds.indexOf(speed) == -1) _speeds.push(speed);
				if(_cams.indexOf(cam) == -1) _cams.push(cam);
			}			
		}

		public function organize() : void
		{
			// DICTIONARY TIERS
			// 1 - SCENE
			// 2 - SPEEDS
			// 3 - CAMERAS
			// 4 - DTOS

			_vids = new Dictionary();

			var definitions : Array = [TimeTracker.LOW_DEF, TimeTracker.HIGH_DEF];
			var scenesD : Dictionary;
			var speedsD : Dictionary;
			var camerasD : Dictionary;
			var currDef : String;
			var currScene : String;
			var currSpeed : String;
			var currCam : String;
			
			for each( var def : String in definitions)
			{
				scenesD = new Dictionary();
				
				for each( var scene : String in _scenes)
				{
					speedsD = new Dictionary();
	
					for each( var speed : String in _speeds)
					{
						camerasD = new Dictionary();
	
						for each( var cam : String in _cams)
						{
							for each( var dto : VideoDTO in _allVideos)
							{
								currDef = (dto.name.indexOf(TimeTracker.LOW_DEF) > -1 ) ? TimeTracker.LOW_DEF : TimeTracker.HIGH_DEF;
								currScene = dto.name.split('_')[1];
								currSpeed = dto.name.split('_')[2];
								currCam = dto.name.split('_')[3];
	
								
								if(currDef == def && currScene == scene && currSpeed == speed && currCam == cam)
								{
									camerasD[cam] = dto;
								}
							}
							
						}
						speedsD[speed] = camerasD;
					}
					scenesD[scene] = speedsD;
				}
				_vids[def] = scenesD;
			}


		 	sampleDTO = _allVideos[0] as VideoDTO;


//			for (var i : String in scenesD) {
//				trace('VIDEOMODEL : organize() : SCENES :', i);
//			}	
//			for (i in speedsD) {
//				trace('VIDEOMODEL : organize() : SPEEDS :', i);
//			}	
//			for (i in camerasD) {
//				trace('VIDEOMODEL : organize() : CAMERAS :', i, VideoDTO(camerasD[i]).flvUrl);
//			}	
		}

		public function dispose() : void
		{
			// TODO - DISPOSE OF DICTIONARY
//			for(var key : String in _scenes)
//			{
//				
//			}
		}

		
		//-------------------------------------------------------------------------
		//
		// SEARCH METHODS
		//
		//-------------------------------------------------------------------------
		public function getCamCount(currentScene : String) : uint 
		{
			var scene : Dictionary = _vids[TimeTracker.gi.def][currentScene]['f024'];
			var count : uint;
			
			for(var key : Object in scene)
			{
				trace('key: ' + (key));
				count++;
			}
			
			return count;
		}
		
		public function getAssetPath(i : Number, speed : String = '', scene : String = '') : String 
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
			var tt : TimeTracker = TimeTracker.gi;

			if(speed == '') speed = tt.currentSpeed;
			if(scene == '') scene = tt.currentScene;

			var cam : String = (i < 10) ? 'c0' + i.toString() : 'c' + i.toString();
//			trace("VideoModel.getAssetPath(i, speed, scene) : cam:", this, (cam));
//			trace("VideoModel.getAssetPath(i, speed, scene) : videosD[TimeTracker.gi.def]:", this, (videosD[TimeTracker.gi.def]));
//			trace("VideoModel.getAssetPath(i, speed, scene) : speed: " + (speed));
//			trace("VideoModel.getAssetPath(i, speed, scene) : scene: " + (scene));
//			trace("VideoModel.getAssetPath(i, speed, scene) : TimeTracker.gi.def: " + (TimeTracker.gi.def));
			
			// FORCE HIDEF FOR LANDING VIDEO
			var def : String = (scene == SiteConstants.LANDING) ? TimeTracker.HIGH_DEF : TimeTracker.gi.def;
			var url : String = videosD[def][scene][speed][cam].flvUrl;
//			trace("VideoModel.getAssetPath(i, speed, scene) : url:", this, (url));
			var base : String = url.substring(0, url.indexOf('&'));
			var asset : String = url.split('?')[0].substr(base.length + 1);
			
//			for(var key : String in videosD[TimeTracker.gi.def][tt.currentScene])
//			{
//				trace('Scene : speeds : ', key);
//			}

//			for(var cnt : uint = 0; cnt < 9; cnt++)
//			{
//				var camTest : String = (cnt < 10) ? 'c0' + cnt.toString() : 'c' + cnt.toString();
//				trace('Speed : cameras : ', camTest, videosD[TimeTracker.gi.def][tt.currentScene][tt.currentSpeed][camTest].flvUrl);
//			}

			return asset;
		}	

		public function getFwdSpeeds() : Array
		{
			var tt : TimeTracker = TimeTracker.gi;
			var speeds : Array = new Array();
			for(var key : String in videosD[TimeTracker.gi.def][tt.currentScene])
			{
				if(key.indexOf('f') > -1) speeds.push(key);
			}
			
			speeds.sort();
			speeds.reverse();
			return speeds;
		}

		public function getRevSpeeds() : Array
		{
			var tt : TimeTracker = TimeTracker.gi;
			var speeds : Array = new Array();
			for(var key : String in videosD[TimeTracker.gi.def][tt.currentScene])
			{
				if(key.indexOf('r') > -1) speeds.push(key);
			}
			
			speeds.sort();
			return speeds;
		}


		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function get sampleDTO():VideoDTO
		{
			return _sampleDTO;
		}
		
		public function set sampleDTO(value:VideoDTO):void
		{
			_sampleDTO = value;
		}
		
		public function get videosD() : Dictionary 
		{
			return _vids;
		}
		
		public function get nc():NetConnection
		{
			return _nc;
		}
		
		public function set nc(value:NetConnection):void
		{
			_nc = value;
		}
		
		public function getLandingUrl() : String
		{
			var url : String = getAssetPath( 0, "f024", SiteConstants.LANDING );
			trace( "VideoModel.getLandingUrl.url: " + url );
			if(url.indexOf('_lowdef') > -1) url = url.split('_lowdef')[0] + url.split('_lowdef')[1];
			trace( "VideoModel.getLandingUrl.url: AFTER : " + url );
			return url;
		}
		
		public function getIntroUrl() : String
		{
			var url : String = getAssetPath( 0, "f024", SiteConstants.INTRO );
			return url;
		}
		
		public function getBlondUrl() : String
		{
			var url : String = getAssetPath( 0, "f024", SiteConstants.VIGNETTE_BLOND );
			return url;
		}
		
		public function getUrlByName( name : String ) : String
		{
			trace( "VIDEOMODEL : getUrlByName() : name is "+name );
			var url : String = getAssetPath( 0, "f024", name );
			return url;
		}


	}
}

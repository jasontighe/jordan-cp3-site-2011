package com.jordan.cp.model 
{
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipLibrary;

	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.players.StreamSwapper;
	import com.jordan.cp.players.TimeTracker;
	import com.plode.framework.events.ParamEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author nelson.shin
	 */



	public final class CameraPannerModel extends EventDispatcher
	{
		private static var _instance: CameraPannerModel;

		private var _scenes : Dictionary;
		private var _bmpCache : Dictionary;
//		private var _lastTimes : Dictionary;
		private var _loadQueue : Array;
		private var _zipQueue : Array;
		private var _transitionQueue : Array;
		private var _isLoading : Boolean;
		private var _inEase : Boolean;

		public static const TRANSITION_ITEM_ADDED : String = "TRANSITION_ITEM_ADDED";
		public static const PAN_COMPLETE : String = 'PAN_COMPLETE';
		private var _zipLib : FZipLibrary;
		private var _isLoaded : Boolean;

		//---------------------------------------------------------------------
		//
		// SINGLETON STUFFS
		//
		//---------------------------------------------------------------------
		public function CameraPannerModel( se : SingletonEnforcerer ) 
		{
			if( se != null ){
				trace("CameraPannerModel.CameraPannerModel(se) : READY");
				init();
			}
		}

		public static function get gi() : CameraPannerModel {
			if( _instance == null ){
				_instance = new CameraPannerModel( new SingletonEnforcerer() );
			}
			return _instance;
		}

		
		//-------------------------------------------------------------------------
		//
		// LOAD ZIP ARCHIVE INTO DICTIONARY
		//
		//-------------------------------------------------------------------------

		// NO LONGER IN USE
		public function load(path : String) : void
		{
			// LORES FULL ARRAY
			path = 'http://cp.dev.nyc.wk.com/player/video/zip/cp_img_array_400x200.zip';
//			path = 'http://c827809.r9.cf2.rackcdn.com/cp_img_array_400x200.zip';

			// HIGHRES AND OVERWEIGHT
//			path = 'http://cp.dev.nyc.wk.com/site/zip/cp_img_array.zip';
//			path = 'http://cp.dev.nyc.wk.com/site/zip/cp_img_array_hi.zip';
			_loadQueue.push(path);

			if(!_isLoading) startLoad();
		}

		// NO LONGER IN USE
		private function startLoad() : void 
		{
			var path : String = _loadQueue.shift();
			var zip : FZip = new FZip();
//			zip.addEventListener(Event.OPEN, onOpen);
			zip.addEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.addEventListener(Event.COMPLETE, onComplete);
			zip.load(new URLRequest(path));
			
			_isLoading = true;
		}

		// NO LONGER IN USE
		private function onProgress(event : ProgressEvent) : void 
		{
			TimeTracker.gi.percentLoaded = Math.round(event.bytesLoaded/event.bytesTotal * 100);
		}

		// NO LONGER IN USE
		private function onComplete(evt : Event) : void 
		{
			var zip : FZip = evt.target as FZip;
			
			parseZip(zip);
		}

		private function parseZip(zip : FZip) : void 
		{
			_zipLib.addZip(zip);

			var len : uint = zip.getFileCount();
			var file : FZipFile;
			var scene : String;
//			var biggestTime : String;

			var items : Array = new Array();
			var times : Array = new Array();

			for ( var i : uint = 0; i < len; i++)
			{
				
				file = zip.getFileAt(i);
				
				var filename : String = file.filename.split('.')[0];
				scene = filename.split('_')[1];
				var time : String = filename.split('_t')[1].split('_c')[0];
//				var ldr : Loader = new Loader();
				var ba : ByteArray;

				if(file.filename.indexOf( '.jpg' ) > -1 || file.filename.indexOf( '.webp' ) > -1)//&& file.filename.indexOf( '__MACOSX' ) == -1)
				{
//					var bmpd : BitmapData = _zipLib.getBitmapData(file.filename);

//					ldr.loadBytes(file.content);
//					items.push({filename: file.filename, bitmap: ldr} );

					ba = file.content;
				}

				if(times.indexOf(time) == -1) times.push(time);
				if(ba) items.push({filename: filename, ba: ba} );
			}

//			biggestTime = times[time.length];
			organize(scene, items, times);
			
			// DISPOSE OF ZIP OBJECT
			zip.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.removeEventListener(Event.COMPLETE, onComplete);
			zip.close();
			zip = null;


			// ADVANCE LOAD QUEUE
			_isLoading = false;
			if(_loadQueue.length == 0 && _zipQueue.length == 0)
			{
				trace('\n\n\n\n\n\n----------------------------------------------------------');
				trace('ZIP LOADED!');
				trace('----------------------------------------------------------\n\n\n\n\n\n');
				_isLoaded = true;
				dispatchEvent(new Event(Event.COMPLETE, true));
			}
			else
			{
				if(_loadQueue.length > 0) startLoad();
				if(_zipQueue.length > 0)
				{
					parseZip(_zipQueue.shift());
				}
			}
		}

		private function organize(sceneId : String, items : Array, times : Array) : void 
		{
			// MAKE A MASTER DICTIONARY
			// 1) SCENE
			// 2) TIMESTAMPS
			// 3) LOADER OBJECTS BY FILENAMES
			if(!_scenes[sceneId])
			{
				var timeD : Dictionary = new Dictionary();
				var filename : String;
				var time : String;
				var bmps : Dictionary;
				var ldr : Loader;
				var ba : ByteArray;
	
				for each(var timestamp : String in times)
				{
					bmps = new Dictionary();
					
					for each(var item : Object in items)
					{
						filename = item.filename;
						time = filename.split('_t')[1].split('_c')[0];
//						ldr = item.bitmap;
						ba = item.ba;
	
						if(time == timestamp) bmps[filename] = ba;//ldr; 
					}
					
					timeD[timestamp] = bmps;
				}
	
				_scenes[sceneId] = timeD;
			}
			else
			{
				new Error("CameraPanner.organize() : TRYING TO ADD A SCENE DICTIONARY WITH A DUPLICATE SCENE ID");
			}
		}		
		
		
		
		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		public function init() : void
		{
//	        WebPLib.init();//Only needs to be called once.

			// SETUP ZIP OBJECTS
//			_zip = new FZip();
//			_zip.addEventListener(Event.OPEN, onOpen);
//			_zip.addEventListener(Event.COMPLETE, onComplete);

			// FORMAT ZIP ITEMS
			_zipLib = new FZipLibrary();
			_zipLib.formatAsBitmapData('.jpg');
//			_zipLib.formatAsBitmapData('.gif');
//			_zipLib.formatAsBitmapData('.png');
//			_zipLib.formatAsDisplayObject('.swf');
//			_zipLib.addZip(_zip);

			// INIT ORGANIZER OBJECTS
			_scenes = new Dictionary();
//			_lastTimes = new Dictionary();
			_bmpCache = new Dictionary();
			
			// INIT LOADER QUEUE
			_loadQueue = new Array();
			_zipQueue = new Array();
			_transitionQueue = new Array();
		}
		
		public function addZips(zips : Array) : void
		{
			_zipQueue = zips;
			parseZip(_zipQueue.shift());
		}
		
		public function getImage(i : int) : Bitmap 
		{
			var camNumber : String = (i < 10) ? '0' + i.toString() : i.toString();
			var scene : String = TimeTracker.gi.currentScene;


			// MAKE TIME RELATIVE TO DEFAULT SPEED
			var tt : TimeTracker = TimeTracker.gi;
			var baseSpeed : Number = Number(TimeTracker.SPEED_SLOW.substr(TimeTracker.SPEED_SLOW.indexOf('0') + 1, 2));
//			trace("CameraPannerModel.getImage(i) : baseSpeed: " + (baseSpeed));
			var activeSpeed : Number = Number(tt.currentSpeed.substr(tt.currentSpeed.indexOf('0') + 1, 2));
//			trace("CameraPannerModel.getImage(i) : activeSpeed: " + (activeSpeed));
//			trace("CameraPannerModel.getImage(i) : tt.currentSpeed: " + (tt.currentSpeed));
			var speedRatio : Number = (scene == SiteConstants.SCENE_COURT) ? baseSpeed/activeSpeed : 1;
//			trace("CameraPannerModel.getImage(i) : speedRatio: " + (speedRatio));
			var currentTime : Number = tt.currentTime * speedRatio;
//			trace("CameraPannerModel.getImage(i) : tt.currentTime: " + (tt.currentTime));


			//			var currentTime : Number = TimeTracker.gi.currentTime;
			// TODO - NEED TO ACCOUNT FOR DECIMAL POINTS!
			var rounded : Number = Math.min(Math.round(currentTime), Math.floor(TimeTracker.gi.videoDuration * speedRatio ) );
//			trace( "CameraPannerModel.getImage.currentTime: " + currentTime );
//			trace( "CameraPannerModel.getImage.TimeTracker.gi.videoDuration: " + TimeTracker.gi.videoDuration );
//			trace( "CameraPannerModel.getImage.rounded: " + rounded );
			var time : String = (rounded < 10) ? '0' + rounded.toString() : rounded.toString();
			var times : Dictionary = _scenes[scene];
//			trace( 'scene: ' + (scene) );

			// CORRECT FOR AVAILABLE CAMERAS AND TIMES
//			findNextAvailable(camNumber, time);

			// CONSTRUCT FILE NAME
			var filename : String = 'jordancp_court_f024_t' + time + '_c' + camNumber;// + '.jpg';
//			trace("CameraPannerModel.getImage(i)");
//			trace( 'filename: ' + (filename) );
			
			
//			for(var key : Object in times[time])
//			{
//				trace('key', key)
//			}
			
			if(!times[time][filename])
			{
				trace('\n\n\n\n\n\n----------------------------------------------------------');
				trace('NO IMAGE TO MATCH SEARCH KEYS', '\ntime:', time, '\nfilename:', filename);
				trace('----------------------------------------------------------\n\n\n\n\n\n');
				new Error('invalid filename seek');
			}
//			var ldr : Loader = times[time][filename] as Loader;
			var ba : ByteArray = times[time][filename];
			
			var bmp : Bitmap;

			if(_bmpCache[filename])
			{
				bmp = _bmpCache[filename];
			}
			else
			{
				var bmpd : BitmapData = _zipLib.getBitmapData(filename + '.jpg');
				bmp = new Bitmap(bmpd);
//				bmp = new Bitmap(WebPLib.decode(ba as ByteArray));
				_bmpCache[filename] = bmp;
			}
//			var bmp : Bitmap = BitmapConverter.getBmp(ldr);
			
			bmp.smoothing = true;
			bmp.width = StreamSwapper.W;
			bmp.height = StreamSwapper.H;
			
			return bmp;
		}

		public function get totalCams() : uint
		{
			// TODO - NEED TO GRAB CURRENT SCENE ID FROM GLOBAL OBJECT
			var scene : String = 'court';
			var currentTime : Number = TimeTracker.gi.currentTime;
			// TODO - NEED TO ACCOUNT FOR DECIMAL POINTS!  maybe :(
			var rounded : Number = Math.round(currentTime);
			var time : String = (rounded < 10) ? '0' + rounded.toString() : rounded.toString();
			var times : Dictionary = _scenes[scene];

			var cnt : uint = 0;			
			for(var key : Object in times[time])
			{
				cnt++;
			}

			return cnt;			
		}
		
		
		//-------------------------------------------------------------------------
		//
		// MANAGE TRANSITION QUEUE
		//
		//-------------------------------------------------------------------------
		public function addTransition(i : uint ) : void
		{
			
//			trace("CameraPannerModel.addTransition", i);
			dispatchEvent(new ParamEvent(TRANSITION_ITEM_ADDED, {index: i}));
		}
		
//		public function get transitionQueue() : Array 
//		{
//			return _transitionQueue;
//		}
		
		public function setPanComplete() : void
		{
			dispatchEvent(new Event(PAN_COMPLETE));
		}
		
//		private function findNextAvailable(camNumber : String, time : String) : void 
//		{
//			trace('camNumber:', camNumber);
//			trace('time: ' + (time));
//			var times : Dictionary = _scenes['court'];
//			for(var key : String in times)
//			{
//				trace('times keys:', key, times[key]);
//			}
//			
//			
//			var filename : String = 'jordancp_court_f024_t' + time + '_c' + camNumber + '.jpg';
//		}

		public function get inEase():Boolean
		{
			return _inEase;
		}
		
		public function set inEase(value:Boolean):void
		{
			_inEase = value;
		}
		
		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}
	}
}

class SingletonEnforcerer {}

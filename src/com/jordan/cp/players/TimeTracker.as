package com.jordan.cp.players 
{
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.managers.TrackingManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	/**
	 * @author nelson.shin
	 */
	public final class TimeTracker extends EventDispatcher
	{
		private static var _instance: TimeTracker;

		private var _currentScene : String = SiteConstants.SCENE_COURT;
		private var _currentSpeed : String = SPEED_SLOW;
		private var _pausedTime : Number;

		// IND IS SETUP WHEN GRID IS BUILT
		private var _isHD : Boolean = true;
		private var _masterStage : Stage;
		private var _bm : BandwidthManager = BandwidthManager.gi;


//		private var _prevCamInd : String;
		private var _currentCamInd : String;
		private var _currentTime : Number;
		private var _percentLoaded : Number;
		private var _videoDuration : Number;
		private var _zoom : Number = 1;
		private var _prevDefaultSpeed : String;
		private var _defaultSpeed : String;
		public var cpUnlocked : Boolean;

		
		private static const ZOOM_RATIO : Number = 1.5;
		
		// VIDEO CATEGORIES
		public static const LOW_DEF : String = 'lowdef';
		public static const HIGH_DEF : String = 'HIGH_DEF';
		public static const SPEED_BASE : String = "24";
		public static const SPEED_SLOW : String = 'f024';
		public static const SPEED_REG : String = 'f012';
		public static const SPEED_FF : String = 'f006';
		public static const SPEED_RW : String = 'r006';

		// UTILITY CONSTANTS
		public static const PANNING_RETARDER : Number = 4;
		
		// EVENT STRINGS
		public static const INDEX_CHANGED : String = "INDEX_CHANGED";
		public static const TIMETRACKER_SPEED_CHANGED : String = "TIMETRACKER_SPEED_CHANGED";
		public static const TIMETRACKER_PAUSE : String = "TIMETRACKER_PAUSE";
		public static const TIMETRACKER_UNPAUSE : String = "TIMETRACKER_UNPAUSE";
		public static const DEFAULT_SPEED_CHANGED : String = "DEFAULT_SPEED_CHANGED";
		public static const SHOW_UTIL : String = "SHOW_UTIL";
		public static const HIDE_UTIL : String = "HIDE_UTIL";		public static const BANDWIDTH_CHANGED : String = 'BANDWIDTH_CHANGED';
		//---------------------------------------------------------------------
		//
		// SINGLETON STUFFS
		//
		//---------------------------------------------------------------------
		public function TimeTracker( se : SingletonEnforcerer ) 
		{
			if( se != null ){
				init();
			}
		}

		public static function get gi() : TimeTracker {
			if( _instance == null ){
				_instance = new TimeTracker( new SingletonEnforcerer() );
			}
			return _instance;
		}

		private function init() : void {
			_bm.addEventListener(Event.COMPLETE, onBandwidthChanged);
			prevDefaultSpeed = defaultSpeed = SPEED_SLOW;
		}


		//-------------------------------------------------------------------------
		//
		// DISPATCH EVENTS
		//
		//-------------------------------------------------------------------------
		public function setPauseAudio() : void 
		{
			dispatchEvent(new Event(TIMETRACKER_PAUSE));
		}

		public function setUnpauseAudio() : void 
		{
			dispatchEvent(new Event(TIMETRACKER_UNPAUSE));
		}

		private function onBandwidthChanged(event : Event) : void 
		{
			isHD = _bm.highBandwidth();
			dispatchEvent(new Event(BANDWIDTH_CHANGED));
		}

		public function showUtilNav() : void 
		{
			dispatchEvent(new Event(SHOW_UTIL));
		}

		public function hideUtilNav() : void 
		{
			dispatchEvent(new Event(HIDE_UTIL));
		}


		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function get currentTime():Number
		{
			return _currentTime;
		}

		public function set currentTime(value:Number):void
		{
			if(value == 0 )
			{
//				trace('\n\n\n\n\n\n----------------------------------------------------------');
//				trace("TimeTracker.currentTime SET : ", value);
//				trace('----------------------------------------------------------\n\n\n\n\n\n');
			}
			_currentTime = value;
		}

		public function get percentLoaded():Number
		{
			return _percentLoaded;
		}
		
		public function set percentLoaded(value:Number):void
		{
			_percentLoaded = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get def():String
		{
			isHD = _bm.highBandwidth();
			return isHD ? HIGH_DEF : LOW_DEF;
		}
		
		public function get currentCamInd() : String
		{
			return _currentCamInd;
		}
		
		public function set currentCamInd(currentCamInd : String) : void
		{
//			_prevCamInd = _currentCamInd;
			_currentCamInd = currentCamInd;
//			dispatchEvent(new Event(INDEX_CHANGED ) );
		}

		public function set zoom(i : Number) : void 
		{
			_zoom = ( i > 0 ) ? ZOOM_RATIO : 1;
		}
		
		public function get zoom() : Number
		{
			return _zoom;
		}
		
		public function get currentScene() : String
		{
			return _currentScene;
		}
		
		public function set currentScene(currentScene : String) : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace("TimeTracker.currentScene");
			trace( "TimeTracker.currentScene.currentScene: " + currentScene );
			_currentScene = currentScene;
		}
		public function get currentSpeed() : String
		{
			return _currentSpeed;
		}
		
		public function set currentSpeed(currentSpeed : String) : void
		{
			_currentSpeed = currentSpeed;
			
			dispatchEvent(new Event(TIMETRACKER_SPEED_CHANGED));
			
			TrackingManager.gi.trackCustom(TrackingConstants.CHANGE_FPS);
		}
		
		public function get pausedTime() : Number
		{
			if(_pausedTime == 0 )
			{
//				trace('\n\n\n\n\n\n----------------------------------------------------------');
//				trace("TimeTracker.pausedTime() : IS ZERO!!!");
//				trace('----------------------------------------------------------\n\n\n\n\n\n');
			}
			return _pausedTime;
		}
		
		public function set pausedTime(val : Number) : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("TimeTracker.pausedTime(val)", val);
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
			_pausedTime = val;
		}
		
		public function get isHD() : Boolean
		{
			return _isHD;
		}
		
		public function set isHD(isHD : Boolean) : void
		{
			_isHD = isHD;
		}
		
		public function get masterStage() : Stage
		{
			return _masterStage;
		}
		
		public function set masterStage(val: Stage) : void
		{
			_masterStage = val;
		}
		
		public function get videoDuration() : Number
		{
			return _videoDuration;
		}
		
		public function set videoDuration(val : Number) : void
		{
			_videoDuration = val;
		}
		
		public function get defaultSpeed() : String
		{
			return _defaultSpeed;
		}
		
		public function set defaultSpeed(val : String) : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
			_defaultSpeed = currentSpeed = val;
//			trace("TimeTracker.defaultSpeed(val) : defaultSpeed: " + (defaultSpeed));
			dispatchEvent(new Event(DEFAULT_SPEED_CHANGED));
		}
		
		public function get prevDefaultSpeed() : String
		{
			return _prevDefaultSpeed;
		}
		
		public function set prevDefaultSpeed(val : String) : void
		{
			_prevDefaultSpeed = val;
		}

	}
}

class SingletonEnforcerer {}
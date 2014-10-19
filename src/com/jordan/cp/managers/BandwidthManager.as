package com.jordan.cp.managers {
	import com.jordan.cp.constants.TrackingConstants;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jason.tighe
	 */
	public class BandwidthManager extends EventDispatcher
	{
		//----------------------------------------------------------------------------
		// private static const
		//----------------------------------------------------------------------------
		private static var _instance					: BandwidthManager;
		//----------------------------------------------------------------------------
		// public static const
		//----------------------------------------------------------------------------
		public static const	HIGH						: String = "high";
		public static const	LOW							: String = "low";
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _speed								: String;	
		private var _threshold 							: uint = 4000;	
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function BandwidthManager( e : Enforcer ) 
		{
			_speed = HIGH;
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function setBandwidth( kbs : Number = 0 ) : void
		{
			if( kbs >= _threshold )
			{
				_speed = HIGH;
				TrackingManager.gi.trackCustom(TrackingConstants.HIGH_BANDWIDTH_SELECTED);
			}
			else
			{
				TrackingManager.gi.trackCustom(TrackingConstants.LOW_BANDWIDTH_SELECTED);
			}
				
//				trace( "BANDWIDTHMANAGER : setBandwidth() : _speed is "+ _speed );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public static function get gi() : BandwidthManager
		{
			if( !_instance ) _instance = new BandwidthManager(new Enforcer());
			return _instance;
		}
		
		public function get speed() : String
		{
			return _speed;
		}
		
		public function set speed( s : String ) : void
		{
			_speed = s;
			trace( "BANDWIDTHMANAGER : set speed : s is "+s )
			dispatchEvent(new Event(Event.COMPLETE));
			
			if( s.toUpperCase() == "HIGH" )
			{
				_speed = HIGH;
				TrackingManager.gi.trackCustom(TrackingConstants.HIGH_BANDWIDTH_SELECTED);
			}
			else
			{
				TrackingManager.gi.trackCustom(TrackingConstants.LOW_BANDWIDTH_SELECTED);
			}
//			TimeTracker.gi.isHD = (_speed == HIGH);
		}
		
		public function highBandwidth(  ) : Boolean
		{
			return (_speed == HIGH );
		}
	}
}

class Enforcer{}
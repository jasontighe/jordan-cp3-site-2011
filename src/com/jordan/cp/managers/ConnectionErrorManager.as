package com.jordan.cp.managers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author nelson.shin
	 */
	public final class ConnectionErrorManager extends EventDispatcher
	{
		private static var _instance : ConnectionErrorManager;
		public static const SHOW_ERROR_STATE : String = "SHOW_ERROR_STATE";
		public static const HIDE_ERROR_STATE : String = "HIDE_ERROR_STATE";
		public static const SHOW_PINWHEEL : String = "SHOW_PINWHEEL";
		public static const HIDE_PINWHEEL : String = "HIDE_PINWHEEL";

		//---------------------------------------------------------------------
		//
		// SINGLETON STUFFS
		//
		//---------------------------------------------------------------------
		public function ConnectionErrorManager( se : SingletonEnforcerer ) 
		{
			if( se != null )
			{
				init();
			}
		}

		public static function get gi() : ConnectionErrorManager 
		{
			if( _instance == null )
			{
				_instance = new ConnectionErrorManager(new SingletonEnforcerer());
			}
			return _instance;
		}

		private function init() : void 
		{
		}

		
		
		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
//		public function showError() : void
//		{
//			dispatchEvent(new Event(SHOW_ERROR_STATE));
//		}
//
//		public function hideError() : void
//		{
//			dispatchEvent(new Event(HIDE_ERROR_STATE));
//		}
//
		public function showPinwheel() : void
		{
			dispatchEvent(new Event(SHOW_PINWHEEL));
		}

		public function hidePinwheel() : void
		{
			dispatchEvent(new Event(HIDE_PINWHEEL));
		}




	}
}

class SingletonEnforcerer 
{
}

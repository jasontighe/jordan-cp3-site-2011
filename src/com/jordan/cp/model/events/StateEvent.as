package com.jordan.cp.model.events {
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */

	public class StateEvent
	extends Event
	{
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const LANDING						: String = "landing";
		public static const INTRO						: String = "intro";
//		public static const INSTRUCTIONS				: String = "instructions";
		public static const MAIN						: String = "main";
		public static const HELP						: String = "help";
		public static const EMAIL						: String = "email";
		public static const SCENE						: String = "scene";
		public static const VIGNETTE					: String = "vignette";
//		public static const FINALE						: String = "finale";
		public static const SUMMARY						: String = "summary";
//		public static const DEBUGGER					: String = "debugger";
		public static const OVERLAY_OUT					: String = "overlayOut";
		public static const VIGNETTE_OUT				: String = "vignetteOut";
		public static const DANCE_OFF					: String = "danceOff";
		//----------------------------------------------------------------------------
		// private model properties
		//----------------------------------------------------------------------------
		private var _item								: Object;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function StateEvent(type:String, bubbles:Boolean, item:Object = null)
		{
			super(type, bubbles);
			
			_item = item;
		}
		
		//----------------------------------------------------------------------------
		// public implicit getters/setters
		//----------------------------------------------------------------------------
		public function get item():Object
		{
			return _item;
		}
	}
}

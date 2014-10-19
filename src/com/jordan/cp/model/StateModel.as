package com.jordan.cp.model {
	import com.jordan.cp.model.events.StateEvent;

	import flash.events.EventDispatcher;

	/**
	 * @author jason.tighe
	 */
	public class StateModel 
	extends EventDispatcher 
	{
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const STATE_LANDING			: String = "landing";
		public static const STATE_INTRO				: String = "intro";
		public static const STATE_MAIN				: String = "main";
		public static const STATE_DANCE_OFF			: String = "danceOff";
		public static const STATE_SCENE				: String = "scene";
		public static const STATE_VIGNETTE			: String = "vignette";
		public static const STATE_HELP				: String = "help";
		public static const STATE_EMAIL				: String = "email";
//		public static const STATE_INSTRUCTIONS		: String = "instructions";
//		public static const STATE_FINALE			: String = "finale";
		public static const STATE_SUMMARY			: String = "summary";
		public static const STATE_VIGNETTE_OUT		: String = "vignetteOut";
		public static const STATE_OVERLAY_OUT		: String = "overlayOut";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _state						: String;
		protected var _previousState				: String;
		protected var _mainCamNum					: uint;
		protected var _hotspotCamNum				: uint;
		protected var _hotspotNum					: uint;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function StateModel() 
		{
			trace( "STATEMODEL : Constr" );
			
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		 protected function updateState() : void
		 {
			trace( "STATEMODEL : updateState()" );
			var category:String;
			switch (_state)
			{
				case STATE_LANDING:
					dispatchEvent( new StateEvent( StateEvent.LANDING, false ) );
					break;
				case STATE_INTRO:
					dispatchEvent( new StateEvent( StateEvent.INTRO, false ) );
					break;
				case STATE_MAIN:
					dispatchEvent( new StateEvent( StateEvent.MAIN, false ) );
					break;
				case STATE_SCENE:
					dispatchEvent( new StateEvent( StateEvent.SCENE, false ) );
					break;
				case STATE_VIGNETTE:
					dispatchEvent( new StateEvent( StateEvent.VIGNETTE, false ) );
					break;
				case STATE_HELP:
					dispatchEvent( new StateEvent( StateEvent.HELP, false ) );
					break;
				case STATE_EMAIL:
					dispatchEvent( new StateEvent( StateEvent.EMAIL, false ) );
					break;
//				case STATE_INSTRUCTIONS:
//					dispatchEvent( new StateEvent( StateEvent.INSTRUCTIONS, false ) );
//					break;
//				case STATE_FINALE:
//					dispatchEvent( new StateEvent( StateEvent.FINALE, false ) );
//					break;
				case STATE_SUMMARY:
					dispatchEvent( new StateEvent( StateEvent.SUMMARY, false ) );
					break;
//				case STATE_DEBUGGER:
//					dispatchEvent( new StateEvent( StateEvent.DEBUGGER, false) );
//					break;
				case STATE_OVERLAY_OUT:
					dispatchEvent( new StateEvent( StateEvent.OVERLAY_OUT, false) );
					break;
				case STATE_VIGNETTE_OUT:
					dispatchEvent( new StateEvent( StateEvent.VIGNETTE_OUT, false) );
					break;
				case STATE_DANCE_OFF:
					dispatchEvent( new StateEvent( StateEvent.DANCE_OFF, false) );
					break;
			}
		}
		 
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function get state( ) : String
		{
			return _state;
		} 
		
		public function set state( value : String ) : void 
		{	
			trace( "\n" );
			trace( "STATEMODEL : STATE = " + value + ",	 OLD STATE = " + _state);
			if( _state != value)
			{
//				_previousState = _state;
				_state = value;
				updateState();
			}
		}
		
		public function get previousState( ) : String
		{
			return _previousState;
		}
		
		public function set previousState( s : String ) : void
		{
			_previousState = s;
		}
		
		public function get mainCamNum() : uint
		{
			return _mainCamNum;
		}
		public function set mainCamNum( n : uint ) : void
		{
			_mainCamNum = n;
		}
		
		public function get hotspotCamNum() : uint
		{
			return _hotspotCamNum;
		}
		public function set hotspotCamNum( n : uint ) : void
		{
			_hotspotCamNum = n;
		}
		
		public function get hotspotNum() : uint
		{
			return _hotspotNum;
		}
		public function set hotspotNum( n : uint ) : void
		{
			_hotspotNum = n;
		}
	}
}

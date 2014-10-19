package com.jordan.cp.managers {
	import com.jasontighe.util.Box;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * @author jsuntai
	 */
	public class KeyboardManager 
	extends Sprite
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _keyCode							: uint;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function KeyboardManager() 
		{
			trace( "KEYBOARDMANAGER : Constr" );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function activate() : void
		{
			trace( "KEYBOARDMANAGER : activate() : stage is "+stage );
			stage.focus = stage;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyboardDown );
		}
		
		public function deactivate() : void
		{
			trace( "KEYBOARDMANAGER : deactivate()" );
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyboardDown );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function onAddedToStage( e : Event ) : void
		{
//			trace( "KEYBOARDMANAGER : onAddedToStage()" );
			activate();
		}
		
		protected function init() : void
		{
//			trace( "KEYBOARDMANAGER : init()" );
//			addView();
//			if( root )	activate();
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function addView() : void
		{
//			trace( "KEYBOARDMANAGER : addView()" );
			var box : Box =  new Box();
			addChild( box );
		}
		
		protected function onKeyboardDown( e : KeyboardEvent ) : void
		{
//			trace( "KEYBOARDMANAGER : onKeyboardDown() : e.keyCode is "+e.keyCode );  
			_keyCode = e.keyCode;
			dispatchEvent( new Event( Event.COMPLETE ) );          
//			trace("ctrlKey: " + e.ctrlKey);
//          trace("keyLocation: " + e.keyLocation);
//          trace("shiftKey: " + e.shiftKey);
//          trace("altKey: " + e.altKey);
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get keyCode() : uint
		{
			return _keyCode;
		}
		
	}
}

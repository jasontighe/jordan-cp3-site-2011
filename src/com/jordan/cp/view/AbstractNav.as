package com.jordan.cp.view {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.JSBridge;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.menu_lower.AbstractIcon;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class AbstractNav 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public constants
		//----------------------------------------------------------------------------
		public const LEFT								: String = "left";
		public const RIGHT								: String = "right";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id								: uint;
		protected var _direction						: String;
		protected var _jsBridge							: JSBridge;
		protected var _stateModel						: StateModel;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var copyTxt								: MovieClip;
		public var icon									: AbstractIcon;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractNav() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function activate() : void {}
		
		public function deactivate() : void {}
		
		public function transitionIn() : void {}
		
		public function transitionOut() : void {}
		
		public function doMouseOver() : void {}
		
		public function doMouseOut() : void {}
		
		public function doClick() : void {}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function transitionInComplete() : void {}
		
		protected function transitionOutComplete() : void {}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set stateModel( object : StateModel ) : void
		{
//			trace( "ABSTRACTNAV : set stateModel .......... : object is "+object );
			_stateModel = object;
//			trace( "ABSTRACTNAV : set _stateModel .......... : _stateModel is "+_stateModel );
		}
		
		public function set jsBridge( object : JSBridge ) : void
		{
//			trace( "ABSTRACTNAV : set jsBridge .........." );
			_jsBridge = object;
		}
		
		public function get id( ) : uint
		{
			return _id;
		}
		
		public function set id( n : uint ) : void
		{
			_id = n;
		}
		
		public function set direction( s : String ) : void
		{
			_direction = s;
		}
	}
}

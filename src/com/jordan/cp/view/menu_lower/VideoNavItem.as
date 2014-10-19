package com.jordan.cp.view.menu_lower {
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;

	/**
	 * @author jason.tighe
	 */
	public class VideoNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static var BACKGROUND_COLOR			: uint = 0xFFFFFF;
		protected static var OUTLINE_COLOR				: uint = 0x999999;
		protected static var OUT_ALPHA					: Number = .1;
		protected static var OVER_ALPHA					: Number = .05;
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static var SIZE							: uint = 50;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		protected var _size								: uint;
		protected var _id								: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var background							: Box;
		
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoNavItem() 
		{
			super();
			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			_size = SIZE;
			addBackground();
			addLines();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		public function addBackground() : void
		{
			background = new Box( _size, _size, BACKGROUND_COLOR );
			background.alpha = OUT_ALPHA;
			addChild( background );
		}
		
		public function addLines() : void
		{
			
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set size( value : uint ) : void 
		{
			_size = value
		}
		
		public function get id() : uint
		{
			return _id;	
		}
		
		public function set id( n : uint ) : void
		{
			_id = n;	
		}
	}
}

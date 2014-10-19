package com.jordan.cp.media {
	import com.greensock.TweenLite;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class VideoPlayerPlayhead 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _isPlaying							: Boolean = false;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var playIcon									: MovieClip;
		public var pauseIcon								: MovieClip;
		public var background								: MovieClip;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoPlayerPlayhead() 
		{
			init();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			playIcon.visible = false;
//			toggle();
		}
		
		public function toggle() : void
		{
			playIcon.visible = !playIcon.visible;
			pauseIcon.visible = !pauseIcon.visible;
		}
		
		public function set isPlaying( b : Boolean ) : void
		{
			b = _isPlaying;
		}
		
		public function activate() : void
		{
			trace( "VIDEOPLAYERPLAYHEAD : activate()" );
			 addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			 addEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			 removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
			 removeEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			trace( "VIDEOPLAYERPLAYHEAD : onMouseOver()" );
			TweenLite.to( background, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED } );
		}

		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			trace( "VIDEOPLAYERPLAYHEAD : onMouseOut()" );
			TweenLite.to( background, SiteConstants.NAV_TIME_OUT, { tint: 0x000000 } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			trace( "VIDEOPLAYERPLAYHEAD : onClick()" );
			toggle();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
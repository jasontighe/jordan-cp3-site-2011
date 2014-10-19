package com.jordan.cp.view.landing {
	import com.greensock.TweenMax;
	import com.jordan.cp.view.menu_lower.AbstractIcon;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class BandwidthIcon 
	extends AbstractIcon 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const COLOR_OVER			: uint = 0x000000;
		protected static const COLOR_OUT			: uint = 0x000000;
		protected static const COLOR_CLICK			: uint = 0xD7270A;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var center							: MovieClip;
		public var background						: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function BandwidthIcon()
		{
			
		}
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function setOverState( time : Number, color : uint ) : void
		{
//			trace( "BANDWIDTHICON : setOverState" );
			TweenMax.to( center, time, { tint: color } );
		}
		
		public function setOutState( time : Number, color : uint ) : void
		{
//			trace( "BANDWIDTHICON : setOutState" );
			TweenMax.to( center, time, { tint: color } );
		}
		
		public function setActiveState( color : uint ) : void
		{
//			trace( "BANDWIDTHICON : setActiveState" );
			TweenMax.to( center, 0, { tint: color } );
		}
		
	}
}

package com.jordan.cp.view.landing {
	import com.greensock.TweenMax;
	import com.jasontighe.navigations.NavItem;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class BandwidthNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const ICON_ALPHA			: uint = 0;
		protected static const COLOR_OVER			: uint = 0xFFFFFF;
		protected static const COLOR_OUT			: uint = 0x464646;
		protected static const COLOR_CLICK			: uint = 0xFFFFFF;
		protected static const TIME_OVER			: Number = .5;
		protected static const TIME_OUT				: Number = .25;
		protected static const ICON_COLOR_OVER		: uint = 0xD7270A;
		protected static const ICON_COLOR_OUT		: uint = 0x000000;
		protected static const ICON_COLOR_CLICK		: uint = 0xD7270A;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon								: BandwidthIcon;
		public var copyTxt							: MovieClip;
		public var background						: MovieClip;
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function BandwidthNavItem() 
		{
			super();
			background.alpha = ICON_ALPHA;
		}

		public override function setOverState ( active : int = -1 ) : void
		{
			doOverState()
		}

		public override function setOutState () : void
		{
			doOutState()
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}
		
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function doOverState( ) : void
		{
			TweenMax.to( copyTxt, TIME_OVER, { tint: COLOR_OVER } );
			icon.setOverState( TIME_OVER, ICON_COLOR_OVER );
		}

		protected function doOutState( ) : void
		{
			TweenMax.to( copyTxt, TIME_OVER, { tint: COLOR_OUT } );
			icon.setOutState( TIME_OVER, ICON_COLOR_OUT );
		}
		
		protected function doClickState( ) : void
		{
			TweenMax.to( copyTxt, 0, { tint: COLOR_CLICK } );
			icon.setActiveState( ICON_COLOR_CLICK );
		}
		
	}
}

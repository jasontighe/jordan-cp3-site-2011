package com.jordan.cp.view.vignette {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperDeviceNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var BACKGROUND_HEIGHT				: uint = 10;
		protected static var ARROW_X						: uint = 7;
		protected static var ARROW_Y						: uint = 8;
		protected static var DEVICE							: String = "Device";
		protected static var DEVICE_X						: uint = 12;
		protected static var DEVICE_Y						: uint = 0;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var deviceTxt								: TextContainer;
		public var arrow									: MovieClip;
		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function WallpaperDeviceNavItem() 
		{
			super();
		}
		// TODO SET TEXT, THEN RESIZE BACKGROUND
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			addViews();
		}
		
		public function addViews( s : String ) : void
		{
//			trace( "WALLPAPERDEVICENAVITEM : addViews() : s is "+s);
			addBackground();
			addArrow();
			addCopy( s );
			resizeBackground( );
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
		protected function addBackground() : void
		{
			background = new Box( BACKGROUND_HEIGHT, BACKGROUND_HEIGHT, 0xFFFFFF );
			addChild( background );
			background.alpha = 0;
		}
		
		protected function addArrow() : void
		{
			arrow = MovieClip( AssetManager.gi.getAsset( "WallpaperArrowAsset", SiteConstants.ASSETS_ID ) );
			arrow.x = ARROW_X;
			arrow.y = ARROW_Y;
			addChild( arrow );
		}
		
		protected function addCopy( s : String ) : void
		{
			deviceTxt = new TextContainer();
			deviceTxt.populate( s.toUpperCase(), 'wallpaper-device-inactive');
            deviceTxt.x = DEVICE_X;
            deviceTxt.y = DEVICE_Y;
			addChild( deviceTxt );
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
		}
		
		protected function doOverState( ) : void
		{
			TweenMax.to( arrow, SiteConstants.NAV_TIME_IN, { rotation: 0, tint: 0xFFFFFF } );
			TweenMax.to( deviceTxt, SiteConstants.NAV_TIME_IN, { tint: 0xFFFFFF } );
		}

		protected function doOutState( ) : void
		{
			TweenMax.to( deviceTxt, SiteConstants.NAV_TIME_OUT, { tint: 0x464646 } );
			TweenMax.to( arrow, SiteConstants.NAV_TIME_OUT, { tint: 0x464646, rotation: 0, ease:Quad.easeOut } );
		}
		
		protected function doClickState( ) : void
		{
			TweenMax.to( arrow, SiteConstants.NAV_TIME_IN, { rotation: 90, tint: 0xFFFFFF, rotation: 0, ease:Quad.easeOut } );
			TweenMax.to( deviceTxt, 0, { tint: 0xFFFFFF } );
		}
		
	}
}

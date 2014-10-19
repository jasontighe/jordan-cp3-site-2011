package com.jordan.cp.view.vignette {
	import com.greensock.TweenMax;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperThumbNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var BACKGROUND_HEIGHT				: uint = 10;
		protected static var BORDER_X						: uint = 2;
		protected static var BORDER_Y						: uint = 16;
		protected static var BORDER_WIDTH					: uint = 104;
		protected static var BORDER_HEIGHT					: uint = 65;
		protected static var BORDER_COLOR					: uint = 0x464646;
		protected static var OVERLAY_COLOR					: uint = 0x000000;
		protected static var OVERLAY_ALPHA					: Number = .5;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _thumbURL								: String;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var numeralTxt								: TextContainer;
		public var imageHolder								: MovieClip;
		public var border									: Box;
		public var imageBg									: Box;
		public var imageOverlay								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function WallpaperThumbNavItem() 
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
//			trace( "WALLPAPERTHUMBNAVITEM : addViews()" );
			addBorder();
			addCopy( s );
			loadImage();
		}

		public override function setOverState ( active : int = -1 ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : setOverState()" );
			doOverState()
		}

		public override function setOutState () : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : setOutState()" );
			doOutState()
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : setActiveState()" );
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function addBorder() : void
		{
			trace( "WALLPAPERTHUMBNAVITEM : addBorder()" );
			border = new Box( BORDER_WIDTH, BORDER_HEIGHT, BORDER_COLOR );
			border.x = BORDER_X;
			border.y = BORDER_Y;
			addChild( border );
			
			imageBg = new Box( BORDER_WIDTH - 2, BORDER_HEIGHT - 2, OVERLAY_COLOR );
			imageBg.x = BORDER_X + 1;
			imageBg.y = BORDER_Y + 1;
			addChild( imageBg );
		}
		
		protected function addCopy( s : String ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : addCopy()" );
			numeralTxt = new TextContainer();
			numeralTxt.populate( s.toUpperCase(), 'wallpaper-thumb-inactive');
			addChild( numeralTxt );
		}
		
		protected function loadImage() : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : loadImage()" );
			imageHolder = new MovieClip();
			imageHolder.x = BORDER_X + 1;
			imageHolder.y = BORDER_Y + 1;
			addChild( imageHolder );
			
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageLoaded );
			loader.load( new URLRequest( _thumbURL ) );
			imageHolder.addChild( loader );
		}
		
		protected function addImageOverlay() : void
		{
			imageOverlay = new Box( imageHolder.width, imageHolder.height, OVERLAY_COLOR );
			imageOverlay.x = imageHolder.x;
			imageOverlay.y = imageHolder.y;
			imageOverlay.alpha = OVERLAY_ALPHA;
			addChild( imageOverlay );
		}
		
		protected function doOverState( ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : doOverState()" );
			if( imageOverlay && contains( imageOverlay ) )		
				TweenMax.to( imageOverlay, SiteConstants.NAV_TIME_IN, { alpha: 0 } );
				
			TweenMax.to( numeralTxt, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_WHITE });
		}

		protected function doOutState( ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : doOutState()" );
			TweenMax.to( border, SiteConstants.NAV_TIME_OUT, { tint: BORDER_COLOR } );	
			TweenMax.to( numeralTxt, SiteConstants.NAV_TIME_IN, { tint: BORDER_COLOR });
			
			if( imageOverlay && contains( imageOverlay ) )
				TweenMax.to( imageOverlay, SiteConstants.NAV_TIME_OUT, { alpha: OVERLAY_ALPHA } );
		}
		
		protected function doClickState( ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : doClickState()" );
			TweenMax.to( border, 0, { tint: SiteConstants.COLOR_RED } );
			TweenMax.to( numeralTxt, 0, { tint: SiteConstants.COLOR_WHITE });
			
			if( imageOverlay && contains( imageOverlay ) )	
				TweenMax.to( imageOverlay, 0, { alpha: 0 } );
		}

		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onImageLoaded( e : Event ) : void
		{
//			trace( "WALLPAPERTHUMBNAVITEM : onImageLoaded()" );
			addImageOverlay();
		}
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set thumbURL( s : String ) : void
		{
			_thumbURL = s;
		}
		
	}
}

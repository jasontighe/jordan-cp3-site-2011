package com.jordan.cp.view.vignette {
	import com.greensock.TweenMax;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperDownloadButton 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var BG_WIDTH						: uint = 80;
		protected static var BG_HEIGHT						: uint = 19;
		protected static var BG_CORNERS						: uint = 4;
		protected static var DOWNLOAD						: String = "Download";
		protected static var DOWNLOAD_X						: uint = 3;
		protected static var DOWNLOAD_Y						: uint = 2;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var downloadTxt								: TextContainer;
		public var background								: Shape;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function WallpaperDownloadButton() 
		{
			super();
			init();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			addViews();
		}
		

		
		public function activate() : void
		{
			trace( "WALLPAPERDOWNLOADBUTTON : activate()" );
			 addEventListener( MouseEvent.MOUSE_OVER, doOverState );
			 addEventListener( MouseEvent.MOUSE_OUT, doOutState );
			 addEventListener( MouseEvent.CLICK, doClickState );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			trace( "WALLPAPERDOWNLOADBUTTON : deactivate()" );
			 removeEventListener( MouseEvent.MOUSE_OVER, doOverState );
			 removeEventListener (MouseEvent.MOUSE_OUT, doOutState );
			 removeEventListener( MouseEvent.CLICK, doClickState );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
			addBackground();
			addCopy();
		}
		
		protected function addBackground( ) : void
		{
			background = new Shape();
			background.graphics.lineStyle();
			background.graphics.beginFill( SiteConstants.COLOR_RED );
			background.graphics.drawRoundRect( 0, 0, BG_WIDTH, BG_HEIGHT, BG_CORNERS, BG_CORNERS );
			background.graphics.endFill();
			addChild( background );
		}

		protected function addCopy( ) : void
		{
			var downloadTxt : TextContainer = new TextContainer();
			downloadTxt.populate( DOWNLOAD.toUpperCase(), 'wallpaper-download');
            downloadTxt.x = DOWNLOAD_X;
            downloadTxt.y = DOWNLOAD_Y;
			addChild( downloadTxt );
		}
		
		protected function doOverState( e : MouseEvent ) : void
		{
				TweenMax.to( background, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED } );
		}

		protected function doOutState( e : MouseEvent ) : void
		{
				TweenMax.to( background, SiteConstants.NAV_TIME_OUT, { tint: 0xf84d31 } );
		}
		
		protected function doClickState( e : MouseEvent ) : void
		{
				TweenMax.to( background, 0, { tint: SiteConstants.COLOR_RED } );
				dispatchEvent( new Event( Event.COMPLETE ) )
;		}
	}
}

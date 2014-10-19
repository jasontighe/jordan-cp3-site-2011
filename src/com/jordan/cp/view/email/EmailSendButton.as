package com.jordan.cp.view.email {
	import com.greensock.TweenMax;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class EmailSendButton 
	extends DisplayContainer 
	{
		protected static var COPY_LINK					: String = "Copy Link";
		public var arrow								: MovieClip;
		public var sendTxt								: TextContainer;
		public var background							: Box;
		
		public function EmailSendButton() 
		{
			super();
//			init();
		}
		
		public override function init() : void
		{
//			addViews( COPY_LINK );
		}
		
		public function addViews( s : String ) : void
		{
			addBackground()
			addArrow();
			addCopy( s )
			resizeBackground();
		}
		
		public function activate() : void
		{
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, doOverState );
			addEventListener( MouseEvent.MOUSE_OUT, doOutState );
			addEventListener( MouseEvent.CLICK, doClickState );
		}
		
		public function deactivate() : void
		{
			buttonMode = false;
			mouseEnabled = false;
			mouseChildren = false;
			useHandCursor = false;
			
			removeEventListener( MouseEvent.MOUSE_OVER, doOverState );
			removeEventListener( MouseEvent.MOUSE_OUT, doOutState );
			removeEventListener( MouseEvent.CLICK, doClickState );
		}
		
		public function setOutState() : void
		{
			doOutState();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addBackground() : void
		{
			background = new Box( 1, 1 );
			background.alpha = 0;
			addChild( background );
		}
		
		protected function addArrow() : void
		{
			arrow = MovieClip( AssetManager.gi.getAsset( "WallpaperArrowAsset", SiteConstants.ASSETS_ID ) );
			arrow.x = Math.round( arrow.width * .5 );
			arrow.y = Math.round( arrow.height * .5 ) + 4;
			addChild( arrow );
		}

		protected function addCopy( s : String ) : void
		{	
			sendTxt = new TextContainer();
			sendTxt.populate( s.toUpperCase(), "email-send");
			sendTxt.x = arrow.x + arrow.width + 1;
			sendTxt.y = 0;
			addChild( sendTxt );
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function doOverState( e : MouseEvent = null ) : void
		{
				TweenMax.to( this, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED });
		}

		protected function doOutState( e : MouseEvent = null ) : void
		{
				TweenMax.to( this, SiteConstants.NAV_TIME_OUT, { tint: SiteConstants.COLOR_WHITE });
		}
		
		protected function doClickState( e : MouseEvent = null ) : void
		{
			TweenMax.to( this, 0, { tint: 0xd7270a } );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}

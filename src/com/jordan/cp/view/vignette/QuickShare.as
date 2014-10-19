package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class QuickShare 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public constants
		//----------------------------------------------------------------------------
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _type								: String;
		protected var _color							: uint;
		protected var _icon								: MovieClip;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var twitterBtn							: MovieClip;
		public var facebookBtn							: MovieClip;
		public var twitter								: MovieClip;
		public var facebook								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function QuickShare() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function activate() : void
		{
			trace( "QUICKSHARE : activate()" );
			addInteraction( );
		}
		
		public function deactivate() : void
		{
			removeInteraction( );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addInteraction( ) : void
		{
			twitterBtn.addEventListener( MouseEvent.MOUSE_OVER, onTwitterOver );
			twitterBtn.addEventListener( MouseEvent.MOUSE_OUT, onTwitterOut );
			twitterBtn.addEventListener( MouseEvent.CLICK, onTwitterClick );
			twitterBtn.buttonMode = true;
			twitterBtn.useHandCursor = true;
			twitterBtn.mouseEnabled = true;
			twitterBtn.mouseChildren = false;
			
			facebookBtn.addEventListener( MouseEvent.MOUSE_OVER, onFacebookOver );
			facebookBtn.addEventListener( MouseEvent.MOUSE_OUT, onFacebookOut );
			facebookBtn.addEventListener( MouseEvent.CLICK, onFacebookClick );
			facebookBtn.buttonMode = true;
			facebookBtn.useHandCursor = true;
			facebookBtn.mouseEnabled = true;
			facebookBtn.mouseChildren = false;
		}
		
		protected function removeInteraction( ) : void
		{
			twitterBtn.removeEventListener( MouseEvent.MOUSE_OVER, onTwitterOver );
			twitterBtn.removeEventListener( MouseEvent.MOUSE_OUT, onTwitterOut );
			twitterBtn.removeEventListener( MouseEvent.CLICK, onTwitterClick );
			twitterBtn.buttonMode = true;
			twitterBtn.useHandCursor = true;
			twitterBtn.mouseEnabled = true;
			twitterBtn.mouseChildren = false;
			
			facebookBtn.removeEventListener( MouseEvent.MOUSE_OVER, onFacebookOver );
			facebookBtn.removeEventListener( MouseEvent.MOUSE_OUT, onFacebookOut );
			facebookBtn.removeEventListener( MouseEvent.CLICK, onFacebookClick );
			facebookBtn.buttonMode = true;
			facebookBtn.useHandCursor = true;
			facebookBtn.mouseEnabled = true;
			facebookBtn.mouseChildren = false;
		}
		
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onTwitterOver( e : MouseEvent = null ) : void 
		{
			TweenLite.to( twitter, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_TWITTER } );
		}
		
		protected function onTwitterOut( e : MouseEvent = null ) : void 
		{
			TweenLite.to( twitter, SiteConstants.NAV_TIME_OUT, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onTwitterClick( e : MouseEvent = null ) : void 
		{
			_type = SiteConstants.SHARE_TWITTER;
			onTwitterOut();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onFacebookOver( e : MouseEvent = null ) : void 
		{
			TweenLite.to( facebook, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_FACEBOOK });
		}
		
		protected function onFacebookOut( e : MouseEvent = null ) : void 
		{
			TweenLite.to( facebook, SiteConstants.NAV_TIME_OUT, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onFacebookClick( e : MouseEvent = null ) : void 
		{
			_type = SiteConstants.SHARE_FACEBOOK;
			onTwitterOut();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get type() : String
		{
			return _type;
		}
	}
}

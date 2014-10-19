package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class DualVoteNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var VOTE_ALPHA					: Number = .5;
		protected static var OVERLAY_ALPHA				: Number = .6;
		protected static var VOTE_X						: uint = 0;
		public static var VOTE_Y						: uint = 289;
		protected var _videoWidth						: uint;
		protected var _percent							: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var iconBg								: Box;
		public var overlay								: Box;
		public var video								: CopyVideoPanel;
		public var icon									: MovieClip;
		public var result								: DualVideoResult;
		public var iconMask								: Box;
		public var player								: SimpleStreamingPlayer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function DualVoteNavItem() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function addViews( ) : void
		{
			addIconBg();
			addVideo();
			addIcon();
			addOverlay();
			addResults();
			resizeIconBg();
		}
		
		public function playVideo( url : String, nc : NetConnection ) : void
		{
//			trace( "DUALVOTENAVITEM : playVideo() : url is "+url );
			video.playVideo( url, nc );
		}

		public function showResult ( n : uint ) : void
		{
//			trace( "DUALVOTENAVITEM : showResult() : n is "+n );
			result.showResult( n )	
		}
		
		public override function setOverState ( active : int = -1 ) : void
		{
			doOverState();
		}

		public override function setOutState () : void
		{
			doOutState();
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}

		public function transitionOut() : void
		{
			TweenLite.to( icon, SiteConstants.NAV_TIME_IN * .45, { y: icon.y + icon.height, ease:Quad.easeOut, onComplete: transitionOutComplete  } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function transitionOutComplete() : void
		{
			removeChild( icon );
			removeChild( iconMask );
		}

		protected function addIconBg() : void
		{
			iconBg = new Box( 1, 1 );
			iconBg.alpha = 0;
			addChild( iconBg );
		}
		
		protected function addVideo() : void
		{
			video = new CopyVideoPanel();
			video.forDanceOff = true;
			video.type = SiteConstants.EGG_KONAMI;
			video.addEventListener( Event.COMPLETE, onVideoReady );
			video.init();
			video.addEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoComplete );
			addChild( video );
		}
		
		protected function addOverlay() : void
		{
			overlay = new Box( video.width - 2, video.height - 2, 0x000000 );
			overlay.x = 1;
			overlay.y = 1;
			overlay.alpha = 0;
			addChild( overlay );
		}
		
		protected function addIcon() : void
		{
			icon = MovieClip( AssetManager.gi.getAsset( "VoteButtonAsset", SiteConstants.ASSETS_ID ) );
			icon.x = video.x + Math.round( ( video.width - icon.width ) * .5 );
			icon.y = VOTE_Y;
			addChild( icon );
			
			iconMask = new Box( icon.width, icon.height );
			iconMask.x = icon.x;
			iconMask.y = icon.y;
			addChild( iconMask );
			
			icon.mask = iconMask;
		}
		
		protected function addResults(  ) : void
		{		
			result = new DualVideoResult();
			result.addViews();
			result.x = Math.round( ( video.x + video.width - result.width ) * .5 );
			result.y = Math.round( ( video.x + video.height - result.height ) * .5 );
			addChild( result );
			
//			showResult( "20&" );
		}
		
		protected function resizeIconBg() : void
		{
			iconBg.x = icon.x;
			iconBg.y = icon.y;
			iconBg.width = icon.width;
			iconBg.height = icon.height;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function doOverState( ) : void
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED, ease: Quad.easeOut });
//			TweenMax.to( overlay, SiteConstants.NAV_TIME_IN, { alpha: OVERLAY_ALPHA, ease: Quad.easeOut });
		}

		protected function doOutState( ) : void
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_OUT, { tint: 0xFFFFFF, ease: Quad.easeOut });
//			TweenMax.to( overlay, SiteConstants.NAV_TIME_OUT, { alpha: OVERLAY_ALPHA, ease: Quad.easeOut });
		}
		
		protected function doClickState( ) : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onVideoComplete( e : SimpleStreamingEvent ) : void
		{
//			trace( "DUALVOTENAVITEM : onVideoComplete() " );
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
		}
		
		protected function onVideoReady( e : Event = null ) : void 
		{
//			trace( "DUALVOTENAVITEM : onVideoReady()" );
			video.removeEventListener( Event.COMPLETE, onVideoReady );
			player = video.getVideo();
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_READY ) );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		protected function get videoWidth( ) : uint
		{
			return _videoWidth;
		}
		
		protected function getVideoH( ) : uint
		{
			return video.height;
		}
	}
}

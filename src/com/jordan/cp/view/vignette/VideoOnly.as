package com.jordan.cp.view.vignette {
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class VideoOnly 
	extends AbstractVignette 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var SHARE_X						: uint = 380;
		protected static var SHARE_Y						: uint = 98;
		protected static var EXIT_X							: uint = 378;
		protected static var EXIT_Y							: uint = 490;
		protected const VIDEO_LOOPING						: Boolean = false;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _social								: Boolean = false;
		protected var _videoName							: String;
		protected var _stageWidth							: uint = 860;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var quickShare								: QuickShare;
		public var videoPanel								: CopyVideoPanel;
		public var player									: SimpleStreamingPlayer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoOnly() 
		{
			super();
//			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			SET _social BEFORE CALLING INIT FOR SHOWING QUICK SHARE
			addViews();
		}
		
		public override function populateByDTO( dto : ContentDTO ) : void
		{
//			trace( "VIDEOONLY : populateByDTO() : dto is "+dto );
//			var dto : ContentDTO = dto;
//			var name : String = dto.name;
//			var url : String;
//			videoPanel.populateByDTO( dto );
		}
		
		public function playVideo( url : String, nc : NetConnection ) : void
		{
			trace( "VIDEOONLY : playVideo() : url is "+url );
			videoPanel.playVideo( url, nc );
		}
		
		public function destroyVideo( ) : void
		{
//			trace( "VIDEOONLY : destroyVideo()" );
			videoPanel.destroyVideo();
		}
		
		public function pauseStream( ) : void
		{
			player.pauseStream();
		}
		
		public function resumeStream( ) : void
		{
			player.resumeStream();
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected override function addViews( ) : void
		{
//			trace( "VIDEOONLY : addViews()" );
			addBackground();
			addVideo();
			addExitButton();
			if( _social ) addQuickShare();
			positionExitButton( EXIT_X, EXIT_Y );
		}
		
		protected override function addBackground( ) : void
		{
//			trace( "VIDEOONLY : addBackground()" );
			var background : MovieClip = new MovieClip();
			addChild( background );
			
			var box : Box = new Box( SiteConstants.STAGE_AREA_WIDTH, SiteConstants.STAGE_AREA_HEIGHT );
			box.alpha = 0;
			background.addChild( box );
			
			setWidth( width );
			setHeight( height );
		}
		
		protected function addVideo( ) : void
		{
			trace( "VIDEOONLY : addVideo()" ); 
			videoPanel = new CopyVideoPanel();
			videoPanel.addEventListener( Event.COMPLETE, onVideoReady );
			videoPanel.init();
			videoPanel.x = ( _stageWidth - videoPanel.width ) * .5;
			videoPanel.y = 150;
			addChild( videoPanel );
		}
		
		protected function addQuickShare( ) : void
		{
			quickShare = new QuickShare();
			quickShare.x = SHARE_X;
			quickShare.y = SHARE_Y;
			quickShare.addEventListener( Event.COMPLETE, onShareClick );
			quickShare.activate();
			addChild( quickShare );
		}
		
		//----------------------------------------------------------------------------
		// gevent handlers
		//----------------------------------------------------------------------------
		protected function onShareClick( e : Event = null ) : void 
		{
//			trace( "VIDEOONLY : onShareClick()" );
			var type : String = quickShare.type;
			Shell.getInstance().jsBridge().doSocial( type, _videoName );
			
		}
		
		protected function onVideoReady( e : Event = null ) : void 
		{
//			trace( "VIDEOONLY : onVideoReady()" );
			videoPanel.removeEventListener( Event.COMPLETE, onVideoReady );
			player = videoPanel.getVideo();
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set social( value : Boolean ) : void
		{
			_social = value;
		}
		
		public function set videoName( value : String ) : void
		{
			_videoName = value;
		}
	}
}

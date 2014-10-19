package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.media.VideoPlayerControls;
	import com.jordan.cp.media.events.SimpleStreamingEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class CopyVideoPanel 
	extends DisplayContainer
	{
		protected static const VIDEO_LOOPING				: Boolean = false;
		protected static const BORDER_COLOR					: uint = 0x2e2e2e;
		protected static const BORDER_SIZE					: uint = 1;
		protected static const CONTROLS_X					: uint = 12;
		protected static const CONTROLS_Y					: uint = 257;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nc									: NetConnection;
		protected var _url									: String;
		protected var _type									: String = "default"; // or SiteConstants.EGG_KONAMI
		protected var _forDanceOff							: Boolean = false;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var controls									: VideoPlayerControls;
		public var player									: SimpleStreamingPlayer;
		public var border									: Box;
		public var holder									: MovieClip;
		public var background								: Box;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyVideoPanel()
		{
//			trace( "COPYVIDEOPANEL : Constr" );
			super();
//			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			trace( "COPYVIDEOPANEL : init()" );
			// SET TYPE TO RESIZE FOR DANCE OFF
			addViews();
		}
		
		public function resize() : void
		{
//			trace( "COPYVIDEOPANEL : resize()" );
			background.width = getWidth();
			background.height = getHeight();
		}
		
		public function playVideo( url : String, nc : NetConnection ) : void
		{
//			trace( "COPYVIDEOPANEL : playVideo() : url is "+url );
			_url = url;
			_nc = nc;
			
			player = new SimpleStreamingPlayer( _nc );
			player.scaleVideo = false;
			
			var playerW : uint;
			var playerH : uint;
			
			if( _type == SiteConstants.EGG_KONAMI )
			{
				playerW = SiteConstants.VIDEO_DANCE_OFF_WIDTH;
				playerH = SiteConstants.VIDEO_DANCE_OFF_HEIGHT;
			} 
			else
			{
				playerW = SiteConstants.VIDEO_DEFAULT_WIDTH;
				playerH = SiteConstants.VIDEO_DEFAULT_HEIGHT;
			}
			
			
			
			player.setWidth( playerW );
			player.setHeight( playerH );
//			trace( "COPYVIDEOPANEL : playVideo() : _type is "+_type );
//			trace( "COPYVIDEOPANEL : playVideo() : playerW is "+playerW );
//			trace( "COPYVIDEOPANEL : playVideo() : playerH is "+playerH );
//			
//			trace( "COPYVIDEOPANEL : playVideo() : background.width is "+background.width );
//			trace( "COPYVIDEOPANEL : playVideo() : background.height is "+background.height );
			
			holder.addChild( player );
			
			if( !_forDanceOff )
			{
				addControls();
				showControls();
				activateControls();
				player.controls = controls;
			}
			
			player.addEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			player.addEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoComplete );
			player.loop = false;
			player.playVideo( _url );
		}
		
		public function destroyVideo( ) : void
		{
//			trace( "COPYVIDEOPANEL : destroyVideo()" );
			player.closeStream();
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
//			trace( "COPYVIDEOPANEL : addViews() : _forDanceOff is "+_forDanceOff );
			addBorder();
			addBackground();
			addHolder();
		}
		
		protected function addBorder( ) : void
		{
//			trace( "COPYVIDEOPANEL : addBorder()" );
			
			var borderOffset : uint = BORDER_SIZE * 2;
			if( _type == SiteConstants.EGG_KONAMI )
			{
				border = new Box( SiteConstants.VIDEO_DANCE_OFF_WIDTH + borderOffset, SiteConstants.VIDEO_DANCE_OFF_HEIGHT + borderOffset, BORDER_COLOR );
			}
			else
			{
				border = new Box( SiteConstants.VIDEO_DEFAULT_WIDTH + borderOffset, SiteConstants.VIDEO_DEFAULT_HEIGHT + borderOffset, BORDER_COLOR );
			}
			
			addChild( border );
		}
		
		protected function addHolder( ) : void
		{
//			trace( "COPYVIDEOPANEL : addHolder()" );
			holder = new MovieClip();
			holder.x = background.x;
			holder.y = background.y;
			addChild( holder );
		}
		
		protected function addBackground( ) : void
		{
//			trace( "COPYVIDEOPANEL : addBackground()" );
			if( _type == SiteConstants.EGG_KONAMI )
			{
				background = new Box( SiteConstants.VIDEO_DANCE_OFF_WIDTH, SiteConstants.VIDEO_DANCE_OFF_HEIGHT, SiteConstants.VIDEO_BG_COLOR );
			}
			else
			{
				background = new Box( SiteConstants.VIDEO_DEFAULT_WIDTH, SiteConstants.VIDEO_DEFAULT_HEIGHT, SiteConstants.VIDEO_BG_COLOR );
			}
			
			background.x = border.x + BORDER_SIZE;
			background.y = border.y + BORDER_SIZE;
			addChild( background );
			
			setWidth( background.width );
			setHeight( background.height );
		}
		
//		protected function updateVideo( ) : void
//		{
//			trace( "COPYVIDEOPANEL : updateVideo()" );
//			trace( "LANDING : updateVideo() : #######" );
//			player.adjustSize( getWidth(), getHeight() );
//			player.width = player.getWidth();
//			player.height = player.getHeight();
//
//
//			var xPos : Number = background.x;
//			var yPos : Number = background.y;
////			var xPos : Number = Math.round( ( getWidth() - player.getWidth() ) * .5 );
////			var yPos : Number = Math.round( ( getHeight() - player.getHeight() ) * .5 );
//			trace( "LANDING : updateVideo() : xPos is "+xPos );
//			trace( "LANDING : updateVideo() : yPos is "+yPos );
//			player.x = xPos;
//			player.y = yPos;
//		}
		
		protected function addControls( ) : void
		{
//			trace( "COPYVIDEOPANEL : addControls()" );
			controls = new VideoPlayerControls();
//			controls.player = player;
			controls.x = CONTROLS_X;
			controls.y = CONTROLS_Y;
		}
		
		protected function showControls( ) : void
		{
//			trace( "COPYVIDEOPANEL : showControls()" );
			addChild( controls );
			controls.show( SiteConstants.NAV_TIME_IN );
		}
		
		protected function activateControls( ) : void
		{
//			trace( "COPYVIDEOPANEL : activateControls()" );
			controls.activate();
//			controls.addEventListener( SimpleStreamingEvent.VIDEO_PLAY_PAUSE, onPlayheadClick )
		}
		
		protected function deactivateControls( ) : void
		{
//			trace( "COPYVIDEOPANEL : deactivateControls()" );

		}

		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onVideoReady( e : SimpleStreamingEvent ) : void
		{
//			trace( "COPYVIDEOPANEL : onVideoReady() : VIDEO IS FREAKING READY!" );
			player.removeEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
		
		protected function onVideoComplete( e : SimpleStreamingEvent ) : void
		{
//			trace( "COPYVIDEOPANEL : onVideoReady() : VIDEO IS COMPLETE." );
			player.removeEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoComplete );
			player.reset();
			
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set type( s : String ) : void 
		{
			_type = s
		}
		
		public function set forDanceOff( b : Boolean ) : void 
		{
			_forDanceOff = b
		}
		
		public function getVideo() : SimpleStreamingPlayer
		{
			return player;
		}
	}
}

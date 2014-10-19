package com.jordan.cp.view.intro {
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.AbstractView;

	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class Intro 
	extends AbstractView 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const PADDING						: uint = 150;
		protected static const START_PADDING				: uint = 33;
		//----------------------------------------------------------------------------
		// protected constants
		//----------------------------------------------------------------------------
		protected const LANDING								: String = "landing";
		protected const VIDEO_LOOPING						: Boolean = false;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nc									: NetConnection;
		protected var _url									: String;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var player									: SimpleStreamingPlayer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Intro() 
		{
			trace( "INTRO : Constr" );
			super();
			hide();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function updateViews( w : uint, h : uint ) : void
		{		
			trace( "INTRO : updateViews() : w is "+w+" : h is "+h );
			setWidth( w );
			setHeight( h );
			updateVideo();
			center();
//			updateBackground();
		}

		public override function transitionOut() : void
		{
			trace( "LANDING : transitionOut()" );
			hide( .25 );
			destroyVideo();
			addEventListener( ContainerEvent.HIDE, transitionInComplete );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function addViews() : void
		{
			 trace( "INTRO : addViews()" );
//			 addBackground();
			 addVideo();
		}
		
		protected function addVideo() : void
		{
			trace( "INTRO : addVideo()" );
			player = new SimpleStreamingPlayer( _nc );
			addChild( player );
			
			player.addEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			player.addEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoComplete );
			player.loop = VIDEO_LOOPING;
			player.playVideo( _url );
			updateVideo();
		}
		
		protected function updateVideo( ) : void
		{
//			trace( "INTRO : updateVideo() : #######" );
			player.adjustSize( getWidth(), getHeight() );
			player.width = player.getWidth();
			player.height = player.getHeight();


			var xPos : Number = Math.round( ( getWidth() - player.getWidth() ) * .5 );
			var yPos : Number = Math.round( ( getHeight() - player.getHeight() ) * .5 );
//			trace( "INTRO : updateVideo() : xPos is "+xPos );
//			trace( "INTRO : updateVideo() : yPos is "+yPos );
			player.x = xPos;
			player.y = yPos;
		}
		
		protected function destroyVideo( ) : void
		{
			trace( "INTRO : destroyVideo()" );
			player.closeStream();
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onVideoReady( e : SimpleStreamingEvent ) : void
		{
			trace( "INTRO : onVideoReady() : VIDEO IS FREAKING READY!" );
			player.removeEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
		
		protected function onVideoComplete( e : SimpleStreamingEvent ) : void
		{
			trace( "INTRO : onVideoReady() : VIDEO IS COMPLETE." );
			player.removeEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoReady );
			_stateModel.state = StateModel.STATE_MAIN;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set nc( nc : NetConnection ) : void
		{
			_nc = nc;
		}
		
		public function set url( s : String ) : void
		{
			_url = s;
		}
	}
}

	package com.jordan.cp.view.landing 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.media.LandingStreamingPlayer;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.jordan.cp.view.AbstractView;
	import com.jordan.cp.view.events.ViewEvent;
	import com.jordan.cp.view.welcome.Welcome;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class Landing 
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
		protected const VIDEO_LOOPING						: Boolean = true;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nc									: NetConnection;
		protected var _url									: String;
		protected var _bandwidthManager						: BandwidthManager;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var _welcome									: Welcome;
//		public var exploreButton							: ExploreButton;
		public var holder									: DisplayContainer;
		public var player									: LandingStreamingPlayer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Landing() 
		{
//			trace( "LANDING : Constr" );
//			hasBackground = false;
			
			super();
			hide();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function updateViews( w : uint, h : uint ) : void
		{		
//			trace( "LANDING : updateViews() : w is "+w+" : h is "+h );
			setWidth( w );
			setHeight( h );
			if( player && contains( player ) )	updateVideo();
			center();
//			updateBackground();
		}

		public override function transitionIn() : void
		{
			trace( "LANDING : transitionIn()" );
			addEventListener( ContainerEvent.SHOW, transitionInComplete );
			show( SiteConstants.NAVBAR_TIME_IN );
			_welcome.addEventListener( Event.COMPLETE, doBandwidthChosen );
			_welcome.transitionIn();
		}

		public override function transitionOut() : void
		{
			trace( "LANDING : transitionOut()" );
			hide( .25 );
			destroyVideo();
			addEventListener( ContainerEvent.HIDE, transitionInComplete );
		}

		public function playVideo( url : String ) : void
		{
//			trace( "LANDING : playVideo() : url is "+url );
			addVideo( url );
		}
		
		public function killLoop() : void
		{
			// KILLS LOOP AND NOTIFIES MAIN TO CHANGE STATE
			if(player) player.loop = false;
		}
		
//		public function showStartExploring() : void
//		{
////			var preloader : WelcomePreloader = _welcome.preloader;
////			preloader.showStartExploring()
//			var preloader : HelpPreloader = _welcome.preloader;
//			preloader.showStartExploring()
//		}

		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function addViews() : void
		{
			 trace( "LANDING : addViews()" );
//			 addBackground();
			 addVideoHolder();
			 addWelcomeWindow();
//			 addExploreButton();
		}
		
		protected function updateVideo( ) : void
		{
//			trace( "LANDING : updateVideo() : #######" );
			player.adjustSize( getWidth(), getHeight() );
			player.width = player.getWidth();
			player.height = player.getHeight();


			var xPos : Number = Math.round( ( getWidth() - player.getWidth() ) * .5 );
			var yPos : Number = Math.round( ( getHeight() - player.getHeight() ) * .5 );
//			trace( "LANDING : updateVideo() : xPos is "+xPos );
//			trace( "LANDING : updateVideo() : yPos is "+yPos );
			player.x = xPos;
			player.y = yPos;
		}
		
		protected function destroyVideo( ) : void
		{
//			trace( "LANDING : destroyVideo()" );
			if( player && contains( player ) )	player.closeStream();
		}
		
		protected override function center( ) : void
		{
//			trace( "LANDING : center()" );
			var xPos : uint = Math.round( ( getWidth() - _welcome.width ) *.5 );
			var yPos : uint = Math.round( ( getHeight() - _welcome.height ) *.5 );
			_welcome.x = xPos;
			_welcome.y = yPos;
			
//			exploreButton.x = Math.round( _welcome.x + ( ( _welcome.width - exploreButton.width ) * .5 ) );
//			exploreButton.y = _welcome.y + _welcome.height + START_PADDING;
		}
		
		protected function addVideoHolder() : void
		{
			trace( "LANDING : addVideoHolder()" );
			holder = new DisplayContainer();
			addChild( holder );
		}
		
		protected function addVideo( url : String ) : void
		{
			trace( "LANDING : addVideo() : url is "+url );
			player = new LandingStreamingPlayer( _nc );
			player.visible = false;
			player.alpha = 0;
			holder.addChild( player );
			player.setWidth( Shell.getInstance().stageW );
			player.setHeight( Shell.getInstance().stageH );
			
			player.addEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			player.loop = VIDEO_LOOPING;
			player.playVideo( url );
			updateVideo();
			
//			TweenLite.from( player, SiteConstants.NAVBAR_TIME_IN, { alpha: 0, ease: Quad.easeIn } );
		}
		
		protected function addWelcomeWindow() : void
		{
			trace( "LANDING : addWelcomeWindow()" );
//			_welcome.bandwidthManager = _bandwidthManager;
			_welcome.init();
//			_welcome.addEventListener( ViewEvent.START_EXPLORING, onStartExploring );
//			_welcome.transitionIn();
			addChild( _welcome );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected override function transitionInComplete( e : ContainerEvent = null ) : void
		{
			removeEventListener( ContainerEvent.SHOW, transitionInComplete );
//			bandwidthWindow.init();
//			bandwidthWindow.bandwidthManager = _bandwidthManager;
		}
		
//		protected function onStartExploring( e : ViewEvent ) : void
//		{
////			trace( "LANDING : onStartExploring()" );
//			_welcome.removeEventListener( ViewEvent.START_EXPLORING, onStartExploring );
//			_stateModel.state = StateModel.STATE_MAIN;
//		}

		protected function onExploreOver( e : MouseEvent ) : void
		{
//			trace( "LANDING : onExploreOver()" );
		}
		
		protected function onExploreOut( e : MouseEvent ) : void
		{
//			trace( "LANDING : onExploreOut()" );
		}
		
		protected function doBandwidthChosen( e : Event ) : void
		{
			trace( "LANDING : doBandwidthChosen()" );
			_welcome.removeEventListener( Event.COMPLETE, doBandwidthChosen );
			Shell.getInstance().bandwidthChosen = true;
			dispatchEvent( new ViewEvent( ViewEvent.BANDWIDTH_SELECTED ) );
		}
		
		protected function onVideoReady( e : SimpleStreamingEvent ) : void
		{
			trace( "\n\n");
			trace( "LANDING : onVideoReady() : VIDEO IS FREAKING READY!" );
			player.removeEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady );
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
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
		
		public function set welcome( object : Welcome ) : void
		{
			trace( "LANDING : set welcome() : _welcome is "+object );
			_welcome = object;
		}
		
		protected function getScale( w : uint, h : uint ) : Number
		{
			var percent : Number;
			var videoPercent : Number = 2 / 1;
			var stagePercent : Number = w / h;
			
			if( stagePercent)
			trace( "SIMPLESTREAMINGPLAYER : getScale() ********** stagePercent is "+stagePercent );
			return percent;
		}
	}
}

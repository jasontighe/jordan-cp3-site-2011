package com.jordan.cp.view.vignette {
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.Tokens;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.view.AbstractOverlay;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author jason.tighe
	 */
	public class DualVideo 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var ICON_X							: uint = 337;
		protected static var ICON_Y							: uint = 23;
		protected static var TITLE_X						: uint = 398;
		protected static var TITLE_Y						: uint = 35;
		protected static var NAV_X							: uint = 53;
		protected static var NAV_Y							: uint = 143;
		protected static var EXIT_X							: uint = 383;
		protected static var EXIT_Y							: uint = 502;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _votingData							: DualVotingData;
		protected var _votingArray							: Array = new Array();
		protected var _videosComplete						: Boolean = false;
		protected var _videosVoted							: Boolean = false;
		protected var _type									: String;
		protected var _inSummary							: Boolean = false;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon										: MovieClip;
		public var titleTxt									: TextContainer;
		public var boyResult								: DualVideoResult;
		public var girlResult								: DualVideoResult;
		public var voteNav									: DualVoteNav;
		public var background								: Box;
		public var exitButton								: AbstractExitButton;
		public var votedIcon								: MovieClip;
//		public var girlBtn									: MovieClip;
//		public var voteBoyBtn								: MovieClip;
//		public var voteGirlBtn								: MovieClip;
//		public var boyOverlay								: MovieClip;
//		public var girlOverlay								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function DualVideo() 
		{
			super();
			_votingArray = [ SiteConstants.DANCE_OFF_JORDAN, SiteConstants.DANCE_OFF_BLONDE ];
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			trace( "DUALVIDEO : init()" );
			addViews();
		}
		
		public override function updateViews( stageW : uint, stageH : uint ) : void
		{
//			trace( "DUALVIDEO : updateViews()" );
			setWidth( stageW );
			setHeight( stageH );
			exitButton.x = Math.round( ( x + width - exitButton.width ) * .5 );
			exitButton.y = EXIT_Y;
			
			center();
		}
		
		public function addViews(  ) : void
		{
//			trace( "DUALVIDEO : addViews()" );
			addBackground();
			addIcon();
			addCopy( "Dance Off" );
			addNav();
			addExitButton();
//			testVote();			
		}
		
		public override function transitionIn() : void
		{
			alpha = 1;
			TweenLite.from( this, TIME_IN, { alpha: 0, onComplete: transitionInComplete  } );
			if( exitButton && contains( exitButton ) )	exitButton.activate();
		}
		
		public override function transitionOut() : void
		{
			TweenLite.to( this, TIME_OUT, { alpha: 0, onComplete: transitionOutComplete  } );
		}
		
		public function pauseVignette() : void
		{
//			trace( "DUALVIDEO : pauseVignette()" );
			var videos : Array = voteNav.videos;
			var i : uint = 0;
			var I : uint = videos.length;
//			trace( "DUALVIDEO : pauseVignette() : videos.length is "+videos.length );
			for( i; i < I; i++ )
			{
				var player : SimpleStreamingPlayer = videos[ i ];
				player.pauseStream();
			}
		}
		
		public function resumeVignette() : void
		{
//			trace( "DUALVIDEO : resumeVignette()" );
			var videos : Array = voteNav.videos;
			var i : uint = 0;
			var I : uint = videos.length;
//			trace( "DUALVIDEO : resumeVignette() : videos.length is "+videos.length );
			for( i; i < I; i++ )
			{
				var player : SimpleStreamingPlayer = videos[ i ];
				player.resumeStream();
			}
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function transitionInComplete() : void
		{
//			if( voteNav && contains( voteNav ) ) 	
				voteNav.playVideos();
		}
		
		protected function addBackground( ) : void
		{
//			trace( "ABSTRACTVIGNETTE : addBackground()" );
			background = new Box( 860, SiteConstants.STAGE_AREA_HEIGHT );
			background.alpha = 0;
			addChild( background );
			
			setWidth( width );
			setHeight( height );
		}
		
		protected function addIcon() : void
		{
//			trace( "DUALVIDEO : addIcon()" );
			icon = MovieClip( AssetManager.gi.getAsset( "DualIconAsset", SiteConstants.ASSETS_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
		}

		protected function addCopy( s : String ) : void
		{	
//			trace( "DUALVIDEO : addCopy()" );
			titleTxt = new TextContainer();
			titleTxt.populate( s.toUpperCase(), "voting-title");
			titleTxt.x = TITLE_X;
			titleTxt.y = TITLE_Y;
			addChild( titleTxt );
		}
		
		protected function addNav() : void
		{
//			trace( "DUALVIDEO : addNav()" );
			var name : String = SiteConstants.EGG_KONAMI;
			var dto : ContentDTO = Shell.getInstance().getContentModel().getContentItemByName( name );
			voteNav = new DualVoteNav();
			voteNav.addNav( dto );
			voteNav.x = NAV_X;
			voteNav.y = NAV_Y;
			voteNav.addEventListener( Event.COMPLETE, onVideoVoted );
			voteNav.addEventListener( SimpleStreamingEvent.VIDEO_COMPLETE , onVideosComplete );
			addChild( voteNav );
		}
		
//		protected function addExitButton() : void
//		{
//			trace( "EMAIL : addExitButton()" );
//			exitButton = new AbstractExitButton();
//			exitButton.addViews( _type );
//			exitButton.addViews( SiteConstants.EXIT_BUTTON_CLOSE );
//			exitButton.addEventListener( Event.COMPLETE, onExitClick );
//			addChild( exitButton );
//		}
		
		protected function addExitButton() : void
		{
//			trace( "EMAIL : addExitButton()" );
			exitButton = new AbstractExitButton();
			exitButton.addViews( SiteConstants.EXIT_BUTTON_CLOSE );
			exitButton.addEventListener( Event.COMPLETE, onExitClick );
			addChild( exitButton );
		}
		
		
		protected function testVote( ) : void 
		{	
			var id : uint = Math.round( Math.random());
			sendVote( id );	
		}
		
		
		protected function sendVote( n : uint ) : void 
		{	
//			trace( "DUALVIDEO : sendVote() : n is "+n );
			// VOTE AND RESULTS
			// http://cp-services.dev.nyc.wk.com/svcs/vote.php
			// RESULTS ONLY
			// http://cp-services.dev.nyc.wk.com/svcs/get_results.php
			var vote : String= _votingArray[ n ];
//			trace( "DUALVIDEO : sendVote() : vote is "+vote );

			var variables : URLVariables = new URLVariables();
			variables.video_id = vote;

			var request : URLRequest = new URLRequest( Tokens.VOTE_AND_RESULTS_URL );
			request.method = URLRequestMethod.GET;
			request.data = variables;

			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResultsReceived );
			loader.load(request);
		}
		
		protected function onResultsReceived( e : Event) : void 
		{
			//Get the returned JSON data string
			var data : String = e.target.data as String;
			var response : Object = JSON.decode( data ) as Object;
			_votingData = new DualVotingData( response );
			showVotedIcon();
			_videosVoted = true;
			showResults();
			trace( "DUALVIDEO : onResultsReceived() : data is "+ data );
			trace( "DUALVIDEO : onResultsReceived() : response is "+ response );
		}
		
		protected function showResults( ) : void 
		{
			trace( "DUALVIDEO : showResults()" );
			trace( "DUALVIDEO : showResults() : _votingData.jordanPerc is "+_votingData.jordanPerc );
			trace( "DUALVIDEO : showResults() : _votingData.blondePerc is "+_votingData.blondePerc );
//			var percentages : Array = new Array( _votingData.jordanPerc, _votingData.blondePerc );
			var percentages : Array = new Array();
			percentages = [ _votingData.jordanPerc, _votingData.blondePerc ];
			voteNav.showResults( percentages );
		}
		
		protected function showVotedIcon( ) : void 
		{
//			trace( "DUALVIDEO : showVotedIcon()" );
			votedIcon = MovieClip( AssetManager.gi.getAsset( "VotedAsset", SiteConstants.ASSETS_ID ) );
			var xPos : uint = NAV_X + voteNav.itemXPos + ( ( SiteConstants.VIDEO_DANCE_OFF_WIDTH - votedIcon.width) * .5 );
			
			var id : uint = voteNav.id;
//			var xPos : uint = voteNav.nav.getItemAt( id );
			votedIcon.x = xPos;
			votedIcon.y = NAV_Y + DualVoteNavItem.VOTE_Y;
			addChild( votedIcon );
			
			var iconMask : Box = new Box( votedIcon.width, votedIcon.height );
			iconMask.x = votedIcon.x;
			iconMask.y = votedIcon.y;
			addChild( iconMask );
			
			votedIcon.mask = iconMask;
			votedIcon.y -= votedIcon.height;
			
			TweenLite.to( votedIcon, SiteConstants.NAV_TIME_IN * .45, { y: iconMask.y, ease:Quad.easeOut, delay: SiteConstants.NAV_TIME_IN * .5 } );
		}
		
//		protected function checkFinishedActions() : void
//		{
////			trace( "DUALVIDEO : checkFinishedActions() : _videosComplete is "+_videosComplete );
////			trace( "DUALVIDEO : checkFinishedActions() : _videosVoted is "+_videosVoted );
//			if( _videosComplete && _videosVoted )
//			{
//				showResults();
//			}
//		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onExitClick( e : Event = null ) : void
		{
			trace( "DUALVIDEO : onExitClick()" );
			if( _inSummary )
			{
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
			else
			{
				_stateModel.state = StateModel.STATE_VIGNETTE_OUT;
			}
		}

		protected function onVideoVoted( e : Event = null ) : void
		{
//			trace( "DUALVIDEO : onVideoVoted()" );
			var id : uint = voteNav.id;
			sendVote( id );
		}
		
		protected function onVideosComplete( e : SimpleStreamingEvent = null ) : void
		{
//			trace( "DUALVIDEO : onVideosComplete() : THE DANCE OFF VIDEOS ARE FINISHED PLAYING...." );
			_videosComplete = true;
//			checkFinishedActions();
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set type( s : String ) : void
		{
			_type = s;
		}
		
		public function set inSummary( value : Boolean ) : void
		{
			_inSummary = value;
		}
		
	}
}

package com.jordan.cp.media {
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.media.events.SimpleStreamingEvent;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author jason.tighe
	 */
	public class SimpleStreamingPlayer 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _netStream						: NetStream;
		protected var _nc								: NetConnection;
		protected var _url								: String;
		protected var _loop								: Boolean = false;
		protected var _videoFinished					: Boolean = false;
		protected var _videoStarted						: Boolean = false;
		protected var _isPlaying						: Boolean = false;
		protected var _isPlayingAtScrub					: Boolean = false;
		protected var _scaleVideo						: Boolean = true;
		protected var _duration							: Number = 0;
		protected var _framerate						: Number;
		protected var _metaVideoW						: Number;
		protected var _metaVideoH						: Number;
		protected var _currentTime						: Number = 0;
		protected var _controls							: VideoPlayerControls;
		//----------------------------------------------------------------------------
		// public variables 
		//----------------------------------------------------------------------------
		public var video								: Video;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SimpleStreamingPlayer( nc : NetConnection ) 
		{
//			trace( "SIMPLESTREAMINGPLAYER : Constr" );
			_nc = nc;
			_netStream = new NetStream( _nc );
			_netStream.client = {};
			_netStream.bufferTime = .0001;
			_netStream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
			_netStream.addEventListener( NetStatusEvent.NET_STATUS,	onNetStatus );
			
			var custom_obj : Object = new Object();
			custom_obj.onMetaData = metaDataHandler;
//			custom_obj.onCuePoint = onCuePointHandler;
//			custom_obj.onPlayStatus = playStatusHandler;
			_netStream.client = custom_obj;
			
			// http://help.adobe.com/en_US/FlashMediaServer/3.5_CS_ASD/WS5b3ccc516d4fbf351e63e3d11a070f7ddf-7ede.html#WS5b3ccc516d4fbf351e63e3d11a070f7ddf-7fad	
			custom_obj.onPlayStatus = function ( infoObject : Object )  : void
			{ 
//				trace( "\nSIMPLESTREAMINGPLAYER : NetStream.onPlayStatus called: ("+getTimer()+" ms)" );
//			    for (var prop : Object in infoObject) 
//			    { 
//			        trace( "\t"+prop+":\t"+infoObject[prop]); 
//			    } 
				if( infoObject.code == 'NetStream.Play.Complete')	onVideoComplete();
//			    trace("\n"); 
			}
			
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function playVideo( url : String ) : void
		{
			trace( "SIMPLESTREAMINGPLAYER : playVideo() : url is "+url );
			_url = url;
			
			if( _scaleVideo )	adjustSize( getWidth(), getHeight() );
			
			//attach netstream to the video object
			video = new Video( getWidth(), getHeight() );
			video.smoothing = true;
			video.attachNetStream( _netStream );
			addChild( video );
			
			_isPlaying = true;
			addEventListener( Event.ENTER_FRAME, onVideoPlaying );
			_netStream.play( _url );
			
			trace( "SIMPLESTREAMINGPLAYER : playVideo() : getWidth() is "+getWidth() );
			trace( "SIMPLESTREAMINGPLAYER : playVideo() : getHeight() is "+getHeight() );
//			center();
		}

		public function seek( time : Number ) : void
		{
			_netStream.seek( time );
		}
		
		public function reset( ) : void
		{
//			trace( "SIMPLESTREAMINGPLAYER : reset()" );
			_netStream.pause();
			_netStream.seek( 0 );
		}
		
		// USE THIS TO ADJUST WIDTH AND HEIGHT ACCORDING TO STAGE SIZE : ONSTAGERESIZE
		public function adjustSize( stageW : uint, stageH : uint ) : void
		{
			var videoW : uint = SiteConstants.VIDEO_WIDTH;
			var videoH : uint = SiteConstants.VIDEO_HEIGHT;
			
			getScale( videoW, videoH );
			
			var widthPercent : Number = stageW / videoW;
			var heightPercent : Number = stageH / videoH;
			
			var percent : Number = Math.max( widthPercent, heightPercent );
			
			var adjustedW : Number = Math.floor( videoW * percent );
			var adjustedH : Number = Math.floor( videoH * percent );
			
			setWidth( adjustedW );
			setHeight( adjustedH );
			
			trace( "SIMPLESTREAMINGPLAYER : adjustSize() : widthPercent is "+widthPercent );
			trace( "SIMPLESTREAMINGPLAYER : adjustSize() : heightPercent is "+heightPercent );
		}
		
		public function pauseStream() : void
		{
			trace( "SIMPLESTREAMINGPLAYER : pauseStream()" );
			_isPlaying = false;
			removeEventListener( Event.ENTER_FRAME, onVideoPlaying );
			_currentTime = _netStream.time;
			_netStream.close();
		}
		
		public function resumeStream() : void
		{
			trace( "SIMPLESTREAMINGPLAYER : resumeStream()" );
			_isPlaying = true;
			addEventListener( Event.ENTER_FRAME, onVideoPlaying );
			_netStream.play( _url );
			_netStream.seek( _currentTime );
		}
		
		public function togglePause() : void
		{
			trace( "SIMPLESTREAMINGPLAYER : togglePause()" );
			_netStream.togglePause();
		}
		
		public function closeStream() : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace( "SIMPLESTREAMINGPLAYER : closeStream()" );
//			trace("SimpleStreamingPlayer.closeStream() : _netStream.peerStreams: BEFORE: " + (_netStream.peerStreams.length));
//			trace("SimpleStreamingPlayer.closeStream() : _nc.unconnectedPeerStreams: BEFORE: " + (_nc.unconnectedPeerStreams.length));
_netStream.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
_netStream.removeEventListener( NetStatusEvent.NET_STATUS,	onNetStatus );
			removeEventListener( Event.ENTER_FRAME, onVideoPlaying );
//			_netStream.pause();
			_netStream.close();
//			_netStream = null;
			
			removeChild( video );
video.clear();
video.attachNetStream(null);
//			video = null;
			
//			trace("SimpleStreamingPlayer.closeStream() : _nc.unconnectedPeerStreams: AFTER: " + (_nc.unconnectedPeerStreams.length));
		}

		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function onNetStatus( e : Object ) : void 
		{
//			trace( "**********" );
//			trace( "SIMPLESTREAMINGPLAYER : onNetStatus() : _nc.connected is "+_nc.connected );
//			trace( "SIMPLESTREAMINGPLAYER : onNetStatus() : e.info.code is "+e.info.level );
			trace( "SIMPLESTREAMINGPLAYER : onNetStatus() : e.info.code is "+e.info.code );
			
			
//			trace( "SIMPLESTREAMINGPLAYER : onNetStatus() : _netStream.time is "+_netStream.time );
			//handles NetConnection and NetStream status events
			switch ( e.info.code ) 
			{
				case "NetConnection.Connect.Success":
					//play stream if connection successful
//					connectStream();
//					dispatchCompleteEvent();
					break;
				
				case "NetConnection.Connect.Rejected":
					//error if stream file not found in
					//location specified
					trace("Stream not found: " + _url);
					break;
				
				case "NetConnection.Connect.Closed":
					//error if stream file not found in
					//location specified
					trace("SIMPLESTREAMINGPLAYER : SOD OFF!");
					break;
				
				case "NetStream.Play.StreamNotFound":
					//error if stream file not found in
					//location specified
					trace("Stream not found: " + _url);
					break;
				
				case "NetStream.Unpause.Notify":
//					trace( "\n" );
//					toggleIsPlaying();
					break;
				
				case "NetStream.Pause.Notify":
//					trace( "\n" );
//					toggleIsPlaying();
					break;
				
				case "NetStream.Play.Stop":
					trace( "\n" );
//					toggleIsPlaying();
//					startPlayingEnterFrame();
					trace( "SIMPLESTREAMINGPLAYER : NetStream.Play.Stop() ..................................... _isPlaying is "+_isPlaying );
					
					dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_PLAY_PAUSE ) );
					//do if video is stopped
//					onVideoComplete();
					break;
				case "NetStream.Buffer.Full":
					trace( "SIMPLESTREAMINGPLAYER : NetStream.Buffer.Full()" );
					if( !_videoStarted )
					{
//						trace( "SIMPLESTREAMINGPLAYER : NetStream.Buffer.Full() : _videoStarted is "+_videoStarted );
						dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_READY ) );
//						toggleIsPlaying();
//						startPlayingEnterFrame();
						_videoStarted = true;
					}

					break;				
				
				
				case "NetStream.Seek.Notify":                
					// A successful seek() call has occurred. THIS DOESN'T DO SHITE.
	                // Parse event.info.description to check whether the seek is "smart".
//                    var desc : String = new String( e.info.description); 
//                    if( desc.indexOf( "client-inBufferSeek" ) >= 0 ) 
//                        trace("A SMART SEEK occured"); 
//                    else 
//                        trace("A STANDARD SEEK occured"); 
                    break; 
			}
		}
		
		protected function getScale( w : uint, h : uint ) : Number
		{
			var percent : Number;
			var videoPercent : Number = 2 / 1;
			var stagePercent : Number = w / h;
			
//			if( stagePercent)
//			trace( "SIMPLESTREAMINGPLAYER : getScale() ********** stagePercent is "+stagePercent );
			return percent;
		}
		
		protected function onVideoComplete() : void 
		{
			trace( "SIMPLESTREAMINGPLAYER : onVideoComplete()" );
			
			if( _loop )
			{
				_netStream.play( _url );
//				_netStream.seek( 0 );
			}
			else
			{
				_isPlaying = false;
				_currentTime = 0.1;
				removeEventListener( Event.ENTER_FRAME, onVideoPlaying );
				dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
//				Shell.getInstance().main.stateModel.state = StateModel.STATE_MAIN;
			}
			
			togglePlayhead();
		}
		
		protected function startPlayingEnterFrame() : void 
		{
			if( _isPlaying )
			{
				addEventListener( Event.ENTER_FRAME, onVideoPlaying );
			}
			else
			{
				removeEventListener( Event.ENTER_FRAME, onVideoPlaying );
			}
		}
		 
//		private function setVideoInit() : void 
//		{
////			trace( "SIMPLESTREAMINGPLAYER : setVideoInit()" );
//			_netStream.play( _url );
//			_netStream.pause();
//			_netStream.seek( 0 );
//		}
		
		protected function addControlListeners() : void 
		{
			trace( "COPYVIDEOPANEL : addControlListeners() .........................." );
			_controls.addEventListener( SimpleStreamingEvent.VIDEO_PLAY_PAUSE, onPlayheadClick );
			_controls.addEventListener( SimpleStreamingEvent.VIDEO_SCRUB_START, onControlsScrubStart );
			_controls.addEventListener( SimpleStreamingEvent.VIDEO_SCRUB_END, onControlsScrubEnd );
		}
		
		protected function togglePlayhead() : void
		{
			trace( "COPYVIDEOPANEL : togglePlayhead() : " );
			trace( "COPYVIDEOPANEL : togglePlayhead() : _controls is "+_controls );
			trace( "COPYVIDEOPANEL : togglePlayhead() : contains( _controls ) is "+contains( _controls ) );
			if( _controls != null )
			{
				_controls.togglePlayhead()
			}
		}
		
		protected function onControlsScrubStart( e : SimpleStreamingEvent = null ) : void
		{
			trace( "COPYVIDEOPANEL : onControlsScrubStart() : " );
			_isPlayingAtScrub = _isPlaying;
			pauseStream();
		}
		
		protected function onControlsScrubEnd( e : SimpleStreamingEvent = null ) : void
		{
			trace( "COPYVIDEOPANEL : onControlsScrubStart() : " );
			
			_currentTime = _duration * _controls.barPercent;
			if( _isPlayingAtScrub )
			{
				resumeStream();
			}
			else
			{
				pauseStream();
			}
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onAsyncErrorHandler( e : AsyncErrorEvent ) : void 
		{
			trace( "SIMPLESTREAMINGPLAYER : onAsyncErrorHandler() e.info.code is "+e.text );
		}
		
		protected function asyncErrorHandler( e : AsyncErrorEvent ) : void 
		{
			trace( "SIMPLESTREAMINGPLAYER : asyncErrorHandler() e.text is "+e.text );
		}
		
		protected function metaDataHandler( metaInfoObj : Object ) : void 
		{
//			trace( "SIMPLESTREAMINGPLAYER : metaDataHandler()" );
			_duration= metaInfoObj.duration;
			_framerate = metaInfoObj.framerate;
			_metaVideoW = metaInfoObj.width;
			_metaVideoH = metaInfoObj.height;
			
			if( _controls )	_controls.setDuration( _duration );
			
//			trace( "SIMPLESTREAMINGPLAYER : metaDataHandler() : _duration is "+_duration );
//			trace( "SIMPLESTREAMINGPLAYER : metaDataHandler() : _framerate is "+_framerate );
//			trace( "SIMPLESTREAMINGPLAYER : metaDataHandler() : _metaVideoW is "+_metaVideoW );
//			trace( "SIMPLESTREAMINGPLAYER : metaDataHandler() : _metaVideoH is "+_metaVideoH );
		}
		
		protected function onVideoPlaying( e : Event ) : void 
		{
			var seconds : Number = _netStream.time;
//			trace( "SIMPLESTREAMINGPLAYER : onVideoPlaying() .... seconds is "+seconds+" ...." );
			if( _controls )	_controls.updateProgress( seconds );
		}

		public function secondsToTimecode( seconds : Number ) : String
		{
		    var s:Number = seconds % 60;
		    var m:Number = Math.floor((seconds % 3600 ) / 60);
		    var h:Number = Math.floor(seconds / (60 * 60));
		 
//		    var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
		    var minuteStr:String = doubleDigitFormat(m) + ":";
		    var secondsStr:String = doubleDigitFormat(s);
		 
		    return minuteStr + secondsStr;
//		    return hourStr + minuteStr + secondsStr;
		}
		 
		protected function doubleDigitFormat(num:uint):String
		{
		    if (num < 10)
		    {
		        return ( "0" + num );
		    }
		    return String( num );
		}
		
		protected function onPlayheadClick( e : SimpleStreamingEvent ) : void
		{
			trace( "COPYVIDEOPANEL : onPlayheadClick() : VIDEO HAS PLAYED OR PAUSED. .......................... _isPlaying is "+_isPlaying );
//			togglePause();
			
			if( _isPlaying )
			{
				pauseStream();
			}
			else
			{
				resumeStream();
			}
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set loop( value : Boolean ) : void
		{
			_loop = value;
		}
		
		public function get isPlaying() : Boolean
		{
			return _isPlaying;
		}
		
		public function get duration() : Number
		{
			return _duration;
		}
		
		public function set controls( object : VideoPlayerControls ) : void
		{
			_controls = object;
			addControlListeners();
		}
		
		public function set scaleVideo( value : Boolean ) : void
		{
			_scaleVideo = value;
		}
	}
}

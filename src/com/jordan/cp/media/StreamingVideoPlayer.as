package com.jordan.cp.media {
	import fl.video.VideoEvent;

	import com.jasontighe.containers.DisplayContainer;

	import mx.controls.Button;

	import flash.events.*;
	import flash.media.Video;
	import flash.net.*;

	//	import fl.controls.Button;

	/**
	 * @author jason.tighe
			 
				http://api.brightcove.com/services/library"
	                + "?command=find_all_videos"
	                  + "&video_fields=id,name,referenceId"
	                  + "&token=BMkaixIhjbhxfa5ATEGTzXm9CrmR8urXRDr9o7bbc64.";
	                   
	                   
	                   
	                   http:\/\/brightcove.vo.llnwd.net\/d2\/unsecured\/media\/270881183\/270881183_502534831_9c1e5fe9c3e95ca5009e7ceb68df2915ff669774.jpg?pubId=270881183
	                   
               
            MEDIA TOKENS 
            Type	: read
			uMLrHgmzi0iYFZk-QXxHS9WRqj2WafAqbKRt_ODOVvlTXMNzgMcFdQ..
			
			Type	: read (URL Access)
			uMLrHgmzi0iELX_Rf6eWjyKz0coiCW9xu3GnnAFgesOdTXiHr9eRwQ..
			
			Type	: write
			uMLrHgmzi0g9Bsj5AJgKvhju2-2w1O60TQcLs8yEHZk-xkk3JzvPYg..   
			  
	 */
	public class StreamingVideoPlayer 
	extends DisplayContainer 
	{
		private var _videoURL					 	: String;
		private var _video						 	: Video;
		private var _vidDuration					: Number;
		private var _videoWidth						: uint;
		private var _videoHeight					: uint;
		private var _vidWidth						: Number;
		private var _vidHeight						: Number;	
		private var _netConnection					: NetConnection = new NetConnection();
		private var _serverLoc						: String;
		private var _netStream						: NetStream;
		private var _start_btn						: Button;

		public function StreamingVideoPlayer( ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : Constr" );
		}
		
		public function connect( serverLoc : String ) : void 
		{
			
//			trace( "STREAMINGVIDEOPLAYER : connect" );
			//set video params
//			var authParams : Array = authParams;
			
			//add eventListeners to NetConnection and connect
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			_netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorHandler );
			_netConnection.objectEncoding = ObjectEncoding.AMF3;
			_netConnection.client = this;
			_netConnection.connect( serverLoc );
		}
		
		public function attachNetStream( w : uint = 320, h : uint = 240 ) : void
		{
//			trace( "STREAMINGVIDEOPLAYER : connect()" );
			//netstream object
			_netStream = new NetStream( _netConnection );
			_netStream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
			_netStream.addEventListener( NetStatusEvent.NET_STATUS,	onNetStatus );
			
			//other event handlers assigned
			//to the netstream client property
			var custom_obj : Object = new Object();
			custom_obj.onMetaData = onMetaDataHandler;
			custom_obj.onCuePoint = onCuePointHandler;
			custom_obj.onPlayStatus = playStatus;
			_netStream.client = custom_obj;
			
			//attach netstream to the video object
			_video = new Video( 720, 360 );
//			_video.smoothing = true;
			_video.attachNetStream( _netStream );
			addChild(_video);
		}
		
		public function playStream( videoName : String, seekTime : Number = 0 ) : void 
		{
//			trace( "STREAMINGVIDEOPLAYER : playStream() : videoName is "+videoName );
			
//			if( !_netStream.hasEventListener( NetStatusEvent.NET_STATUS ) )
//			{
//				_netStream.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
//			}
			
			var time : Number = _netStream.time;
			trace( "STREAMINGVIDEOPLAYER : playStream() : time is "+time );
			_netStream.play( videoName );
//			_netStream.pause();
			_netStream.seek( time );
//			playStreamSeek( time );
		}
		
		public function playStreamSeek( time : Number = 0 ) : void 
		{
//			trace( "STREAMINGVIDEOPLAYER : playStreamSeek() : time is "+time );
			_netStream.seek( time );
		}
		
//		TODO
		public function onBWDone( ) : void 
		{
//			trace( "STREAMINGVIDEOPLAYER : onBWDone() : **** TODO!" );
		}
		
//		protected function addCuePoints() : void
//		{
//			_netStream.client.onCuePoint = ns_onCuePoint; 
//		}
		
//		function ns_onCuePoint(item:Object):void 
//		{ 
//				trace("cuePoint"); trace(item.name + "\t" + item.time); 
//		}
		
		protected function dispatchCompleteEvent() : void
		{
//			trace( "STREAMINGVIDEOPLAYER : dispatchCompleteEvent()" );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function onNetStatus( e : Object ) : void 
		{
//			trace( "**********" );
//			trace( "STREAMINGVIDEOPLAYER : onNetStatus() : _netConnection.connected is "+_netConnection.connected );
//			trace( "STREAMINGVIDEOPLAYER : onNetStatus() : e.info.code is "+e.info.level );
//			trace( "STREAMINGVIDEOPLAYER : onNetStatus() : e.info.code is "+e.info.code );
			//handles NetConnection and NetStream status events
			switch ( e.info.code ) 
			{
				case "NetConnection.Connect.Success":
					//play stream if connection successful
//					connectStream();
					dispatchCompleteEvent();
					break;
				
				case "NetConnection.Connect.Rejected":
					//error if stream file not found in
					//location specified
					trace("Stream not found: " + _videoURL);
					break;
				
				case "NetConnection.Connect.Closed":
					//error if stream file not found in
					//location specified
					trace("STREAMINGVIDEOPLAYER : SOD OFF!");
					break;
				
				case "NetStream.Play.StreamNotFound":
					//error if stream file not found in
					//location specified
					trace("Stream not found: " + _videoURL);
					break;
				
				case "NetStream.Play.Stop":
					//do if video is stopped
					videoPlayComplete();
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
			
			
//			trace( "**********" );
		}
		
		private function onAsyncErrorHandler( e : AsyncErrorEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onAsyncErrorHandler() e.info.code is "+e.text );
		}
		 
		/* -------------NetStream actions and events-------------- */
		private function videoPlayComplete() : void 
		{
//			trace( "STREAMINGVIDEOPLAYER : videoPlayComplete()" );
//			setVideoInit();
		}
		 
		private function setVideoInit() : void 
		{
			trace( "STREAMINGVIDEOPLAYER : setVideoInit()" );
			_netStream.play(_videoURL);
			_netStream.pause();
			_netStream.seek(_vidDuration/2);
			
//			addStartBtn();
		}
		
		private function playStatus( e : Object ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : playStatus()" );
			//handles onPlayStatus complete event if available
			switch ( e.info.code ) 
			{
				case "NetStream.Play.Complete":
					//do if video play completes
					videoPlayComplete();
					break;
			}
			//trace(event.info.code);
		}
		
		private function playFlv( e : MouseEvent = null ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : playFlv()" );
			_netStream.play(_videoURL);
			//_netStream.seek(192); //used for testing
			removeChild(_start_btn);
		}
		
		private function pauseFlv( e : MouseEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : pauseFlv()" );
			_netStream.pause();
		}
		 
		/* -----------------Video handlers---------------- */
		private function onVideoLoading( e : VideoEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onVideoLoading()" );
		}
		
		private function onVideoPlaying( e : VideoEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onVideoPlaying()" );
		}
		
		private function onVideoReady( e : VideoEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onVideoReady()" );
		}
		 
		/* ---------Buttons, labels, and other assets------------- */
		//could be placed in it's own VideoControler class
		private function addStartBtn() : void 
		{
			trace( "STREAMINGVIDEOPLAYER : addStartBtn()" );
			_start_btn = new Button();
 			_start_btn.width = 80;
			_start_btn.x = (_videoWidth-_start_btn.width)/2+_video.x;
			_start_btn.y = (_videoHeight-_start_btn.height)/2+_video.y;
			_start_btn.label = "Start Video";
			_start_btn.addEventListener( MouseEvent.CLICK, playFlv );
			//addChild(_start_btn);
		}
		 
		/* -----------------Information handlers---------------- */
		private function onMetaDataHandler( metaInfoObj : Object ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onMetaDataHandler()" );
			_video.width = metaInfoObj.width;
			_vidWidth = metaInfoObj.width;
			_video.height = metaInfoObj.height;
			_vidHeight = metaInfoObj.height;
			trace("metadata: duration=" + metaInfoObj.duration +"width=" + metaInfoObj.width + " height=" + metaInfoObj.height + " framerate=" + metaInfoObj.framerate);
		}
		
		private function onCuePointHandler( cueInfoObj : Object ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : onCuePointHandler()" );
			//trace("cuepoint: time=" + cueInfoObj.time + " name=" +
			//cueInfoObj.name + " type=" + cueInfoObj.type);
		}
		 
		/* -----------------------Error handlers------------------------ */
		private function securityErrorHandler( e : SecurityErrorEvent ) : void 
		{
			trace("STREAMINGVIDEOPLAYER : securityErrorHandler: " + e);
		}
		
		private function asyncErrorHandler( e : AsyncErrorEvent ) : void 
		{
			trace( "STREAMINGVIDEOPLAYER : asyncErrorHandler() e.text is "+e.text );
		}
		
	}
}

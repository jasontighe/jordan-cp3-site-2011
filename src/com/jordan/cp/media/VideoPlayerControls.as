package com.jordan.cp.media {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.media.events.SimpleStreamingEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author jason.tighe
	 */
	public class VideoPlayerControls 
	extends DisplayContainer
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nav									: Nav;
		protected var _gutterWidth							: Number;
		protected var _duration								: Number;
		protected var _barPercent							: Number;
//		protected var _player								: SimpleStreamingPlayer;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var currentTf								: TextField;
		public var durationTf								: TextField;
		public var playhead									: VideoPlayerPlayhead;
		public var dragBar									: MovieClip;
		public var progress									: MovieClip;
		public var gutter									: MovieClip;
		public var background								: MovieClip;
		public var dragBox									: Box;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoPlayerControls()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{	
			activate();
			_gutterWidth = gutter.width;
		}
		
		public function resize() : void
		{
			var w : uint = getWidth();
			var yDifference : uint = ( background.x + background.width ) - ( gutter.x + gutter.width );
			background.width = w - background.x;
			
			progress.width = gutter.width = ( background.x - gutter.x ) + background.width - yDifference;
			durationTf.x = background.x + background.width - durationTf.width - 5;
		}
		
		public function activate() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : activate()" );
			addDragBox();
			activatePlayhead();
			activateDragbar();
			addPlayerListeners();
		}
		
		public function togglePlayhead() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : togglePlayhead()" );
			playhead.toggle();
		}
		
		public function updateProgress( time : Number ) : void
		{
//			trace( "VIDEOPLAYERCONTROLS : updateProgress() : time is "+time );
			var percent : Number = time / _duration;
			updateProgressBar( percent );
//			var barWidth : Number = _gutterWidth * percent;
//			progress.width = barWidth;
			
			dragBar.x = progress.x + progress.width;
			
			var time : Number = Math.round( time );
			var timecode : String = secondsToTimecode( time );
			currentTf.htmlText = String( timecode );
		}
		
		public function setDuration( time : Number ) : void
		{
			var time : Number = Math.round( time );
			_duration = time;
			var timecode : String = secondsToTimecode( _duration );
			durationTf.htmlText = String( timecode );
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function activatePlayhead() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : activatePlayhead()" );
			playhead.activate();
		}
		
		protected function addDragBox() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : addDragBox()" );
			dragBox = new Box( gutter.width, dragBar.height );
			dragBox.x = gutter.x;
			dragBox.y = Math.round( dragBar.y - ( dragBar.height * .5 ) );
			dragBox.alpha = 0;
			addChild( dragBox );
		}
		
		protected function activateDragbar() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : activateDragbar()" );
			dragBox.buttonMode = true;
			dragBox.mouseEnabled = true;
			dragBox.mouseChildren = false;
			dragBox.useHandCursor = true;
			
			dragBox.addEventListener( MouseEvent.MOUSE_DOWN, onGutterDown );
			dragBox.addEventListener( MouseEvent.MOUSE_UP, onGutterUp );
			trace( "VIDEOPLAYERCONTROLS : activateDragbar() : stage is "+stage );
//			stage.addEventListener(MouseEvent.MOUSE_UP, onGutterUp);
		}
		
		protected function deactivateDragbar() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : activateDragbar()" );
			dragBox.buttonMode = false;
			dragBox.mouseEnabled = false;
			dragBox.mouseChildren = false;
			dragBox.useHandCursor = false;
			
			dragBox.removeEventListener( MouseEvent.MOUSE_DOWN, onGutterDown );
			dragBox.removeEventListener( MouseEvent.MOUSE_UP, onGutterUp );
//			stage.removeEventListener(MouseEvent.MOUSE_UP, onGutterUp);
		}
		
		public function updateProgressBar( percent : Number ) : void
		{
			var barWidth : Number = _gutterWidth * percent;
			progress.width = barWidth;
		}
		
		protected function updateDragBar( e : Event = null ) : void
		{
			var valueX : Number;
			var xMin : Number = gutter.x;
			var xMax : Number = gutter.x + gutter.width;
			
			if( mouseX >= xMax )
			{
				valueX = xMax;
			}
			else if( mouseX <= xMin )
			{
				valueX = xMin;
			}
			else
			{
				valueX = mouseX;
			}
			
//			trace( "VIDEOPLAYERCONTROLS : activateDragbar()" );
			
			
			dragBar.x = valueX;
			var percent : Number = ( valueX - gutter.x )  / gutter.width;
			
//			if( percent >= 1)
//			{
//				percent = 1
//			}
//			else if( percent <= 0)
//			{
//				percent = 0;
//			}
			
			updateProgressBar( percent );
			_barPercent = percent;
		}
		
		protected function addPlayerListeners() : void
		{
//			trace( "VIDEOPLAYERCONTROLS : addPlayerListeners()" );
//			_player.addEventListener( SimpleStreamingEvent.VIDEO_PLAY_PAUSE, onVideoPlayPause );
			playhead.addEventListener( Event.COMPLETE, onPlayheadClick );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onVideoPlayPause( e : SimpleStreamingEvent ) : void
		{
//			trace( "VIDEOPLAYERCONTROLS : onVideoPlayPause() : VIDEO HAS PLAYED OR PAUSED." );
			playhead.toggle();
		}
		
		protected function onPlayheadClick( e : Event ) : void
		{
//			trace( "VIDEOPLAYERCONTROLS : onPlayheadClick() ..............................." );
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_PLAY_PAUSE ) );
//			_player.togglePause();
		}
		
		protected function onGutterDown( e : Event ) : void
		{
//			trace( "VIDEOPLAYERCONTROLS : onGutterDown()" );
			addEventListener(Event.ENTER_FRAME, updateDragBar );
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_SCRUB_START ) );
		}

		protected function onGutterUp( e : Event ) : void
		{
//			trace( "VIDEOPLAYERCONTROLS : onGutterUp()" );
			removeEventListener(Event.ENTER_FRAME, updateDragBar );
			stage.removeEventListener(MouseEvent.MOUSE_UP, onGutterUp);
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_SCRUB_END ) )
		}

		protected override function onAddedToStage( e : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			init();
		}
		
		//----------------------------------------------------------------------------
		// getters/setter
		//----------------------------------------------------------------------------
//		public function set player( object : SimpleStreamingPlayer ) : void
//		{
//			_player = object;
//			addPlayerListeners();
//		}
//		
//		public function get player( ) : SimpleStreamingPlayer
//		{
//			return _player;
//		}
//		
		public function get barPercent( ) : Number
		{
			return _barPercent;
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
		
	}
}

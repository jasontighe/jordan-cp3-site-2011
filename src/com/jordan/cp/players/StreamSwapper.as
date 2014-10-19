package com.jordan.cp.players 
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenMax;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.ConnectionErrorManager;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.CameraPannerModel;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.VideoModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.players.hotspots.HotspotPlotter;
	import com.jordan.cp.view.interactionmap.MapMain;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.managers.sound.PlodeSoundManager;
	import com.plode.framework.utils.BitmapConverter;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;	

	/**
	 * @author nelson.shin
	 */

	public class StreamSwapper extends AbstractDisplayContainer
	{
		protected var _model : VideoModel;
		protected var _cem : ConnectionErrorManager = ConnectionErrorManager.gi;
		protected var _timeTracker : TimeTracker = TimeTracker.gi;
		protected var _panner : CameraPanner;
		protected var _hotspots : HotspotPlotter;
		protected var _vidHolder : Sprite;
		protected var _ns : NetStream;
		protected var _video : Video;
		protected var _timer : Timer;
		protected var _latencyTimer : Timer;

		protected var _staticCamera : Boolean;
		protected var _currentVidPath : String;
		protected var _isPlaying : Boolean;
		protected var _bufferFull : Boolean;
		protected var _isComplete : Boolean;
		protected var _isScrubbing : Boolean;
		private var _flagNotify : Boolean;

		public static const W : uint = 960;
		public static const H : uint = 480;
		public static const SHIFT_DOWN : String = "SHIFT_DOWN";
		public static const SHIFT_UP : String = "SHIFT_UP";
		public static const STREAM_READY : String = "STREAM_READY";
		public static const STREAM_READY_FOR_TRANS : String = 'STREAM_READY_FOR_TRANS';
		public static const STREAM_READY_FOR_FADE : String = 'STREAM_READY_FOR_FADE';
		public static const KILL_INTERACTION : String = "KILL_INTERACTION";
		public static const SHOW_ENDFRAME : String = 'SHOW_ENDFRAME';
		
		protected static const TIMER_DELAY : Number = 500;
		protected static const LATENCY_TIMER_DELAY : uint = 2000;

		
		
		//-----------------------------------------------------
		//
		// SETUP
		//
		//-----------------------------------------------------
		public function populate(model : VideoModel) : void
		{
			// INDEX NEEDS TO BE INITIALIZED BEFORE MODEL IS SET
			_model = model;
			setup( );
		}
		
		override public function setup() : void
		{
			setDuration();
			
			CameraPannerModel.gi.addEventListener(CameraPannerModel.PAN_COMPLETE, onPannerComplete);
			_timeTracker.addEventListener(TimeTracker.DEFAULT_SPEED_CHANGED, onDefaultSpeedChanged);
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.SOUND_CHANGED, onSoundChanged);
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.MUTE_VIDEO, onMuteVideo);
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.UNMUTE_VIDEO, onUnmuteVideo);
			
			// ASSIGN TARGET VID PATH
			_currentVidPath = getAssetPath(Number(TimeTracker.gi.currentCamInd));

			// INIT NETSTREAM			
			_ns = new NetStream(_model.nc);
//			_ns.client = {};
			_ns.bufferTime = .0001;
//			_ns.checkPolicyFile = true;
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_ns.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onInitStatus);
			_ns.play(_currentVidPath);
			resetClient();
			updateSound();

			// START TIMER TO CHECK LAGGY PLAYBACK TIMES
			startLatencyTimer();

			// INIT VIDEO OBJECT
			_video = new Video(W, H);
			_video.smoothing = true;
			_video.attachNetStream(_ns);

			_vidHolder = new Sprite();
			_vidHolder.x = -W / 2;
			_vidHolder.y = -H / 2;
			_vidHolder.addChild(_video);
	
			// CAMERA PANNER
			_panner = new CameraPanner();			
			_panner.x = -W/2;
			_panner.y = -H/2;
			_panner.hide();
			
			addChild(_vidHolder);
			addChild(_panner);
		}

		protected function setDuration() : void 
		{
			// STUPID METADATAHANDLER :(
			switch (_timeTracker.currentScene)
			{
				case SiteConstants.SCENE_COURT:
					_timeTracker.videoDuration = (_timeTracker.defaultSpeed == TimeTracker.SPEED_SLOW) ? 41.625 : 41.625 * .5;
					break;

				case SiteConstants.SCENE_CHEF:
					_timeTracker.videoDuration = 12.25;
					break;

				case SiteConstants.SCENE_HORSE:
					_timeTracker.videoDuration = 20.25;
					break;

				case SiteConstants.SCENE_KISS:
					_timeTracker.videoDuration = 14.708;
					break;
			}
		}

		protected function setupHotspots() : void 
		{
			_hotspots = new HotspotPlotter();
			_hotspots.setup();
			_hotspots.activeStream = _ns;

			addChild(_hotspots);		
		}
		
		
		//-------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------
		public function togglePlayback() : void 
		{
			(_isPlaying) ? pause() : unpause();
		}

		public function pause() : void 
		{
			// PEG TIME FOR MAIN
			_timeTracker.pausedTime = resetCurrentTime();
			
			_isPlaying = false;
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);
			_ns.close();
			_hotspots.pause();
			_timeTracker.setPauseAudio();
			stopTimer();

			killClient();
		}

		public function unpause() : void 
		{
			// CHECK TO SEE IF NS IS STILL ACTIVE
			if(_isComplete)
			{
				_isComplete = false;
				_timeTracker.currentSpeed = _timeTracker.defaultSpeed;
				_timeTracker.currentTime = 0;
				_timeTracker.pausedTime = 0;
			}
			
			resume();
		}

		public function resume() : void
		{
			MonsterDebugger.inspect(this);
			MonsterDebugger.breakpoint(this);

			setDuration();
			
			var camInd : Number = (_staticCamera) ? 0 : Number(TimeTracker.gi.currentCamInd);

			if(!_ns.hasEventListener(NetStatusEvent.NET_STATUS))
				_ns.addEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);

			resetClient();
			resetTimer();

			// START TIMER TO CHECK LAGGY PLAYBACK TIMES
			startLatencyTimer();
			
			// RESUME FROM SCRUBBING
			if(_isScrubbing)
			{
				_isScrubbing = false;
				
				// SET SPEED TO DEFAULT
				var path : String = _model.getAssetPath(camInd, _timeTracker.defaultSpeed);
				
				if(path != _currentVidPath)
				{
					_currentVidPath = path;
	
					if(_ns.time > 0)
					{
						_timeTracker.currentTime = resetCurrentTime();
					}
	
					_ns.play(_currentVidPath);
					_ns.seek(_timeTracker.currentTime);
				}
				
				_timeTracker.currentSpeed = _timeTracker.defaultSpeed;
			}
			else
			{
				_isPlaying = true;
				_currentVidPath = getAssetPath(camInd);
				
				if(_timeTracker.prevDefaultSpeed != _timeTracker.defaultSpeed)
				{
					_timeTracker.currentTime = resetDefaultSpeed();
					_timeTracker.prevDefaultSpeed = _timeTracker.defaultSpeed;
				}
				else if(_timeTracker.currentTime != 0 && _timeTracker.pausedTime != 0)
				{
					_timeTracker.currentTime = resetCurrentTime();
				}

				_ns.play(_currentVidPath);
				_ns.seek(_timeTracker.currentTime );
			}
		}

		private function onDefaultSpeedChanged(event : Event) : void 
		{
			setDuration();
			pause();
			resume();
		}

		public function scrub(dx : Number) : void 
		{
			// MAKE SURE VIDEO IS ALREADY PLAYING - NOT IN RESUMING MODE
			if(_isPlaying)
			{
				if(_timer.running) stopTimer();
				
				_isScrubbing = true;
				
				// GET AVAILABLE SPEEDS
				var speeds : Array = (dx >= 0) ? _model.getFwdSpeeds() : _model.getRevSpeeds();
				var speed : String = (dx == 0) ? _timeTracker.defaultSpeed : speeds[speeds.length - 1];
				
				if(speed != _timeTracker.currentSpeed)
				{
					// FORCE REVERT TO DEFAULT SPEED IF SWITCHING BETWEEN DIRECTIONS
					if(_timeTracker.currentSpeed.indexOf('006') > -1 && speed.indexOf('006') > -1)
					{
						speed = _timeTracker.defaultSpeed;
					}
					
					var path : String = _model.getAssetPath(Number(TimeTracker.gi.currentCamInd), speed);
					var time : Number;
					
					_hotspots.pause();
					_currentVidPath = path;
					
					// SHOW THAT GREEN SCREEN EGG HAS BEEN TRIGGERED
					if(_currentVidPath.indexOf('jordancp-court-r006-c00') > -1)
					{
						MonsterDebugger.inspect(this);
						MonsterDebugger.breakpoint(this, 'GREEN SCREEN EGG BREAKPOINT');
						
						var contentModel : ContentModel = Shell.getInstance().getContentModel();
						contentModel.hotspotName = SiteConstants.EGG_GREEN;
						var dto : ContentDTO = contentModel.getContentItemByName(contentModel.hotspotName) as ContentDTO;
						if(!contentModel.isUnlockedEgg(dto.id))
							TrackingManager.gi.trackCustom(TrackingConstants.BONUS_UNLOCKED_GREENSCREEN );

						TrackingManager.gi.trackPage(TrackingConstants.OVERLAY_GREENSCREEN );
						contentModel.addUnlockedEgg(dto.id);
					}
					
	
					if(_ns.time > 0)
					{
						// TARGET SPEED IS REVERSE
						if(speed.indexOf('r') > -1)
						{
							// SET TIME BACK TO DEFAULT SPEED
							time = _timeTracker.videoDuration * getTimeMultiplier(speed) - (_ns.time * getTimeMultiplier(speed));
						}
						else if(speed == _timeTracker.defaultSpeed)
						{
							// UPDATE GLOBAL TIME TRACKER
							time = resetCurrentTime();
						}
						else
						{
							time = _ns.time * getTimeMultiplier(speed);
						}
					}

					_timeTracker.currentSpeed = speed;
					_ns.play(_currentVidPath);
					_ns.seek(time);
				}
			}
		}
		
		public function restart() : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("StreamSwapper.restart() : DOES THIS EVER GET CALLED?????");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			resetClient();

			if(!_ns.hasEventListener(NetStatusEvent.NET_STATUS))
				_ns.addEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);

			_timeTracker.currentSpeed = _timeTracker.defaultSpeed;
			_timeTracker.currentTime = 0;

			resume();
		}		
		
		public function kill() : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("StreamSwapper.kill() : DOES THIS EVER GET CALLED?????");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			
			pause();
			_hotspots.destroy();
		}
		
		public function getBmp() : Bitmap
		{
			return BitmapConverter.getBmp( _vidHolder );
		}
		
		
		
		
		//-------------------------------------------------------------
		//
		// AUDIO
		//
		//-------------------------------------------------------------
		protected function onSoundChanged(event : Event) : void
		{
			updateSound();
		}
		
		protected function updateSound() : void
		{
			if(!PlodeSoundManager.gi.videoMuted)
			{
				var st : SoundTransform = new SoundTransform();
				st.volume = PlodeSoundManager.gi.globalVolume;
				_ns.soundTransform = st;
			}
			else mute();
		}

		protected function onMuteVideo(event : Event) : void
		{
			mute();
		}
		
		protected function mute() : void
		{	
			var st : SoundTransform = new SoundTransform();
			st.volume = 0;
			_ns.soundTransform = st;
		}

		protected function onUnmuteVideo(event : Event) : void
		{
			var st : SoundTransform = new SoundTransform();
			st.volume = PlodeSoundManager.gi.globalVolume;
			_ns.soundTransform = st;
		}
		
		
		
		//-----------------------------------------------------
		//
		// SWAP QUEUE
		//
		//-----------------------------------------------------
		public function startSwapQueue() : void 
		{
			_bufferFull = false;

			if(!_panner.hasEventListener(CameraPanner.TRANSITION_COMPLETE))
				_panner.addEventListener(CameraPanner.TRANSITION_COMPLETE, onTransitionComplete);
			
			// UPDATE PANNER
			if(!_panner.visible) _panner.show(.2);

			// STOP PLAYBACK			
			if(_isPlaying)
			{
				pause();
				TrackingManager.gi.trackCustom(TrackingConstants.CAMERA_DRAG);
			}

		}

		protected function onPannerComplete(event : Event) : void 
		{
			CameraPannerModel.gi.inEase = true;
			resume();
		}

		protected function onTransitionComplete(event : Event) : void 
		{
			if(_bufferFull && _flagNotify)
			{
				completeSwap();
			}
		}
		
		protected function completeSwap() : void 
		{
			_flagNotify = false;

			CameraPannerModel.gi.inEase = false;

			_panner.hide();
			_hotspots.resume();
		}		



		
		//-----------------------------------------------------
		//
		// NETSTREAM EVENTS
		//
		//-----------------------------------------------------
		protected function onSecurityErrorHandler(event : SecurityErrorEvent) : void 
		{
			trace("securityErrorHandler: " + event);
		}

		protected function asyncErrorHandler(e : AsyncErrorEvent) : void 
		{
			trace("asyncErrorHandler: " + e);
		}	

		protected function onInitStatus(e : NetStatusEvent) : void 
		{
			var code : String = e.info.code;
			
//			trace('\n\n\n----------------------------------------------------------');
//			trace("StreamSwapper.onInitStatus(e)", this, code);
                	
			switch(code)
			{			
				case "NetStream.Buffer.Full":
					if(e.target == _ns)
					{
						// HIDE LATENCY PINWHEEL
						stopLatencyTimer();
						_cem.hidePinwheel();
						
						_ns.removeEventListener(NetStatusEvent.NET_STATUS, onInitStatus);
						_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
						_ns.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);

						_isPlaying = true;


						beginTimer();
						setupHotspots();

						dispatchEvent(new Event(STREAM_READY));
						dispatchEvent(new Event( STREAM_READY_FOR_TRANS ) );
					}
					break;
			}
		} 

		protected function onRunningStatus(e : NetStatusEvent) : void 
		{
			var code : String = e.info.code;

//			trace('\n\n----------------------------------------------------------');
			trace("StreamSwapper.onRunningStatus(e)", code);
//					trace('_ns.bufferLength', _ns.bufferLength);
//					trace('_ns.bufferTime', _ns.bufferTime);
//					trace('_ns.playbackBytesPerSecond', _ns.info.playbackBytesPerSecond);
//					trace('_ns.byteCount', _ns.info.byteCount);
//					trace('_ns.dataBufferByteLength', _ns.info.dataBufferByteLength);
//					trace('_ns.dataBufferLength', _ns.info.dataBufferLength);
//					trace('_ns.dataByteCount', _ns.info.dataByteCount);
//					trace('_ns.dataBytesPerSecond', _ns.info.dataBytesPerSecond);
//					trace('_ns.videoSampleAccess', _ns.videoSampleAccess);
			
			switch(code)
			{
				case "NetStream.Play.Stop":
					if(!_bufferFull && !_panner.complete)
					{
//						trace('\n\n\n\n\n\n----------------------------------------------------------');
//						trace('STOP FIRED WITH NO BUFFER EVENT', _bufferFull, _panner.complete);
//						trace('----------------------------------------------------------\n\n\n\n\n\n');
					}
					break;

				case "NetStream.Buffer.Full":
					if( _flagNotify)
					{
						_isPlaying = true;
						
						// HIDE LATENCY PINWHEEL
						stopLatencyTimer();
						_cem.hidePinwheel();
						_timeTracker.setUnpauseAudio();
						
						_bufferFull = true;
						_ns.removeEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);
						dispatchEvent(new Event(STREAM_READY_FOR_FADE));
						
						if(_panner.complete) 
						{
	//						trace('\n\n\n\n\n\n----------------------------------------------------------');
	//						trace('GLITCHY?');
	//						trace('----------------------------------------------------------\n\n\n\n\n\n');
							
							// INSERTING DELAY TO AVOID BLIP OF OLD VIDEO
							_panner.removeEventListener(CameraPanner.TRANSITION_COMPLETE, onTransitionComplete);
							completeSwap();
							
//							TweenMax.delayedCall(.15, completeSwap);
						}
					}
					else
					{
//						trace('\n\n\n-------------------------------------------------------------');
//						trace("StreamSwapper.onRunningStatus : BUFFER FULL : SEEK HAS NOT FIRED - WILL CONTINUE TO LOOP THROUGH STATUS EVENTS");
					}
					break;
                	
				case "NetStream.Seek.Notify":
					_flagNotify = true;
					
					if(_bufferFull)
					{
//						trace('\n\n\n-------------------------------------------------------------');
//						trace("StreamSwapper.onRunningStatus : SEEK NOTIFY : BUFFER IS FULL - WILL CONTINUE TO LOOP THROUGH STATUS EVENTS");
					}
					
					break;
			}
		}
		
		protected function onMetaDataHandler(o : Object) : void
		{
			if(!_timeTracker.videoDuration || _timeTracker.videoDuration == 0) _timeTracker.videoDuration = o.duration;
			
//			trace('\n\n\n----------------------------------------------------------');
//			trace('onMetaDataHandler', o.duration);
//			trace('----------------------------------------------------------');
//			trace('\n\n\n');

//			for( var key : Object in o)
//			{
//				trace('key: ' + (key));
//			}
		}

		protected function onPlayStatus(o : Object) : void
		{
//			trace('\n\n\n-------------------------------------------------------------');
//			trace('onPlayStatus', o.code, _ns.client.onMetaData);
//			trace('-------------------------------------------------------------\n\n\n');
			
			// code, level, duration, bytes
			if(o.code == 'NetStream.Play.Complete')
			{
				showFinish();
			}
		}
		
		protected function showFinish() : void 
		{
			_isComplete = true;
			
			if(_timeTracker.currentSpeed == TimeTracker.SPEED_RW)
			{
				dispatchEvent(new Event(KILL_INTERACTION));
				
				MapMain(parent.parent).pause(false);
				MapMain(parent.parent).resume();
			}
			else
			{
				stopLatencyTimer();
				_cem.hidePinwheel();
				
				dispatchEvent(new Event(SHOW_ENDFRAME));
			}

		}

		protected function killClient() : void 
		{
			_ns.client = {};
//			_ns.client.onMetaData = null;
			_ns.client.onPlayStatus = null;
		}

		protected function setClient() : void 
		{
//			_ns.client.onMetaData = onMetaDataHandler;
			_ns.client.onPlayStatus = onPlayStatus;
		}

		protected function resetClient() : void 
		{
			killClient();
			setClient();
		}
		
		

		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		private function resetDefaultSpeed() : Number 
		{
			var currSpeed : Number = Number(_timeTracker.prevDefaultSpeed.substr(_timeTracker.prevDefaultSpeed.indexOf('0') + 1, 2));
			var tarSpeed : Number = Number(_timeTracker.defaultSpeed.substr(_timeTracker.defaultSpeed.indexOf('0') + 1, 2));
			var multiplier : Number = tarSpeed / currSpeed;

			return _timeTracker.currentTime * multiplier;
		}
		
		// CONVERTS TIME TO DEFAULT SPEED TIME
		private function resetCurrentTime() : Number 
		{
			var time : Number;
			var ticker : Number = (_ns.time == 0) ? _timeTracker.currentTime : _ns.time;

			// CONVERT FROM REVERSE TO FWD SLOMO
			if(_timeTracker.currentSpeed.indexOf('r') > -1)
			{
				time = _timeTracker.videoDuration - (ticker * getTimeMultiplier(_timeTracker.defaultSpeed));
			}
			else
			{
				time = ticker * getTimeMultiplier(_timeTracker.defaultSpeed);
			}
			
			return time;
		}
		
	 	protected function getTimeMultiplier(speed : String) : Number 
		{
			// RETURNS RATIO OF TARGET SPEED OVER CURRENT SPEED
			var currSpeed : Number = Number(_timeTracker.currentSpeed.substr(speed.indexOf('0') + 1, 2));
			var tarSpeed : Number = Number(speed.substr(speed.indexOf('0') + 1, 2));
			var currRatio : Number = currSpeed / Number(TimeTracker.SPEED_BASE);
			var tarRatio : Number = tarSpeed / Number(TimeTracker.SPEED_BASE);
			var base : Number = _timeTracker.videoDuration * currRatio;
			var tar : Number = _timeTracker.videoDuration * tarRatio;
			var multiplier : Number = tar / base;
			
			return multiplier;
		}



		//-------------------------------------------------------------------------
		//
		// TIMER STUFF
		//
		//-------------------------------------------------------------------------
		protected function beginTimer() : void 
		{
			if(!_timer)
			{
				_timer = new Timer(TIMER_DELAY);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
			_timer.start();
		}

		protected function stopTimer() : void
		{
			if(_timer) _timer.stop();
		}

		protected function resetTimer() : void
		{
			if(_timer)
			{
				_timer.reset();
				beginTimer();
			}
		}

		protected function onTimer(event : TimerEvent) : void 
		{
			updateTime();
		}
		
		protected function updateTime() : void
		{
			var tarTime : Number = (_ns.time == 0) ? _timeTracker.pausedTime : _ns.time;

			if(tarTime * getTimeMultiplier(_timeTracker.currentSpeed) == 0)
			{
				trace('\n\n\n\n\n\n----------------------------------------------------------');
				trace("StreamSwapper.updateTime() : _timeTracker.pausedTime: ", this, (_timeTracker.pausedTime));
				trace("StreamSwapper.updateTime() : _ns.time: " + (_ns.time));
				trace("StreamSwapper.updateTime() : SETTING TIME TO ZERO!!!!!");
				trace('----------------------------------------------------------\n\n\n\n\n\n');
			}

			_timeTracker.currentTime = tarTime * getTimeMultiplier(_timeTracker.currentSpeed);
		}
		
		protected function startLatencyTimer() : void
		{
			if(!_latencyTimer)
			{
				_latencyTimer = new Timer(LATENCY_TIMER_DELAY);
				_latencyTimer.addEventListener(TimerEvent.TIMER, onLatencyTimer);
			}
			
			_latencyTimer.start();
		}
		
		protected function stopLatencyTimer() : void
		{
			if(_latencyTimer) _latencyTimer.stop();
		}
		
		protected function onLatencyTimer(e : TimerEvent) : void
		{
			stopLatencyTimer();
			_cem.showPinwheel();
		}


						
		//-----------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-----------------------------------------------------
		protected function getAssetPath(i : Number) : String 
		{
			var url : String = _model.getAssetPath(i);
			var base : String = url.substring(0, url.indexOf('&'));
			var asset : String = url.split('?')[0].substr(base.length);

			return asset;
		}
		
		public function get stream() : NetStream 
		{
			return _ns;
		}
		
		public function get isScrubbing() : Boolean
		{
			return _isScrubbing;
		}
		
		public function get panner() : CameraPanner
		{
			return _panner;
		}
		
		public function get isComplete() : Boolean
		{
			return _isComplete;
		}
		
	}
}

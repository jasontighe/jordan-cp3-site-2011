package com.jordan.cp.players 
{
	import com.jordan.cp.Shell;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.interactionmap.BonusScenePlayer;
	import com.plode.framework.managers.sound.PlodeSoundManager;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetStream;	

	/**
	 * @author nelson.shin
	 */


	public class BonusStreamSwapper extends StreamSwapper 
	{
		private var _pauseTime : Number;
		
		//-----------------------------------------------------
		//
		// SETUP
		//
		//-----------------------------------------------------
		override public function setup() : void
		{
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.SOUND_CHANGED, onSoundChanged);
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.MUTE_VIDEO, onMuteVideo);
			PlodeSoundManager.gi.addEventListener(PlodeSoundManager.UNMUTE_VIDEO, onUnmuteVideo);

			setDuration();
			_staticCamera = true;

			// ASSIGN TARGET VID PATH
			_currentVidPath = getAssetPath(0);

			// INIT NETSTREAM			
			_ns = new NetStream(_model.nc);
			_ns.client = {};
			_ns.bufferTime = .0001;
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_ns.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onInitStatus);
			_ns.play(_currentVidPath);

			resetClient();
			updateSound();

			// INIT VIDEO OBJECT
			_video = new Video(W, H);
			_video.smoothing = true;
			_video.attachNetStream(_ns);

			_vidHolder = new Sprite();
			_vidHolder.x = -W / 2;
			_vidHolder.y = -H / 2;
			_vidHolder.addChild(_video);

			addChild(_vidHolder);
		}
		


		//-----------------------------------------------------
		//
		// NETSTREAM EVENTS
		//
		//-----------------------------------------------------
		override protected function onSecurityErrorHandler(event : SecurityErrorEvent) : void 
		{
			trace("securityErrorHandler: " + event);
		}

		override protected function asyncErrorHandler(e : AsyncErrorEvent) : void 
		{
			trace("asyncErrorHandler: " + e);
		}	

		override protected function onRunningStatus(e : NetStatusEvent) : void 
		{
			var code : String = e.info.code;

			trace("BonusStreamSwapper.onRunningStatus(e)", this, code);
			
			switch(code)
			{
				case "NetStream.Buffer.Full":
					_bufferFull = true;

					// DISPATCH TO PARENT FOR VIDEO TRANSITION
					dispatchEvent(new Event( STREAM_READY_FOR_TRANS ) );
					
					break;
			}
		}

		override protected function onPlayStatus(o : Object) : void
		{
			// code, level, duration, bytes
			if(o.code == 'NetStream.Play.Complete')
			{
				exit();
			}
		}

		override protected function onMetaDataHandler(o : Object) : void
		{
			// DO NOT UPDATE videoDuration
		}


		//-------------------------------------------------------------------------
		//
		// EXTENDED METHODS
		//
		//-------------------------------------------------------------------------
		override protected function addEventListeners() : void
		{
			
			if(!_ns.hasEventListener(NetStatusEvent.NET_STATUS))
				_ns.addEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);
		}

		override protected function removeEventListeners() : void
		{
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);
		}

		override public function restart() : void 
		{
			addEventListeners();
			
			
			setDuration();
			_currentVidPath = getAssetPath(0);
			_ns.play(_currentVidPath);
			resetClient();
			_hotspots.resume();
		}
		
		override public function pause() : void 
		{
			// SAME AS SUPERCLASS BUT NOT SETTING PAUSED TIME
			_pauseTime = _ns.time;
			
			_isPlaying = false;
			removeEventListeners();
			_ns.close();
			_hotspots.pause();
			_timeTracker.setPauseAudio();
			stopTimer();

			killClient();
		}

		override public function unpause() : void
		{
			if(!_ns.hasEventListener(NetStatusEvent.NET_STATUS))
				_ns.addEventListener(NetStatusEvent.NET_STATUS, onRunningStatus);
				
			resetClient();
			_ns.play(_currentVidPath);
			_ns.seek(_pauseTime); 
			_hotspots.resume();
			
			_isPlaying = true;
		}

		override protected function beginTimer() : void
		{
			// DISABLING TIMER FOR THIS EXTENDED CLASS
		}
		
		override protected function getAssetPath(i : Number) : String 
		{
			// HARD-CODED CAM AND SPEED
			var url : String = _model.getAssetPath(0, TimeTracker.SPEED_SLOW);
			var base : String = url.substring(0, url.indexOf('&'));
			var asset : String = url.split('?')[0].substr(base.length);

			return asset;
		}
		
		
		//-------------------------------------------------------------------------
		//
		// INTERFACE
		//
		//-------------------------------------------------------------------------		
		public function exit() : void 
		{
			BonusScenePlayer(parent.parent).pause(false);

			_pauseTime = 0;

			// RETURN TIME TO POINT WHERE WE JUMPED OUT
			TimeTracker.gi.currentTime = TimeTracker.gi.pausedTime;

			// INFORM STATE MODEL OF STATE CHANGE
			Shell.getInstance().main.stateModel.state = StateModel.STATE_MAIN;
		}
	}
}

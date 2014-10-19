package com.jordan.cp.audio 
{
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.players.TimeTracker;
	import com.plode.framework.managers.sound.PlodeSoundItem;
	import com.plode.framework.managers.sound.PlodeSoundManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	/**
	 * @author nelson.shin
	 */
	public class VoiceOver extends EventDispatcher 
	{
		private var _psm : PlodeSoundManager = PlodeSoundManager.gi;
		private var _tt : TimeTracker = TimeTracker.gi;
		private var _vo : PlodeSoundItem;
		private var _active : Boolean;
//		private var _bg : PlodeSoundItem;
		
		public function VoiceOver()
		{
			setup();
		}

		private function setup() : void 
		{
			_vo = _psm.getSound(SiteConstants.AUDIO_CP_VO);
			_vo.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
//			_bg = _psm.getSound(SiteConstants.AUDIO_BG_LOOP);

			_tt.addEventListener(TimeTracker.TIMETRACKER_SPEED_CHANGED, onSpeedChange);
			_tt.addEventListener(TimeTracker.TIMETRACKER_PAUSE, onPause);
			_tt.addEventListener(TimeTracker.TIMETRACKER_UNPAUSE, onUnpause );
		}				// KEYCODE TRIGGERS FROM MAIN IF IN CORRECT SPEED
		public function startVo() : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace("VoiceOver.startVo() : currentTime: " + (_tt.currentTime));
			_active = true;
			_vo.play(_tt.currentTime);
			_psm.muteVideo();
			_psm.focusItem(SiteConstants.AUDIO_CP_VO);
//			_bg.fadeVolume(.4);

			TrackingManager.gi.trackCustom(TrackingConstants.CP3_COMMENTARY);
		}

		// PAUSE EVENT IN MAPMAIN		
//		private function pause() : void
//		{
//			_vo.pause();
//		}
		
		// REACH BONUS SCREEN
		private function stopVo() : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace("VoiceOver.stopVo");
			if(_psm.isActive(SiteConstants.AUDIO_CP_VO ))
			{
				_vo.pause();
				_psm.unfocus();
				_psm.unmuteVideo();
	//			_bg.fadeVolume(1);
			}
		}

		// DUNNO WHEN THIS EVER HAPPENS
		private function dispose() : void
		{
			_vo = null;
		}
		
		
		//-------------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onPause(event : Event) : void 
		{
			stopVo();
//			active = false;
		}

		private function onUnpause(event : Event) : void 
		{
			if(_active && _tt.currentSpeed == TimeTracker.SPEED_SLOW && !_psm.isActive(SiteConstants.AUDIO_CP_VO )) 
				startVo();
		}

		private function onSpeedChange(event : Event) : void 
		{
			// STOP VO IF SCRUBBING
			// - STREAMSWAPPER WILL KICK OUT A RESUME EVENT
			if(_active && _tt.currentSpeed != TimeTracker.SPEED_SLOW)
				stopVo( );
		}
		
		private function soundCompleteHandler(event : Event) : void
		{
			stopVo();
		}

//		public function get active() : Boolean
//		{
//			return _active;
//		}
//		
		public function set active(active : Boolean) : void
		{
			_active = active;
			
			if(!_active) stopVo();
		}
	}
}

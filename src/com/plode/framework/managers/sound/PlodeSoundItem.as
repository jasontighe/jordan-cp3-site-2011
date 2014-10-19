package com.plode.framework.managers.sound{	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;	
	/**	 * @author ns	 */	public class PlodeSoundItem extends EventDispatcher	{		protected var _manager : PlodeSoundManager = PlodeSoundManager.gi;		protected var _sound : Sound;		protected var _channel : SoundChannel;		protected var _trans : SoundTransform;		protected var _currentTime : Number;		protected var _id : String;		private var _looping : Boolean;		private var _volume : Number;		//-------------------------------------------------------------------------		//		// PUBLIC METHODS		//		//-------------------------------------------------------------------------				public function PlodeSoundItem(id : String) 		{			_id = id;		}		public function populate(sound : Sound) : void 		{			_volume = 1;			_trans = new SoundTransform();			_trans.volume = _volume * _manager.globalVolume;			_sound = sound;		}		public function play(time : Number = 0) : void 		{
			if(_sound)			{				_manager.addToActiveList(_id);								_channel = _sound.play(time * 1000, 0 );				_channel.soundTransform = _trans;								if(!_channel.hasEventListener(Event.SOUND_COMPLETE))					_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);			}			else new Error("PlodeSoundItem.play : SOUND NOT YET CREATED" );		}				public function pause() : void 		{			_manager.removeFromActiveList(_id);			_currentTime = _channel.position;			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);			_channel.stop();		}		public function setVolume(val : Number) : void		{			// SET LOCAL VOLUME & UPDATE VOLUME RELATIVE TO SOUND MANAGER			_volume = val;			_trans.volume = _volume * _manager.globalVolume;			if(_channel) _channel.soundTransform = _trans;		}		public function fadeVolume(val : Number, dur : Number = .8) : void		{			TweenLite.to(this, dur, {volume: val});		}				public function updateVolume() : void		{			// UPDATES VOLUME WHEN GLOBAL VOLUME CHANGES			setVolume(_volume);		}				//-------------------------------------------------------------------------		//		// EVENT HANDLERS		//		//-------------------------------------------------------------------------		private function soundCompleteHandler(event : Event) : void		{			dispatchEvent(event);			if(_looping) play();		}				//-------------------------------------------------------------------------		//		// SETTERS & GETTERS		//		//-------------------------------------------------------------------------		public function get time() : Number		{			return _currentTime;		}				public function get volume() : Number		{			return _volume;		}				public function set volume(val : Number) : void		{			_volume = val;			updateVolume();		}		public function set looping(val : Boolean) : void		{			_looping = val;		}		
	}}
package com.plode.framework.managers.sound
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.utils.Dictionary;	

	/*
	 * 
	 * 
	 * USAGE: 
	 * 1) add sounds
	 * 	  - PlodeSoundManager.gi.add(id, sound); 
	 * 
	 * 2) retrieve asset
	 * 	  - PlodeSoundManager.gi.getSound(id);
	 * 
	 * 
	 */
	 
	public class PlodeSoundManager extends EventDispatcher
	{
		private static var _instance : PlodeSoundManager;
		
		private var _d : Dictionary;
		private var _swf : MovieClip;
		private var _active : Array;
		private var _volume : Number;
		private var _focusId : String;
		private var _videoMuted : Boolean;

		public static const SOUND_CHANGED : String = 'SOUND_CHANGED';
		public static const MUTE_VIDEO : String = 'MUTE_VIDEO';
		public static const UNMUTE_VIDEO : String = 'UNMUTE_VIDEO';
		private static const VOL_LOW : Number = .2;

		public function PlodeSoundManager(e : Enforcer)
		{
			init();
		}

		private function init() : void 
		{
			_d = new Dictionary();
			_volume = 0;
		}

		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function addSwf(soundSwf : MovieClip) : void
		{
			_swf = soundSwf;
		}

		public function add(id : String, sound : Sound) : void
		{
			var item : PlodeSoundItem;
			
			if(!_d[id])
			{
				item = new PlodeSoundItem(id);
				item.populate(sound);

				_d[id] = item;
			}
			else new Error('PlodeSoundManager.add : THIS ASSET HAS ALREADY BEEN ADDED');
		}

		public function pauseAllActiveSounds() : void 
		{
			var item : PlodeSoundItem;
			
			if(_active)
			{
				for each(var key : String in _active)
				{
					item = _d[key];
					item.pause();
				}
			}
			else new Error("PlodeSoundItem.pauseAllActiveSounds : NO ACTIVE LIST ITEMS" );
		}

		public function resumeAllActiveSounds() : void 
		{
			var item : PlodeSoundItem;
			
			if(_active)
			{
				for each(var key : String in _active)
				{
					item = _d[key];
					item.play(item.time);
				}
			}
			else new Error("PlodeSoundItem.resumeAllActiveSounds : NO ACTIVE LIST ITEMS" );
		}
		
		public function fadeGlobalVolume(val : Number, dur : Number = 1.8) : void
		{
			TweenLite.to(this, dur, {globalVolume: val});		
		}		
		
		public function focusItem(id : String) : void
		{
			// FADES DOWN ALL ITEMS EXCEPT FOR SELECTED
			if(_focusId != id)
			{
				_focusId = id;
	
				var item : PlodeSoundItem;
				
				if(_active)
				{
					for each(var key : String in _active)
					{
						if(key != id)
						{
							item = _d[key];
							trace('\n\n\n-------------------------------------------------------------');
	//						trace( "PlodeSoundManager.focusItem.item.volume: BEFORE: " + item.volume );
							item.fadeVolume(item.volume * VOL_LOW );
							trace( "PlodeSoundManager.focusItem.item.volume: AFTER: " + item.volume * VOL_LOW );
						}
					}
				}
				else new Error("PlodeSoundItem.focusItem : NO ACTIVE LIST ITEMS" );
			}
		}
	
		public function unfocus() : void
		{
			// FADES ALL ITEMS BACK TO THEIR ORIGINAL VOLUMES
			if(_focusId != '')
			{
				var item : PlodeSoundItem;
				
				if(_active)
				{
					for each(var key : String in _active)
					{
						if(key != _focusId)
						{
							item = _d[key];
							item.fadeVolume(item.volume * 1/VOL_LOW );
							trace('\n\n\n-------------------------------------------------------------');
							trace( "PlodeSoundManager.unfocus.item.volume *  1/ VOL_LOW: AFTER " + item.volume *  1/ VOL_LOW );
						}
					}
				}
				else new Error("PlodeSoundItem.unfocus : NO ACTIVE LIST ITEMS" );			
	
				_focusId = '';
			}
		}
	
		public function muteVideo() : void
		{
			_videoMuted = true;
			dispatchEvent(new Event(MUTE_VIDEO));
		}
		
		public function unmuteVideo() : void
		{
			_videoMuted = false;
			dispatchEvent(new Event(UNMUTE_VIDEO));
		}
		
		public function isActive(id : String) : Boolean
		{
			return (_active && _active.indexOf(id) > -1);
		}

		private function updateVolumes() : void
		{
			var item : PlodeSoundItem;
			for(var key : Object in _d)
			{
				item = _d[key];
				item.updateVolume();
			}
		}


		//-------------------------------------------------------------------------
		//
		// INTERNAL METHODS
		//
		//-------------------------------------------------------------------------
		internal function addToActiveList(id : String) : void
		{
			if(!_active) _active = new Array();
			if(_active.indexOf(id) == -1)
			{
				_active.push(id);
			}
			else new Error('PlodeSoundManager.addToActive : THIS ASSET HAS ALREADY BEEN ADDED');
		}
		
		internal function removeFromActiveList(id : String) : void
		{
			if(_active)
			{
				if(_active.indexOf(id) != -1)
				{
					_active.splice(_active.indexOf(id), 1);
				}
			}
			else new Error('PlodeSoundManager.removeFromActiveList : LIST NOT YET CREATED');
		}
		

		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public static function get gi() : PlodeSoundManager
		{
			if(!_instance) _instance = new PlodeSoundManager(new Enforcer());
			return _instance;
		}
		
		public function getSound(id : String) : PlodeSoundItem
		{
			if(!_d[id])
			{
				var sound : Class = _swf.loaderInfo.applicationDomain.getDefinition(id) as Class;
				add(id, Sound(new sound()));
			}

			return _d[id];
		}

		public function set globalVolume(val : Number) : void
		{
			dispatchEvent(new Event(SOUND_CHANGED));

			_volume = val;
			updateVolumes( );
		}				public function get globalVolume() : Number
		{
			return _volume;
		}
		
		public function get videoMuted() : Boolean
		{
			return _videoMuted;
		}
	}
}

class Enforcer{}
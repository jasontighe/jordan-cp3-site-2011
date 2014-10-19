package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.managers.sound.PlodeSoundManager;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class Sound 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var soundManager							: PlodeSoundManager;
		protected var soundwave0X							: uint;
		protected var soundwave1X							: uint;
		protected static var OFFSET_X						: uint = 2;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var speaker									: MovieClip;
		public var soundwave0								: MovieClip;
		public var soundwave1								: MovieClip;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Sound() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
			soundwave0X = soundwave0.x;
			soundwave1X = soundwave1.x;
			addSoundManager();
		}
		
		public function activate() : void
		{
			 addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			 addEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			 removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
			 removeEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}
		
		public function toggleSound() : void
		{
			var globalVolume : Number = soundManager.globalVolume;
			
			if( globalVolume == 0 )
			{
				soundManager.fadeGlobalVolume( 1, SiteConstants.TIME_IN );
				showSoundwaves();
			}
			else
			{
				soundManager.fadeGlobalVolume( 0, SiteConstants.TIME_IN );
				hideSoundwaves();
			}
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addSoundManager() : void
		{
			soundManager = PlodeSoundManager.gi;
		}
		
		protected function showSoundwaves() : void
		{
			var time : Number = SiteConstants.NAV_TIME_OUT;
			var delay : Number = time * .15;
			TweenLite.to( soundwave0, time, { alpha: 1, x: soundwave0X, ease:Quad.easeOut } );
			TweenLite.to( soundwave1, time, { alpha: 1, x: soundwave1X, ease:Quad.easeOut, delay: delay, onComplete: onAnimationComplete } );
		}
		
		protected function hideSoundwaves() : void
		{
			var time : Number = SiteConstants.NAV_TIME_OUT;
			var delay : Number = time * .15;
			TweenLite.to( soundwave1, time, { alpha: 0, x: soundwave0X - OFFSET_X, ease:Quad.easeOut } );
			TweenLite.to( soundwave0, time, { alpha: 0, x: soundwave1X - OFFSET_X, ease:Quad.easeOut, delay: delay, onComplete: onAnimationComplete } );
		}
		
		protected function onAnimationComplete() : void
		{
			activate();
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_OUT, { tint: 0x464646 } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			deactivate();
			toggleSound();
		}
	}
}

package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenLite;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.players.TimeTracker;
	import com.jordan.cp.view.AbstractNav;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class UtilNav 
	extends AbstractNav 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
//		protected var soundManager							: PlodeSoundManager;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var realTime									: RealTime;
		public var commentary								: Commentary;
		public var divider0									: MovieClip;
		public var sound									: Sound;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function UtilNav() 
		{
			trace( "UTILNAV : Constr" );
			super();
//			addSoundManager();

			// TOGGLE VISIBILITY BASED ON SPEED AND SCENE
			TimeTracker.gi.addEventListener(TimeTracker.DEFAULT_SPEED_CHANGED, onVideoDefaultSpeedChanged);
			TimeTracker.gi.addEventListener(TimeTracker.HIDE_UTIL, onHideUtil);
			TimeTracker.gi.addEventListener(TimeTracker.SHOW_UTIL, onShowUtil);
		}

		private function onShowUtil(event : Event) : void 
		{
			showUtil();
		}
		
		private function onHideUtil(event : Event) : void 
		{
			realTime.dim();
			realTime.deactivate();
			commentary.dim();
			commentary.deactivate();
		}

		private function onVideoDefaultSpeedChanged(event : Event) : void 
		{
			var isDefaultSpeed : Boolean = (TimeTracker.gi.defaultSpeed == TimeTracker.SPEED_SLOW);
			realTime.visible = !isDefaultSpeed;
			commentary.visible = isDefaultSpeed;
		}

		private function showUtil() : void
		{
			realTime.undim();
			realTime.activate();
			commentary.undim();
			commentary.activate();
		}



		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "UTILNAV : init()" );
			realTime.init();
			commentary.init();
			sound.init();
			
			realTime.visible = false;
//			commentary.visible = false;
		}
		
		public override function activate() : void
		{
			trace( "UTILNAV : activate()" );
			realTime.activate();
			commentary.activate();
			sound.activate();
		}
		
		public override function deactivate() : void
		{
			realTime.deactivate();
			commentary.deactivate();
			sound.deactivate();
		}
		
		public function showRealTime() : void
		{
			TweenLite.to( realTime, SiteConstants.NAV_TIME_IN, { alpha: 1 } );
			realTime.undim();
			realTime.activate();
			realTime.visible = true;
			
			commentary.deactivate();
			commentary.visible = false;	
		}
		
		public function showCommentary() : void
		{
			TweenLite.to( commentary, SiteConstants.NAV_TIME_IN, { alpha: 1 } );
			commentary.activate();
			commentary.visible = true;	
			
			realTime.deactivate();
			realTime.visible = false;
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
			
	}
}

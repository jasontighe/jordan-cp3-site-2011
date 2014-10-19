package com.jordan.cp.view.video 
{
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.Shell;
	import com.jordan.cp.players.TimeTracker;
	import com.jordan.cp.view.AbstractView;
	import com.jordan.cp.view.interactionmap.MapMain;	

	/**
	 * @author jason.tighe
	 */

	public class VideoView 
	extends AbstractView implements IScenePlayer
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _shell : Shell = Shell.getInstance();
		private var _player : MapMain;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoView() 
		{
			trace( "VIDEOVIEW : Constr" );
			super();
			hide();
		}


		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		public function pause(blur : Boolean = true) : void 
		{
			 trace( "VIDEOVIEW : pause() : blur is "+blur );
			_player.pause(blur);
		}

		public function resume() : void 
		{
			 trace( "VIDEOVIEW : resume()" );
			TimeTracker.gi.showUtilNav();
			_player.resume();
//			transitionIn();
		}

		public function restart() : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			 trace( "VIDEOVIEW : restart() : DOES THIS EVER GET CALLED" );
			trace('-------------------------------------------------------------\n\n\n');
//			_player.restart();
		}
		
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function addViews() : void
		{
			 trace( "VIDEOVIEW : addViews()" );
			 addPlayer();	
		}
		
		protected function addPlayer() : void
		{
			trace( "VIDEOVIEW : addPlayer()" );
			
			_player = new MapMain();
			_player.setup();
//			_player.y = SiteConstants.NAV_BAR_HEIGHT;
			addChild(_player);
		}
		
		override protected function center( ) : void
		{
			// RESIZE TO BROWSER
			if(_player) _player.resize();
		}
		
		
		override public function transitionIn() : void
		{
//			super.transitionIn();
			
			
			show( 1.5 );
			addEventListener( ContainerEvent.SHOW, transitionInComplete );
			
			
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("VideoView.transitionIn()");
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
		}
		
		override public function transitionOut() : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("VideoView.transitionOut()");
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
//			super.transitionOut();
//			pause();
		}

		public function hideEndframe() : void 
		{
			_player.hideEndframe();
		}
		
		public function get isPaused() : Boolean
		{
			return _player.isPaused;
		}
		
	}
}



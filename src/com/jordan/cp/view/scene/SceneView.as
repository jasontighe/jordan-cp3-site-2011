package com.jordan.cp.view.scene 
{
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.Shell;
	import com.jordan.cp.players.StreamSwapper;
	import com.jordan.cp.view.AbstractView;
	import com.jordan.cp.view.interactionmap.BonusScenePlayer;
	import com.jordan.cp.view.video.IScenePlayer;
	
	import flash.events.Event;	

	/**
	 * @author jason.tighe
	 */
	public class SceneView 
	extends AbstractView implements IScenePlayer
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _shell : Shell = Shell.getInstance();
		private var _player : BonusScenePlayer;

		public static const STREAM_READY : String = 'STREAM_READY';

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SceneView() 
		{
			trace( "SCENEVIEW : Constr" );
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
			_player.pause(blur);
		}

		public function resume() : void 
		{
			_player.resume();
		}

		public function restart() : void
		{
			_player.restart();
		}

//		public function restart() : void
//		{
//			_player.restart();
//		}
		
//		override public function transitionIn() : void
//		{
////			show( 1.5 );
//			addEventListener( ContainerEvent.SHOW, transitionInComplete );
//		}
		
//		override public function transitionOut() : void
//		{
//			hide( 1.25 );
//			addEventListener( ContainerEvent.HIDE, transitionOutComplete );
//		}

		override protected function transitionOutComplete( e : ContainerEvent = null ) : void
		{
			removeEventListener( ContainerEvent.HIDE, transitionInComplete );
		}
		
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function addViews() : void
		{
			 trace( "SCENEVIEW : addViews()" );
			 addPlayer();	
		}
		
		protected function addPlayer() : void
		{
			trace( "SCENEVIEW : addPlayer()" );
			_player = new BonusScenePlayer();
			_player.setup();
//			_player.y = SiteConstants.NAV_BAR_HEIGHT;
			_player.addEventListener(StreamSwapper.STREAM_READY_FOR_TRANS, onStreamReadyForTrans);

			addChild(_player );
		}
		
		override protected function center( ) : void
		{
			// RESIZE TO BROWSER
			if(_player) _player.resize();
		}
		
		//-------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//-------------------------------------------------------------
		private function onStreamReadyForTrans(event : Event) : void
		{
			dispatchEvent(new Event(STREAM_READY));
		}
		
		public function get isPaused() : Boolean
		{
			return _player.isPaused;
		}
	}
}
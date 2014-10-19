package com.jordan.cp.view.interactionmap {
	import com.greensock.TweenMax;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.players.BonusStreamSwapper;
	import com.jordan.cp.players.StreamSwapper;
	import com.jordan.cp.view.video.VideoCursor;
	import com.plode.framework.utils.RectangleScaler;

	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * @author nelson.shin
	 * 
	 * - subset of MapMain functionality for bonus scenes
	 * - no panning
	 * 
	 */

	

	public class BonusScenePlayer extends MapMain 
	{
		private var _close : BonusPlayerCloseButton;
		
		
		//-------------------------------------------------------------------------
		// INITIAL SETUP
		//-------------------------------------------------------------------------
		public function BonusScenePlayer() 
		{
		}

		override public function setup() : void 
		{
			addDisplayObjects();
		}

		
		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		public function restart() : void 
		{
			_isPaused = false;
			
			// NEEDED TO REMOVE FADING FOR SUMMARY AND INTRO TRANSITIONS
			if(_blurBmp)
			{
				TweenMax.to(_blurBmp, .3, {autoAlpha: 0, blurFilter: {remove: true}, onComplete: disposeBitmap});
			}			
			
			resize();
			addEventListeners();
			addKeyEventListeners();
			_overHolder.mouseEnabled = false;
			
			_vidSwapper.restart( );
		}
		

		//-------------------------------------------------------------------------
		// ADD DISPLAY OBJECTS
		//-------------------------------------------------------------------------
		override protected function addDisplayObjects() : void
		{		
			addHolders();
			addVideo();
			addCursor();
			addHoverIcons();
			addClose();

			resize();
		}

		override protected function addVideo() : void 
		{
			// ADD BONUS SWAPPER VIEW
			_vidSwapper = new BonusStreamSwapper();

			_vidSwapper.populate(vidModel);

			_vidSwapper.addEventListener(StreamSwapper.STREAM_READY, onStreamReady);
			_vidSwapper.addEventListener(StreamSwapper.STREAM_READY_FOR_TRANS, onStreamReadyForTrans);
			_vidSwapper.addEventListener(StreamSwapper.KILL_INTERACTION, onVideoComplete);
			
			_holder.addChildAt(_vidSwapper, 0);
		}
		
		// MOVED FROM MAPMAIN
		protected function onVideoComplete(event : Event) : void 
		{
			resetMouse();
		}

		protected function onStreamReadyForTrans(event : Event) : void 
		{
			// PASS EVENT ON TO PARENT VIEWS
			dispatchEvent(event);
		}
		
//		override protected function checkCapsLockCursor() : void
//		{
//			_cursor.hideCapsLock();
//		}
		
		protected function checkCapsLockCursor() : void
		{
//			_cursor.hideCapsLock();
		}

		


		//-------------------------------------------------------------------------
		//
		// CLOSE BUTTON
		//
		//-------------------------------------------------------------------------
		protected function addClose() : void 
		{
			var s : String = 'BACK TO THE PLAY';

			_close = new BonusPlayerCloseButton();
			_close.addViews(s);
			_close.activate();
			_close.addEventListener( Event.COMPLETE, onCloseClick);

			addChildAt(_close, getChildIndex(_overScreen));
		}

		protected function onCloseClick(event : Event) : void 
		{
			BonusStreamSwapper(_vidSwapper).exit();
		}

		
		
		
		//-------------------------------------------------------------------------
		// UI HANDLERS
		//-------------------------------------------------------------------------
		override protected function onIndexChanged(event : Event) : void 
		{
		}
		

		
		
		//-------------------------------------------------------------------------
		// INTERACTION HANDLERS
		//-------------------------------------------------------------------------
		override protected function onEF(event : Event) : void 
		{
			updateCursor(VideoCursor.EXPLORE);
			if(!_cursor.visible && !_overlayVisible) showCursor();

			// THROTTLE SPEED
			var tx : Number = _startPnt.x - mouseX;
			if(tx > 0) _pol = 1;
			else if(tx < 0) _pol = -1;
			else _pol = 0;
			
			var limX : Number = 300;
			var dy : Number = _startPnt.y - mouseY;
			
			// TRACK DISTANCE FROM START POINT FOR VELOCITY OF SCROLLING
			limX = 20;

			// ANIMATE POSITION WITH EASE
			var div : Number = 12 + (masterStage.stageWidth * (_timeTracker.zoom))/400;
			_vidSwapper.x += tx / div;
			_vidSwapper.y += dy / div;

			// SET LIMITS
			var padW : Number = _vidSwapper.width - masterStage.stageWidth;
			var padH : Number = _vidSwapper.height - masterStage.stageHeight;
			var leftLim : Number = padW/2;
			var rightLim : Number = -padW/2;
			var topLim : Number = padH/2;
			var bottomLim : Number = -padH/2;
			
			if(_vidSwapper.x >= leftLim) _vidSwapper.x = leftLim;
			if(_vidSwapper.x <= rightLim) _vidSwapper.x = rightLim;
			if(_vidSwapper.y >= topLim) _vidSwapper.y = topLim;
			if(_vidSwapper.y <= bottomLim) _vidSwapper.y = bottomLim;
		}

		override protected function onKeyDown(e : KeyboardEvent) : void
		{
			// REMOVE SCRUBBING CONTROLS
//			trace('\n\n\n-------------------------------------------------------------');
//			trace('KEY PRESSED: ', this, e.keyCode);
//			trace('-------------------------------------------------------------\n\n\n');

			if(_shell.main.stateModel.state != StateModel.STATE_EMAIL && !_overHolder.mouseEnabled)
			{
				switch(e.keyCode)
				{
					// up (38) - ZOOM IN
					case 38:
						_timeTracker.zoom = 1;
						resize();
						break;
					
					// down (40) - ZOOM OUT
					case 40:
						_timeTracker.zoom = 0;
						resize();
						break;
				}
			}
		}

		override public function resize() : void
		{
			super.resize();
			
			// PADDING EXISTS WITHIN SYMBOL
			_close.x = masterStage.stageWidth - _close.width + 35;
			_close.y = masterStage.stageHeight - _close.height - 20;
			
			var tarW : Number = masterStage.stageWidth * SiteConstants.VIDEO_SCALE * _timeTracker.zoom;
			var tarH : Number = masterStage.stageHeight * SiteConstants.VIDEO_SCALE * _timeTracker.zoom;
			var padW : Number = _vidSwapper.width - masterStage.stageWidth;
			var padH : Number = _vidSwapper.height - masterStage.stageHeight;

			if(_blurBmp)
			{
				RectangleScaler.scale(_blurBmp, tarW, tarH);
				_blurBmp.x = _vidSwapper.x - Math.round(padW/2);
				_blurBmp.y = _vidSwapper.y - Math.round(padH/2);
			}
		}

		override protected function repositionEndframe() : void 
		{
			// JUST HERE TO OVERRIDE
		}

		override protected function resetTimeTracker() : void
		{
			// JUST HERE TO OVERRIDE
		}		
	
	}
}

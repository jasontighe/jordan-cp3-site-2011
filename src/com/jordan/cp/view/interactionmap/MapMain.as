package com.jordan.cp.view.interactionmap 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.CameraPannerModel;
	import com.jordan.cp.model.HotspotModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.VideoModel;
	import com.jordan.cp.players.StreamSwapper;
	import com.jordan.cp.players.TimeTracker;
	import com.jordan.cp.players.VideoTransitionView;
	import com.jordan.cp.players.hotspots.HotspotOverlayManager;
	import com.jordan.cp.players.hotspots.HotspotOverlayView;
	import com.jordan.cp.view.video.ExploreCursor;
	import com.jordan.cp.view.video.VideoCursor;
	import com.plode.framework.events.ParamEvent;
	import com.plode.framework.managers.sound.PlodeSoundItem;
	import com.plode.framework.utils.BoxUtil;
	import com.plode.framework.utils.PercentToPolarConverter;
	import com.plode.framework.utils.RectangleScaler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;	

	/**
	 * @author nelson.shin
	 * 
	 * - STAGE SCALING
	 * - INIT MEDIA CONNECTOR
	 *   - CREATE VIDEO MODEL
	 * - INIT TIMETRACKER STATES
	 * - BUILD AND MANAGE INTERACTION
	 *   - GRID
	 *   - SWAPPER
	 *   - KEYS
	 * 
	 */

	public class MapMain extends MovieClip 
	{
		protected var _shell : Shell = Shell.getInstance();
		protected var _pannerModel : CameraPannerModel = CameraPannerModel.gi;
		protected var _timeTracker : TimeTracker = TimeTracker.gi;
		protected var _vidTransition : VideoTransitionView = VideoTransitionView.gi;
		protected var _holder : Sprite;
		protected var _overHolder : Sprite;
		protected var _overScreen : Sprite;
		protected var _endframe : MapMainEndframe;
		protected var _grid : Sprite;
		protected var _target : Sprite;
		protected var _vidSwapper : StreamSwapper;
		protected var _cursor : VideoCursor;
		protected var _hoverView : HotspotOverlayView;
		protected var _zoomSound : PlodeSoundItem;
		protected var _keysDown : Array;
		private var _shiftArray : Array = [65, 16];
		protected var _blurBmp : Bitmap;

		protected var _overlayVisible : Boolean;
		protected var _isInverted : Boolean;
		protected var _nextId : String;
		protected var _startPnt : Point;
		protected var _shiftDown : Boolean;
		protected var _colCount : uint;
		protected var _rowCount : uint = 1;
		protected var _pol : int;
		protected var _uiDelay : uint = 0; 
		protected var _prevSpeed : String = TimeTracker.SPEED_SLOW;
		protected var _scrubDelay : Number = 0;
		protected var _isPaused : Boolean;

		protected const BOX_W : uint = 50;
		protected const BOX_H : uint = 0;
		protected static const VIGNETTE_DARK : Number = .7;
		protected static const SCRUB_RETARDER : Number = 8;

		//-------------------------------------------------------------------------
		// INITIAL SETUP
		//-------------------------------------------------------------------------
		public function MapMain() 
		{
		}
		
		public function setup() : void 
		{
			if(CameraPannerModel.gi.isLoaded) onConnected();
			else CameraPannerModel.gi.addEventListener(Event.COMPLETE, onZipLoaded );
		}
		
		protected function onZipLoaded(event : Event) : void 
		{
			event.stopPropagation();
			onConnected();
		}

		protected function onConnected(event : Event = null) : void 
		{
			TimeTracker.gi.currentScene = 'court';
			TimeTracker.gi.currentTime = 0;
			
			_colCount = vidModel.getCamCount( TimeTracker.gi.currentScene );

			addDisplayObjects();
		}
				//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		public function pause(blur : Boolean, dur : Number = .3, blurAmount : Number = 15, screenAmount : Number = 1) : void 
		{
			_isPaused = true;
			_shiftDown = false;

			createVideoBmp();
			resize();
			removeEventListeners();	
			resetMouse();
			
			if(blur)
			{
				TweenMax.to(_blurBmp, dur, {blurFilter: {blurX: blurAmount, blurY: blurAmount}});
				TweenMax.to(_overScreen, dur, {autoAlpha: screenAmount});
			}
			else if(_shell.main.stateModel.state == StateModel.STATE_SCENE && _shell.main.stateModel.previousState == StateModel.STATE_MAIN)
			{
				// IF NO BLUR, MEANS TRANSITION TO BONUS SCENE
				_vidTransition.setBmp(this);
			}

			_overHolder.mouseEnabled = true;
			_vidSwapper.pause();
			
			HotspotOverlayManager.gi.hide();
			
			if(_endframe) _endframe.checkTimer();
		}
		
		public function resume(dur : Number = .3) : void 
		{
			_isPaused = false;
			
			resetTimeTracker();
			addEventListeners();
			addKeyEventListeners();

			if(_vidSwapper.isComplete)
			{
				TimeTracker.gi.currentSpeed =
				TimeTracker.gi.defaultSpeed = TimeTracker.SPEED_SLOW;

				//showTransition
				_vidSwapper.addEventListener(StreamSwapper.STREAM_READY_FOR_FADE, onFadeInVideo);
			}
			else
			{
				fadeInVideo();
			}

			_vidSwapper.unpause();
			
			refocus( );
		}
		
		private function onFadeInVideo(event : Event) : void
		{
			fadeInVideo();
		}
		
		protected function fadeInVideo() : void
		{
			var dur : Number = .3;
			TweenMax.to(_blurBmp, dur, {autoAlpha:0, blurFilter: {remove: true}, onComplete: disposeBitmap});
			TweenMax.to(_overScreen, dur, {autoAlpha: 0});
			_overHolder.mouseEnabled = false;
		}
		
		private function createVideoBmp() : void
		{
			try
			{
				_blurBmp.bitmapData = _vidSwapper.getBmp().bitmapData.clone();
				_blurBmp.smoothing = true;
				_blurBmp.visible = true;
				_blurBmp.alpha = 1;
			}
			catch(e : Error)
			{
				trace('\n\n\n-------------------------------------------------------------');
				trace("MapMain.createVideoBmp : CANNOT CAPTURE BITMAP OF VIDEO");
				trace('-------------------------------------------------------------\n\n\n');
			}
		}
		
		protected function disposeBitmap() : void
		{
			if(_blurBmp) _blurBmp.bitmapData.dispose();
		}

		protected function resetTimeTracker() : void
		{
			TimeTracker.gi.currentScene = SiteConstants.SCENE_COURT;
			TimeTracker.gi.currentTime = TimeTracker.gi.pausedTime;
			TimeTracker.gi.showUtilNav();
		}


		//-------------------------------------------------------------------------
		// ADD DISPLAY OBJECTS
		//-------------------------------------------------------------------------
		protected function addDisplayObjects() : void
		{
			addHolders();
			addEndframe();
			addGrid();
			addVideo();
			addHoverIcons();
			addCursor();

			resize( );
		}
		
		protected function addHolders() : void
		{
			_holder = new Sprite();
			
			_blurBmp = new Bitmap();
			_blurBmp.smoothing = true;

			_overHolder = BoxUtil.getGradientBox(100, 100, 0x000000, true);
			_overHolder.mouseEnabled = false;
			_overHolder.mouseChildren = false;
			
			_overScreen = BoxUtil.getBox(100, 100, 0x000000, VIGNETTE_DARK);
			_overScreen.alpha = 0;
			_overScreen.visible = false;

			addChild(_holder);
			addChild(_blurBmp);
			addChild(_overHolder);
			addChild(_overScreen);
		}

		private function addEndframe() : void
		{
			_endframe = new MapMainEndframe();
			_endframe.alpha = 0;
			_endframe.visible = false;
			_endframe.addEventListener(MapMainEndframe.REPLAY, onEndframeReplay);
			_endframe.addEventListener(MapMainEndframe.SHOW_RESOLVE, onEndframeResolve);
			_endframe.addEventListener( Event.COMPLETE, onEndframeReplay);

			addChild(_endframe);
		}
		
		protected function addGrid() : void 
		{
			_grid = new Sprite();
			_grid.visible = false;
			_grid.mouseEnabled = false;

			var pnt : Point;
			var box : GridBox;
			var label : TextField;
			var centerOffsetX : uint = (_colCount * BOX_W) / 2;
			var centerOffsetY : uint = (_rowCount * BOX_W * GridBox.ratio) / 2;
			var lim : Number = _rowCount * _colCount;

			for( var i : uint = 0; i < lim;i++ )
			{
				box = new GridBox(BOX_W, BOX_H);
				
				// THIS IS JUST FOR SHORTCUT NAV
				box.addEventListener(MouseEvent.CLICK, onGridClick);
				box.id = i.toString();

				pnt = new Point();
				pnt.x = Math.floor(i / _rowCount) * box.width;
				pnt.y = (i % _rowCount) * box.height;
				
				box.x = pnt.x - centerOffsetX;
				box.y = pnt.y - centerOffsetY;

				label = new TextField();
				//				label.border = true;
				label.autoSize = TextFieldAutoSize.LEFT;
				label.text = i.toString();
				label.x = (box.width - label.textWidth) / 2;
				label.y = (box.height - label.textHeight) / 2;
				box.addChild(label);
							
				_grid.addChild(box);
			}
			
			_target = new Sprite();
			_target.visible = false;
			_target.graphics.beginFill(0xff0000);
			_target.graphics.drawCircle(0, 0, 2);
			
			_holder.addChild(_grid);
			_holder.addChild(_target);
			
			TimeTracker.gi.currentCamInd = Math.floor(_colCount/2).toString();
			_nextId = TimeTracker.gi.currentCamInd;
			
			// CENTER GRID TO ITEM
			if(_colCount % 2 == 0) _grid.x -= BOX_W / 2;

			// FOCUS CENTER VIDEO ANGLE
			for (i = 0;i < _grid.numChildren;i++)
			{
				box = _grid.getChildAt(i) as GridBox;
				if(box.id == TimeTracker.gi.currentCamInd) box.showOver();
				else box.showOut();
			}
		}

		protected function addVideo() : void 
		{
			// ADD VIDEO SWAPPER VIEW
			_vidSwapper = new StreamSwapper();
			_vidSwapper.populate(vidModel);
			_vidSwapper.alpha = 0;

			_vidSwapper.addEventListener(StreamSwapper.STREAM_READY, onStreamReady);
			_vidSwapper.addEventListener(StreamSwapper.SHOW_ENDFRAME, onShowEndframe);
			
			_holder.addChildAt(_vidSwapper, 0 );
		}
		
		protected function addHoverIcons() : void 
		{
			_hoverView = new HotspotOverlayView();
			addChild(_hoverView);
		}
		
		
		//-------------------------------------------------------------
		//
		// ADD/REMOVE HANDLERS
		//
		//-------------------------------------------------------------
		protected function onStreamReady(event : Event) : void 
		{
			TweenLite.to(_vidSwapper, .4, {alpha: 1});

			addEventListeners();
			addKeyEventListeners();
		}
		
		protected function addEventListeners() : void 
		{
			_pannerModel.addEventListener(CameraPannerModel.PAN_COMPLETE, onIndexChanged);

			HotspotOverlayManager.gi.addEventListener(HotspotOverlayManager.SHOW_OVERLAY, onShowOverlay);
			HotspotOverlayManager.gi.addEventListener(HotspotOverlayManager.HIDE_OVERLAY, onHideOverlay);

			masterStage.addEventListener(Event.MOUSE_LEAVE, onLeave);
			_holder.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_holder.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		protected function removeEventListeners() : void 
		{
			_pannerModel.removeEventListener(CameraPannerModel.PAN_COMPLETE, onIndexChanged);

			HotspotOverlayManager.gi.removeEventListener(HotspotOverlayManager.SHOW_OVERLAY, onShowOverlay);
			HotspotOverlayManager.gi.removeEventListener(HotspotOverlayManager.HIDE_OVERLAY, onHideOverlay);

			masterStage.removeEventListener(Event.MOUSE_LEAVE, onLeave);
			_holder.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_holder.removeEventListener(MouseEvent.MOUSE_UP, onUp);

			removeKeyEventListeners();
		}
		
		protected function addKeyEventListeners() : void 
		{
			masterStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			masterStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		protected function removeKeyEventListeners() : void 
		{
			masterStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			masterStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}


		//-------------------------------------------------------------------------
		//
		// CURSOR
		//
		//-------------------------------------------------------------------------
		protected function addCursor() : void
		{
			_cursor = new ExploreCursor();
			_cursor.init();
			_cursor.visible = false;
			addChild( _cursor );
		}
		
		protected function showCursor() : void
		{
			if(!_overlayVisible)
			{
				_cursor.show(.2);
				Mouse.hide();
			}
		}
		
		protected function hideCursor() : void
		{
			_cursor.hide(.2);
			Mouse.show();  
		}
		
		protected function updateCursor(mode : String) : void
		{
			if(!_cursor.visible) showCursor();
			
			_cursor.x = mouseX;
		    _cursor.y = mouseY;
		    _cursor.mode = mode;
		    
		    if(mode == VideoCursor.EXPLORE)
		    {
			    switch(_pol)
			    {
			    	case -1 : 
			    		_cursor.direction = VideoCursor.RIGHT;
			    		break;
			    		
			    	case 0 : 
			    		_cursor.direction = VideoCursor.NEUTRAL;
						break;
			    		
			    	case 1 : 
			    		_cursor.direction = VideoCursor.LEFT;
			    		break;
			    		
				}
		    }
		    else
		    {
				switch(TimeTracker.gi.currentSpeed)
				{
					case TimeTracker.SPEED_FF: 
						_cursor.direction = VideoCursor.RIGHT;
			    		break;
			    		
			    	case TimeTracker.SPEED_REG : 
						_cursor.direction = VideoCursor.NEUTRAL;
						break;
			    		
			    	case TimeTracker.SPEED_SLOW : 
						_cursor.direction = VideoCursor.NEUTRAL;
						break;
			    		
			    	case TimeTracker.SPEED_RW : 
						_cursor.direction = VideoCursor.LEFT;
			    		break;
				}
			}
		}
		
		
		
		//-------------------------------------------------------------------------
		// UI HANDLERS
		//-------------------------------------------------------------------------
		protected function onDown(event : MouseEvent) : void 
		{
			if(!_pannerModel.inEase)
			{
				if(!_startPnt) _startPnt = new Point();
				_startPnt.x = mouseX;
				_startPnt.y = mouseY;
				
				if(!hasEventListener(Event.ENTER_FRAME))
					addEventListener(Event.ENTER_FRAME, onEF);
					
				if(!_hoverView.visible) showCursor();
				
				TrackingManager.gi.trackCustom(TrackingConstants.SCREENDRAG);
			}
		}

		protected function onUp(event : MouseEvent) : void 
		{
			resetMouse();
		}

		protected function onLeave(event : Event) : void 
		{
			resetMouse();
		}

		protected function resetMouse() : void 
		{
			hideCursor();

			_uiDelay = TimeTracker.PANNING_RETARDER;
			removeEventListener(Event.ENTER_FRAME, onEF);

			// REMOVE SHIFT KEY FROM ARRAY IF CAPSLOCK
			// - REPLACING BEHAVIOR OF ONKEYUP
			var i : int;

		 	if(_vidSwapper.isScrubbing && _overScreen.alpha == 0) _vidSwapper.resume();
			if(Keyboard.capsLock)
			{
				_shiftDown = false;
				
				for each(var key : Number in _shiftArray)
				{
					i = _keysDown.indexOf(key);
					if(i > -1) _keysDown.splice(i, 1);
				}
			}
		}

		protected function onKeyDown(e : KeyboardEvent) : void
		{
//			trace('\n\n\n-------------------------------------------------------------');
//			trace('KEY PRESSED: ', this, e.keyCode);
//			trace('-------------------------------------------------------------\n\n\n');
			if(!_keysDown) _keysDown = new Array();
			
			if(_shell.main.stateModel.state != StateModel.STATE_EMAIL && !_overHolder.mouseEnabled)
			{
				if(_keysDown.indexOf(e.keyCode) == -1)
				{
					switch(e.keyCode)
					{
						case 65:// SHIFT OR COMMAND (65) - SCRUB W/ MOUSE
							_shiftDown = true;
							break;
						
						case 16: // shift on my macbook
							_shiftDown = true;
							break;
						
						case 38:// up (38) - ZOOM IN
							_timeTracker.zoom = 1;
							resize();
							break;
						
						case 40:// down (40) - ZOOM OUT
							_timeTracker.zoom = 0;
							resize();
							break;
						
						case 32: // space for speed toggle
							if(TimeTracker.gi.cpUnlocked)
							{
								_timeTracker.prevDefaultSpeed = _timeTracker.currentSpeed;
								_timeTracker.defaultSpeed = (_timeTracker.defaultSpeed == TimeTracker.SPEED_SLOW) ? TimeTracker.SPEED_REG : TimeTracker.SPEED_SLOW;
							}						
							break;
						
						case 90: // z: toggle shortcut buttons
							HotspotModel.gi.toggleShortcut();
							_grid.visible = !_grid.visible;
							_target.visible = !_target.visible;
							break;
					}
	
					// TRACK PRESSED KEYS
					if(_keysDown.indexOf(e.keyCode) == -1) _keysDown.push(e.keyCode);
				}
			}
		}

		protected function onKeyUp(e : KeyboardEvent) : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("MapMain.onKeyUp(e):", e.keyCode);

			var i : int;
			if(!Keyboard.capsLock)
			{
				// ALWAYS RESET SHIFT DOWN
			 	if(_vidSwapper.isScrubbing && _overScreen.alpha == 0) _vidSwapper.resume();
				_shiftDown = false;
				
				for each(var key : Number in _shiftArray)
				{
					i = _keysDown.indexOf(key);
					if(i > -1)
					{
				        _keysDown.splice(i, 1);
					}
				}
			}
			else
			{
				trace("MapMain.onKeyUp : CAPS LOCK IS DOWN - SHIFT WILL BE REMOVED ON MOUSEUP");
			}
		}
		
		protected function onEF(event : Event) : void 
		{
			// THROTTLE SPEED
			var tx : Number = _startPnt.x - mouseX;
			if(tx > 0) _pol = 1;
			else if(tx < 0) _pol = -1;
			else _pol = 0;
			
			var limX : Number = 20;
			var dx : Number = Math.min(Math.abs(tx), limX) * _pol;
			var dy : Number = _startPnt.y - mouseY;

			// SCRUB VIDEO
			if(_shiftDown)
			{
				if(!_overlayVisible) updateCursor(VideoCursor.SCRUB);
				
				var change : Number = Math.round( -dx / limX );
				var speeds : Array = (change >= 0) ? vidModel.getFwdSpeeds() : vidModel.getRevSpeeds();
				var speed : String = (change == 0) ? _timeTracker.defaultSpeed : speeds[speeds.length - 1];

				if(speed != _prevSpeed)
				{
					if(_scrubDelay < SCRUB_RETARDER)
					{
						_scrubDelay++;
					}
					else
					{
						_scrubDelay = 0;
						_vidSwapper.scrub(change);
						_prevSpeed = _timeTracker.defaultSpeed;

						if(speed == _timeTracker.defaultSpeed)
						{
							_startPnt.x = mouseX;
						}
					}
				}
			}
			
			// SWAP CAMERAS/VIDEOS
			else if(!_pannerModel.inEase)
			{
				if(!_overlayVisible) updateCursor(VideoCursor.EXPLORE);

				// DELAY IS RELATIVE TO STAGE WIDTH
				var del : Number = Math.round((masterStage.stageWidth * (_timeTracker.zoom))/ 1400);
				_uiDelay += Math.min(del, TimeTracker.PANNING_RETARDER - 2);
	
				if(_uiDelay >= TimeTracker.PANNING_RETARDER && _vidSwapper.panner.imgQueue.length < 2)
				{
					// TRACK DISTANCE FROM START POINT FOR VELOCITY OF SCROLLING
					dx = Math.min(Math.abs(tx), limX) * _pol;

					// - div is inversely relative to size of stage
					var div : Number = 12 + (masterStage.stageWidth * (_timeTracker.zoom))/600;

					_grid.x += dx / div;
					_grid.y += dy / div;
					
					// SET LIMITS
					var center : Point = new Point(0,0);
					var topLim : Number = center.y + _grid.height/2;
					var bottomLim : Number = center.y - _grid.height/2;
					var leftLim : Number = center.x + _grid.width/2 - 2;
					var rightLim : Number = center.x - _grid.width/2 + 2;
					
					if(_grid.y >= topLim) _grid.y = topLim;
					if(_grid.y <= bottomLim) _grid.y = bottomLim;
					if(_grid.x >= leftLim) _grid.x = leftLim;
					if(_grid.x <= rightLim) _grid.x = rightLim;
					
					// USE GRID POSITION TO DISCERN WHICH BOX IS AT CENTER
					var gdx : Number = center.x - _grid.x;
					var gdy : Number = center.y - _grid.y;
					var colNum : int = Math.floor(gdx / BOX_W + _colCount / 2);
					var rowNum : int = Math.floor((gdy/(BOX_W * GridBox.ratio)) + _rowCount / 2);
		//			var idNum : uint = (colNum * _rowCount) - (_colCount - rowNum) - 1;
		//			var id : String = idNum.toString();
					var id : String = colNum.toString();

					// INVERSE SCRUBBING
					_nextId = (_isInverted) ? (_colCount - 1 - colNum).toString() : id;

					if(TimeTracker.gi.currentCamInd != _nextId)
					{
						_uiDelay = 0;
						
						// ADJUST GRID POS TO MATCH FOCAL POINT OF PREVIOUS ANGLE
						var transitionOffset : Number = (dx < 0) ? -1 : 1;
						var angleOffset : Number = .95;
						_grid.x += transitionOffset * (BOX_W * angleOffset);
						
						var box : GridBox;
						for (var i : uint = 0;i < _grid.numChildren;i++)
						{
							box = _grid.getChildAt(i) as GridBox;
							if(box.id == id) box.showOver();
							else box.showOut();
						}

						if(_vidSwapper) _vidSwapper.startSwapQueue();
						CameraPannerModel.gi.addTransition(Number(_nextId));
						TimeTracker.gi.currentCamInd = _nextId;
					}
					
					// distance from left edge of grid to center
					var absoluteDifX : Number = center.x - _grid.x + _grid.width/2; 
					var absoluteDifY : Number = center.y - _grid.y + _grid.height / 2;
					// offset to chunk out grid items
					var offsetX : Number = BOX_W * colNum;
					var offsetY : Number = (BOX_W * GridBox.ratio) * rowNum;
					var relPosX : Number = absoluteDifX - offsetX;
					var relPosY : Number = absoluteDifY - offsetY;
					// convert to polar range
					var polarX : Number = PercentToPolarConverter.getPolarValue(relPosX / BOX_W);
					var polarY : Number = PercentToPolarConverter.getPolarValue(relPosY / (BOX_W * GridBox.ratio));
					
					var padW : Number;
					var padH : Number;
					var tarX : Number;
					var tarY : Number;
					
					if(_vidSwapper)
					{			
						padW = _vidSwapper.width - masterStage.stageWidth;
						padH = _vidSwapper.height - masterStage.stageHeight;
						tarX = center.x - (polarX * padW / 2);
						tarY = center.y - (polarY * padH / 2);
			
						_vidSwapper.x += (tarX - _vidSwapper.x) / 6;
						_vidSwapper.y += (tarY - _vidSwapper.y) / 6;
					}

				}
			}
			
			if(!_cursor.visible) showCursor();
		}

		protected function onHideOverlay(event : Event) : void 
		{
			_overlayVisible = false;
		}

		protected function onShowOverlay(event : ParamEvent) : void 
		{
			hideCursor();
			_overlayVisible = true;
		}

		public function resize() : void
		{
			_holder.x = masterStage.stageWidth/2;
			_holder.y = masterStage.stageHeight/2;

			repositionEndframe();
			
			// SCALE VIGNETTE TO STAGE
			_overHolder.width = masterStage.stageWidth;
			_overHolder.height = masterStage.stageHeight;
			_overScreen.width = masterStage.stageWidth;
			_overScreen.height = masterStage.stageHeight;

			var tarW : Number = masterStage.stageWidth * SiteConstants.VIDEO_SCALE * _timeTracker.zoom;
			var tarH : Number = masterStage.stageHeight * SiteConstants.VIDEO_SCALE * _timeTracker.zoom;
			RectangleScaler.scale(_vidSwapper, tarW, tarH);//, 600, 300, 3200, 1600);

			// REPOSITION IF PUSHED OFF STAGE
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

			if(_blurBmp)
			{
				RectangleScaler.scale(_blurBmp, tarW, tarH);
				_blurBmp.x = _vidSwapper.x - Math.round(padW/2);
				_blurBmp.y = _vidSwapper.y - Math.round(padH/2);
			}
			
			TimeTracker.gi.masterStage = masterStage;
		}
		
		protected function repositionEndframe() : void 
		{
			_endframe.x = _holder.x;
			_endframe.y = _holder.y;
		}

		protected function onIndexChanged(event : Event) : void 
		{
			updateGridPos();
		}
		
		private function onGridClick(event : MouseEvent) : void 
		{
			// CENTER GRID TO THIS BOX
			var box : GridBox = event.currentTarget as GridBox;
			TimeTracker.gi.currentCamInd = box.id;

			updateGridPos();

			// UPDATE
			_vidSwapper.pause();
			_vidSwapper.resume();
		}		

		private function updateGridPos() : void 
		{
			// REPOSITION GRID DUE TO EASE ANIMATION DISPLACEMENT
			// USE GRID POSITION TO DISCERN WHICH BOX IS AT CENTER

			// CENTER GRID TO THIS BOX
			var center : Point = new Point(0, 0);
			var gdx : Number = center.x - _grid.x;
			var colNum : int = Math.floor(gdx / BOX_W + _colCount / 2);
			var invertedColNum : int = _colCount - 1 - colNum;
			var dif : int = colNum - Number(TimeTracker.gi.currentCamInd);
			var invertedDif : int = -(invertedColNum -  Number(TimeTracker.gi.currentCamInd));

			// INVERSE SCRUBBING
			var tarDif : int = (_isInverted) ? invertedDif : dif;

			var displacement : Number = tarDif * BOX_W;
			_grid.x += displacement;

			// UPDATE BOX HIGHLIGHT
			var box : GridBox;
			for (var i : uint = 0;i < _grid.numChildren;i++)
			{
				box = _grid.getChildAt(i) as GridBox;
				if(box.id == TimeTracker.gi.currentCamInd) box.showOver();
				else box.showOut();
			}
		}		

		private function refocus() : void 
		{
			masterStage.focus = this;
		}


		//-------------------------------------------------------------------------
		// INTERSTITIAL FRAME
		//-------------------------------------------------------------------------
		public function hideEndframe() : void 
		{
			_endframe.hide();
		}

		private function onEndframeReplay(event : Event) : void
		{
			_endframe.hide();
			resume();
		}

		private function onEndframeResolve(event : Event) : void
		{
			var dur : Number = .4;
			TweenMax.to(_overScreen, dur, {autoAlpha: 1});

			_endframe.hide();
			Shell.getInstance().main.stateModel.state = StateModel.STATE_SUMMARY;
		}
		
		private function onShowEndframe(event : Event) : void
		{
			pause(true, .3, 15, .5);

			_endframe.reveal(TimeTracker.gi.cpUnlocked);

			TimeTracker.gi.hideUtilNav();
			TimeTracker.gi.cpUnlocked = true;
		}



		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function get masterHs() : Number
		{
			var h : Number = masterStage.stageHeight - (SiteConstants.NAV_BAR_HEIGHT * 2);
			return h;
		}		
		
		public function get vidModel() : VideoModel
		{
			return _shell.getVideoModel();
		}
		
		public function get masterStage() : Stage
		{
			return _shell.masterStage;
		}
		
		public function get isPaused() : Boolean
		{
			return _isPaused;
		}
	}
}

package com.jordan.cp.players.hotspots 
{
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.HotspotModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.model.dto.HotspotDTO;
	import com.jordan.cp.players.StreamSwapper;
	import com.jordan.cp.players.TimeTracker;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.managers.sound.PlodeSoundItem;
	import com.plode.framework.managers.sound.PlodeSoundManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetStream;
	import flash.utils.Dictionary;	

	/**
	 * @author nelson.shin
	 */
	
	public class HotspotPlotter extends AbstractDisplayContainer 
	{
		protected var _stateModel : StateModel;
		protected var _contentModel : ContentModel;
		protected var _hsModel : HotspotModel = HotspotModel.gi;
		protected var _tracker : TimeTracker = TimeTracker.gi;
		protected var _hsManager : HotspotOverlayManager = HotspotOverlayManager.gi;

		protected var _holder : Sprite;
		protected var _shortcutHolder : Sprite;
//		protected var _hotspotView : HotspotOverlayView;
		protected var _activeStream : NetStream;
		protected var _d : Dictionary;

		protected var _rounded : Number;
		protected var _hotspot : Hotspot;
		private var _overSound : PlodeSoundItem;
		private var _clickSound : PlodeSoundItem;

		//-------------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//-------------------------------------------------------------------------
		public function HotspotPlotter()
		{
		}

		override public function setup() : void
		{
			_hsModel.addEventListener(HotspotModel.TOGGLE_SHORTCUTS, onToggleShorts);
			
			_stateModel = Shell.getInstance().main.stateModel;
			_contentModel = Shell.getInstance().getContentModel();
			_d = new Dictionary();

//			_hotspotView = new HotspotOverlayView();
			_holder = new Sprite();
			_holder.alpha = 0;
			_shortcutHolder = new Sprite();
			_shortcutHolder.visible = false;

//			addChild(_hotspotView);
			addChild(_holder);
			addChild(_shortcutHolder);
			
			addSceneShortcuts();
			addContentShortcuts();
			
			resume();

//			focusRect = false;
		}

		private function onToggleShorts(event : Event) : void 
		{
			_holder.alpha = (_hsModel.shortcutsVisible) ? 1 : 0;
			_shortcutHolder.visible = _hsModel.shortcutsVisible;
		}

		public function pause() : void
		{
			clearAllHotspots();
			removeEventListener(Event.ENTER_FRAME, onEF);
		}

		public function resume() : void
		{
			if(!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME, onEF);
		}

		protected function addSceneShortcuts() : void
		{
			_hotspot = new Hotspot();
			_hotspot.id = SiteConstants.SCENE_CHEF;
			_hotspot.color = Math.random() * 0xffffff;
			_hotspot.graphics.beginFill(_hotspot.color, .5);
			_hotspot.graphics.drawRect(-200, -50, 100, 100);
			_hotspot.buttonMode = true;
			_hotspot.addEventListener(MouseEvent.ROLL_OVER, onHotspotOver);
			_hotspot.addEventListener(MouseEvent.ROLL_OUT, onHotspotOut);
			_hotspot.addEventListener(MouseEvent.CLICK, onHotspotClick);
			_shortcutHolder.addChild(_hotspot);
			
			var horse : Hotspot = new Hotspot();
			horse.id = SiteConstants.SCENE_HORSE;
			horse.color = Math.random() * 0xffffff;
			horse.graphics.beginFill(horse.color, .5);
			horse.graphics.drawRect(-90, -50, 100, 100);
			horse.buttonMode = true;
			horse.addEventListener(MouseEvent.ROLL_OVER, onHotspotOver);
			horse.addEventListener(MouseEvent.ROLL_OUT, onHotspotOut);
			horse.addEventListener(MouseEvent.CLICK, onHotspotClick);
			_shortcutHolder.addChild(horse);
			
			var kiss : Hotspot = new Hotspot();
			kiss.id = SiteConstants.SCENE_KISS;
			kiss.color = Math.random() * 0xffffff;
			kiss.graphics.beginFill(kiss.color, .5);
			kiss.graphics.drawRect(20, -50, 100, 100);
			kiss.buttonMode = true;
			kiss.addEventListener(MouseEvent.ROLL_OVER, onHotspotOver);
			kiss.addEventListener(MouseEvent.ROLL_OUT, onHotspotOut);
			kiss.addEventListener(MouseEvent.CLICK, onHotspotClick);
			_shortcutHolder.addChild(kiss);
		}

		protected function addContentShortcuts() : void
		{
			var i : uint = 0;
			var I : uint = _contentModel.content.length;
			
			var size : uint = 20;
			
			for( i; i < I; i++ )
			{
				var hotspot : Hotspot = new Hotspot();
				hotspot.id = _contentModel.getContentItemAt( i ).name;
				hotspot.color = Math.random() * 0xffffff;
				hotspot.graphics.beginFill( hotspot.color, 0.5);
				var xPos : Number = -200 + ( size * 1.5  * i );
				hotspot.graphics.drawRect(xPos, 100, size, size);
				hotspot.buttonMode = true;
				hotspot.addEventListener(MouseEvent.ROLL_OVER, onHotspotOver);
				hotspot.addEventListener(MouseEvent.ROLL_OUT, onHotspotOut);
				hotspot.addEventListener(MouseEvent.CLICK, onHotspotClick);
				_shortcutHolder.addChild( hotspot );
			}
		}
		
		
		
		//-------------------------------------------------------------------------
		//
		// HANDLERS
		//
		//-------------------------------------------------------------------------
		protected function onEF(event : Event) : void
		{
			if(_activeStream)
			{
				// ROUND TO NEAREST .5
				
				var baseSpeed : Number = Number(TimeTracker.SPEED_SLOW.substr(TimeTracker.SPEED_SLOW.indexOf('0') + 1, 2));
				var activeSpeed : Number = Number(_tracker.currentSpeed.substr(_tracker.currentSpeed.indexOf('0') + 1, 2));
				var speedRatio : Number = (_tracker.currentScene == SiteConstants.SCENE_COURT) ? baseSpeed/activeSpeed : 1;
				var relativeTime : Number = _activeStream.time * speedRatio;
				var time : String = (Math.round(relativeTime * 10) / 10).toString();
				var tenth : Number = (Number(time.split('.')[1]) > 5) ? 5 : 0;
				var rounded : Number = Number(time.split('.')[0] + '.' + tenth.toString());

				if(rounded != _rounded)
				{
					_rounded = rounded;

					var scene : Dictionary = _hsModel.d[_tracker.currentScene];
					// DEFAULT TO 0 FOR SCENES
					var camInd : Number = (_stateModel.state == StateModel.STATE_SCENE)
						? 0
						: Number(_tracker.currentCamInd);
						
					var camera : Dictionary = scene[camInd];
		
					for(var key : Object in camera)
					{
						// EVERY HOTSPOT TARGET ITEM (ie. court, chef, kiss)
						var targetObjId : String = key.toString();
						var object : Dictionary = camera[targetObjId];

						try
						{
							// time-based node
							var dto : HotspotDTO = object[rounded];
//							dto.preview();
							
							drawHotspot(dto, targetObjId);
						}
						catch(e : Error)
						{
							clearHotspots(targetObjId);
//							trace('NO HOTSPOT DTO EXISTS FOR', object[rounded]);
						}
					}
				}
				
				// FOLLOW CURSOR
				
				_hsManager.move(mouseX, mouseY);
//				_hotspotView.x = ;
//				_hotspotView.y = mouseY;
			}
		}

		protected function drawHotspot(dto : HotspotDTO, key : String) : void
		{
			// RATIO OF SOURCE FOOTAGE TO VIDEO OBJECT SCALE
			var ratio : Number = StreamSwapper.W / HotspotDTO.W;
			var hotspot : Hotspot;
			var contentDTO : ContentDTO = _contentModel.getContentItemByName(key) as ContentDTO;
			var type : String = contentDTO.type;

			var tarX : Number = dto.x * ratio - (dto.w * ratio) / 2;
			var tarY : Number = dto.y * ratio - (dto.h * ratio) / 2;
			var tarW : Number = dto.w * ratio;
			var tarH : Number = dto.h * ratio;
			
			// CREATE OR PULL FROM EXISTING			
			if(!_d[key])
			{
				hotspot = new Hotspot();
				hotspot.id = key;
				hotspot.color = Math.random() * 0xffffff;
				hotspot.buttonMode = true;
				hotspot.addEventListener(MouseEvent.ROLL_OVER, onHotspotOver);
				hotspot.addEventListener(MouseEvent.ROLL_OUT, onHotspotOut);
				if(type != SiteConstants.HOTSPOT_TYPE_CONTENT)
					hotspot.addEventListener(MouseEvent.CLICK, onHotspotClick);
//				hotspot.graphics.clear();
				hotspot.graphics.beginFill(hotspot.color, .5);
				hotspot.graphics.drawRect(0, 0, tarW, tarH);

				_holder.addChild(hotspot);
				_d[key] = hotspot;
			}
			else
			{
				hotspot = _d[key] as Hotspot;
				hotspot.width = tarW;
				hotspot.height = tarH;
			}
			
			hotspot.visible = true;
			hotspot.x = tarX;
			hotspot.y = tarY;
			
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("HotspotPlotter.drawHotspot(dto, key)"); 
//			
//			for(var test : Object in _d)
//			{
//				trace(test);
//			}
		}

		protected function clearHotspots(key : String) : void 
		{
			if(_d[key])
			{
				var hotspot : Hotspot = _d[key] as Hotspot;
				hotspot.visible = false;
			}
		}

		public function clearAllHotspots() : void 
		{
			for(var key : Object in _d)
			{
//				trace("HotspotPlotter.clearAllHotspots()", key);
				clearHotspots(key.toString());
			}
		}

		protected function onHotspotOver(event : MouseEvent) : void 
		{
			var hotspot : Hotspot = event.target as Hotspot;
			_contentModel.hotspotName = hotspot.id;
//			trace("HotspotPlotter.onHotspotOver(event) : hotspot.id: " + (hotspot.id));
			var dto : ContentDTO = _contentModel.getContentItemByName(hotspot.id) as ContentDTO;

			// MANAGER DISPATCHES EVENT AND HOLDS TYPE
			_hsManager.show(dto);
			
			if(!_overSound)
			{
				_overSound = PlodeSoundManager.gi.getSound(SiteConstants.AUDIO_ROLL_OVER );
			}
			_overSound.play();
			
			// UPDATE UNLOCKED CONTENT
			var type : String = dto.type;
			if( type == SiteConstants.HOTSPOT_TYPE_CONTENT )
			{
				_contentModel.addUnlockedContent(dto.id);
			}
		}

		protected function onHotspotOut(event : MouseEvent) : void 
		{
//			trace("HotspotPlotter.onHotspotOut(event)");
			// MANAGER DISPATCHES EVENT
			_hsManager.hide();
		}

		protected function onHotspotClick(event : MouseEvent) : void 
		{
			var hotspot : Hotspot = event.target as Hotspot;
			_contentModel.hotspotName = hotspot.id;
			var dto : ContentDTO = _contentModel.getContentItemByName(hotspot.id) as ContentDTO;
			var type : String = dto.type;

			if(!_clickSound)
			{
				_clickSound = PlodeSoundManager.gi.getSound(SiteConstants.AUDIO_CLICK );
			}
			_clickSound.play( );

			
			//			trace('\n\n\n\n\n\n');
//			trace('----------------------------------------------------------');
//			trace('CLICK: ID:', hotspot.id);
//			trace('----------------------------------------------------------');
//			trace('\n\n\n\n\n\n');

			_hsManager.hide();

			// DEPRECATED - DONE IN STREAMSWAPPER			
//			// LOCK TIME FOR MAIN SCENE
//			if(Shell.getInstance().main.state == StateModel.STATE_MAIN)
//			{
//				// TODO - RELATIVE TO SPEED
//				TimeTracker.gi.pausedTime = _activeStream.time;
//			}

			TrackingManager.gi.trackCustom(TrackingConstants.BONUS_CLICKED );

			switch (type)
			{
				case SiteConstants.HOTSPOT_TYPE_SCENE:
				{
					// RESET CAMERA GLOBAL VARS
					TimeTracker.gi.currentScene = dto.name;
					
					
					// SET TO DEFAULT SPEED FOR BONUS SCENES
//					TimeTracker.gi.prevDefaultSpeed = TimeTracker.gi.defaultSpeed;
//					TimeTracker.gi.defaultSpeed = TimeTracker.SPEED_SLOW;
//					TimeTracker.gi.currentSpeed = TimeTracker.gi.defaultSpeed;



//					// TODO - RELATIVE TO SPEED
//					TimeTracker.gi.pausedTime = _activeStream.time;
					
					_contentModel.addUnlockedScene(dto.id);
					_stateModel.state = StateModel.STATE_SCENE;
					
					break;
				}
				case SiteConstants.HOTSPOT_TYPE_VIGNETTE:
				{
					_contentModel.addUnlockedContent(dto.id);
					_stateModel.state = StateModel.STATE_VIGNETTE;
					break;
				}
				default:
				{
					trace("HotspotPlotter.onHotspotClick(event) : INVALID TYPE SELECTED");
					break;
				}
			}
			
			// UPDATE UNLOCKED CONTENT
//			updateUnlockedContent(dto.id);
		}


		
		//-------------------------------------------------------------------------
		//
		// SETTERS & GETTERS
		//
		//-------------------------------------------------------------------------
		public function set activeStream(val : NetStream) : void
		{
			_activeStream = val;
		}

		public function destroy() : void 
		{
//			_d = null;
//			_hsManager = null;
//			removeChild(_hotspotView);
			while(_holder.numChildren > 0) _holder.removeChildAt(0);
		}
	
	
	
	}
}

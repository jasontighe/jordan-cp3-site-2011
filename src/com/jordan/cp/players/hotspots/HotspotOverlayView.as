package com.jordan.cp.players.hotspots 
{
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.events.ParamEvent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;	

	/**
	 * @author nelson.shin
	 */
	public class HotspotOverlayView extends AbstractDisplayContainer 
	{
		private var _holder : Sprite;
		private var _manager : HotspotOverlayManager = HotspotOverlayManager.gi;
		private var _iconContent : IconContent;
		private var _iconVignette : IconVignette;
		private var _iconScene : IconScene;

		private static const MAR_Y : Number = 0;

		//-------------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//-------------------------------------------------------------------------
		public function HotspotOverlayView()
		{
			hide();
			setup();
		}
		
		override public function setup() : void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			_holder = new Sprite();
			addChild(_holder);
			
			// ADD TYPES
			_iconScene = new IconScene();
			_iconVignette = new IconVignette();
			_iconContent = new IconContent();
			
			_iconScene.visible = false;
			_iconVignette.visible = false;
			_iconContent.visible = false;
			
			_iconScene.alpha = 0;
			_iconVignette.alpha = 0;
			_iconContent.alpha = 0;
			
			_holder.addChild(_iconScene);
			_holder.addChild(_iconVignette);
			_holder.addChild(_iconContent);
			
			_manager.addEventListener(HotspotOverlayManager.SHOW_OVERLAY, onShow);
			_manager.addEventListener(HotspotOverlayManager.HIDE_OVERLAY, onHide);
			_manager.addEventListener(HotspotOverlayManager.MOVE_OVERLAY, onMove);
		}

		override public function show(dur : Number = .3, del : Number = 0) : void
		{
			alpha = 1;
			visible = true;
		}

		
		//-------------------------------------------------------------------------
		//
		// HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onShow(event : ParamEvent) : void 
		{
//			trace("HotspotOverlayView.onShow(event)", event.params, event.params.dto);
			var dto : ContentDTO = event.params.dto as ContentDTO;

			showHover(dto);
			show();
			
			
			var s : String = '';
			switch(dto.name)
			{
				case 'meal' :
					s = TrackingConstants.OVERLAY_MEAL;
					break;
					
				case 'soda' :
					s = TrackingConstants.OVERLAY_SODA;
					break;
					
				case 'gospel' :
					s = TrackingConstants.OVERLAY_GOSPEL;
					break;
			}			

		
			if(s != '') TrackingManager.gi.trackPage( s );
		}

		private function onHide(event : Event) : void 
		{
			hide(0);
			hideHover();	
		}

		private function onMove(event : ParamEvent) : void 
		{
			var masterStage : Stage = Shell.getInstance().masterStage;
			x = masterStage.mouseX;
			y = masterStage.mouseY - MAR_Y;
		}


		
		//-------------------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------------------
		private function showHover(dto : ContentDTO) : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("HotspotOverlayView.showHover(dto) : dto: " + (dto.name));
//			dto.preview();
			
			var targetIcon : AbstractHotspotIcon;
			
			switch (dto.type)
			{
				case SiteConstants.HOTSPOT_TYPE_SCENE:
				{
					targetIcon = _iconScene;
					break;
				}
				case SiteConstants.HOTSPOT_TYPE_VIGNETTE:
				{
					_iconVignette.icon = dto.icon;
					targetIcon = _iconVignette;
					break;
				}
				case SiteConstants.HOTSPOT_TYPE_CONTENT :
				{
					targetIcon = _iconContent;
					break;
				}
				default:
				{
					trace("HotspotOverlayView.showHover(dto) : INVALID TYPE SELECTED");
					break;
				}
			}
			
			// SET DTO FOR TEXT
			targetIcon.dto = dto;

			var icon : AbstractHotspotIcon;
			for(var i : uint = 0; i < 3; i++)
			{
				icon = _holder.getChildAt(i) as AbstractHotspotIcon;
				(icon == targetIcon) ? icon.show(.3) : icon.hide(0);
			}
		}
		
		private function hideHover() : void 
		{
			for(var i : uint = 0; i < 3; i++)
			{
				var icon : AbstractHotspotIcon = _holder.getChildAt(i) as AbstractHotspotIcon;
				icon.hide();
			}
		}
		


	}
}

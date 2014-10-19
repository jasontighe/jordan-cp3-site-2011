package com.jordan.cp.players.hotspots 
{
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.events.ParamEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	/**
	 * @author nelson.shin
	 */
	public final class HotspotOverlayManager extends EventDispatcher
	{
		private static var _instance: HotspotOverlayManager;
		public static const SHOW_OVERLAY : String = 'SHOW_OVERLAY';
		public static const HIDE_OVERLAY : String = "HIDE_OVERLAY";
		public static const MOVE_OVERLAY : String = "MOVE_OVERLAY";

		//---------------------------------------------------------------------
		//
		// SINGLETON STUFFS
		//
		//---------------------------------------------------------------------
		public function HotspotOverlayManager( se : SingletonEnforcerer ) 
		{
			if( se != null ){
				init();
			}
		}

		public static function get gi() : HotspotOverlayManager {
			if( _instance == null ){
				_instance = new HotspotOverlayManager( new SingletonEnforcerer() );
			}
			return _instance;
		}

		private function init() : void 
		{
		}

		
		
		
		//-------------------------------------------------------------------------
		//
		// EVENT NOTIFICATION
		//
		//-------------------------------------------------------------------------
		public function show(dto : ContentDTO) : void 
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("HotspotOverlayManager.show(dto)");
//			dto.preview();
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
			dispatchEvent(new ParamEvent(SHOW_OVERLAY, {dto: dto}));
		}

		public function hide() : void
		{
			dispatchEvent(new Event(HIDE_OVERLAY));
		}
		
		public function move(tarX : int, tarY : int) : void
		{
			var point : Point = new Point();
			point.x = tarX;
			point.y = tarY;

			dispatchEvent(new ParamEvent(MOVE_OVERLAY, {point: point}));
		}
	}
}

class SingletonEnforcerer {}
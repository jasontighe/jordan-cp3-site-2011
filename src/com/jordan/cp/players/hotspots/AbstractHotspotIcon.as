package com.jordan.cp.players.hotspots {
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.Sprite;

	/**
	 * @author nelson.shin
	 */
	public class AbstractHotspotIcon extends AbstractDisplayContainer 
	{
		protected var _libItem : Sprite;
		protected var _dto : ContentDTO;
		protected var _active : Boolean;

		public function AbstractHotspotIcon()
		{
		}
		
		protected function addAsset(id : String, swfId : String = SiteConstants.ASSETS_ID) : void
		{
			_libItem = AssetManager.gi.getAsset(id, swfId);
			addChild(_libItem);
		}
		



		public function get dto():ContentDTO
		{
			return _dto;
		}
		public function set dto(value:ContentDTO):void
		{
			_dto = value;
			updateCopy();
		}

		protected function updateCopy() : void 
		{
		}
	}
}

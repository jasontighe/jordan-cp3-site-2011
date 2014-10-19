package com.jordan.cp.players.hotspots 
{
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author nelson.shin
	 */
	public class IconVignette extends AbstractHotspotIcon 
	{
		private var _icons : Array;
		private var _arrow : Sprite;
		private var _bg : Sprite;
		private var _text : TextContainer;

		public function IconVignette()
		{
			addAsset('IconVignetteAsset');

			_arrow = MovieClip(_libItem).arrow;
			_bg = MovieClip(_libItem).bg;

			_icons = 
			[
				SiteConstants.HOTSPOT_ICON_KEYBOARD
				, 'message'//SiteConstants.HOTSPOT_ICON_FACTOID
				, SiteConstants.HOTSPOT_ICON_CAMERA
				, SiteConstants.HOTSPOT_ICON_SHOE
				, SiteConstants.HOTSPOT_ICON_VIDEO
			];
		}
		
		public function set icon(val : String) : void
		{
//			trace( '\n\n\n-------------------------------------------------------------' );//			trace( "IconVignette.icon.val: " + val );
//			trace('-------------------------------------------------------------\n\n\n');
			
			for(var i : uint = 0; i < _icons.length; i++)
			{
//				trace( "IconVignette.icon._icons[i]: " + _icons[i] );
				_libItem.getChildByName(_icons[i]).visible = (_icons[i] == val);
			}
		}


		override protected function updateCopy() : void 
		{
			// TODO - TEXT SHOULD BE DYNAMIC
			var text : String = 'SEE MORE';

			if(!_text)
			{
				_text = new TextContainer();
				_text.populate(text, 'hover-content-header');
				
				addChild(_text);
			}
			else
			{
				_text.update(text);
			}
			
			_text.x = - _text.width/2;
			var mar : Number = 14;
			_text.y = -mar;
		}


	}
}

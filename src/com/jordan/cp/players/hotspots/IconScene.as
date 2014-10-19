package com.jordan.cp.players.hotspots 
{
	import com.plode.framework.containers.TextContainer;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author nelson.shin
	 */
	public class IconScene extends AbstractHotspotIcon
	{
		private var _icon : Sprite;
		private var _text : TextContainer;

		public function IconScene()
		{
			addAsset('IconSceneAsset');

			_icon = MovieClip(_libItem).icon;
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

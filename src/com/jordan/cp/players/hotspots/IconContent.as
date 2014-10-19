package com.jordan.cp.players.hotspots 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.utils.BoxUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author nelson.shin
	 */
	public class IconContent extends AbstractHotspotIcon 
	{
		private var _arrow : Sprite;
		private var _bg : Sprite;
		private var _masker : Sprite;
		private var _textMasker : Sprite;
		private var _textBg : Sprite;
		private var _bgHolder : Sprite;
		private var _inX : int;
		private var _outX : int;
		private var _header : TextContainer;
		private var _desc : TextContainer;
		
		protected static var HEADER_Y_OFFSET : uint = 4;
		protected static var DESC_Y_OFFSET : uint = 4;
		
		public function IconContent()
		{
			addAsset('IconContentAsset');

			_arrow = MovieClip(_libItem).arrow;
			_bg = MovieClip(_libItem).bg;
			_textBg = MovieClip(_libItem).textBg;
			
			
			var padding : int = 4;
			_inX = _bg.x - _textBg.width;
			_outX = _bg.x + _bg.width/2 + padding;

			_masker = new Sprite();
			_masker.graphics.beginFill(0xff0000, .5);
			_masker.graphics.drawRect(_outX, _bg.y - _bg.height/2, _textBg.width, _textBg.height);
			addChild(_masker);
			
			_textMasker = new Sprite();
			_textMasker.graphics.beginFill(0xff0000, .5);
			_textMasker.graphics.drawRect(_outX, _bg.y - _bg.height/2, _textBg.width, _textBg.height);
			addChild(_textMasker);
			
			_bgHolder = BoxUtil.getBox(_textBg.width, _textBg.height, 0x000000, 0);
			_bgHolder.x = _inX;
			_bgHolder.mask = _masker;
			addChild(_bgHolder);
			
			_textBg.alpha = 0;
			_textBg.x = _inX;
			_textBg.mask = _textMasker;
		}
		
		override public function show(dur : Number = .3, del : Number = 0) : void
		{
			expand();
			super.show(dur);
		}

		override public function hide(dur : Number = .3, del : Number = 0) : void
		{
			collapse();
			super.hide(dur);
		}

		private function expand(dur : Number = .3, del : Number = .6) : void 
		{
//			TweenMax.killTweensOf(_bgHolder);
			TweenMax.to(_textBg, dur, {x: _outX, autoAlpha: 1, delay: del, ease: Strong.easeOut});
			TweenMax.to(_bgHolder, dur, {x: _outX, autoAlpha: 1, delay: del, ease: Strong.easeOut});
		}

		private function collapse(dur : Number = .3) : void 
		{
//			TweenMax.killTweensOf(_bgHolder);
			TweenMax.to(_textBg, dur, {x: _inX, ease: Strong.easeOut});
			TweenMax.to(_bgHolder, dur, {x: _inX, ease: Strong.easeOut});
		}
		
		override protected function updateCopy() : void 
		{
			var header : String = dto.longTitle;
			var desc : String = dto.desc.substring(0, 70 );

			if(!_header)
			{
				_header = new TextContainer();
				_header.populate(header, 'hover-content-header');
				_header.tf.width = _textBg.width - 10;

				_desc = new TextContainer();
				_desc.populate(desc, 'hover-content-desc', true);
				_desc.tf.width = _textBg.width - 10;

				var mar : Number = 4;
				_header.x = (_bgHolder.width - _header.width)/2;
				_desc.x = (_bgHolder.width - _desc.width)/2;
				_header.y = (_bgHolder.height)/2 - (_header.height + _desc.height + mar)/2 + HEADER_Y_OFFSET;
				_desc.y = _header.y + _header.tf.textHeight + mar - DESC_Y_OFFSET;
				
				_bgHolder.addChild(_header);
				_bgHolder.addChild(_desc);
			}
			else
			{
				_header.update(header);
				_desc.update(desc);
			}
			
			
			_bgHolder.x = _textBg.x + (_textBg.width - _bgHolder.width)/2;
			_bgHolder.y = _textBg.y + (_textBg.height - _bgHolder.height)/2;
		}
		
	}
}

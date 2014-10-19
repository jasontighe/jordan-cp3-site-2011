package com.jordan.cp.view.error 
{
	import com.greensock.TweenLite;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author nelson.shin
	 */
	public class ErrorPinwheel extends AbstractDisplayContainer 
	{
		private var _holder : Sprite;
		private var _asset : MovieClip;
		private var _kit : MovieClip;
		private var _div : MovieClip;
		private var _txt : TextContainer;
		private var _t : Timer;
		private var _cnt : Number = 0;

		private static const TIMER_DELAY : uint = 100;
		private static const BOX_COUNT : Number = 4;

		
		
		public function ErrorPinwheel()
		{
			setup();
		}
		
		override public function setup() : void
		{
			_holder = new Sprite();
			addChild(_holder);

			_asset = AssetManager.gi.getAsset('ConnectionErrorPinwheelAsset', SiteConstants.WELCOME_ID) as MovieClip;
			_kit = _asset.kit;
			_div = _asset.divCenter;

			_txt = new TextContainer();
			_txt.populate('PLEASE WAIT', 'loader-help-body');
			var bottomCenterY : Number = Math.round(_asset.height/4);
			_txt.y = Math.round( bottomCenterY - _txt.tf.textHeight/2);
			_txt.x = - Math.round( _txt.tf.textWidth / 2 );
			
			_holder.addChild(_asset);
			_holder.addChild(_txt);
		}

		override public function show(dur : Number = .4, del : Number = 0) : void
		{
			super.show(dur, del);
			start();
		}

		override public function hide(dur : Number = .4, del : Number = 0) : void
		{
			super.hide(dur, del);
			stop();
		}

		
		
		//-------------------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------------------
		private function start() : void 
		{
			dimBoxes();
			startTimer();
		}

		private function stop() : void 
		{
			dimBoxes();
			stopTimer();
		}

		private function dimBoxes() : void 
		{
			var box : MovieClip;
			
			for(var i : uint = 0; i < BOX_COUNT; i++)
			{
				box = _kit['box' + i] as MovieClip;
				box.alpha = .3;
				box.width = 4;
				box.height = 4;
			}
		}
		
		private function animate() : void 
		{
			var dur : Number = .3;
			var box : MovieClip;
			
			for(var i : uint = 0; i < BOX_COUNT; i++)
			{
				box = _kit['box' + i] as MovieClip;

				(i == _cnt)
				? TweenLite.to(box, dur, {alpha: 1, width: 5, height: 5})
				: TweenLite.to(box, dur, {alpha: .3, width: 4, height: 4});
			}
		}
		
		private function startTimer() : void
		{
			if(!_t)
			{
				_t = new Timer(TIMER_DELAY);
				_t.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
			_t.start();
		}
		
		private function stopTimer() : void
		{
			if(_t) _t.stop();
		}
		
		private function onTimer(e : TimerEvent) : void
		{
			if(_cnt < BOX_COUNT)
			{
				animate();
				_cnt++;
			}
			else _cnt = 0;
		}		


	}
}

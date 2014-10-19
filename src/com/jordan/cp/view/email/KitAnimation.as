package com.jordan.cp.view.email 
{
	import com.greensock.TweenLite;
	import com.jasontighe.containers.DisplayContainer;
	import com.plode.framework.containers.TextContainer;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jsuntai
	 */
	public class KitAnimation 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// private static constants
		//----------------------------------------------------------------------------
		private static const TIMER_DELAY 					: uint = 100;
		private static const BOX_COUNT 						: Number = 4;
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _t 										: Timer;
		private var _cnt 									: Number = 0;
		private var _boxes 									: Array;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var box0 									: MovieClip;
		public var box1 									: MovieClip;
		public var box2 									: MovieClip;
		public var box3 									: MovieClip;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function KitAnimation() 
		{
			super();
			_boxes = new Array( box0, box1, box2, box3 );
			hide();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}

		public function transitionIn( ) : void
		{
			show( .4 );
			startAnimation();
		}

		public function transitionOut( ) : void
		{
			hide( );
			stopAnimation();
		}
		
		//----------------------------------------------------------------------------
		// private methods
		//----------------------------------------------------------------------------
		private function startAnimation() : void 
		{
			dimBoxes();
			startTimer();
		}

		private function stopAnimation() : void 
		{
			dimBoxes();
			stopTimer();
		}

		private function dimBoxes() : void 
		{
			for(var i : uint = 0; i < BOX_COUNT; i++)
			{
				var box : MovieClip = _boxes[ i ];
				box.alpha = .3;
				box.width = 4;
				box.height = 4;
			}
		}
		
		private function animate() : void 
		{
			var dur : Number = .3;
			
			for(var i : uint = 0; i < BOX_COUNT; i++)
			{
				var box : MovieClip = _boxes[ i ];

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

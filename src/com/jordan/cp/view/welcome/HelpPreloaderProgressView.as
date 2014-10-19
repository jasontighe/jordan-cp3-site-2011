package com.jordan.cp.view.welcome 
{	import com.greensock.TweenLite;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.containers.TextContainer;
	
	import flash.display.Sprite;	

	/**	 * @author ns	 */	public class HelpPreloaderProgressView extends AbstractDisplayContainer 
	{
		private var _holder : Sprite;
		private var _current : TextContainer;
		private var _total : TextContainer;
		private static const MARGIN_X : uint = 3;
		private static const STYLE : String = 'loader-counter';
		private var _ind : uint;
		private var _max : uint;

		public function HelpPreloaderProgressView()
		{
			setup();
		}
		
		override public function setup() : void
		{
			_holder = new Sprite();
			addChild(_holder);
			
			_current = new TextContainer();
			_current.populate('1', STYLE);
			TweenLite.to(_current, 0, {tint: 0xffffff});
			
			_total = new TextContainer();
			_total.populate('/3', STYLE);
			_total.x = _current.tf.textWidth + MARGIN_X;
			
			_holder.addChild(_current);
			_holder.addChild(_total);
		}
		
		public function populate(len : uint) : void
		{
			_max = len;
			_total.update('/' + (_max).toString());
			
			// CENTER
			_holder.x = -Math.round(_holder.width/2);
		}

		public function set index(val : uint) : void
		{
			_ind = val + 1;
			TweenLite.to(_current, .4, {alpha:0, onComplete:update});
		}
		
		private function update() : void
		{
			_current.update(_ind.toString());
			TweenLite.to(_current, .4, {alpha:1});
		}
		
	}}
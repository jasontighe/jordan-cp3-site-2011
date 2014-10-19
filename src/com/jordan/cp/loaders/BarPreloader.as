package com.jordan.cp.loaders {
	import com.greensock.TweenLite;
	import com.jasontighe.util.Box;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class BarPreloader 
	extends AbstractPreloader 
	{
		protected static const DEFAULT_WIDTH			 : uint = 100;
		protected static const DEFAULT_HEIGHT			 : uint = 10;
		
		protected var _gutterColor						: uint = 0xFF0032;
		protected var _barColor							: uint = 0x00CCFF;
		
		public var _gutter								: Box;
		public var _bar									: Box;
		
		public function BarPreloader() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// interface
		//----------------------------------------------------------------------------
		override public function init() : void
		{
//			hide();
			
			_gutter = new Box( _w, _h, _gutterColor );
			_bar = new Box( _w, _h, _barColor );
			
			_bar.scaleX = 0;
			
			addChild( _gutter );
			addChild( _bar );
		}
		
		override public function transitionIn() : void
		{
			show( .5 );
		}
		
		override public function transitionOut() : void
		{
			TweenLite.to( this, .25, { alpha: 0, onComplete: transitionOutComplete } );
		}
		
		//----------------------------------------------------------------------------
		// protected functions
		//----------------------------------------------------------------------------
		override protected function updateDisplay() : void
		{
			_bar.scaleX = _showPercent;
		}
		
		override protected function doLoadComplete() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
			_bar.scaleX = 1;
			reset();
		}
		
		override protected function transitionOutComplete() : void
		{
			remove();
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set gutterColor( n : uint ) : void
		{
			_gutterColor = n;
		}
		
		public function set barColor( n : uint ) : void
		{
			_barColor = n;
		}
	}
}

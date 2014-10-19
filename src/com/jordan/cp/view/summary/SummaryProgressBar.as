package com.jordan.cp.view.summary {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.view.locks.Lock;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryProgressBar 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		//TODO TEMP, PULL FROM content.xml
		protected static var PERCENTAGE_TIME			: Number = 6;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _percent							: Number;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var closed								: Lock;
		public var open									: Lock;
		public var barMask								: Box;
		public var bar									: MovieClip;
		public var gutter								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryProgressBar() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			barMask = new Box( bar.width, bar.height );
			barMask.x = bar.x;
			barMask.y = bar.y;
			addChild( barMask );
			bar.mask = barMask;
			barMask.width = 0;
		}

		public function showProgress( percent : Number ) : void
		{
			trace( "\n\n");
			trace( "SUMMARYPROGRESSBAR : showProgress() : percent is "+percent );
			barMask.width = 0;
			var maskWidth : Number = bar.width * percent;
			TweenLite.to( barMask, PERCENTAGE_TIME, { width: maskWidth, ease: Quint.easeOut, onComplete: showProgressComplete } )
			
			open.openLock();
		}
		
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function maskBar() : void
		{
			barMask = new Box( bar.width, bar.height );
			addChild( barMask );
			bar.mask = barMask;
			barMask.width = 0;
		}
		
		protected function showProgressComplete( ) : void
		{
//			trace( "SUMMARYPROGRESSBAR : setPercent()" );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function getPercentage( ) : Number
		{
//			trace( "SUMMARYPERCENTAGESCREEN : getPercentage " );
			return barMask.width / bar.width;
		}
	}
}

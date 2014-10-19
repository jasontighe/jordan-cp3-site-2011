package com.jordan.cp.loaders {
	import com.jasontighe.containers.DisplayContainer;

	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author jsuntai
	 */
	public class AbstractPreloader 
	extends DisplayContainer 
	{
		protected var _displayPercent				: Number = 0;
		protected var _showPercent					: Number = 0;
		protected var _autoPercent					: Number = 0;
		protected var _throttlePercent				: Number = .0032;
		
		protected var _isThrottled					: Boolean = false;
		protected var _auto							: Boolean = false;
		
		public function AbstractPreloader() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// interface
		//----------------------------------------------------------------------------
		public function transitionIn() : void
		{
		}
		
		public function transitionOut() : void
		{
		}
		
		public function update( n : Number ) : void
		{
			if( isNaN( n ) ) return;
			
			_displayPercent += _throttlePercent;
			var actualPercent : Number = n;
			
			if( isThrottled )
			{
           		_showPercent = Math.min( actualPercent, _displayPercent);
			}
			else
			{
           		_showPercent = actualPercent;
			}
//            trace( "ABSTRACTPRELOADER : update : _isThrottled is " + _isThrottled );
//            trace( "ABSTRACTPRELOADER : update : _displayPercent is " + _displayPercent );
//            trace( "ABSTRACTPRELOADER : update : actualPercent is " + actualPercent );
//            trace( "ABSTRACTPRELOADER : update : _showPercent is " + _showPercent + "\n" );

			
			if( _showPercent < 1 )
			{
				updateDisplay();
			}
			else
			{
				doLoadComplete();
			}
		}
		
		public function autoUpdate( delay : Number = 0 ) : void
		{
			trace( "ABSTRACTPRELOADER : autoUpdate()" );
			_auto = true;
			var time : uint = delay * 1000;
			var to : Number = setTimeout( startAutoEnterFrame, time )
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function transitionInComplete() : void
		{
		}
		
		protected function transitionOutComplete() : void
		{
		}
		
		protected function updateDisplay() : void
		{
		}
		
		protected function startAutoEnterFrame() : void
		{
			addEventListener( Event.ENTER_FRAME, onAutoEnterFrame );
		}
		
		protected function doLoadComplete() : void
		{
			trace( "ABSTRACTPRELOADER : doLoadComplete()" );
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
			if( _auto )	removeEventListener( Event.ENTER_FRAME, onAutoEnterFrame );
			
			reset();
		}
		
		protected function reset() : void
		{
			_displayPercent	= 0;
			_showPercent = 0;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onAutoEnterFrame( e : Event ) : void
		{
			_autoPercent += 1;
			update( _autoPercent );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get isThrottled( ) : Boolean
		{
			return _isThrottled;
		}
		
		public function set isThrottled( b : Boolean ) : void
		{
			_isThrottled = b;
		}
		
		public function set throttlePercent( n : Number ) : void
		{
			_throttlePercent = n;
		}
		public function get showPercent( ) : Number
		{
			return _showPercent;
		}
	}
}

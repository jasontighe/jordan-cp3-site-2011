package com.plode.framework.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AbstractSlideshowModel extends EventDispatcher
	{
		protected var _items : Array;
		protected var _currentIndex : uint;
		protected var _nextIndex : uint;
		protected var _pol : int;

		public function AbstractSlideshowModel()
		{
			super();
		}

		public function parseXml(xml : XML) : void
		{
			trace('AbstractSlideshowModel.parseXml : NEED TO OVERRIDE');
		}
		
		public function dispose() : void
		{
			if(_items) _items.splice( 0 );
		}
		
		public function updateIndex() : void
		{
			currentIndex = nextIndex;
		}
		
	
		//------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//------------------------------------------------------------------------
		public function get items() : Array
		{
			return _items;
		}
		
		public function get currentIndex() : uint
		{
			return _currentIndex;
		}
		
		public function set currentIndex( val : uint) : void
		{
			_currentIndex = val;
		}
	
		public function set nextIndex( val : uint) : void
		{
			_nextIndex = val;
			dispatchEvent(new Event(Event.CHANGE));
		}
	
		public function get nextIndex( ) : uint
		{
			return _nextIndex;
		}
	
	
	
	}
}
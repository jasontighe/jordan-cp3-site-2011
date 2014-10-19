package com.plode.framework.layout
{
	import com.plode.framework.containers.AbstractDisplayContainer;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class GridLayout extends AbstractDisplayContainer
	{
		private var _len : int;
		private var _rowLen : uint;
		private var _columnLen : uint;
		private var _marV : int;
		private var _marH : int;
		private var _itemW : int;
		private var _itemH : int;
		
		// TODO - ADD ORIENTATION
		
		
		public function GridLayout(len : uint = 0, 
								   itemW : uint = 0, 
								   itemH : uint = 0,
								   marV : int = 0, 
								   marH : int = 0, 
								   rowLen : uint = 0, 
								   columnLen : uint = 0)
		{
			_len = len;
			_itemW = itemW;
			_itemH = itemH;
			_marV = marV;
			_marH = marH;
			_rowLen = rowLen;
			_columnLen = columnLen;
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function position(i : uint) : Point
		{
			var pnt : Point = new Point();
			
			// LEFT TO RIGHT REPEATING
			pnt.x = (i % _rowLen) * (_itemW + _marH);
			pnt.y = Math.floor(i / _rowLen) * (_itemH + _marV);
			
			return pnt;
		}
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
	}
}
package com.jordan.cp.model.dto 
{

	/**
	 * @author nelson.shin
	 * 
	 * - holds hotspot x, y, w, h per frame of active content
	 * - converts relative values from source video dimensions
	 * 
	 * 
	 */
	public class HotspotDTO 
	{
		public var start : Number;
		private var _w : Number;
		private var _h : Number;
		private var _x : Number;
		private var _y : Number;

		public static const W : Number = 1600;
		public static const H : Number = 800;
		public static const SHAPE_DEFAULT_SIZE : Number = 50;
		

		public function populate(contents : *) : void 
		{
//			trace("HotspotDTO.populate(contents): ", contents.@type.toString() );
		}

		public function preview() : void
		{
			trace('----------------------------------------------------------');
			trace('start', start);
			trace('w', w);
			trace('h', h);
			trace('x', x);
			trace('y', y);
			trace('----------------------------------------------------------');
		}
		

		//-------------------------------------------------------------------------
		//
		// MAKE RELATIVE FROM CENTER OF SOURCE FOOTAGE USED TO GENERATE XML
		// 1024x512
		//
		//-------------------------------------------------------------------------
		public function get x() : Number
		{
			return _x;
		}
		
		public function set x(val : Number) : void
		{
			// DISTANCE FROM CENTER
			_x = (val - W/2);
		}

		public function get y() : Number
		{
			return _y;
		}
		
		public function set y(val : Number) : void
		{
			_y = (val - H/2);
		}
		
		public function get w() : Number
		{
			return _w;
		}
		
		public function set w(val : Number) : void
		{
			_w = val * .01 * SHAPE_DEFAULT_SIZE;
		}

		public function get h() : Number
		{
			return _h;
		}
		
		public function set h(val : Number) : void
		{
			_h = val * .01 * SHAPE_DEFAULT_SIZE;
		}

	}
}

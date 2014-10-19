package com.jordan.cp.model.dto {

	/**
	 * @author jsuntai
	 */
	public class SubNavDTO 
	implements IDTO 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _title 							: String;
		protected var _titleX 							: int;
		protected var _titleY 							: int;
		protected var _subNav							: Array = new Array();
		//----------------------------------------------------------------------------
		// contructor
		//----------------------------------------------------------------------------
		public function SubNavDTO( data : * )
		{
			var data : Object = Object(data);
			
			if ( data )				_title = String( data );
			if ( data.@x )			_titleX = data.@x;
			if ( data.@y )			_titleY = data.@y;
			
//			trace("\n");
//			trace("SUBNAVDTO : _title is " + _title );
//			trace("SUBNAVDTO : _titleX is " + _titleX );
//			trace("SUBNAVDTO : _titleY is " + _titleY );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id() : uint 
		{
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function get name() : String 
		{
			// TODO: Auto-generated method stub
			return null;
		}
	}
}

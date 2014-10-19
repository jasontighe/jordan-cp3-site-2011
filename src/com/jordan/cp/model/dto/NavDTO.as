package com.jordan.cp.model.dto {

	/**
	 * @author jsuntai
	 */
	public class NavDTO 
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
		public function NavDTO( data : * )
		{
			var data : Object = Object(data);
			
			if ( data.@title )		_title = data.@title;
			if ( data.@x )			_titleX = data.@x;
			if ( data.@y )			_titleY = data.@y;
			
//			trace("\n");
//			trace("NAVDTO : _title is " + _title );
//			trace("NAVDTO : _titleX is " + _titleX );
//			trace("NAVDTO : _titleY is " + _titleY );
			
//			SECTION DTOS
			var subNavs : XMLList = data.subnav.*;
			var i : uint = 0
			var I : uint = subNavs.length();
			
			for( i; i < I; i++ )
			{
				_subNav.push( new SubNavDTO( XMLList( subNavs[ i ] ) ) );
			}
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

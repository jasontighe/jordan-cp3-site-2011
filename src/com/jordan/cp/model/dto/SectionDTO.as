package com.jordan.cp.model.dto {

	/**
	 * @author jsuntai
	 */
	public class SectionDTO 
	implements IDTO 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _name 							: String;
		protected var _title 							: String;
		protected var _header 							: String;
		protected var _desc 							: String;
		protected var _titleX 							: int;
		protected var _titleY 							: int;
		protected var _headerX 							: int;
		protected var _headerY 							: int;
		protected var _descX 							: int;
		protected var _descY 							: int;
		protected var _copies							: Array = new Array();
		protected var _navs								: Array = new Array();
		//----------------------------------------------------------------------------
		// contructor
		//----------------------------------------------------------------------------
		public function SectionDTO( data : * )
		{
			var data : Object = Object( data);
			
//			SECTION DTOS
//			var copies : XMLList = data.copies.*;
//			var i : uint = 0
//			var I : uint = copies.length();
//			for( i; i < I; i++ )
//			{
//				_copies.push( new SectionDTO( copies[ i ] ) );
//			}
			
			if ( data.@name )		_name = data.@name;
			if ( data.title )		_title = data.title;
			if ( data.header )		_header = data.header;
			if ( data.desc )		_desc = data.desc;
			if ( data.title.@x )	_titleX = data.title.@x;
			if ( data.title.@y )	_titleY = data.title.@y;
			if ( data.header.@x )	_headerX = data.header.@x;
			if ( data.header.@y )	_headerY = data.header.@y;
			if ( data.desc.@x )		_descX = data.desc.@x;
			if ( data.desc.@y )		_descY = data.desc.@y;
			
			trace("\n");
			trace("SECTIONDTO : Constr");
			trace("SECTIONDTO : _name is " + _name );
			trace("SECTIONDTO : _title is " + _title );
			trace("SECTIONDTO : _header is " + _header );
			trace("SECTIONDTO : _desc is " + _desc );
			trace("SECTIONDTO : _titleX is " + _titleX );
			trace("SECTIONDTO : _titleY is " + _titleY );
			trace("SECTIONDTO : _headerX is " + _headerX );
			trace("SECTIONDTO : _headerY is " + _headerY );
			trace("SECTIONDTO : _descX is " + _descX );
			trace("SECTIONDTO : _descY is " + _descY );
			
//			NAV DTOS
			var navs : XMLList = XMLList( data.navs.* );
			var i : uint = 0
			var I : uint = navs.length();
			
			for( i; i < I; i++ )
			{
				_navs.push( new NavDTO( navs[ i ] ) );
			}
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id() : uint 
		{
			return 0;
		}
		
		public function get name() : String 
		{
			return _name;
		}
		
		public function get title() : String 
		{
			return _title;
		}
		
		public function get header() : String 
		{
			return _header;
		}
		
		public function get desc() : String 
		{
			return _desc;
		}
	}
}

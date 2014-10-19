package com.jordan.cp.model.dto {

	/**
	 * @author jsuntai
	 */
	public class CopyDTO 
	implements IDTO 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _name 							: String;
		protected var _copy 							: String;
		protected var _copyX 							: int;
		protected var _copyY 							: int;
		protected var _copies							: Array = new Array();
		protected var _navs								: Array = new Array();
		//----------------------------------------------------------------------------
		// contructor
		//----------------------------------------------------------------------------
		public function CopyDTO( data : * )
		{
			var data : Object = Object( data);
			
//			Copy DTOS
//			var copies : XMLList = data.copies.*;
//			var i : uint = 0
//			var I : uint = copies.length();
//			for( i; i < I; i++ )
//			{
//				_copies.push( new SectionDTO( copies[ i ] ) );
//			}
			
			if ( data.@name )		_name = data.@name;
			if ( data )				_copy = String( data );
			if ( data.@x )			_copyX = data.@x;
			if ( data.@y )			_copyY = data.@y;
			
//			trace("\n");
//			trace("COPYDTO : Constr : X");
//			trace("COPYDTO : _name is " + _name );
//			trace("COPYDTO : _copy is " + _copy );
//			trace("COPYDTO : _copyX is " + _copyX );
//			trace("COPYDTO : _copyY is " + _copyY );
			
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
		
		public function get copy() : String 
		{
			return _copy;
		}
		
		public function get copyX() : uint 
		{
			return _copyX;
		}
		
		public function get copyY() : uint 
		{
			return _copyY;
		}
	}
}

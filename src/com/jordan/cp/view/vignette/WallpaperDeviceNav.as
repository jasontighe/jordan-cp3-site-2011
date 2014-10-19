package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.INavItem;
	import com.jasontighe.navigations.Nav;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperDeviceNav 
	extends DisplayContainer 
	{
		protected static var DEVICE_NAV_X_SPACE				: uint = 26;
		protected var _id									: uint;
		protected var _name									: String;
		public var nav										: Nav;
//		public var deviceArray								: Array;
		
		public function WallpaperDeviceNav() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( array : Array ) : void
		{
			trace( "WALLPAPERDEVICENAV : addNav()" );
			nav = new Nav();
			
			var item : WallpaperDeviceNavItem;
			var last : WallpaperDeviceNavItem;
			var i : uint = 0;
			var I : uint = array.length;
			var lastItem : uint = I - 1;
			
			var xSpace : uint = 0;
			
			for( i; i < I; i++)
			{	
				item = new WallpaperDeviceNavItem();
				item.setIndex( i );
				
				var name : String = array[ i ].toUpperCase() as String;
				item.addViews( name );
				item.setOutEventHandler( onDeviceNavItemOut );
				item.setOverEventHandler( onDeviceNavItemOver );
				item.setClickEventHandler( onDeviceNavItemClick );
				
				item.x = xSpace;
				item.y = 0;
				
				xSpace += item.width + DEVICE_NAV_X_SPACE;
				
				item.setOutState();
				nav.add( item );
				nav.addChild( item );
			}
			
			nav.init();
			addChild( nav );
		}
		
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function activateNav( id : uint ) : void
		{
			var item : INavItem = nav.getItemAt( id );
			nav.setActiveItem( item );
			item.setActiveState();
			
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onDeviceNavItemOut( e : Event ) : void
		{
			var item : WallpaperDeviceNavItem = e.target as WallpaperDeviceNavItem; 
			item.setOutState();
		}
		
		protected function onDeviceNavItemOver( e : Event ) : void
		{
			var item : WallpaperDeviceNavItem = e.target as WallpaperDeviceNavItem; 
			item.setOverState();
		}
		
		protected function onDeviceNavItemClick( e : Event ) : void
		{
			var item : WallpaperDeviceNavItem = e.target as WallpaperDeviceNavItem; 
			_id = item.getIndex();
			nav.setActiveItem( item );
			item.setActiveState();
			trace("WALLPAPER : onDeviceNavItemClick() : _id is "+_id );
			dispatchCompleteEvent();
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}
		
		public override function get name( ) : String
		{
			return _name;
		}
	}
}

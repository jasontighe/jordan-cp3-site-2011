package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.MediaDTO;
	import com.jordan.cp.model.dto.CopyDTO;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperThumbNav 
	extends DisplayContainer 
	{
		protected static var DEVICE_NAV_Y_SPACE				: uint = 98;
		protected var navArray								: Array = new Array();
		protected var _id									: uint;
		protected var _name									: String;
		public var _nav										: Nav;
//		public var deviceArray								: Array;
		
		public function WallpaperThumbNav() 
		{
			super();
//			deviceArray = new Array( "DESKTOP", "IPHONE", "IPAD", "TWITTER" );
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( array : Array ) : void
		{
			_nav = new Nav();
			navArray = array;
//			var dto : ContentDTO;
			var item : WallpaperThumbNavItem;
			var last : WallpaperThumbNavItem;
			var i : uint = 0;
			var I : uint = array.length;
			var lastItem : uint = I - 1;
			
			var ySpace : uint = 0;
			
			for( i; i < I; i++)
			{	
				item = new WallpaperThumbNavItem();
				item.setIndex( i );
				
				var id : String = "wallpaper-thumb"
				var extraDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
				var thumbExtra : String = extraDTO.copy;
				
				var name : String = ".0" + ( i + 1 ) +" "+ thumbExtra as String;
				var dto : MediaDTO = array[ i ] as MediaDTO;
//				trace( "WALLPAPERTHUMBNAV : addNav() : dto is "+dto );
				var thumbURL : String = dto.thumbURL;
				var imageURL : String = dto.imageURL;
//				trace( "WALLPAPERTHUMBNAV : addNav() : name is "+name );
//				trace( "WALLPAPERTHUMBNAV : addNav() : thumbURL is "+thumbURL );
//				trace( "WALLPAPERTHUMBNAV : addNav() : imageURL is "+imageURL );
				item.thumbURL = thumbURL;
				item.addViews( name );
//				trace( "\n\n" );
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				item.x = 0;
				item.y = ySpace;
				
				ySpace += DEVICE_NAV_Y_SPACE;
				
				item.setOutState();
//				item.disable();
				_nav.add( item );
				_nav.addChild( item );
			}
			
			_nav.init();
			_nav.enable();
			addChild( _nav );
			
			preselectNav( 0 );
		}
		
		protected function preselectNav( id : uint ) : void
		{
			var item : WallpaperThumbNavItem = _nav.getItemAt( id ) as WallpaperThumbNavItem;
			_nav.setActiveIndex( id );
		}
		
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : WallpaperThumbNavItem = e.target as WallpaperThumbNavItem; 
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : WallpaperThumbNavItem = e.target as WallpaperThumbNavItem; 
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : WallpaperThumbNavItem = e.target as WallpaperThumbNavItem; 
			
			_id = item.getIndex();
			_nav.setActiveItem( item );
			item.setActiveState( _id );
			var dto : MediaDTO = navArray[ _id ] as MediaDTO;
			_name = dto.name;
			
//			trace("WALLPAPERTHUMBNAV : onNavItemClick() : _name is "+_name );
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
		
		public function get nav( ) : Nav
		{
			return _nav;
		}
	}
}

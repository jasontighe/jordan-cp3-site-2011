package com.jordan.cp.view.summary {
	import com.jordan.cp.constants.SiteConstants;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.INavItem;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryContentNav 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var CONTENT_NAV_X_SPACE			: uint = 97;
//		protected static var CONTENT_NAV_Y_SPACE			: uint = 116;
//		protected static var CONTENT_NAV_ROWS				: uint = 2;
//		protected static var CONTENT_NAV_COL				: uint = 7;
		protected static var ITEM_ALPHA						: Number = .3;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id									: uint;
		protected var _navTotal								: uint = 0;
		protected var _contentModel							: ContentModel;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var leftHolder								: MovieClip;
		public var rightHolder								: MovieClip;
		public var nav										: Nav;
		public var _shiftX									: uint;
		
		public function SummaryContentNav() 
		{
			super();
			
			_contentModel = ContentModel.gi;
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( ) : void
		{
			leftHolder = new MovieClip();
//			addChild( leftHolder );
			 
			rightHolder = new MovieClip();
//			addChild( rightHolder );
			rightHolder.x = 300;


			nav = new Nav();
			
//			TODO Figure out best way to address easter eggs without putting them on the xml
			var total : uint = _contentModel.content.length + _contentModel.eggs.length;
			_navTotal = _contentModel.content.length + _contentModel.eggs.length;
			
//		 	var totalRows : uint =  CONTENT_NAV_ROWS;
//		 	var totalColumns : uint = Math.ceil( total / totalRows );
		 	
			var dto : ContentDTO;
			var item : SummaryContentNavItem;
			var last : SummaryContentNavItem;
			var i : uint = 0;
			var I : uint = total;
			var lastItem : uint = I - 1;
			var contentTotal : uint = _contentModel.content.length;
			var half : uint = Math.floor( total * .5 );
			var isUnlocked : Boolean;
			var icon : String;
			
//			trace( "SUMMARYCONTENTNAV : addNav() contentTotal is "+contentTotal );
				
			for( i; i < I; i++)
			{
//				trace( "\n" );
				var xPos : Number = i * CONTENT_NAV_X_SPACE;
				var yPos : Number = 0; 
				
				if( i == half)	_shiftX = xPos;
				
				item = new SummaryContentNavItem();
				item.setIndex( i );
				
					
				if( i < contentTotal )
				{
					dto = _contentModel.getContentItemAt( i ) as ContentDTO;
					isUnlocked = _contentModel.isUnlockedContent( i );
				}
				else
				{
					var eggId : uint = i - contentTotal
					dto = _contentModel.getEggItemAt( eggId ) as ContentDTO;
					
					isUnlocked = _contentModel.isUnlockedEgg( eggId );
//					trace( "SUMMARYCONTENTNAV : addNav() eggId is "+eggId+" : isUnlocked is "+isUnlocked );
//					trace( "SUMMARYCONTENTNAV : addNav() model.unlockedEggs.length "+_contentModel.unlockedEggs.length );
				}
				
				icon = dto.icon;
				item.iconType = icon;
				item.isUnlocked = isUnlocked;
				item.addCopy(dto);
				
				
				
//				trace( "SUMMARYCONTENTNAV : addNav() i is "+i+" : isUnlocked is "+isUnlocked );
//				trace( "SUMMARYCONTENTNAV : addNav() i is "+i+" : isUnlocked is "+isUnlocked );
//				trace( "SUMMARYCONTENTNAV : addNav() i is "+i+" : dto.icon is "+dto.icon );
//				trace( "SUMMARYCONTENTNAV : addNav() i is "+i+" : dto.category is "+dto.category );
					
				if( dto.name == SiteConstants.EGG_GREEN && isUnlocked )
				{
					item.disable();
					item.alpha = 1;	
				}
				else if( !isUnlocked )
				{
					item.disable();
					item.alpha = ITEM_ALPHA;
				}
				else if( isUnlocked && dto.category != SiteConstants.HOTSPOT_CATEGORY_FACTOID )
				{
					item.enable();
				}
				else if( dto.category == SiteConstants.HOTSPOT_CATEGORY_FACTOID )
				{
					item.disable();
					item.alpha = 1;
				}
				else
				{
					item.disable();
					item.alpha = ITEM_ALPHA;
				}
				
				
				item.addViews();
		 		item.x = xPos;
		 		item.y = yPos;

				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				nav.add( item );
				
				rightHolder.alpha = 0;
				nav.addChild( item );
			}
			
			nav.init();
			addChild( nav );
		}
		
		public function enableNavItem( id : uint ) : void
		{
			var item : INavItem = nav.getItemAt( id );
			item.enable();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : SummaryContentNavItem = e.target as SummaryContentNavItem; 
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : SummaryContentNavItem = e.target as SummaryContentNavItem; 
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : SummaryContentNavItem = e.target as SummaryContentNavItem; 
			_id = item.getIndex();
//			nav.setActiveItem( item );
//			item.setActiveState();
//			trace("SUMMARYCONTENTNAV : onNavItemClick() : _id is "+_id );
			dispatchCompleteEvent();
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}

		public function get shiftX( ) : uint
		{
			return _shiftX;
		}
//		public function set contentModel( object : ContentModel ) : void
//		{
//			trace( "SUMMARYCONTENTNAV : set contentModel : object is "+object );
//			_contentModel = object;
//		}
	}
}

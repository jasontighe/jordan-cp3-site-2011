package com.jordan.cp.view.summary {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.INavItem;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.containers.TextContainer;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryScrollerNav 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var SCROLL							: String = "Scroll";
		protected static var NAV_ITEM_X_SPACE				: uint = 75;
		protected static var NAV_ITEM_Y						: uint = 147;
		protected static var DIVIDER_WIDTH					: uint = 1;
		protected static var DIVIDER_HEIGHT					: uint = 29;
		protected static var DIVIDER_COLOR					: uint = 0x393939;
		protected static var DIVIDER_X						: uint = 62;
		protected static var DIVIDER_Y						: uint = 138;
		protected var _id									: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var scrollTxt								: TextContainer;
		public var nav										: Nav;
		public var divider									: Box;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryScrollerNav() 
		{
			trace( "\n\n\n" );
			trace( "SUMMARYSCROLLERNAV : Constr" );
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( n : uint ) : void
		{
			trace( "SUMMARYSCROLLERNAV : addNav : n is "+n );
			nav = new Nav();
			
			var dto : ContentDTO;
			var item : SummaryScrollerNavItem;
			var last : SummaryScrollerNavItem;
			var i : uint = 0;
			var I : uint = n;
			
			for( i; i < I; i++)
			{
				item = new SummaryScrollerNavItem();
				item.setIndex( i );
				var pageNum : uint = i + 1;
				item.addViews( String( "PAGE " + pageNum ) );
		 		item.x = i * NAV_ITEM_X_SPACE;
		 		item.y = NAV_ITEM_Y;

				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				nav.add( item );
				nav.addChild( item );
				
				if( i == 0 ) 
				{
					nav.setActiveItem( item );
					item.setActiveState();
				}
			}
			
			nav.init();
			addChild( nav );
			
			addDivider();
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
		
		protected function addDivider() : void
		{
			divider = new Box( DIVIDER_WIDTH, DIVIDER_HEIGHT, DIVIDER_COLOR );
			divider.x = DIVIDER_X;
			divider.y = DIVIDER_Y;
			addChild( divider );
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : SummaryScrollerNavItem = e.target as SummaryScrollerNavItem; 
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : SummaryScrollerNavItem = e.target as SummaryScrollerNavItem; 
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : SummaryScrollerNavItem = e.target as SummaryScrollerNavItem; 
			_id = item.getIndex();
			nav.setActiveItem( item );
			item.setActiveState();
			dispatchCompleteEvent();
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}
	}
}
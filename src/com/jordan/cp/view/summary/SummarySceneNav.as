package com.jordan.cp.view.summary {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummarySceneNav 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var SCENE_NAV_X_SPACE				: uint = 194;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id									: uint;
//		protected var _contentModel							: ContentModel;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var nav										: Nav;
		
		public function SummarySceneNav() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( model : ContentModel ) : void
		{
//			trace( "SUMMARYSCENENAV : addNav()" );
			nav = new Nav();
			
			var dto : ContentDTO;
			var item : SummarySceneNavItem;
			var last : SummarySceneNavItem;
			var i : uint = 0;
			var I : uint = model.scenes.length;
			var lastItem : uint = I - 1;
			
			for( i; i < I; i++)
			{	
				dto = model.getSceneItemAt( i ) as ContentDTO;
				item = new SummarySceneNavItem();
				item.setIndex( i );
				
				item.addViews();
				var thumbURL : String = dto.thumbURL;
				item.addImage( thumbURL );
				var name : String = model.getSceneItemAt( i ).name;
				var isUnlockedScene : Boolean = model.isUnlockedScene( i );
				item.isUnlocked = isUnlockedScene;
				
//				item.init();
				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				
				if( isUnlockedScene )
				{
					item.enable();
				}
				else
				{
					item.disable();
//					item.resetInactive();
				}
				
				
//				trace( "SUMMARYSCENENAV : addScenesNav() : name is "+name );
//				trace( "SUMMARYSCENENAV : addScenesNav() : isUnlockedScene is "+isUnlockedScene );
				item.x = i * SCENE_NAV_X_SPACE ;
				item.y = 0;
				
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
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : SummarySceneNavItem = e.target as SummarySceneNavItem; 
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : SummarySceneNavItem = e.target as SummarySceneNavItem; 
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : SummarySceneNavItem = e.target as SummarySceneNavItem; 
			_id = item.getIndex();
//			nav.setActiveItem( item );
//			item.setActiveState();
//			trace("SUMMARYSCENENAV : onNavItemClick() : _id is "+_id );
			dispatchCompleteEvent();
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}

//		public function set contentModel( object : ContentModel ) : void
//		{
//			trace( "SUMMARYCONTENTNAV : set contentModel : object is "+object );
//			_contentModel = object;
//		}
	}
}

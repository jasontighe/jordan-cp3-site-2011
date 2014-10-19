package com.jordan.cp.view.menu_lower {
	import flash.events.MouseEvent;
	import com.jordan.cp.view.AbstractNav;

	/**
	 * @author jason.tighe
	 */
	public class SocialNav 
	extends AbstractNav 
	{
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var fbLike									: FBLike;
		public var plusOne									: PlusOne;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SocialNav() 
		{
			trace( "SOCIALNAV : Constr" );
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "SOCIALNAV : init()" );
		}
		
		public override function activate() : void
		{
			trace( "SOCIALNAV : activate()" );
			activateItem( fbLike );
			fbLike.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			fbLike.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			fbLike.addEventListener( MouseEvent.CLICK, onClick );
			
			activateItem( plusOne );
			plusOne.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			plusOne.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			plusOne.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		public override function deactivate() : void
		{
			trace( "SOCIALNAV : deactivate()" );
			deactivateItem( fbLike );
			fbLike.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			fbLike.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			fbLike.removeEventListener( MouseEvent.CLICK, onClick );
			
			deactivateItem( plusOne );
			plusOne.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			plusOne.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			plusOne.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function activateItem( item : * ) : void
		{
			item.mouseEnabled = true;
			item.mouseChildren = false;
			item.buttonMode = true;
			item.useHandCursor = true;
		}
		
		protected function deactivateItem( item : * ) : void
		{
			item.mouseEnabled = false;
			item.mouseChildren = false;
			item.buttonMode = false;
			item.useHandCursor = false;
		}
		
		protected function onMouseOver( e : MouseEvent = null ) : void
		{
			var item : * = e.target;
//			trace( "SOCIALNAV : onMouseOver() : item is "+item );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void
		{
			var item : * = e.target;
//			trace( "SOCIALNAV : onMouseOut() : item is "+item );
		}
		
		protected function onClick( e : MouseEvent = null ) : void
		{
			var item : * = e.target;
			trace( "SOCIALNAV : onClick() : item is "+item );
		}
		
	}
}

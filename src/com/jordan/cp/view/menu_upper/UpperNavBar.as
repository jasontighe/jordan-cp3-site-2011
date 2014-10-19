package com.jordan.cp.view.menu_upper {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ConfigModel;
	import com.jordan.cp.view.AbstractOverlay;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author jason.tighe
	 */
	public class UpperNavBar 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const JORDAN_X_SPACE			: uint = 26;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var header								: MovieClip;
		public var logo									: LogoJordan;
		public var background							: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function UpperNavBar() 
		{
			trace( "UPPERNAVBAR : Constr" );
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			hide();
		}
		
		public override function updateViews( stageW : uint, stageH : uint ) : void
		{
			setWidth( stageW );
			updateBackground();
			updateJordan();
		}
		
		public override function transitionIn() : void
		{
			trace( "UPPERNAVBAR : transitionIn()" );
			show();
			TweenLite.from( this, SiteConstants.NAVBAR_TIME_IN, { y: -height, ease: Quad.easeOut, onComplete: transitionInComplete } );
		}
		
		public override function transitionOut() : void
		{
			
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function updateBackground() : void
		{
			var w : uint = getWidth();
			background.width = w;
		}
		
		protected function updateJordan() : void
		{
			var w : uint = getWidth();
			var logoX : uint = w - logo.width - JORDAN_X_SPACE;
			logo.x = logoX;
		}
		
		protected override function transitionInComplete() : void
		{
			trace( "UPPERNAVBAR : transitionInComplete()" );
			dispatchEvent( new ContainerEvent( ContainerEvent.SHOW ) );
			activate();
		}
		
		protected function activate() : void
		{
			trace( "UPPERNAVBAR : activate()" );
			activateItem( header );
			header.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			header.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			header.addEventListener( MouseEvent.CLICK, onClick );
			
			activateItem( logo );
			logo.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			logo.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			logo.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		public function deactivate() : void
		{
			trace( "UPPERNAVBAR : deactivate()" );
			deactivateItem( header );
			header.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			header.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			header.removeEventListener( MouseEvent.CLICK, onClick );
			
			deactivateItem( logo );
			logo.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			logo.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			logo.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
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
//			trace( "UPPERNAVBAR : onMouseOver() : item is "+item );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void
		{
			var item : * = e.target;
//			trace( "UPPERNAVBAR : onMouseOut() : item is "+item );
		}
		
		protected function onClick( e : MouseEvent = null ) : void
		{
			var url : String;
			
			var item : * = e.target;
			if( item == header )
			{
				TrackingManager.gi.trackCustom(TrackingConstants.CPV_BUTTON_CLICKED );
				url = ConfigModel.gi.chaosURL;
			}
			else
			{
				url = ConfigModel.gi.jumpmanURL;
			}
			
			var request : URLRequest = new URLRequest( url );
			navigateToURL( request, "_self");
			trace( "UPPERNAVBAR : onClick() : item is "+item+" :  url is "+url );
		}
	}
}

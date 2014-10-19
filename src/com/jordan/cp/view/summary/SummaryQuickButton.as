package com.jordan.cp.view.summary {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class SummaryQuickButton 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var ICON_X							: uint = 0;
		protected static var ICON_Y							: uint = 1;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var copyTxt									: AutoTextContainer;
		public var icon										: MovieClip;
		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryQuickButton() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}
		
		public function addViews() : void
		{
			addBackground();
			addIcon();
			addCopy();
			resizeBackground();
		}
		
		
		public function activate() : void
		{
			trace( "SUMMARYQUICKBUTTON : activate()" );
			 addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			 addEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			 removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
			 removeEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addBackground() : void
		{
			background = new Box( 1, 1 );
			background.alpha = 0;
			addChild( background );
		}
		
		protected function addIcon() : void
		{
			icon = MovieClip( AssetManager.gi.getAsset( 'QuickMovesAsset', SiteConstants.ASSETS_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
		}

		protected function addCopy() : void
		{
			var id : String = "summary-quick"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt = new AutoTextContainer( );
			copyTxt.populate( dto, "summary-lowernav-inactive" );
			addChild( copyTxt );
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent ) : void 
		{
			TweenLite.to( copyTxt, SiteConstants.NAV_TIME_IN * .6, { tint: SiteConstants.COLOR_RED, ease: Quad.easeOut } );
		}
		
		protected function onMouseOut( e : MouseEvent ) : void 
		{
			TweenLite.to( copyTxt, SiteConstants.NAV_TIME_OUT, { tint: SiteConstants.COLOR_WHITE, ease: Quad.easeOut } );
		}
		
		protected function onClick( e : MouseEvent ) : void 
		{
			TrackingManager.gi.trackCustom(TrackingConstants.RESOLVE_QUICK_MOVES );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}

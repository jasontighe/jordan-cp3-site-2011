package com.jordan.cp.view.summary {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class SummaryContinueButton 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var COPY							: String = "CONTINUE EXPLORING";
		protected static var ICON_X							: uint = 0;
		protected static var ICON_Y							: uint = 5;
		protected static var COPY_X							: uint = 12;
		protected static var COPY_Y							: uint = 0;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var overTxt									: TextContainer;
		public var outTxt									: TextContainer;
		public var outMask									: Box;
		public var overMask									: Box;
		public var icon										: MovieClip;
		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryContinueButton() 
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
			addMasks();
			resizeBackground();
		}
		
		
		public function activate() : void
		{
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
			icon = MovieClip( AssetManager.gi.getAsset( 'ExitArrowAsset', SiteConstants.ASSETS_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
		}

		protected function addCopy() : void
		{
			outTxt = new TextContainer();
			var s : String = COPY;
			outTxt.populate( s, 'summary-exit-inactive' );
			outTxt.x = COPY_X;
			outTxt.y = COPY_Y;
			addChild( outTxt );
			
			overTxt = new TextContainer();
			overTxt.populate( s, 'summary-exit-active' );
			overTxt.x = COPY_X;
			overTxt.y = COPY_Y;
			addChild( overTxt );
		}
		
		protected function addMasks() : void
		{
			outMask = new Box( outTxt.width, outTxt.height );
			outMask.x = outTxt.x;
			addChild( outMask );
			outTxt.mask = outMask;
			
			overMask = new Box( outTxt.width, outTxt.height );
			overMask.x = outTxt.x;
			addChild( overMask );
			overTxt.mask = overMask;
			
			overMask.y = -overMask.height
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
			TweenLite.to( outMask, SiteConstants.NAV_TIME_IN, { y: outMask.height, ease: Quad.easeOut } );
			TweenLite.to( overMask, SiteConstants.NAV_TIME_IN, { y: 0, ease: Quad.easeOut } );
		}
		
		protected function onMouseOut( e : MouseEvent ) : void 
		{
			TweenLite.to( outMask, SiteConstants.NAV_TIME_OUT, { y: 0, ease: Quad.easeOut } );
			TweenLite.to( overMask, SiteConstants.NAV_TIME_OUT, { y: -overMask.height, ease: Quad.easeOut } );
		}
		
		protected function onClick( e : MouseEvent ) : void 
		{
			deactivate();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}

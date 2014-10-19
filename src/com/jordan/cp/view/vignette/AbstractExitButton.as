package com.jordan.cp.view.vignette {
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
	import flash.geom.ColorTransform;

	/**
	 * @author jason.tighe
	 */
	public class AbstractExitButton 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected var COPY							: String = "CLOSE";
		protected var ICON_X						: int = 0;
		protected var ICON_Y						: int = 4;
		protected var COPY_X						: uint = 12;
		protected var COPY_Y						: int = 0;
		protected var MASK_Y_OFFSET					: int = 2;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var overTxt									: TextContainer;
		public var outTxt									: TextContainer;
		public var outMask									: Box;
		public var overMask									: Box;
		public var outIconMask								: Box;
		public var overIconMask								: Box;
		public var icon										: MovieClip;
		public var iconRed									: MovieClip;
		public var hitBox									: Box;
		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractExitButton() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}
		
		public function addViews( s : String ) : void
		{
			addBackground();
			addIcons();
			addCopy( s );
			addMasks();
			resizeBackground();
			addHitbox();
		}
		
		public function activate() : void
		{
//			trace( "ABSTRACTEXITBUTTON : activate()" );
			hitBox.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			hitBox.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			hitBox.addEventListener( MouseEvent.CLICK, onClick );
			 
			hitBox.buttonMode = true;
			hitBox.useHandCursor = true;
			hitBox.mouseEnabled = true;
			hitBox.mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			 hitBox.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 hitBox.removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
			 hitBox.removeEventListener( MouseEvent.CLICK, onClick );
			 
			 hitBox.buttonMode = false;
			 hitBox.useHandCursor = false;
			 hitBox.mouseEnabled = false;
			 hitBox.mouseChildren = false;
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
		
		protected function addIcons() : void
		{
			icon = MovieClip( AssetManager.gi.getAsset( 'ExitArrowAsset', SiteConstants.WELCOME_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
			
			iconRed = MovieClip( AssetManager.gi.getAsset( 'ExitArrowAsset', SiteConstants.WELCOME_ID ) );
			iconRed.x = ICON_X;
			iconRed.y = ICON_Y;
//			TweenMax.to( iconRed, 0, { tint: SiteConstants.COLOR_RED });
			addChild( iconRed );
			
			var colorTransform : ColorTransform = iconRed.transform.colorTransform;
			colorTransform.color = SiteConstants.COLOR_RED;
			iconRed.transform.colorTransform = colorTransform;
		}

		protected function addCopy( s : String ) : void
		{
			outTxt = new TextContainer();
			var s : String = s.toUpperCase();
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
			outMask = new Box( outTxt.width, outTxt.height - MASK_Y_OFFSET );
			outMask.x = outTxt.x;
			addChild( outMask );
			outTxt.mask = outMask;
			
			overMask = new Box( outTxt.width, outTxt.height - MASK_Y_OFFSET );
			overMask.x = outTxt.x;
			overMask.y = outMask.y;
			addChild( overMask );
			overTxt.mask = overMask;
			overTxt.y = -overMask.height;
			
			
			outIconMask = new Box( icon.width, outTxt.height - MASK_Y_OFFSET );
			outIconMask.x = icon.x;
			outIconMask.y = outTxt.y;
			addChild( outIconMask );
			icon.mask = outIconMask;
			
			overIconMask = new Box( icon.width, outTxt.height - MASK_Y_OFFSET );
			overIconMask.x = icon.x;
			overIconMask.y = outTxt.y;
			addChild( overIconMask );
			iconRed.mask = overIconMask;
			iconRed.y = overIconMask.height;
			
			iconRed.y = overIconMask.height + MASK_Y_OFFSET;
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
		}
		
		protected function addHitbox() : void
		{
			hitBox = new Box( 1, 1 );
			hitBox.width = outTxt.x + outTxt.width;
			hitBox.height = outTxt.y + outTxt.height - 1;
			hitBox.alpha = 0;
			addChild( hitBox );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
//			trace( "ABSTRACTEXITBUTTON : onMouseOver()" );
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.2;

			TweenLite.to( outTxt, time, { y: outMask.height, ease: Quad.easeInOut } );
			TweenLite.to( overTxt, time, { y: COPY_Y, ease: Quad.easeOut } );
			
			TweenLite.to( icon, time, { y: -overMask.height, ease: Quad.easeInOut } );
			TweenLite.to( iconRed, time, { y: ICON_Y, ease: Quad.easeOut } );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
//			trace( "ABSTRACTEXITBUTTON : onMouseOut()" );
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.5;
			
			TweenLite.to( outTxt, time, { y: COPY_Y, ease: Quad.easeOut } );
			TweenLite.to( overTxt, time, { y: -overMask.height, ease: Quad.easeInOut } );
			
			TweenLite.to( icon, time, { y: ICON_Y, ease: Quad.easeOut } );
			TweenLite.to( iconRed, time, { y: overIconMask.height + MASK_Y_OFFSET, ease: Quad.easeInOut } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
//			trace( "ABSTRACTEXITBUTTON : onClick()" );
			deactivate();
			onMouseOut();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}

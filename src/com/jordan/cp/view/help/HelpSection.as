package com.jordan.cp.view.help {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class HelpSection 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
//		protected const MARGIN								: uint = 10;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon										: MovieClip;
		public var hr										: MovieClip;
		public var guide									: MovieClip;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function HelpSection() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			setVariables();
		}
		
		public function transitionIn() : void
		{
			
		}
		
		public function activate() : void
		{
//			 addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
//			 addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
//			 addEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
//			 removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
//			 removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
//			 removeEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}
		
		public function scale( percent : Number ) : void
		{
			var scaleW : Number = getWidth() * percent;
			var scaleH : Number = getHeight() * percent;
			var xPos : Number = getX() + ( ( getWidth() - scaleW ) * .5 );
			var yPos : Number = getY() + ( ( getHeight() - scaleH ) * .5 );
			TweenLite.to( this, SiteConstants.NAV_TIME_IN * .5, { x: xPos, y: yPos, width: scaleW, height: scaleH, ease: Quad.easeOut } );
		}

		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function initViews() : void
		{
		}
		
//		protected function setVariables() : void
//		{
//			setX( background.x );
//			setY( background.y );
//			setWidth( background.width );
//			setHeight( background.height );
//		}
	}
}

package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class RealTime 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _knobXOn								: uint;
		protected var _knobXOff								: uint;
		protected static var DIM_ALPHA						: Number = .3;

		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var realTimeTxt								: AutoTextContainer;
		public var icon										: MovieClip;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function RealTime() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
			addViews();
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

		public function dim() : void
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_OUT, { alpha: DIM_ALPHA } );
		}

		
		public function undim() : void
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_OUT, { alpha: 1 } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
			addCopy();
		}
		
		protected function addCopy( ) : void
		{
			var id : String = "real-time"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			realTimeTxt = new AutoTextContainer( );
			realTimeTxt.populate( dto, id );
			addChild( realTimeTxt );
		}
		
		protected function toggleKnobComplete() : void
		{
			activate();
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			TweenLite.to( realTimeTxt, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			TweenLite.to( realTimeTxt, SiteConstants.NAV_TIME_OUT, { tint: 0x464646 } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			deactivate();
		}
	}
}

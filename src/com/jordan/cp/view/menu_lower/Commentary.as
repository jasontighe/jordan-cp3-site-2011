package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.audio.VoiceOver;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class Commentary 
	extends DisplayContainer 
	{
		protected static var BLOCKER_COLOR					: uint = 0x070707;
		protected static var DIM_ALPHA						: Number = .3;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _knobXOn								: uint;
		protected var _knobXOff								: uint;
		private var _vo 									: VoiceOver;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var commentaryTxt							: AutoTextContainer;
		public var onTxt									: AutoTextContainer;
		public var offTxt									: AutoTextContainer;
		public var knob										: MovieClip;
		public var gutter									: MovieClip;
		public var gutterOff								: MovieClip;
		public var blocker									: Box;
		public var background								: MovieClip;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Commentary() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
			_knobXOn = Math.round( gutter.x + gutter.width - knob.width );
			_knobXOff = Math.round( gutter.x );
			addViews();
		}
		
		public function setOff( ) : void
		{
			knob.x = _knobXOff;
			gutterOff.alpha = 1;
			gutter.alpha = 0;
		}
		
		public function setOn( ) : void
		{
			knob.x = _knobXOn;
			gutterOff.alpha = 0;
			gutter.alpha = 1;
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
			 
//			 blocker.alpha = 0;
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
			 
//			 blocker.alpha = 1;
		}
		
		public function dim() : void
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_OUT, { alpha: DIM_ALPHA } );
		}

		
		public function undim() : void
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_OUT, { alpha: 1 } );
		}
		
		public function toggleKnob() : void
		{
			var knobX : uint;
			var gutterAlpha : uint;
			var gutterOffAlpha : uint;
			
			if( knob.x == _knobXOn )
			{
				knobX = _knobXOff;
				gutterAlpha = 0;
				gutterOffAlpha = 1;

				// TURN OFF VO
				if(_vo) _vo.active = false;
			}
			else
			{
				knobX = _knobXOn;
				gutterAlpha = 1;
				gutterOffAlpha = 0;

				// TURN ON VO
				if(!_vo) _vo = new VoiceOver();
				_vo.startVo();
			}
			
			var time : Number = SiteConstants.NAV_TIME_IN * .25;
//			var delay : Number = time * 2;
			TweenLite.to( knob, time, { x: knobX, ease:Quad.easeOut } );
			TweenLite.to( gutterOff, time, { alpha: gutterOffAlpha, ease:Quad.easeOut } );
			TweenLite.to( gutter, time, { alpha: gutterAlpha, ease:Quad.easeOut, onComplete: toggleKnobComplete } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
			addCopy();
			setOff();
			addBlocker();
		}
		
		protected function addCopy( ) : void
		{
			var commentaryId : String = "commentary-title"
			var commentaryDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( commentaryId ) as CopyDTO;
			commentaryTxt = new AutoTextContainer( );
			commentaryTxt.populate( commentaryDTO, commentaryId );
			addChild( commentaryTxt );
			
			var onId : String = "commentary-on"
			var onDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( onId ) as CopyDTO;
			onTxt = new AutoTextContainer( );
			onTxt.populate( onDTO, onId );
			gutter.addChild( onTxt );
			
			var offId : String = "commentary-off"
			var offDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( offId ) as CopyDTO;
			offTxt = new AutoTextContainer( );
			offTxt.populate( offDTO, offId );
			gutterOff.addChild( offTxt );
		}
		
		protected function toggleKnobComplete() : void
		{
			activate();
		}
		
		protected function addBlocker() : void
		{
			blocker = new Box( width, height, BLOCKER_COLOR );
			blocker.alpha = 0;
			addChild( blocker );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
//			TweenLite.to( commentaryTxt, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
//			TweenLite.to( commentaryTxt, SiteConstants.NAV_TIME_OUT, { tint: SiteConstants.COLOR_WHITE } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			toggleKnob();
			deactivate();
		}
	}
}

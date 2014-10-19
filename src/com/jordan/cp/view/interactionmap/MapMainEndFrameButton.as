package com.jordan.cp.view.interactionmap 
{
	import com.greensock.TweenLite;	import com.greensock.easing.Quad;	import com.jordan.cp.constants.SiteConstants;	import com.jordan.cp.view.vignette.AbstractExitButton;	import com.plode.framework.containers.TextContainer;	import com.plode.framework.utils.BoxUtil;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	
	/**
	 * @author nelson.shin
	 */
	public class MapMainEndFrameButton extends AbstractExitButton 
	{
		private var _background : Sprite;

		public function MapMainEndFrameButton()
		{
			ICON_Y = 5;
			COPY_Y = 2;
			MASK_Y_OFFSET = 0;
		}
				
		override protected function addBackground() : void
		{
		}
		
		
		override protected function resizeBackground() : void
		{
			_background = BoxUtil.getRoundBox(width + 15, height-24, 5, SiteConstants.COLOR_RED);
			_background.x = -8;
			_background.y = -1;
			addChildAt(_background, 0);
		}
		
		override protected function addCopy( s : String ) : void
		{
			outTxt = new TextContainer();
			var s : String = s.toUpperCase();
			outTxt.populate( s, 'interstitial-exit-inactive' );
			outTxt.x = COPY_X;
			outTxt.y = COPY_Y;
			addChild( outTxt );
			
			overTxt = new TextContainer();
			overTxt.populate( s, 'interstitial-exit-active' );
			overTxt.x = COPY_X;
			overTxt.y = COPY_Y;
			addChild( overTxt );
		}

		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		override protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			super.onMouseOver(e);
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.2;
			TweenLite.to( _background, time, { tint: 0x000000, ease: Quad.easeOut } );
		}
		
		override protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			super.onMouseOut(e);
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.5;
			TweenLite.to( _background, time, { tint: null, ease: Quad.easeOut } );
		}		
		
		override protected function onClick( e : MouseEvent = null ) : void 
		{
//			trace( "ABSTRACTEXITBUTTON : onClick()" );
//			deactivate();
			onMouseOut();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}

		
	}
}

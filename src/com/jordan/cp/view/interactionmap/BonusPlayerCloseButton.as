package com.jordan.cp.view.interactionmap 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.view.vignette.AbstractExitButton;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * @author nelson.shin
	 */
	public class BonusPlayerCloseButton extends AbstractExitButton 
	{
		
		public function BonusPlayerCloseButton()
		{
			setup();
		}
		
		public function setup() : void
		{
			ICON_X = -10;
			ICON_Y = 9;
		}

		override protected function addIcons() : void
		{
			icon = MovieClip( AssetManager.gi.getAsset('ComputerArrowAsset', SiteConstants.ASSETS_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
		}

		override protected function addCopy( val : String ) : void
		{
			var s : String = val.toUpperCase();
			
			outTxt = new TextContainer();
			outTxt.populate( s, 'bonus-exit-inactive' );
			outTxt.x = COPY_X;
			outTxt.y = COPY_Y;
			addChild( outTxt );
			
			overTxt = new TextContainer();
			overTxt.populate( s, 'bonus-exit-active' );
			overTxt.x = COPY_X;
			overTxt.y = COPY_Y;
			addChild( overTxt );
		}
		
		override protected function addMasks() : void
		{
			addTextMasksOnly( );
		}
		
		private function addTextMasksOnly() : void
		{
			outMask = new Box( outTxt.width, outTxt.height );
			outMask.x = outTxt.x;
			addChild( outMask );
			outTxt.mask = outMask;
			
			overMask = new Box( outTxt.width, outTxt.height );
			overMask.x = outTxt.x;
			overMask.y = outMask.y;
			addChild( overMask );
			overTxt.mask = overMask;
			overTxt.y = -overMask.height;
		}



		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		override protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace("BonusPlayerCloseButton.onMouseOver");
//			trace( "ABSTRACTEXITBUTTON : onMouseOver()" );
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.2;

			TweenLite.to( outTxt, time, { y: outMask.height, ease: Quad.easeInOut } );
			TweenLite.to( overTxt, time, { y: 0, ease: Quad.easeOut } );
		}
		
		override protected function onMouseOut( e : MouseEvent = null ) : void 
		{
//			trace( "ABSTRACTEXITBUTTON : onMouseOut()" );
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.5;
//			
			TweenLite.to( outTxt, time, { y: 0, ease: Quad.easeOut } );
			TweenLite.to( overTxt, time, { y: -overMask.height, ease: Quad.easeInOut } );
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

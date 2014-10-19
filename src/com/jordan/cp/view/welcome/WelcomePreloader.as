package com.jordan.cp.view.welcome {
	import com.greensock.TweenLite;	import com.greensock.TweenMax;	import com.greensock.easing.Quad;	import com.jordan.cp.constants.SiteConstants;	import com.jordan.cp.loaders.AbstractPreloader;	import com.jordan.cp.view.events.ViewEvent;	import com.plode.framework.managers.sound.PlodeSoundItem;	import com.plode.framework.managers.sound.PlodeSoundManager;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	/**
	 * @author jsuntai
	 */
	public class WelcomePreloader 
	extends AbstractPreloader 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var objectsArray								: Array = new Array();
		protected var increment									: uint = 20;
		protected var iconNum									: uint = 0;
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public var loadingTxt									: MovieClip;
		public var icons										: LoaderIcons;
		public var percentTxt									: MovieClip;
		public var percentTf									: TextField;
		public var startTxt										: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function WelcomePreloader() 
		{
			trace( "WELCOMEPRELOADER : Constr" );
			super();
			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "WELCOMEPRELOADER : init()" );
			percentTf = percentTxt.tf;
			percentTf.htmlText = "";
			objectsArray = [ loadingTxt, icons, percentTxt ];
			
			var i : uint = 0;
			var I : uint = objectsArray.length;
			for( i; i < I; i++ )
			{
				var object : * = objectsArray[ i ];
				object.alpha = 0;
			}
			
			startTxt.alpha = 0;
		}
		
		public override function transitionIn() : void
		{
			trace( "WELCOMEPRELOADER : transitionIn()" );
			var time : Number = SiteConstants.NAV_TIME_IN;
			
			var i : uint = 0;
			var I : uint = objectsArray.length;
			for( i; i < I; i++ )
			{
				var delay : Number = ( time * i * .5 ) + time;
				trace( "WELCOME : transitionIn()" );
				var object : * = objectsArray[ i ];
				trace( "WELCOME : transitionIn() : object is "+object );
				TweenMax.to( object, time, { alpha: 1, delay: delay, ease: Quad.easeOut, onComplete: transitionInComplete } );
			}
		}
		
		public function showStartExploring() : void
		{
			TweenLite.to( startTxt, SiteConstants.NAV_TIME_IN, { alpha: 1, onComplete: activateStart } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function updateDisplay( ) : void
		{
//			trace( "WELCOMEPRELOADER : updateDisplay() : showPercent is "+showPercent );
			var percent : Number = Math.round( showPercent * 100 );
			percentTf.htmlText = String( percent );
			
			var percentageMin : uint = iconNum * increment;
			if( percent > percentageMin )
			{
				icons.updateIcon( iconNum );
				iconNum++;
			}
		}
		
		protected override function doLoadComplete() : void
		{
			trace( "WELCOMEPRELOADER : doLoadComplete()" );
			if( _auto )	removeEventListener( Event.ENTER_FRAME, onAutoEnterFrame );
//			showStart();
			
			reset();
		}
		
		protected function activateStart() : void
		{
			startTxt.buttonMode = true;
			startTxt.useHandCursor = true;
			startTxt.mouseEnabled = true;
			startTxt.mouseChildren = false;
			
			startTxt.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			startTxt.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			startTxt.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		protected function deactivateStart() : void
		{
			startTxt.buttonMode = false;
			startTxt.useHandCursor = false;
			startTxt.mouseEnabled = false;
			startTxt.mouseChildren = false;
			
			startTxt.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			startTxt.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			startTxt.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent ) : void
		{
			
		}
		
		protected function onMouseOut( e : MouseEvent ) : void
		{
			
		}
		
		protected function onClick( e : MouseEvent ) : void
		{
			// MAYBE NO SOUND SWF IS LOADED YET :(//			var psm : PlodeSoundManager = PlodeSoundManager.gi;//			// TODO - CHANGE BACK TO 1//			psm.fadeGlobalVolume(1);
////			var item : PlodeSoundItem = PlodeSoundManager.gi.getSound(SiteConstants.AUDIO_BG_LOOP);//			item.looping = true;//			item.play();
			deactivateStart();
			dispatchEvent( new ViewEvent( ViewEvent.START_EXPLORING ) ); 
		}
	}
}

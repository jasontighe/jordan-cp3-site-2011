package com.jordan.cp.players 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.utils.BitmapConverter;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author nelson.shin
	 */
	public class VideoTransitionView extends AbstractDisplayContainer 
	{
		private var _snapshot : Bitmap;
		private static var INSTANCE: VideoTransitionView;
		private static const ZOOM : Number = 1.5;
		
		
		//-------------------------------------------------------------
		//
		// SINGLETON STUFF
		//
		//-------------------------------------------------------------
		public function VideoTransitionView( se : SingletonEnforcerer ) {
			if( se != null ){
				init();
			}
		}

		public static function get gi() : VideoTransitionView {
			if( INSTANCE == null ){
				INSTANCE = new VideoTransitionView( new SingletonEnforcerer() );
			}
			return INSTANCE;
		}
		
		private function init() : void {
			
		}



		//-------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------
		public function setBmp(obj : DisplayObject) : void 
		{
			trace('\n\n\n\n\n\n\n\n\n\n-------------------------------------------------------------');
			trace("VideoTransitionView.setBmp : PLEASE HAPPEN BEFORE BONUS SCENE SHOWS");
			trace('-------------------------------------------------------------\n\n\n');
			// TAKE SNAPSHOT
			if(!_snapshot)
			{
				_snapshot = new Bitmap();
				addChild(_snapshot);
			}
			_snapshot.bitmapData = BitmapConverter.getBmp(obj).bitmapData.clone();
			_snapshot.smoothing = true;
		}

		public function showTransition(zoomIn : Boolean) : void
		{
			var displaceX : Number = -((_snapshot.width * ZOOM) - _snapshot.width ) / 4;
			var displaceY : Number = -((_snapshot.height * ZOOM) - _snapshot.height ) / 4;

			if(zoomIn)
			{
				_snapshot.x = _snapshot.y = 0;
				_snapshot.scaleX = _snapshot.scaleY = 1;
				_snapshot.alpha = 1;
			}
			else
			{
				_snapshot.x = displaceX;
				_snapshot.y = displaceY;
				_snapshot.scaleX = _snapshot.scaleY = ZOOM;
				_snapshot.alpha = 0;
			}
		}
		
		public function animateTransition(zoomIn : Boolean, dur : Number = 1) : void
		{
			// ZOOM IN OR OUT + FADE
			// - zoomIn : FALSE out, TRUE in
			var tarZoom : Number;
			var tarAlpha : Number;
			var tarEase : Function;
			var tarX : Number;
			var tarY : Number;
			var displaceX : Number = -((_snapshot.width * ZOOM) - _snapshot.width ) / 4;
			var displaceY : Number = -((_snapshot.height * ZOOM) - _snapshot.height ) / 4;
//			var blurAmount : Number = 15;

			if(zoomIn)
			{
				tarZoom = ZOOM;
				tarX = displaceX;
				tarY = displaceY;
				tarAlpha = 0;
				tarEase = Strong.easeInOut;

//				TweenMax.to(_snapshot, dur, {blurFilter: {blurX: blurAmount, blurY: blurAmount}});

				TweenMax.to(_snapshot, dur, {x: tarX, y: tarY, scaleX: tarZoom, scaleY: tarZoom, alpha: tarAlpha, ease: tarEase});//, onComplete: dispatchComplete} );
			}
			else
			{
				tarZoom = 1;
				tarX = 0;
				tarY = 0;
				tarAlpha = 1;
				tarEase = Strong.easeOut;
				
//				TweenMax.to(_snapshot, dur, {blurFilter: {remove: true}});

				TweenMax.to(_snapshot, dur * .5, {alpha: tarAlpha, ease: tarEase} );
				TweenMax.to(_snapshot, dur * .5, {alpha: 0, delay: dur * .5, ease: tarEase} );
				TweenMax.to(_snapshot, dur, {x: tarX, y: tarY, scaleX: tarZoom, scaleY: tarZoom, ease: tarEase, onComplete: dispatchComplete} );
			}

		}




		private function dispatchComplete() : void
		{
			_snapshot.x = _snapshot.y = 0;
			_snapshot.bitmapData.dispose();
			
//			dispatchEvent(new Event(Event.COMPLETE ) );
		}
		
	}
}

class SingletonEnforcerer {}		

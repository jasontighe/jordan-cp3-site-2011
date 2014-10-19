package com.jordan.cp.players 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Strong;
	import com.jordan.cp.Shell;
	import com.jordan.cp.model.CameraPannerModel;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.events.ParamEvent;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author nelson.shin
	 * 
	 * FZIP docs:
	 * http://codeazur.com.br/lab/fzip/
	 */

	public final class CameraPanner extends AbstractDisplayContainer 
	{
		private var _tracker : TimeTracker = TimeTracker.gi;
		private var _model : CameraPannerModel = CameraPannerModel.gi;
		private var _holder : Sprite;
		private var _imgQueue : Array;
		private var _easeQueue : Array;
		private var _activeQueue : Array;

		private var _complete : Boolean = true;
		private var _inTransition : Boolean;
		private var _ind : uint;
		private var _pol : int = 0;

		public static const QUEUE_VIDEO : String = "QUEUE_VIDEO";
		public static const TRANSITION_COMPLETE : String = "TRANSITION_COMPLETE";

		/*
		 * 
		 * TODO
		 * - SHOULD ADD ASSETS TO CACHE/ASSETMANAGER FOR TO AVOID REDUNDANT LOADING
		 * 
		 * 
		 */
		 
		//-------------------------------------------------------------------------
		//
		// SINGLETON ISH
		//
		//-------------------------------------------------------------------------
		public function CameraPanner() 
		{
			init();
		}

		private function init() : void 
		{
			// INIT DISPLAY OBJECTS
			_holder = new Sprite();
			addChild(_holder);

 			_imgQueue = new Array();
			_easeQueue = new Array();
 			
 			_model.addEventListener(CameraPannerModel.TRANSITION_ITEM_ADDED, onIndexChanged);
		}


		
		
		
		//-------------------------------------------------------------------------
		//
		// PUBLIC INTERFACE
		//
		//-------------------------------------------------------------------------
		override public function show(dur : Number = .2, del : Number = 0) : void
		{
//			trace("CameraPanner.show(dur)");
			TweenMax.to(this, dur, { autoAlpha: 1, delay: 0, ease: Strong.easeOut});
		}
		
		override public function hide(dur : Number = .3, del : Number = 0) : void
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("CameraPanner.hide");
			if(_holder.numChildren > 1) _holder.removeChildAt(0);
			
			TweenMax.to(this, dur, { autoAlpha: 0, delay: .1, ease: Quad.easeIn, onComplete: disposeBmp});
		}

		private function disposeBmp() : void
		{
			while(_holder.numChildren > 0) _holder.removeChildAt(0);
		}




		private function onIndexChanged(event : ParamEvent) : void 
		{
			_imgQueue.push(event.params.index);
			
			// IF IN STABLE STATE, BEGIN TRANSITION
			if(_complete)
			{
//				trace("CameraPanner.onIndexChanged(event)");
//				trace('SHOULD ONLY FIRE UPON INITIATION OF TRANSITION', event.params.index);
				_ind = Number(_tracker.currentCamInd);
//				trace( 'Initial : _prevInd: ' + (_prevInd) );
				
				_complete = false;
//				_inTransition = true;

				killEase();
				checkQueue(_imgQueue[0]);
			}
		}

		private function killEase() : void 
		{
			_activeQueue = _imgQueue;
			_easeQueue.splice(0);
		}
		
		private function checkQueue(i : Number) : void 
		{
			calculatePolarity(i, _ind);

			var bmp : Bitmap = _model.getImage(_activeQueue[0] );

			_holder.addChild(bmp);
			animateIn(bmp);
		}

		private function animateIn(item : DisplayObject) : void 
		{
			// CALCULATE EASE FOR TAIL ITEMS
			var base : Number = TimeTracker.PANNING_RETARDER * .1 - .1;
			var dur : Number = (_activeQueue == _easeQueue) ? (base + (2 - _activeQueue.length) * .1) : base;
//			trace("CameraPanner.animateIn(item) : base * 1.2:", this, (base * 1.2));
//			trace("CameraPanner.animateIn(item) : _activeQueue.length:", this, (_activeQueue.length));
//			trace("CameraPanner.animateIn(item) : dur:", this, (dur));
			
			var sw : Number;
			try
			{
				sw = Shell.getInstance().masterStage.stageWidth;
			}
			catch( e : Error)
			{
				sw = TimeTracker.gi.masterStage.stageWidth;
			}
//			var mar : Number = sw / 80;
			
//			item.x = _pol * mar;
			item.alpha = .1;
			
			// DELAYED CALL TO CREATE OVERLAPPING ANIMATIONS
			TweenMax.delayedCall(dur * .7, advanceQueue);
//			trace("CameraPanner.animateIn(item) : dur * .6:", this, (dur * .6));
			TweenMax.to(item, dur, {x: 0, alpha: 1, ease: Quad.easeOut, onComplete: cleanup});
		}

		private function advanceQueue() : void
		{
//			trace('CameraPanner.advanceQueue :_imgQueue: ' + (_imgQueue) );
//			trace('CameraPanner.advanceQueue :_easeQueue: ' + (_easeQueue) );

			// UPDATE QUEUE
			_ind = _activeQueue.shift();
//			_activeQueue.shift();
						
			
			
			

			// CHECK IF EASEQUEUE SHOULD BEGIN
			checkForEnd();





			
			
			// UPDATE POLARITY & CHECK FOR QUEUE COMPLETION
			if(_activeQueue.length > 0)			{
//				calculatePolarity(_activeQueue[0].ind, _ind);
//				if(_pol == 0) calculatePolarity(_activeQueue[0], _ind);
//				trace('pol after', _pol)
//				showTransition();

				checkQueue(_activeQueue[0]);
			}
			else
			{
//				trace('\n\n\n-------------------------------------------------------------');
//				trace( 'CAMERA PANNER IS DONE...ONCE PER SWING PLEASE');
//				trace('-------------------------------------------------------------\n\n\n');
				_inTransition = false;
				completeQueue();
			}
		}
		
		private function checkForEnd() : void
		{
			if(_activeQueue == _imgQueue && _activeQueue.length == 0)
			{
				_activeQueue = _easeQueue;

//				trace('\n\n\n\n\n\n----------------------------------------------------------');
//				trace('QUEUE EMPTY', _pol);
//				trace('----------------------------------------------------------\n\n\n\n\n\n');
				//
//				trace("CameraPanner.checkForEnd() : _ind: " + (_ind));
//				trace("CameraPanner.checkForEnd() : _model.totalCams - 1: " + (_model.totalCams - 1));

				if(_ind == 0 || _ind == _model.totalCams - 1)
				{
//					trace("CameraPanner.checkForEnd() : ARC END");
					_model.setPanComplete();
				}
				else
				{
					var tarInd : int = Number(_ind);
	
					// ADD TO EASEQUEUE
					for(var i : uint = 0; i < 2; i++)
					{
						tarInd += _pol;
						if(tarInd >= 0 && tarInd <= _model.totalCams - 1)
						{
	//						trace("CameraPanner.add to ease : tarInd: " + (tarInd));
							_easeQueue.push(tarInd);
						}
					}
					
					// CORRECT TARGET INDEX
					if(tarInd < 0) tarInd = 0;
					else if(tarInd > _model.totalCams - 1) tarInd = _model.totalCams - 1;
					
					// NOTIFY VIDSWAPPER TO LOAD UP TARGET VIDEO
					_tracker.currentCamInd = tarInd.toString();
					_model.setPanComplete();
					
					// IF NO EASE TO ADD
					if(!_easeQueue || _easeQueue.length == 0) 
					{
						// TODO - WHAT HAPPENS HERE?
	//					killEase();
	//					completeQueue();
	//					trace('\n\n\n\n\n\n----------------------------------------------------------');
	//					trace('TESTING');
	//					trace('----------------------------------------------------------\n\n\n\n\n\n');
					}
				}
			}
		}

		private function completeQueue() : void 
		{
			_pol = 0;
//			_inTransition = false;
			
			// ANIMATION
			_complete = true;
			dispatchEvent(new Event(TRANSITION_COMPLETE));
		}

		private function cleanup() : void
		{
			// DISPOSE OF UNUSED BOTTOM LAYERS
			if(_holder.numChildren > 2)
			{
				_holder.removeChildAt(0);
			}
		}
		
		private function calculatePolarity(end : int, start : Number) : void 
		{
			_pol = end - start;
			if(_pol < -1) _pol = -1;
			else if(_pol > 1) _pol = 1;
		}		
		
		
		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function get complete() : Boolean {
			return _complete;
		}
		
		public function get imgQueue() : Array
		{
			return _imgQueue;
		}
	}
}









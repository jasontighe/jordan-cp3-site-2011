// NEED TO SETUP ASSET & HIT SHAPE

package com.plode.framework.containers
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AbstractButtonContainer extends AbstractDisplayContainer implements IContainer
	{
		protected var _asset : DisplayObject;
		protected var _hit : Sprite;
		
		public function AbstractButtonContainer()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		override public function setup() : void
		{
			addDisplayObjects();
			addEventListeners();
		}
		
		public function activate() : void
		{
//			trace('AbstractButtonContainer.activate : NEED TO OVERRIDE');
			showOutState();
			addEventListeners();
		}	
		
		public function deactivate() : void
		{
//			trace('AbstractButtonContainer.deactivate : NEED TO OVERRIDE');
			showClickState();
			removeEventListeners();
		}	
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		protected function loadAsset() : void
		{
			trace('AbstractButtonContainer.loadAsset : NEED TO OVERRIDE');
		}
		
		override protected function addDisplayObjects() : void
		{
			_hit = new Sprite();
			_hit.buttonMode = true;
			addChild(_asset);
			addChild(_hit);
		}
		
		override protected function removeDisplayObjects() : void
		{
			removeChild(_asset);
			removeChild(_hit);
		}
		
		override protected function addEventListeners() : void
		{
			if(!_hit.hasEventListener(MouseEvent.ROLL_OVER))
			{
				_hit.addEventListener(MouseEvent.ROLL_OVER, onHitOver);
				_hit.addEventListener(MouseEvent.ROLL_OUT, onHitOut);
				_hit.addEventListener(MouseEvent.CLICK, onHitClick);
			}
		}
		
		override protected function removeEventListeners() : void
		{
			_hit.removeEventListener(MouseEvent.ROLL_OVER, onHitOver);
			_hit.removeEventListener(MouseEvent.ROLL_OUT, onHitOut);
			_hit.removeEventListener(MouseEvent.CLICK, onHitClick);
		}
		
		protected function resizeHit(w: uint, h: uint) : void
		{
			_hit.graphics.clear();
			_hit.graphics.beginFill( 0xff0000, 0 );
			_hit.graphics.drawRect(0, 0, w, h);
		}

		protected function showOverState() : void
		{
			trace('AbstractButtonContainer.showOverState : NEED TO OVERRIDE');
		}
		
		protected function showOutState() : void
		{
			trace('AbstractButtonContainer.showOutState : NEED TO OVERRIDE');
		}
		
		protected function showClickState() : void
		{
			trace('AbstractButtonContainer.showClickState : NEED TO OVERRIDE');
		}
		
		protected function dispatchClickEvent() : void
		{
			trace('AbstractButtonContainer.dispatchClickEvent : NEED TO OVERRIDE');
		}
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
		protected function onHitOver(e : MouseEvent) : void
		{
			showOverState();
		}
		
		protected function onHitOut(e : MouseEvent) : void
		{
			showOutState();
		}
		
		protected function onHitClick(e : MouseEvent) : void
		{
			showClickState();
			dispatchClickEvent();
		}
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
	}
}
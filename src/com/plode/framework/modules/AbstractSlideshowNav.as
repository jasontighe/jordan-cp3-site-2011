package com.plode.framework.modules
{
	import com.greensock.TweenMax;
	import com.plode.framework.controllers.AbstractSlideshowController;
	import com.plode.framework.models.AbstractSlideshowModel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AbstractSlideshowNav extends Sprite
	{
		protected var _slideM : AbstractSlideshowModel;
		protected var _slideC : AbstractSlideshowController;
		protected var _bgColor : uint;
		protected var _orientation : String;
		protected var _w : uint;
		protected var _h : uint;
		protected var _hitL : Sprite;
		protected var _hitR : Sprite;
		protected var _arrowL : Sprite;
		protected var _arrowR : Sprite;
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function AbstractSlideshowNav()
		{
			super();
		}
		
		public function setup(m : AbstractSlideshowModel, c : AbstractSlideshowController, w : uint, h : uint, bgColor : uint = 0xff0000, orientation : String = 'H'): void
		{
			_slideM = m;
			_slideC = c;
			_w = w;
			_h = h;
			_bgColor = bgColor;
			_orientation = orientation;
			
			setupArrows( );
			addEventListeners();
			checkArrows();
		}
		
		public function checkArrows() : void
		{
			updateListeners(_slideM.currentIndex);
		}
		
		public function dispose() : void
		{
			removeEventListeners();
			removeDisplayObjects();
		}
		
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		protected function setupArrows() : void
		{
			_hitL = new Sprite( );
			_hitL.graphics.beginFill( 0xff0000, 0 );
			_hitL.graphics.drawRect( 0, 0, _w/2 - 20, _h );
			addChild( _hitL );
			
			_hitR = new Sprite( );
			_hitR.graphics.beginFill( 0xff0000, 0 );
			_hitR.graphics.drawRect( _w/2 + 20, 0, _w/2 - 20, _h );
			addChild( _hitR );
			
//			_arrowL = _assets.getAsset( "SlideArrowL" );
//			_arrowL.buttonMode = true;
//			_arrowL.x = 25;
//			_arrowL.y = (_h - _arrowL.height)/2
//			_arrowL.alpha = 0;
//			_hitL.addChild( _arrowL );
//			
//			_arrowR = _assets.getAsset( "SlideArrowR" );
//			_arrowR.buttonMode = true;
//			_arrowR.x = _w - _arrowR.width - 25;
//			_arrowR.y = (_h - _arrowR.height)/2
//			_arrowR.alpha = 0;
//			_hitR.addChild( _arrowR );
		}
		
		protected function removeDisplayObjects() : void
		{
			while(numChildren > 0) removeChildAt(0);
			_arrowL = null;
			_arrowR = null;
			_hitL = null;
			_hitR = null;
		}
		
		protected function addEventListeners() : void
		{
			_slideC.addEventListener(Event.COMPLETE, onControllerComplete);
			_slideC.addEventListener(Event.CLOSE, onControllerClose);
			_hitL.addEventListener( MouseEvent.MOUSE_OVER, onOver );
			_hitL.addEventListener( MouseEvent.MOUSE_OUT, onOut );
			_hitL.addEventListener( MouseEvent.CLICK, onLeftClick );
			_hitR.addEventListener( MouseEvent.MOUSE_OVER, onOver );
			_hitR.addEventListener( MouseEvent.MOUSE_OUT, onOut );
			_hitR.addEventListener( MouseEvent.CLICK, onRightClick );
		}
		
		protected function removeEventListeners() : void
		{
			_slideC.removeEventListener(Event.COMPLETE, onControllerComplete);
			_slideC.removeEventListener(Event.CLOSE, onControllerClose);
			
			if(_hitL)
			{
				_hitL.removeEventListener( MouseEvent.MOUSE_OVER, onOver );
				_hitL.removeEventListener( MouseEvent.MOUSE_OUT, onOut );
				_hitL.removeEventListener( MouseEvent.CLICK, onLeftClick );
				_hitR.removeEventListener( MouseEvent.MOUSE_OVER, onOver );
				_hitR.removeEventListener( MouseEvent.MOUSE_OUT, onOut );
				_hitR.removeEventListener( MouseEvent.CLICK, onRightClick );
			}
		}
		
		protected function updateListeners(ind : int) : void
		{
			if(ind == 0)
			{
				_hitL.visible = false;
				_arrowL.visible = false;
				_hitR.visible = true;
				_arrowR.visible = true;
			}
			else if(ind == _slideM.items.length-1)
			{
				_hitL.visible = true;
				_arrowL.visible = true;
				_hitR.visible = false;
				_arrowR.visible = false;
			}
			else
			{
				_hitL.visible = true;
				_arrowL.visible = true;
				_hitR.visible = true;
				_arrowR.visible = true;
			}
		}

		protected function hide( s : Sprite ) : void
		{
			TweenMax.to(s, .5, {alpha:0});
		}
		
		protected function deactivate() : void
		{
			_hitL.visible = _hitR.visible = false;
		}
		
		
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
//		protected function onModelIndexChanged( e : Event) : void
//		{
//			updateArrows();
//		}
		
		protected function onControllerComplete( e : Event) : void
		{
			checkArrows();
		}
		
		protected function onControllerClose( e : Event) : void
		{
			dispose();
		}
		
		protected function onLeftClick(event : MouseEvent) : void
		{
			deactivate();
			_slideC.updateModelIndex(-1);
		}
		
		protected function onRightClick(event : MouseEvent) : void
		{
			deactivate();
			_slideC.updateModelIndex(1);
		}
		
		protected function onOver(event : MouseEvent) : void
		{
			var sender : Sprite = event.currentTarget as Sprite;
			var arrow : Sprite = (sender == _hitL) ? _arrowL : _arrowR;
			TweenMax.to( arrow, .25, {alpha: 1} );
		}
		
		protected function onOut(event : MouseEvent) : void
		{
			var func : Function = (event.target == _hitL) ? onLeftClick : onRightClick;
			event.target.removeEventListener( MouseEvent.CLICK, func );
			var arrow : Sprite = ( event.target == _hitL) ? _arrowL : _arrowR;
			hide(arrow);
		}
		
	}
}

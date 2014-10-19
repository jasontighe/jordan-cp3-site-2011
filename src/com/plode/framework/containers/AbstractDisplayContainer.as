package com.plode.framework.containers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import flash.display.Sprite;
	
	
	public class AbstractDisplayContainer extends Sprite implements IContainer
	{
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function setup() : void
		{
			trace('AbstractDisplayContainer.setup : NEED TO OVERRIDE');
		}
		
//		public function update(... optionalArgs) : void
//		{
//			trace('AbstractDisplayContainer.update : NEED TO OVERRIDE');
//		}
		
		public function show(dur : Number = .5, del : Number = 0) : void
		{
//			trace('AbstractDisplayContainer.show : NEED TO OVERRIDE');
			
			// TODO - SATURATE COLOR
			TweenMax.killTweensOf(this);
			TweenMax.to(this, dur, { autoAlpha: 1, delay: del, ease: Strong.easeOut });
		}
		
		public function hide(dur : Number = .5, del : Number = 0) : void
		{
//			trace('AbstractDisplayContainer.hide : NEED TO OVERRIDE');
			
			// TODO DESATURATE
			TweenMax.killTweensOf(this);
			TweenMax.to(this, dur, { autoAlpha: 0, delay: del, ease: Strong.easeOut });
		}
		
		public function dispose() : void
		{
			trace('AbstractDisplayContainer.dispose : NEED TO OVERRIDE');
			
//			removeEventListeners();
//			removeDisplayObjects();
		}
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		protected function addDisplayObjects() : void
		{
			trace('AbstractDisplayContainer.addDisplayObjects : NEED TO OVERRIDE');
		}
		
		protected function removeDisplayObjects() : void
		{
			trace('AbstractDisplayContainer.removeDisplayObjects : NEED TO OVERRIDE');
			
		}
		
		protected function addEventListeners() : void
		{
			trace('AbstractDisplayContainer.addEventListeners : NEED TO OVERRIDE');
			
		}
		
		protected function removeEventListeners() : void
		{
			trace('AbstractDisplayContainer.removeEventListeners : NEED TO OVERRIDE');
			
		}
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		
	
	}
}
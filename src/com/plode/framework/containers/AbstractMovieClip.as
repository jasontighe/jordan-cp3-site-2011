package com.plode.framework.containers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;

	public class AbstractMovieClip extends MovieClip
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
		
		public function update() : void
		{
			trace('AbstractDisplayContainer.update : NEED TO OVERRIDE');
		}
		
		public function show(dur : Number = .5) : void
		{
			trace('AbstractDisplayContainer.show : NEED TO OVERRIDE');
			
			// TODO - SATURATE COLOR
			
			TweenMax.to(this, dur, { autoAlpha: 1, delay: dur, ease: Strong.easeOut });
		}
		
		public function hide(dur : Number = .5) : void
		{
			trace('AbstractDisplayContainer.hide : NEED TO OVERRIDE');
			
			// TODO DESATURATE
			
			TweenMax.to(this, dur, { autoAlpha: 0, delay: 0, ease: Strong.easeOut });
		}
		
		public function dispose() : void
		{
			trace('AbstractDisplayContainer.dispose : NEED TO OVERRIDE');
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
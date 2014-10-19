package com.jordan.cp.view.welcome {
	import com.jasontighe.containers.DisplayContainer;

	import flash.display.MovieClip;

	/**
	 * @author jsuntai
	 */
	public class AbstractIcon 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon									: MovieClip;
		public var background							: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractIcon() 
		{
			super();
		}
	}
}

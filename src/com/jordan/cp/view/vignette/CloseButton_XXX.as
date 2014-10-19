package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.DisplayContainer;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author jason.tighe
	 */
	public class CloseButton_XXX 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon										: MovieClip;
		public var tf										: TextField;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CloseButton_XXX() 
		{
			super();
			init();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
		}
	}
}

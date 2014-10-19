package com.jordan.cp.view.video 
{

	/**
	 * @author nelson.shin
	 */
	public interface IScenePlayer 
	{
		function pause(blur : Boolean = true) : void;

		function resume() : void;

		function restart() : void;

		function get isPaused() : Boolean;

	}
}

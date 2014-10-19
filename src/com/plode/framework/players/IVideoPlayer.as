package com.plode.framework.players {
	/**
	 * @author nelson.shin
	 */
	public interface IVideoPlayer {
		
		function loadVideo(path : String) : void;

		function setTime(seekTime : Number, autoPlay : Boolean = true) : void;

		function play() : void;

		function pause() : void;

		function restart() : void;

		function clear() : void;

	}
}

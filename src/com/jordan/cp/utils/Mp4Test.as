package com.jordan.cp.utils 
{
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import com.plode.framework.containers.AbstractDisplayContainer;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author nelson.shin
	 */
	public class Mp4Test extends AbstractDisplayContainer 
	{
		public function Mp4Test()
		{
			setup();
		}
		
		override public function setup() : void
		{
			var path : String = 'http://cp.dev.nyc.wk.com/player/video/zip/cp_img_array_mp4.zip';
			var zip : FZip = new FZip();
			zip.addEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.addEventListener(Event.COMPLETE, onComplete);
			zip.load(new URLRequest(path));
		}

		private function onProgress(event : ProgressEvent) : void 
		{
			trace('LOADING:', Math.round(event.bytesLoaded/event.bytesTotal * 100));
		}

		private function onComplete(evt : Event) : void 
		{
			var zip : FZip = evt.target as FZip;
			var len : uint = zip.getFileCount();
			var file : FZipFile;
			var items : Array = new Array();

			for ( var i : uint = 0; i < len; i++)
			{
				file = zip.getFileAt(i);
				items.push(file.content);
			}
			
			attachVideo(items[i]);

			// DISPOSE OF ZIP OBJECT
			zip.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.removeEventListener(Event.COMPLETE, onComplete);
			zip.close();
			zip = null;
		}

		private function attachVideo(items : ByteArray) : void 
		{
			
		}
	}
}

package com.jordan.cp.utils 
{
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.unitzeroone.WebPLib;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author nelson.shin
	 */
	public class WebPTest extends AbstractDisplayContainer 
	{
//	    private const WebPImageClass:Class;
	    
		public function WebPTest()
		{
			setup();
		}
		
		override public function setup() : void
		{
	        WebPLib.init();//Only needs to be called once.

//			var ldr : URLLoader = new URLLoader();
//			ldr.dataFormat = URLLoaderDataFormat.BINARY;
//			ldr.addEventListener(Event.COMPLETE, onLoaded);
//			ldr. load(new URLRequest('http://cp.dev.nyc.wk.com/dev/flash/zip/test.webp'));

			var zip : FZip = new FZip();
			zip.addEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.addEventListener(Event.COMPLETE, onComplete);
			zip.load(new URLRequest('http://c827809.r9.cf2.rackcdn.com/webp_75.zip'));
		}

		private function onLoaded(e : Event) : void 
		{
//			trace('onLoadComplete', e.currentTarget.content as DisplayObject);
			var info : URLLoader = e.target as URLLoader;
//			trace('info.bytes', info.bytes)
//			e.stopPropagation();
			var bitmapData:BitmapData = WebPLib.decode(info.data as ByteArray);
	        addChild(new Bitmap(bitmapData));
			
		}

		private function onProgress(event : ProgressEvent) : void 
		{
			trace(Math.round(event.bytesLoaded/event.bytesTotal * 100));
		}

		private function onComplete(evt : Event) : void 
		{
			var zip : FZip = evt.target as FZip;
			
			parseZip(zip);
		}

		private function parseZip(zip : FZip) : void 
		{
			var len : uint = zip.getFileCount();
			var file : FZipFile;

			var items : Array = new Array();

			for ( var i : uint = 0; i < len; i++)
			{
				file = zip.getFileAt(i);
				
				var filename : String = file.filename;
				trace("WebPTest.parseZip(zip) : filename: " + (filename));

//				var ldr : Loader = new Loader();
//				ldr.loadBytes(file.content);

		        var bitmapData:BitmapData = WebPLib.decode(file.content as ByteArray);
//		        addChild(new Bitmap(bitmapData));

				items.push({filename: file.filename, bitmap: new Bitmap(bitmapData)} );
			}

			addChild(items[len-1].bitmap);

			// DISPOSE OF ZIP OBJECT
			zip.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			zip.removeEventListener(Event.COMPLETE, onComplete);
			zip.close();
			zip = null;
		}

	}
}

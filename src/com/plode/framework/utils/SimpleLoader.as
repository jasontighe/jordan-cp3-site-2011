package com.plode.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class SimpleLoader extends EventDispatcher
	{
		private var _loaded : DisplayObject;
		
		public function SimpleLoader()
		{
		}
		
		public function load(path : String) : void
		{
//			trace('\n\n\n\n LOAD!', path);
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.INIT, onLoadInit);//, false, 0, true );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoadError, false, 0, true );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoadProgress, false, 0, true );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete, false, 0, true );
			loader.load(new URLRequest(path));
		}

	
		private function onLoadInit(e:Event):void 
		{
//			trace("onLoaderInit: " + e);
			e.target.removeEventListener(Event.INIT, onLoadInit);
			e.stopPropagation();
		}
		
		private function onLoadError(e:IOErrorEvent):void 
		{
//			trace('onLoadError', e);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			e.stopPropagation();
			dispatchEvent(e);
		}			

		private function onLoadProgress(e : ProgressEvent) : void
		{
//			trace("onLoadProgress : bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
		}
		
		private function onLoadComplete(e : Event) : void
		{
//			trace('onLoadComplete', e.currentTarget.content as DisplayObject);
			var info : LoaderInfo = e.target as LoaderInfo;
			info.removeEventListener( Event.COMPLETE, onLoadComplete );
			e.stopPropagation();

			_loaded = info.content as DisplayObject;
			dispatchEvent(e);
		}
		

		
		
		public function get loaded() : DisplayObject
		{
			return _loaded;
		}
	
	}
}
package com.plode.framework.controllers
{
	
	import com.plode.framework.models.AbstractSlideshowModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AbstractSlideshowController extends EventDispatcher
	{
		protected var _slideM : AbstractSlideshowModel;
		
		public function AbstractSlideshowController(m : AbstractSlideshowModel)
		{
			_slideM = m;
		}
		
		public function updateModelIndex(pol : int) : void
		{
			var tarInd : int = _slideM.currentIndex + pol;
			
			if(tarInd > _slideM.items.length - 1)
			{
				tarInd = 0;
			}
			else if(tarInd < 0)
			{
				tarInd = _slideM.items.length -1;
			}

			_slideM.nextIndex = tarInd;
		}

	
		public function checkArrows() : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose() : void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	
	}
}

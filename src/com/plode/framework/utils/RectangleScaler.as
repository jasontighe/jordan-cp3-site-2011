package com.plode.framework.utils 
{
	import flash.display.DisplayObject;

	/**
	 * @author nelson.shin
	 */
	public class RectangleScaler 
	{
		public static function scale(obj : DisplayObject, tarW : int, tarH : int, minW : int = 0, minH : int = 0, maxW : int = 0, maxH : int = 0) : void
		{
			// ARBITRARY MINIMUM
//			var minW : int = 800;
//			var minH : int = Math.ceil(minW / obj.width * obj.height);

			var aspectRatio : Number = obj.width / obj.height;

			if(tarW > maxW && maxW > 0) tarW = maxW;
			if(tarH > maxH && maxH > 0) tarH = maxH;

			if(tarW / tarH >= aspectRatio) 
			{
	          	// STRETCH WIDTH
				obj.width = Math.max(minW, tarW);
				obj.scaleY = obj.scaleX;
			}
			else
			{				
	          	// STRETCH HEIGHT
				obj.height = Math.max(minH, tarH);
				obj.scaleX = obj.scaleY;
			}
		}
	}
}

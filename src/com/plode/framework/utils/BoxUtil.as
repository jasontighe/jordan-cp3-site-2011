package com.plode.framework.utils 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author nelson.shin
	 */
	public class BoxUtil extends Sprite 
	{
		public function BoxUtil()
		{
		}

		public static function getBox(w : uint = 200, h : uint = 200, color : uint = 0xff0000, fillAlpha : Number = 1) : Sprite
		{
			var box : Sprite = new Sprite();
			box.graphics.clear();
			box.graphics.beginFill(color, fillAlpha);
			box.graphics.drawRect(0, 0, w, h);
			
			return box;
		}
		
		public static function getRoundBox(w : uint = 200, h : uint = 200, corner : Number = 15, color : uint = 0xff0000, fillAlpha : Number = 1) : Sprite
		{
			var box : Sprite = new Sprite();
			box.graphics.clear();
			box.graphics.beginFill(color, fillAlpha);
			box.graphics.drawRoundRect(0, 0, w, h, corner, corner);
			
			return box;
		}
		
		public static function getGradientBox(w : uint = 200, h : uint = 200, color : uint = 0xff0000, vignette : Boolean = false, start : Number = 0, finish : Number = 1) : Sprite
		{
			var box : Sprite = new Sprite();
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(w * 2, h * 2, 0, -w/2, -h/2);
			box.graphics.clear();
			if(vignette)
			{
				box.graphics.beginGradientFill(GradientType.RADIAL, [color, color, color], [start, .7, finish], [0,180,255], matrix );
			}
			else
			{
				box.graphics.beginGradientFill(GradientType.RADIAL, [color, color, color], [finish, .3, start], [100,110,130], matrix );
			}
			box.graphics.drawRect(0, 0, w, h);

			return box;
		}
	}
}

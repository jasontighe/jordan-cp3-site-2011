package com.jordan.cp.view.threeD 
{
	import com.plode.framework.utils.BitmapConverter;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MovieMaterial;

	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Sprite2D;

	import com.plode.framework.containers.AbstractDisplayContainer;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.NetStream;
	import flash.ui.Keyboard;

	/**
	 * @author nelson.shin
	 * 
	 * map rtmp texture to Five3d plane
	 * 
	 */

	
	public class Five3dPlane extends AbstractDisplayContainer
	{
		private var _holder : Sprite;

		private var _scene3d : Scene3D;

		private var _movieMat : Sprite;

		private var _lastKey : uint;
		private var _keyIsDown : Boolean = false;

		public static const CAM_Z : Number = -360;
		public static const CAM_ZOOM : Number = 4.5;
		// THIS IS UP/DOWN PANNING
		public static const PAN_LIM_X : Number = 30;
		// THIS IS L/R PANNING
		public static const PAN_LIM_Y : Number = 23;
		public static const BEND_FORCE : Number = -.5;

		
		//-----------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//-----------------------------------------------------
		public function update() : void
		{
			var plane : Sprite2D = _scene3d.getChildByName('box') as Sprite2D;
			
			if(_keyIsDown)
			{
				// if the key is still pressed, just keep on moving
				switch(_lastKey)
				{
                	// PAN CAMERA
					case Keyboard.UP	: 
						plane.rotationX += 5;
						plane.y -= 5;
						break;

					case Keyboard.DOWN	: 
						plane.rotationX -= 5;
						plane.y += 5;
						break;

					case Keyboard.LEFT	: 
						plane.rotationY += 5;
						plane.x += 5;
						break;

					case Keyboard.RIGHT	: 
						plane.rotationY -= 5;
						plane.x -= 5;
						break;


						
					// CAMERA Z POS	
					case 87	: 
						// W
						plane.scaleX += .1;
						plane.scaleY += .1;
						break;

					case 83	: 
						// S
						plane.scaleX -= .1;
						plane.scaleY -= .1;
						break;



					// ZOOM
					case 75	:
						// K - in
						takeScreenshot();
						break;
						
					case 76	:
						// J - out
						break;						
				}
			}
		}

		public function takeScreenshot() : void 
		{
			var plane : Sprite2D = _scene3d.getChildByName('box') as Sprite2D;
			var bmp : Bitmap = BitmapConverter.getBmp(plane);
			
			bmp.scaleX = 2;
			
			trace("Five3dPlane.takeScreenshot()", bmp.width);
			addChild(bmp);
			
		}
		
		public function get plane() : Sprite2D
		{
			return _scene3d.getChildByName('box') as Sprite2D;
		}

		
		//-------------------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------------------
		private function setup3D() : void 
		{
			_holder = new Sprite();
			addChild(_holder);

			_scene3d = new Scene3D();

			var box : Sprite2D = new Sprite2D();
			box.name = 'box';
			box.graphics.beginFill(0xAF0000);
			box.graphics.drawRect(-720, -360, 1440, 720);
			box.graphics.endFill();
			box.buttonMode = true;
			box.useHandCursor = true;
//			_movieMat.x = -275;
//			_movieMat.y = -200;
			box.addChild(_movieMat);
			
			
//			_scene3d.x = 275;
//			_scene3d.y = 200;
			_scene3d.addChild(box);
			_holder.addChild(_scene3d);
			
			takeScreenshot();

//			_scene3d.getChildByName('box').rotationY = 5;

			
//			update();
//
//			addEventListeners();
		}

		override protected function addEventListeners() : void
		{
			// listen for key events and run every frame
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.addEventListener(Event.ENTER_FRAME, onEF);
		}

		
		
		//-------------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onEF(e : Event) : void 
		{
			update();
		}

		private function onKeyDown(e : KeyboardEvent) : void
		{
			trace('test', e.keyCode);
			_lastKey = e.keyCode;
			_keyIsDown = true;
		}

		private function onKeyUp(e : KeyboardEvent) : void
		{
			_keyIsDown = false;
		}

		
		
		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function set movieMat(value : Sprite) : void
		{
			_movieMat = value;
			if(!_holder) setup3D();
		}


	}
}


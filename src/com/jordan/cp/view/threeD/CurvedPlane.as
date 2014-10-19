package com.jordan.cp.view.threeD 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.View3D;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.VideoMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Trident;

	import com.as3dmod.ModifierStack;
	import com.as3dmod.modifiers.Bend;
	import com.as3dmod.plugins.away3d.LibraryAway3d;
	import com.jordan.cp.players.TimeTracker;
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
	 * Create a curved plane object:
	 * - bitmap or video textures can be assigned
	 * - camera properties/controls are exposed
	 * 
	 */



	public class CurvedPlane extends AbstractDisplayContainer
	{
		private var _holder : Sprite;

		private var _cam : Camera3D;
		private var _hcam : HoverCamera3D;
		private var _viewport : View3D;
		private var _plane : Plane;
		private var _stack : ModifierStack;
		private var _bend : Bend;

		private var _stream : NetStream;
		private var _movieMat : Sprite;
		private var _bmp : Bitmap;

		private var _lastKey : uint;
		private var _keyIsDown : Boolean = false;
		
		public static const CAM_Z : Number = -90;//-360;
		public static const CAM_ZOOM : Number = 1;//405;
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
		public function CurvedPlane() 
		{
		}

		public function update() : void
		{
			if(_keyIsDown)
			{
				// if the key is still pressed, just keep on moving
				switch(_lastKey)
				{


                	// PAN CAMERA
					case Keyboard.UP	: 
//						if(_cam.rotationX > -7)
//	                    	_cam.rotationX -= 1;
	                    	_cam.y -= 3;
						_hcam.tiltAngle -= 5;
						break;
					case Keyboard.DOWN	: 
//						if(_cam.rotationX < 7)
//	                    	_cam.rotationX += 1;
	                    	_cam.y += 3;
						_hcam.tiltAngle += 5; 
						break;
					case Keyboard.LEFT	: 
//						if(_cam.rotationY > -30)
	                    	_cam.rotationY -= 1;
						_hcam.panAngle -= 5;
						break;
					case Keyboard.RIGHT	: 
//						if(_cam.rotationY < 30)
	                    	_cam.rotationY += 1;
						_hcam.panAngle += 5; 
						break;
						
						
						
					// CURL	
					case 65	: 
						// A
						_bend.force += .01;
						_stack.apply();
						trace('_bend', _bend.force);
						break;
					case 68	: 
						// D
						_bend.force -= .01;
						_stack.apply();
						trace('_bend', _bend.force);
						break;
						
						
						
					// CAMERA Z POS	
					case 87	: 
						// W
						_cam.z += 5; 
						_hcam.zoom += 0.3; 
						break;
					case 83	: 
						// S
//						if(_cam.z > 630)
	                    	_cam.z -= 5;
						if(_hcam.zoom > 1.4)
						{
							_hcam.zoom -= 0.3;
						} 
						break;



					// ZOOM
					case 75	:
						// K - in
						_cam.zoom -= .1;
						break;
						
					case 76	:
						// J - out
						_cam.zoom += .1;
						break;						





				}

			}
            
//			_viewport.x = TimeTracker.gi.masterStage.stageWidth/2;
//			_viewport.y = TimeTracker.gi.masterStage.stageHeight/2;

			// render the view
			_hcam.hover();
			_viewport.render();
			
			// CENTER CONTENT
//			_holder.x = _holder.y = -25; // HALF THE SIZE OF THE CUBE OR MAIN OBJECT



				trace('\n\n\n----------------------------------------------------------');
				//				trace('_hcam.tiltAngle: ' + (_hcam.tiltAngle)); 
				//				trace('_hcam.zoom: ' + (_hcam.zoom));
				//				trace('_hcam.panAngle: ' + (_hcam.panAngle)); 
				trace('_cam.x: ' + (_cam.x)); 
				trace('_cam.y: ' + (_cam.y)); 
				trace('_cam.z: ' + (_cam.z)); 
				trace('_cam.zoom: ' + (_cam.zoom)); 
				trace('_cam.rotationX: ' + (_cam.rotationX)); 
				trace('_cam.rotationY: ' + (_cam.rotationY)); 
				trace('_cam.rotationZ: ' + (_cam.rotationZ)); 
				trace('_holder.x: ' + (_holder.x)); 
				trace('_holder.y: ' + (_holder.y)); 
				trace('_holder.width: ' + (_holder.width)); 
				trace('_holder.height: ' + (_holder.height)); 

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

//			var mat : BitmapMaterial = new BitmapMaterial(Cast.bitmap(_bmp));
//			var w : Number = _bmp.width;
//			var h : Number = _bmp.height;

			


			// FLAT TEST MATERIAL
//			var mat : WireframeMaterial = new WireframeMaterial();
//			mat.thickness = 2;
//			mat.wireAlpha = 1;
//			mat.wireColor = 0xff0000;
			
			// STREAM-BASED VIDEO MATERIAL
//			var mat : VideoMaterial = new VideoMaterial();
//			mat.interactive = true;
//			mat.autoUpdate = true;
//			mat.smooth = true;
//			mat.netStream = _stream;
//			var w : Number = 1440;
//			var h : Number = 720;
			
			// SWF-BASED VIDEO MATERIAL
			var mat : VideoMaterial = new VideoMaterial(_movieMat);
			mat.interactive = true;
			mat.autoUpdate = true;
			mat.smooth = true;
//			var w : Number = _movieMat.width;
//			var h : Number = _movieMat.height;
			

var cube : Cube = new Cube();
cube.width = cube.height = cube.depth = 500;
//cube.material = mat;
//cube.rotationX = 10;
//cube.rotationY = 10;
//cube.rotationZ = 10;
			
//			var axis : Trident = new Trident(Math.max(StreamSwapper.W, StreamSwapper.H), true);
			var axis : Trident = new Trident(500, true);
//			axis.rotationX = 15;
//			axis.rotationY = 15;
//			axis.rotationZ = 15;

			_plane = new Plane();
			_plane.width = 500;// StreamSwapper.W;
			_plane.height = 500;// StreamSwapper.H;
			_plane.segmentsH = 5;
			_plane.segmentsW = 5;
			_plane.material = mat;
			_plane.rotationX = 90;
			_plane.rotationY = 0;
			_plane.rotationZ = 0;
			//			_plane.invertFaces();
			//			_plane.scaleX = -1;
			_plane.bothsides = true;
			
			_cam = new Camera3D();
			_cam.z = CAM_Z;
			_cam.zoom = CAM_ZOOM;
//			_cam.x = -100;
//			_cam.y = 180;
			//			_cam.x = 200;
//						_cam.rotationX = 50;
			//			_cam.rotationY = 50;
			//			_cam.rotationZ = 50;
			//			_cam.hover(true);
			//			_cam.zoom = 4;

			_hcam = new HoverCamera3D();
			_hcam.z = 5000;
			_hcam.panAngle = -180;
			_hcam.tiltAngle = 0;
			_hcam.zoom = 6;

			_viewport = new View3D({camera:_cam});
			_viewport.scene.addChild(_plane);
_viewport.scene.addChild(cube);
_viewport.scene.addChild(axis);
			//			_viewport.camera.moveTo(150, 150, 150);
			//			_viewport.camera.moveBackward(1);

			//			_holder.x = -1 * w / 2;
			//			_holder.y = -1 * h / 2;
			_holder.addChild(_viewport);

			

			// CREATE ModifierStack FOR BENDING
			_stack = new ModifierStack(new LibraryAway3d(), _plane);
			// BEND PARAMS (FORCE, OFFSET)
			// - FORCE: 0 TO 2 == 0 TO 360
			// - OFFSET: 0 TO 1; THE CENTER POINT OF BEND
			_bend = new Bend(BEND_FORCE, .5);
			_stack.addModifier(_bend);
			_stack.apply();
			
			update();

			trace("CurvedPlane.setup3D()");
			trace('TESTING : _holder.wicth', _holder.width, _viewport.width, _viewport.x);
			addEventListeners();
		}

		override protected function addEventListeners() : void
		{
			// listen for key events and run every frame
//			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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
		public function set stream(value : NetStream) : void
		{
			_stream = value;

			var mat : VideoMaterial = new VideoMaterial();
			mat.interactive = true;
			mat.smooth = true;
			mat.netStream = _stream;
			
			// FLAT TEST MATERIAL
//			var mat : WireframeMaterial = new WireframeMaterial();
//			mat.thickness = 2;
//			mat.wireAlpha = 1;
//			mat.wireColor = 0xff0000;

			if(!_holder)
			{
				setup3D();
			}
			else
			{
				_plane.material = mat;
			}
		}

		public function set movieMat(value : Sprite) : void
		{
			_movieMat = value;
			
			var mat : VideoMaterial = new VideoMaterial(value);
			mat.interactive = true;
			mat.smooth = true;
			
			if(!_holder)
			{
				setup3D();
			}
			else
			{
				_plane.material = mat;
			}
			update();
		}

		public function set bmp(value : Bitmap) : void
		{
			_bmp = value;
			var mat : BitmapMaterial = new BitmapMaterial(Cast.bitmap(_bmp));
			mat.smooth = true;
			
			if(!_holder)
			{
				setup3D();
			}
			else
			{
				_plane.material = mat;
			}

		}

		public function get camRx() : Number
		{
			return _cam.rotationX || 0;
		}

		public function set camRx(value : Number) : void
		{
			_cam.rotationX = value;
		}

		public function get camRy() : Number
		{
			return _cam.rotationY || 0;
		}

		public function set camRy(value : Number) : void
		{
			_cam.rotationY = value;
		}

		public function get camY() : Number
		{
			return _cam.y || 0;
		}

		public function set camY(value : Number) : void
		{
			_cam.y = value;
		}		

		public function get camZ() : Number
		{
			return _cam.z || 0;
		}

		public function set camZ(value : Number) : void
		{
			_cam.z = value;
		}		
	}
}


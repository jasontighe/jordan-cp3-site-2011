package com.jordan.cp.view.error 
{
	import com.jordan.cp.Shell;
	import com.jordan.cp.managers.ConnectionErrorManager;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.utils.BoxUtil;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;	

	/**
	 * @author nelson.shin
	 */
	public class ConnectionErrorOverlay extends AbstractDisplayContainer 
	{
		private var _cem : ConnectionErrorManager = ConnectionErrorManager.gi;
		private var _bg : Sprite;
		private var _pinwheel : ErrorPinwheel;

		public function ConnectionErrorOverlay()
		{
			setup();
		}
		
		override public function setup() : void
		{
			_cem.addEventListener(ConnectionErrorManager.SHOW_PINWHEEL, onShowPinwheel);
			_cem.addEventListener(ConnectionErrorManager.HIDE_PINWHEEL, onHidePinwheel);

			_bg = BoxUtil.getBox(w, h, 0x000000, .4);

			resize();

			addChild(_bg);
			
			hide();
		}

		public function resize() : void 
		{
			_bg.width = w;
			_bg.height = h;
			
			if(_pinwheel)
			{
				_pinwheel.x = Math.round(w/2);
				_pinwheel.y = Math.round(h/2);
			}
		}
		
		//-------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------
		private function setPinwheel() : void 
		{
			if(!_pinwheel) addPinwheel();
			_pinwheel.show();
		}

		private function addPinwheel() : void 
		{
			_pinwheel = new ErrorPinwheel();
			addChild(_pinwheel);

			resize();
		}		
		
		
		
		//-------------------------------------------------------------------------
		//
		// HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onShowPinwheel(event : Event) : void 
		{
			show();
			
			setPinwheel();
		}

		private function onHidePinwheel(event : Event) : void 
		{
			hide();
			if(_pinwheel) _pinwheel.hide();
		}
		
		
		//-------------------------------------------------------------
		//
		// GETTERS
		//
		//-------------------------------------------------------------
		private function get w() : uint
		{
			var masterStage : Stage = Shell.getInstance().masterStage;
			return masterStage.stageWidth;
		}
		
		private function get h() : uint
		{
			var masterStage : Stage = Shell.getInstance().masterStage;
			return masterStage.stageHeight;
		}
		
	}
}

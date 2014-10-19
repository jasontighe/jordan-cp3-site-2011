package com.jordan.cp.model 
{
	import com.jordan.cp.model.dto.HotspotDTO;
	import com.plode.framework.constants.StaticConstants;
	import com.plode.framework.events.ParamEvent;
	import com.plode.framework.utils.XmlLoader;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author nelson.shin
	 * - contains all hotspot xml data for every scene
	 */
	public final class HotspotModel extends EventDispatcher 
	{
		private static var _instance : HotspotModel;
		private var _xml : XML;
		private var _d : Dictionary;
		private var _shortcutsVisible : Boolean;
		public static const TOGGLE_SHORTCUTS : String = "TOGGLE_SHORTCUTS";
		
		public function HotspotModel(se : SingletonEnforcer)
		{
			if( se != null ){
				init();
			}
		}

		public static function get gi() : HotspotModel {
			if( _instance == null ){
				_instance = new HotspotModel( new SingletonEnforcer() );
			}
			return _instance;
		}

		private function init() : void {
		}
				


		//-------------------------------------------------------------------------
		//
		// POPULATE MODEL
		//
		//-------------------------------------------------------------------------
		public function loadXML(path : String) : void
		{
			var ldr : XmlLoader = new XmlLoader(false);
			ldr.addEventListener(StaticConstants.XML_LOADED, onXmlLoaded);
			ldr.loadXml(path);
		}

		private function onXmlLoaded(event : ParamEvent) : void 
		{
			_xml = event.params.xml;
			parse();
		}
		
		private function parse() : void 
		{
//			trace("HotspotModel.parse()", _xml);


			// ORGANIZE HOTSPOT CONTENT
			var contents : Dictionary = new Dictionary();

			for each(var hotspot : XML in _xml..hotspot)
			{
				var id : String = hotspot.@name.toString();
				if(!contents[id])
				{
					contents[id] = hotspot;
				}
			}


			// TODO - SORT BY
			// 1 - CAMERA
			// 2 - LAYER (Hotspot Target)
			// 3 - KEYFRAME
			// 4 - PROPS
			
			
			_d = new Dictionary();
			var sceneId : String;
			var camId : Number;
			var objId : String;
			var camDict : Dictionary;
			var objDict : Dictionary;
			var hotspotDict : Dictionary;
			var dto : HotspotDTO;
			
			for each(var scene : XML in _xml..scene)
			{
				// LOOP THROUGH EACH SCENE
				sceneId = scene.@name.toString();
				camDict = new Dictionary();
				
				for each(var cam : XML in scene..camera)
				{
					// LOOP THROUGH EACH CAMERA/ANGLE
					// camId : 00 - 16
					camId = Number(cam.@name.toString());
					objDict = new Dictionary();

					for each(var layer : XML in cam..layer)
					{
						// LOOP THROUGH EACH TARGET OBJECT
						objId = layer.@name.toString();
						hotspotDict = new Dictionary();
						
						for each(var keyframe : XML in layer..keyframe)
						{
							// LOOP THROUGH EACH HOTSPOT
							dto = new HotspotDTO();
							// ADD CONTENT NODE TO PARSE IN DTO
							dto.populate(contents[objId]);
							dto.start = Number(keyframe.@time.toString());
							// !!!MAINTAIN THIS ORDER OF PROPERTY ASSIGNMENT
							// - X & Y RELY ON W & H VALUES!!!
							dto.w = Number(keyframe..property.(attribute('name') == 'Scale').@value0.toString());
							dto.h = Number(keyframe..property.(attribute('name') == 'Scale').@value1.toString());
							dto.x = Number(keyframe..property.(attribute('name') == 'Position').@value0.toString());
							dto.y = Number(keyframe..property.(attribute('name') == 'Position').@value1.toString());
//							dto.preview();
							
							hotspotDict[dto.start] = dto;
						}
						
						objDict[objId] = hotspotDict;
					}
					
					camDict[camId] = objDict;
				}
				
				_d[sceneId] = camDict;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function get d() : Dictionary
		{
			return _d;
		}
		
		public function set xml( val : XML) : void
		{
			_xml = val;
			parse();
		}

		public function toggleShortcut() : void 
		{
			_shortcutsVisible = !_shortcutsVisible;
			dispatchEvent(new Event(TOGGLE_SHORTCUTS));
		}
		
		public function get shortcutsVisible() : Boolean
		{
			return _shortcutsVisible;
		}
	}
}

class SingletonEnforcer {}
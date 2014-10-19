package com.jordan.cp.utils 
{
	import com.plode.framework.constants.StaticConstants;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.events.ParamEvent;
	import com.plode.framework.utils.XmlLoader;
	
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;	

	/**
	 * @author nelson.shin
	 */
	public class XmlFormatter extends AbstractDisplayContainer 
	{
		private var _tf : TextField;
		private var _masterPath : String;
		private var _sourcePath : String;
		private var _masterXML : XML;
		private var _sourceXML : XML;
		private var _targetId : String;
		private var _targetIndex : String;
		private var _remove : Boolean;
		private var _showLoaderTraces : Boolean = false;
		
		private static const CONFIG_XML_PATH : String = '../xml/xml_formatter_config.xml';

		public function XmlFormatter()
		{
			setup();
		}
		
		override public function setup() : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.setup()");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			_tf = new TextField();
			_tf.selectable = true;
			_tf.width = 300;
			_tf.height = 600;
			_tf.border = true;
			addChild(_tf);
			
			var ldr : XmlLoader = new XmlLoader(_showLoaderTraces);
			ldr.addEventListener(StaticConstants.XML_LOADED, onConfigLoaded);
			ldr.loadXml(CONFIG_XML_PATH);
		}

		private function onConfigLoaded(event : ParamEvent) : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.onConfigLoaded(event)");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			var xml : XML = event.params.xml;
			
			_masterPath = xml..url.(attribute('id') == 'master').@path.toString();
			_sourcePath = xml..url.(attribute('id') == 'source').@path.toString();
			_targetId = xml.target..@id.toString();
			_targetIndex = xml.target..@index.toString();
			_remove = (xml.target..@remove.toString() == 'true');

			var ldr : XmlLoader = new XmlLoader(_showLoaderTraces);
			ldr.addEventListener(StaticConstants.XML_LOADED, onMasterLoaded);
			ldr.loadXml(_masterPath);
		}

		private function onMasterLoaded(event : ParamEvent) : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.onMasterLoaded(event)");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			_masterXML = event.params.xml;
			
			var ldr : XmlLoader = new XmlLoader(_showLoaderTraces);
			ldr.addEventListener(StaticConstants.XML_LOADED, onSourceLoaded);
			ldr.loadXml(_sourcePath);
		}

		private function onSourceLoaded(event : ParamEvent) : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.onSourceLoaded(event)");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			_sourceXML = event.params.xml;

			if(_remove) removeNodes();
			else doConversion();
		}








		private function doConversion() : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.doConversion()");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			var formatted : XML;
			
			formatted = XML(_masterXML..scene.(attribute('name') == 'court').toXMLString( ) );
			
			for each(var node : XML in formatted..camera)
			{
				var cameraID : String = node.@name.toString();

				for each(var newNode : XML in _sourceXML..camera)
				{
					var subCameraID : String = newNode.@name.toString( );
					if(cameraID == subCameraID)
					{
						var layerNode : XML = XML(newNode..layer.(attribute('name') == _targetId).toXMLString());
						if(_targetIndex == '') 
						{
							node.insertChildBefore(null, layerNode);
						}
						else
						{
							var targetChild : Object = node..layer.(attribute('name') == _targetIndex);
							node.insertChildBefore(targetChild, layerNode);
						}
					}
				}
			}
			
			output(formatted);
		}

		private function removeNodes() : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("XmlFormatter.removeNodes()");
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			var formatted : XML = XML(_masterXML..scene.(attribute('name') == 'court').toXMLString( ) );
			
			for each(var node : XML in formatted..camera)
			{
				var cameraIndex : Number = node.childIndex();
				
				for each(var layer : XML in node..layer)
				{
					var layerIndex : Number = layer.childIndex();
					if(layer.@name == _targetId)
					{
						var tarNode : XML = formatted.camera[cameraIndex].layer[layerIndex];
						delete formatted.camera[cameraIndex].layer[layerIndex];
						
					}
				}
			}
			
			output(formatted);
		}









		private function output(formatted : XML) : void 
		{
			_tf.text = formatted.toXMLString();
			
			var fmt : TextFormat = new TextFormat();
			fmt.size = 10;
			
			_tf.setTextFormat(fmt);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(event : MouseEvent) : void
		{
            var ba:ByteArray = new ByteArray();
            ba.writeUTFBytes(_tf.text);

            var fr:FileReference = new FileReference();

            fr.save(ba, "test.xml");
		}
	}
}

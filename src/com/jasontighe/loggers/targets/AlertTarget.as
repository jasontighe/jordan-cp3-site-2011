package com.jasontighe.loggers.targets {	import flash.external.ExternalInterface;	import flash.system.Capabilities;		import com.jasontighe.loggers.LevelObject;	import com.jasontighe.loggers.TargetCreator;	import com.jasontighe.loggers.targets.ILoggerTarget;		/**	 * <p>Allows logging to the firebug web console. Also works with the Safari developer error console.</p>	 * 	 * @author Ronnie Liew, Antti Kupila	 */	// TODO: As this works with Safari too, the name probably should be changed?	public class AlertTarget extends AbstractLoggerTarget implements ILoggerTarget 	{		//---------------------------------------------------------------------		//		//  Constants		//		//---------------------------------------------------------------------				//---------------------------------------------------------------------		//		//  Constructor		//		//---------------------------------------------------------------------				public function AlertTarget() 		{			// Do nothing		}		//---------------------------------------------------------------------		//		//  Public Methods		//		//---------------------------------------------------------------------						/**		 * <p>Published a log item in the console. If this is not possible it automatically falls back to a basic trace</p>		 */		override public function publish(levelObject:LevelObject, obj:*):void 		{			if ( checkLevel( levelObject ) ) return;			if ( checkFilter( obj ) ) return;			obj = checkFormat( obj );			var message:String = levelObject.level.toUpperCase( ) + " : " + obj.toString( );			if ( ExternalInterface.available && Capabilities.playerType == "PlugIn" )				ExternalInterface.call( "alert", ( obj.toString == null ) ? obj : message );			else trace( message ); // better than nothing .. 		}		override public function get id():String 		{						return TargetCreator.ALERT;		}	}}
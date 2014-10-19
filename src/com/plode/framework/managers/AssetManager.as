package com.plode.framework.managers
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/*
	 * 
	 * 
	 * USAGE: 
	 * 1) add preloaded asset swfs
	 * 	  - AssetManager.gi.add(ASSET_GROUP_ID, LOADED_MC); 
	 * 
	 * 2) retrieve asset
	 * 	  - AssetManager.gi.getAsset(LINKAGE_ID, ASSET_GROUP_ID);
	 * 
	 * 
	 */
	 
	public class AssetManager
	{
		private static var _instance : AssetManager;
		private var _d : Dictionary;
		
		public function AssetManager(e : AssetManagerEnforcer)
		{
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function add(id : String, asset : MovieClip) : void
		{
			if(!_d) _d = new Dictionary();
			if(!_d[id])
			{
				_d[id] = asset;
			}
			else new Error('THIS ASSET HAS ALREADY BEEN ADDED');
		}

		//----------------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public static function get gi() : AssetManager
		{
			if(!_instance) _instance = new AssetManager(new AssetManagerEnforcer());
			return _instance;
		}
		
		public function getAsset(linkage : String, assetId : String = 'assets') : Sprite
		{
			var c : Class = (_d[assetId] as MovieClip).loaderInfo.applicationDomain.getDefinition(linkage) as Class;
			return Sprite(new c());
		}
	
	}
}

class AssetManagerEnforcer{}
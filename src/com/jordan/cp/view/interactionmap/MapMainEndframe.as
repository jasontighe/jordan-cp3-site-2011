package com.jordan.cp.view.interactionmap 
{	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	/**	 * @author ns	 */	public class MapMainEndframe extends AbstractDisplayContainer 
	{
		private var _holder : Sprite;
		private var _asset : MovieClip;
		private var _header : TextContainer;
		private var _desc : TextContainer;
		private var _replay : MapMainEndFrameButton;
		private var _resolve : MapMainEndFrameButton;		private var _t : Timer;		
		public static const SHOW_RESOLVE : String = 'SHOW_RESOLVE';
		public static const REPLAY : String = 'REPLAY';
		private static const TIMER_DELAY : Number = 7000;

		public function MapMainEndframe()
		{
			setup();		}
		
		public function reveal(zoomUnlocked : Boolean) : void 
		{
			if(zoomUnlocked && _asset.visible) hidePanel();
			show();
			
			startTimer();

			TrackingManager.gi.trackPage(TrackingConstants.INTERSTITIAL_SCREEN);
		}
		
		override public function setup() : void
		{
			_holder = new Sprite();
			addChild(_holder);

			_asset = AssetManager.gi.getAsset('InterstitialFrameAsset', SiteConstants.ASSETS_ID) as MovieClip;

			var s : String = 'REAL-TIME UNLOCKED';
			_header = new TextContainer();
			_header.populate(s, 'interstitial-header');
			_header.x = -Math.round(_header.width/2);
			_header.y = -(Math.round( _asset.height/4 - _header.height/2)) + 10;
			
			var spacebarId : String = "end-spacebar";
			var spacebarTxt : String = ContentModel.gi.getCopyDTOByName( spacebarId ).copy as String;
//			s = 'HIT "SPACEBAR" TO SEE WHAT "ITS LIKE TO' + "GUARD IN REAL-TIME";
			_desc = new TextContainer();
			_desc.tf.width = _asset.width;
			_desc.populate( spacebarTxt, 'interstitial-body', true);
			_desc.x = -Math.round(_desc.width/2);
			_desc.y = _header.y + _header.height + 10;

			_asset.addChild(_header);
			_asset.addChild(_desc);
			
			_replay = new MapMainEndFrameButton();
			_replay.addViews( 'CONTINUE EXPLORING' );
			_replay.activate();
			_replay.addEventListener( Event.COMPLETE, onReplay );
			_replay.x = -Math.round(_replay.width/2) + 8;
			_replay.y = _header.y - 120;

			_resolve = new MapMainEndFrameButton();
			_resolve.addViews( 'GAME SUMMARY' );
			_resolve.activate();
			_resolve.addEventListener( Event.COMPLETE, onResolve );
			_resolve.x = -Math.round(_resolve.width/2) + 8;
			_resolve.y = _replay.y + 50;
			
			_holder.addChild(_asset);
			_holder.addChild(_replay);
			_holder.addChild(_resolve );
			
			_holder.y = 50;		}

		override public function hide(dur : Number = .5, del : Number = 0) : void
		{
			super.hide(dur, del);
			stopTimer();
		}
		
		public function checkTimer() : void
		{
			// if overlay, stop timer and hide overlay
			if(visible) hide();
		}
		
		
		//-------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------
		private function hidePanel() : void
		{
			_asset.visible = false;

			_holder.y = 150;
		}
		
		private function startTimer() : void
		{
			if(!_t)
			{
				_t = new Timer(TIMER_DELAY);
				_t.addEventListener(TimerEvent.TIMER, onTimer );
			}
			_t.start();
		}
		
		private function stopTimer() : void
		{
			if(_t) _t.stop();
		}

		private function onTimer(event : TimerEvent) : void
		{
//			stopTimer();
//			hide();
			dispatchEvent(new Event(Event.COMPLETE) );
		}
		
		
		
		
		//-------------------------------------------------------------
		//
		// HANDLERS
		//
		//-------------------------------------------------------------
		private function onResolve(event : Event) : void
		{
			dispatchEvent(new Event(SHOW_RESOLVE));

			TrackingManager.gi.trackCustom(TrackingConstants.INTERSTITIAL_GAME_SUMMARY );
		}

		private function onReplay(event : Event) : void
		{
			dispatchEvent(new Event(REPLAY ) );

			TrackingManager.gi.trackCustom(TrackingConstants.INTERSTITIAL_CONTINUE );
		}
		
	}}
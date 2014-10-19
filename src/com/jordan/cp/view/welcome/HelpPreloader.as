package com.jordan.cp.view.welcome {
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.view.events.ViewEvent;
	import com.jordan.cp.view.vignette.AbstractExitButton;
	import com.plode.framework.containers.AbstractDisplayContainer;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.events.ParamEvent;
	import com.plode.framework.managers.AssetManager;
	import com.plode.framework.utils.BoxUtil;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author nelson.shin
	 */

	public class HelpPreloader extends AbstractDisplayContainer 
	{
		private var _am : AssetManager = AssetManager.gi;
		
		private var _headerHolder : Sprite;
		private var _holder : Sprite;
		private var _masker : Sprite;

		private var _iconTime : MovieClip;
		private var _iconZoom : MovieClip;
		private var _iconCamera : MovieClip;

		private var _panelDiv : MovieClip;
		private var _panelAngles : MovieClip;
		private var _panelTime : MovieClip;
		private var _panelZoom : MovieClip;
		private var _panelStart : MovieClip;

		private var _txtTitle : TextContainer;
		private var _txtDesc : TextContainer;
		private var _txtIcon : TextContainer;
		private var _txtLoading : TextContainer;

		private var _cta : AbstractExitButton;
		private var _replayBtn : Sprite;
		private var _progressDots : HelpPreloaderProgressView;

		private var _t : Timer;
		private var _sequence : Array;
		private var _ind : uint;
		private var _startPercent : Number = 0;
		private var _percent : Number;
		private var _tweenDur : Number = .6;
		private var _middleY : Number;
		private var _bottomY : Number;
		private var _complete : Boolean;
		private var _sequenceComplete : Boolean = false;

		private static const MAR : Number = 40;
		private static const BG_Y : Number = -20;
		public static const BG_W : Number = 285;
		public static const BG_X : Number = Math.round((471 - BG_W)/2);
		private static const BG_H : Number = 380;
		private static const BG_REDUCED_H : Number = 300;
		private static const BG_MIN_H : Number = 147;
		private static const TOP_MAR : Number = -108;
		private static const TIMER_DELAY : Number = 6000;
		private static const ANIMATION_X : Number = 300;
		
		public static const RESIZE_BG : String = "RESIZE_BG";

		public function HelpPreloader()
		{
			setup();
		}
		
		override public function setup() : void
		{
			_sequenceComplete = Shell.getInstance().instructionsViewed;
			
			_t = new Timer(TIMER_DELAY);
			_t.addEventListener(TimerEvent.TIMER, onTimer);
			
			_sequence = [showAngles, showTime, showZoom, showStart];

			_headerHolder = new Sprite();
			_headerHolder.alpha = 0;
			_headerHolder.visible = false;

			_holder = new Sprite();
			_holder.cacheAsBitmap = true;
			_holder.alpha = 0;
			_holder.visible = false;
			
			_masker = _am.getAsset('IntroHelpMask', SiteConstants.WELCOME_ID);
			_masker.cacheAsBitmap = true;
			_holder.mask = _masker;

			
			_iconCamera = _am.getAsset('introHelpIconCamera', SiteConstants.WELCOME_ID) as MovieClip;
			_iconZoom = _am.getAsset('introHelpIconZoom', SiteConstants.WELCOME_ID) as MovieClip;
			_iconTime = _am.getAsset('introHelpIconTime', SiteConstants.WELCOME_ID) as MovieClip;
			_panelDiv = _am.getAsset('IntroHelpPanelDividers', SiteConstants.WELCOME_ID) as MovieClip;
			_panelAngles = _am.getAsset('IntroHelpPanelAngles', SiteConstants.WELCOME_ID) as MovieClip;
			_panelTime = _am.getAsset('IntroHelpPanelTime', SiteConstants.WELCOME_ID) as MovieClip;
			_panelZoom = _am.getAsset('IntroHelpPanelZoom', SiteConstants.WELCOME_ID) as MovieClip;
			_panelStart = new MovieClip();


			_txtTitle = new TextContainer();
			_txtDesc = new TextContainer();
			_txtIcon = new TextContainer();
			_txtLoading = new TextContainer();
			var loadId : String = "loader-help-percent";
			var loadTxt : String = ContentModel.gi.getCopyDTOByName( loadId ).copy as String;
			_txtLoading.populate(loadTxt, loadId, false, true);


			_cta = new AbstractExitButton();
			var ballInId : String = "loading-ball-in";
			var ballInTxt : String = ContentModel.gi.getCopyDTOByName( ballInId ).copy as String;
			_cta.addViews( ballInTxt );
			_cta.activate();
			_cta.addEventListener( Event.COMPLETE, onCtaClick );
			_cta.visible = false;
			_cta.alpha = 0;

			// SET POSITION MARKERS
			_middleY = _panelDiv.divCenter.y;
			_bottomY= _panelDiv.divBottom.y;

			// SET TEXT WIDTHS
			_txtTitle.tf.width = BG_W - MAR;
			_txtDesc.tf.width = BG_W - MAR;
			_txtLoading.tf.width = BG_W - MAR;
			_txtLoading.tf.height = 40;

			// CENTER TEXT FIELDS HORIZONTALLY
			_txtTitle.x = - _txtTitle.width / 2;
			_txtDesc.x = - _txtDesc.width / 2;
			_txtLoading.x = - _txtLoading.width / 2;

			_progressDots = new HelpPreloaderProgressView();
			_progressDots.populate(_sequence.length - 1 );
			_progressDots.y = TOP_MAR - 110;
			_progressDots.alpha = 0;

			_holder.addChild(_panelAngles);
			_holder.addChild(_panelTime);
			_holder.addChild(_panelZoom);
			_holder.addChild(_panelStart);
			_holder.addChild(_txtIcon);
			
			_headerHolder.addChild(_txtTitle);
			_headerHolder.addChild(_txtDesc);
			_headerHolder.addChild(_iconCamera);
			_headerHolder.addChild(_iconZoom);
			_headerHolder.addChild(_iconTime);

			addChild(_headerHolder);
			addChild(_holder);
			addChild(_masker);
			addChild(_panelDiv);
			addChild(_txtLoading);
			addChild(_cta);
			addChild(_progressDots);
			
			var item : DisplayObject;
			for(var i : uint = 0; i < _holder.numChildren; i++)
			{
				item = _holder.getChildAt(i) as DisplayObject;
				item.visible = false;
			}

			_cta.visible = false;
			_txtLoading.visible = true;
		}

		override public function show(dur : Number = 0, del : Number = 0) : void
		{
			super.show(dur, del);

			ind = 0;
			_t.start();
			
			var tarH : Number = (!_sequenceComplete && complete) ? BG_REDUCED_H : BG_H;
			dispatchEvent(new ParamEvent(RESIZE_BG, {tarY: BG_Y, tarH: tarH}));
			
			TrackingManager.gi.trackPage(TrackingConstants.COURT_LOADED );
		}

		//-------------------------------------------------------------------------
		//
		// PANEL ANIMATIONS
		//
		//-------------------------------------------------------------------------
		private function showAngles() : void
		{
			_panelDiv.divBottom.visible = (_txtLoading.visible || _cta.visible);
			
			_panelDiv.visible = 
			_panelAngles.visible = true;
			_panelTime.visible = false;
			_panelZoom.visible = false;
			_panelStart.visible = false;
			
			_txtTitle.visible = true;
			_txtDesc.visible = true;
			_txtIcon.visible = true;

			_iconCamera.visible = true;
			_iconZoom.visible = 
			_iconTime.visible = false;

			// POPULATE AND POSITION TEXT
			var anglesId : String = "angles_title";
			var anglesTxt : String = ContentModel.gi.getCopyDTOByName( anglesId ).copy as String;
			_txtTitle.populate( anglesTxt, 'loader-help-header', false, true);
			
			var descId : String = "angles_desc";
			var descTxt : String = ContentModel.gi.getCopyDTOByName( descId ).copy as String;
			_txtDesc.populate(descTxt, 'loader-help-body', true, true);
			
			var dragId : String = "angles_instruction";
			var dragTxt : String = ContentModel.gi.getCopyDTOByName( dragId ).copy as String;
			_txtIcon.populate( dragTxt, 'loader-help-label');

			_txtIcon.x = - _txtIcon.width / 2;
			_txtTitle.y = TOP_MAR;
			var topCenterY : Number = Math.round((_txtTitle.tf.textHeight + _txtTitle.y)/2);
			_txtDesc.y = Math.round( topCenterY - _txtDesc.tf.textHeight/2);
			_txtIcon.y = _panelAngles.iconPan.y + _panelAngles.iconPan.height + 12;
			_txtLoading.y = _bottomY + (BG_H/2 - _bottomY)/2 - _txtLoading.tf.textHeight/2;
			_cta.x = - Math.round(_cta.width / 2);
			_cta.y = _txtLoading.y;// + Math.round(_cta.height / 2);
			
			// ANIMATE IN HOLDER
			animateIn();
			
			// SHOW DOTS
			_progressDots.show();
		}
		
		private function showTime() : void
		{
			animateOut(finishTime);
		}

		private function finishTime() : void
		{
			_panelAngles.visible = false;
			_panelTime.visible = true;
			_panelZoom.visible = 
			_panelStart.visible = false;

			_iconCamera.visible = false;
			_iconZoom.visible = true;
			_iconTime.visible = false;
			
			// POPULATE AND POSITION TEXT
			var controlId : String = "time_title";
			var controlTxt : String = ContentModel.gi.getCopyDTOByName( controlId ).copy as String;
			_txtTitle.update( controlTxt );
			
			var controlDescId : String = "time_desc";
			var controlDescTxt : String = ContentModel.gi.getCopyDTOByName( controlDescId ).copy as String;
			_txtDesc.update( controlDescTxt );
			
			var topCenterY : Number = Math.round((_txtTitle.tf.textHeight + _txtTitle.y)/2);
			_txtDesc.y = Math.round( topCenterY - _txtDesc.tf.textHeight/2);
			
			_txtIcon.x = Math.round(_panelTime.iconScrub.x - _txtIcon.tf.textWidth/2);
			_txtIcon.y = _panelTime.iconScrub.y + _panelTime.iconScrub.height + 12;			
			
			animateIn();
		}
		
		private function showZoom() : void
		{
			animateOut(finishZoom);
		}
		
		private function setCookie() : void
		{
			if( !_sequenceComplete )
			{
				var cookiename : String = Shell.COOKIE_INSTRUCTIONS_VIEWED;
				Shell.getInstance().setCookie( cookiename, true );
			}
		}

		private function finishZoom() : void
		{
			setCookie();
			
			_sequenceComplete = true;
			if(complete) showCta();

			_panelAngles.visible = 
			_panelTime.visible = false;
			_panelZoom.visible = true;
			_panelStart.visible = false;
			
			_txtIcon.visible = false;

			_iconCamera.visible = 
			_iconZoom.visible = false;
			_iconTime.visible = true;
			
			// POPULATE AND POSITION TEXT
			var zoomId : String = "zoom_title";
			var zoomTxt : String = ContentModel.gi.getCopyDTOByName( zoomId ).copy as String;
			_txtTitle.update( zoomTxt );
			
			var zoomDescId : String = "zoom_desc";
			var zoomDescTxt : String = ContentModel.gi.getCopyDTOByName( zoomDescId ).copy as String;
			_txtDesc.update( zoomDescTxt );

			var topCenterY : Number = Math.round((_txtTitle.tf.textHeight + _txtTitle.y)/2) + 5;
			_txtDesc.y = Math.round( topCenterY - _txtDesc.tf.textHeight/2);
			
			animateIn();
		}
		
		private function showStart() : void
		{
			if(complete)
			{
				_t.stop();
				_t.removeEventListener(TimerEvent.TIMER, onTimer);
				animateOut(finishStart);
				TweenLite.delayedCall(_tweenDur * .8, resizeBG);
			}
			else
			{
				_ind = 0;
				animateOut(showAngles);
			}
		}

		private function resizeBG() : void
		{		
			dispatchEvent(new ParamEvent(RESIZE_BG, {tarY: BG_Y + Math.round((BG_H - BG_MIN_H)/2), tarH: BG_MIN_H}));
		}
		
		private function finishStart() : void
		{
			if(complete) showCta();
			
			_panelDiv.divBottom.visible =
			_panelAngles.visible = 
			_panelTime.visible = 
			_panelZoom.visible = false;
			_panelStart.visible = true;
			
			_txtTitle.visible = false;
			_txtIcon.visible = false;

			_iconCamera.visible = 
			_iconZoom.visible = 
			_iconTime.visible = false;
			
			
			// POPULATE AND POSITION TEXT
			var replayId : String = "replay-instructions";
			var replayTxt : String = ContentModel.gi.getCopyDTOByName( replayId ).copy as String;
			_txtDesc.update( replayTxt );

			// SETUP REPLAY BUTTON HIT AREA
			if(!_replayBtn)
			{
				_replayBtn = BoxUtil.getBox(_txtDesc.tf.textWidth, _txtDesc.tf.textHeight, 0xff0000, 0);
				_replayBtn.x = -_replayBtn.width/2;
				_replayBtn.y = _txtDesc.y + _replayBtn.height;
				_replayBtn.buttonMode = true;
				_headerHolder.addChild(_replayBtn);
			}
			_replayBtn.visible = true;
			_replayBtn.addEventListener(MouseEvent.ROLL_OVER, onReplayOver);
			_replayBtn.addEventListener(MouseEvent.ROLL_OUT, onReplayOut);
			_replayBtn.addEventListener(MouseEvent.CLICK, onReplayClicked);
			
			var topCenterY : Number = Math.round(-BG_MIN_H/4);
			_txtDesc.y = Math.round( topCenterY - _txtDesc.tf.textHeight/2);
			var ctaY : Number = -topCenterY - Math.round(_cta.height / 4) + 5;
			TweenLite.to(_cta, _tweenDur * .5, {y: ctaY, ease: Strong.easeOut});

			animateIn();

			TrackingManager.gi.trackPage(TrackingConstants.COURT_LIVE_LOADED);
		}

		private function onReplayOver(event : MouseEvent) : void 
		{
			TweenLite.to(_txtDesc, .3, {tint: SiteConstants.COLOR_RED});
		}

		private function onReplayOut(event : MouseEvent) : void 
		{
			TweenLite.to(_txtDesc, .3, {tint: null});
		}

		private function onReplayClicked(event : MouseEvent) : void 
		{
			_replayBtn.removeEventListener(MouseEvent.ROLL_OVER, onReplayOver);
			_replayBtn.removeEventListener(MouseEvent.ROLL_OUT, onReplayOut);
			_replayBtn.removeEventListener(MouseEvent.CLICK, onReplayClicked);
			_replayBtn.visible = false;

			TweenLite.to(_txtDesc, .3, {tint: null});
			
			// RESIZE BG
			dispatchEvent(new ParamEvent(RESIZE_BG, {tarY: BG_Y, tarH: BG_H}));
			
			// FADE OUT
			_ind = 0;
			_t.start();
			_t.addEventListener(TimerEvent.TIMER, onTimer);
			TweenLite.to(_cta, _tweenDur, {y: _txtLoading.y, delay: _tweenDur * .5, ease: Strong.easeOut});
			TweenLite.delayedCall(_tweenDur * .5, animateOut, [showAngles]);
			
			_progressDots.index = _ind;
			_progressDots.show();
		}

		private function animateIn() : void
		{
			// FADE IN ICON
			_holder.x = (_holder.x < 0) ? ANIMATION_X : 0;
			TweenLite.to(_holder, _tweenDur, {autoAlpha: 1, x: 0, ease: Strong.easeOut});
			TweenLite.to(_headerHolder, _tweenDur, {autoAlpha: 1, ease: Strong.easeOut});
		}
		
		private function animateOut(fun : Function) : void 
		{
			// FADE TOP ITEMS
			TweenLite.to(_holder, _tweenDur, {autoAlpha: 1, x: -ANIMATION_X, ease: Strong.easeIn});
			TweenLite.to(_headerHolder, _tweenDur, {autoAlpha: 0, ease: Strong.easeIn, onComplete: fun});
		}

		private function showCta() : void 
		{
			// IF ANIMATION IS COMPLETE, SHOW CTA
			
			if(_sequenceComplete)
			{
				TweenLite.to(_txtLoading, .3, {autoAlpha:0, delay: .3});
				TweenLite.to(_cta, .3, {autoAlpha:1, delay: .6});
				_panelDiv.divBottom.visible = (ind < _sequence.length - 1);
				
				// STRETCH BG HEIGHT
				if(ind < _sequence.length - 1 && _t.running)
					dispatchEvent(new ParamEvent(RESIZE_BG, {tarY: BG_Y, tarH: BG_H}));
			}
			else
			{
				TweenLite.to(_txtLoading, .3, {autoAlpha:0, delay: .3});
				_panelDiv.divBottom.visible = false;

				// SHRINK BG HEIGHT
				if(_t.running)
					dispatchEvent(new ParamEvent(RESIZE_BG, {tarY: BG_Y, tarH: BG_REDUCED_H}));
			}
		}
		
		
		//-------------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onTimer(event : TimerEvent) : void 
		{
			if(ind < _sequence.length - 1) ind++;
			else
			{
				_t.stop();
				_t.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}
		
		private function onCtaClick(event : Event) : void 
		{
			_t.stop();
			_t.removeEventListener(TimerEvent.TIMER, onTimer);
			
			// DISPATCH TO WELCOME - HIDES BG ITEMS AND NOTIFIES SHELL TO ADVANCE LANDING LOOP
			dispatchEvent(new ViewEvent(ViewEvent.START_EXPLORING));
			hide();
			
			TrackingManager.gi.trackCustom(TrackingConstants.START_EXPLORING );
		}
		
		
		//-------------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//-------------------------------------------------------------------------
		public function get ind() : uint
		{
			return _ind;
		}
		
		// UPDATE INDEX AT LOAD PERCENTAGE INTERVALS OR LOOP CONTINUOUSLY
		public function set ind(ind : uint) : void
		{
			_ind = ind;
			
			// HIDE OR UPDATE DOTS
			if(ind > _sequence.length - 2)
			{
				_progressDots.index = 0;
				_progressDots.hide();
			}
			else
			{
				_progressDots.index = ind;
			}
			
			var fun : Function = _sequence[ind];
			fun();
		}
		
		public function set percent(percent : Number) : void
		{
			var loadTxt : String;
			
			
			var loadingId : String = "loader-percent-dot";
			var loadingTxt : String = ContentModel.gi.getCopyDTOByName( loadingId ).copy as String;
			
			var percentId : String = "loader-percent";
			var percentTxt : String = ContentModel.gi.getCopyDTOByName( percentId ).copy as String;
			
			if(_startPercent == 0 && percent != 0) 
			{
				_startPercent = Math.round(percent * 100);
			}
			else if(_startPercent > 0 && _startPercent < 100)
			{
				_percent = Math.round(  (((percent * 100) - _startPercent) / (100 - _startPercent) ) * 100);
				
				if(_percent >= 100) complete = true;
				else
				{
					if(_percent < 0) _percent = 1;
					loadTxt = loadingTxt + _percent.toString() + percentTxt;
					_txtLoading.update(loadTxt);
				}
			}
			else if(_startPercent == 100)
			{
				complete = true;
			}
		}

		public function get complete():Boolean
		{
			return _complete;
		}

		public function set complete(value:Boolean):void
		{
			// PRELOADING (NOT NECESSARILY ANIMATION) IS COMPLETE
			_complete = value;
			if(value) showCta();
		}

	}
}

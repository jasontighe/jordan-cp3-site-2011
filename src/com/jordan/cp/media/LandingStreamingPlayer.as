package com.jordan.cp.media 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.managers.ConnectionErrorManager;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.jordan.cp.model.StateModel;
	
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.utils.Timer;	

	/**
	 * @author jason.tighe
	 */
	public class LandingStreamingPlayer 
	extends SimpleStreamingPlayer 
	{
		private var _t									: Timer;
		private static const TIMER_DEL					: Number = 3000;
		private static const START_PADDING				: Number = 0;//11;



		public function LandingStreamingPlayer( nc : NetConnection ) 
		{
			super(nc);
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		override public function playVideo( url : String ) : void
		{
			super.playVideo(url);
			
			var st : SoundTransform = new SoundTransform();
			st.volume = 0;
			
			_netStream.soundTransform = st;
			_netStream.seek(START_PADDING);
			
//			startTimer();
		}


		//----------------------------------------------------------------------------
		// private methods
		//----------------------------------------------------------------------------
		private function startTimer() : void 
		{
			if(!_t)
			{
				_t = new Timer(TIMER_DEL);
				_t.addEventListener(TimerEvent.TIMER, onTimer);
			}
			_t.start();
		}
		
		private function stopTimer() : void
		{
			_t.stop();
		}

		private function onTimer(event : TimerEvent) : void 
		{
			if( _loop )
			{
				_netStream.play( _url );
				_netStream.seek( START_PADDING );
			}
			else stopTimer();
		}
		
		
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		override protected function onNetStatus( e : Object ) : void 
		{
			switch ( e.info.code ) 
			{
				case "NetStream.Play.InsufficientBW":
//					ConnectionErrorManager.gi.showError();
					break;
					
				case "NetStream.Play.Stop":
					dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_PLAY_PAUSE ) );
					break;

				case "NetStream.Buffer.Full":
					if( !_videoStarted )
					{
						dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_READY ) );
						_videoStarted = true;

						TweenLite.to( this, 1, { autoAlpha: 1, ease: Quad.easeIn } );
					}
					break;				
			}
		}
		
		override protected function onVideoComplete() : void 
		{
			if( _loop ) _netStream.play( _url );
//			else
//			{
//				dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
//				Shell.getInstance().main.stateModel.state = StateModel.STATE_MAIN;
//			}
		}


		override public function set loop( value : Boolean ) : void
		{
			_loop = value;

			if(!_loop)
			{
				_netStream.close();

				dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
				Shell.getInstance().main.stateModel.state = StateModel.STATE_MAIN;
			}
		}
		


	}
}

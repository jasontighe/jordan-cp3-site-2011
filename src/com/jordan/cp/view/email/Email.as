package com.jordan.cp.view.email {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.Tokens;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.view.AbstractOverlay;
	import com.jordan.cp.view.vignette.AbstractExitButton;
	import com.plode.framework.managers.AssetManager;
	import com.plode.framework.managers.PlodeStyleManager;

	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.errors.MemoryError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author jsuntai
	 */
	public class Email 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static var TITLE_Y_SPACE				: int = -16;
		protected static var AREA_WIDTH					: uint = 369;
		protected static var INPUT_X_MARGIN				: uint = 4;
		protected static var INPUT_Y_MARGIN				: uint = 4;
		public static const PAUSE_TIME					: uint = 5000;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var viewsArray						: Array;	
		protected var _timer							: Timer;	
		protected var _interstitialHeight				: uint;	
		protected var _interstitialIn					: Boolean = false;	
		protected var _callbackReceived					: Boolean = false;	
		protected var _kitVisible						: Boolean = false;	
		protected var _result							: String;	
//		protected var _yPos								: uint;							
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon									: MovieClip;
		public var nameBg								: MovieClip;
		public var addressBg							: MovieClip;
		public var friendsBg							: MovieClip;
		public var messageBg							: MovieClip;
		public var hr									: MovieClip;
		public var background							: MovieClip;
		public var exitButton							: AbstractExitButton;
		public var headerTxt							: AutoTextContainer;
		public var descTxt								: AutoTextContainer;
		public var nameTxt								: AutoTextContainer;
		public var nameInputTxt							: TextField;
		public var addressTxt							: AutoTextContainer;
		public var addressInputTxt						: TextField;
		public var friendsTxt							: AutoTextContainer;
		public var friendsInputTxt						: TextField;
		public var messageTxt							: AutoTextContainer;
		public var messageInputTxt						: TextField;
		public var optionalTxt							: AutoTextContainer;
		public var sendingTxt							: AutoTextContainer;
		public var successTxt							: AutoTextContainer;
		public var failTxt								: AutoTextContainer;
		public var copyLinkBtn							: CopyLinkButton;
		public var sendBtn								: EmailSendButton;
		public var emailMask							: Box;
		public var kit									: KitAnimation;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Email() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init( ) : void
		{
			addViews();
		}
		
		public override function updateViews( stageW : uint, stageH : uint ) : void
		{
			var exitId : String = "email-exit";
			var exitDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( exitId ) as CopyDTO;
			setWidth( stageW );
			setHeight( stageH );
			exitButton.x = Math.round( ( background.x + background.width - exitButton.width ) * .5 );
			exitButton.y = exitDTO.copyY;
			
			center();
		}
		
		public override function transitionIn() : void
		{
			alpha = 1;
			TweenLite.from( this, TIME_IN, { alpha: 0, onComplete: transitionInComplete  } );
			TweenLite.from( icon, TIME_IN, { alpha: 0, x: icon.x - 10, delay: TIME_IN  } );
			if( exitButton && contains( exitButton ) )	exitButton.activate();
		}
		
		public override function transitionOut() : void
		{
			TweenLite.to( this, TIME_OUT, { alpha: 0, onComplete: transitionOutComplete  } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews() : void
		{
			addBackground();
			setBackgroundObjects();
			setCopy();
			addInputText();
			addSendButton();
			addExitButton();
//			addMask();
			addAssetsToViewArray();
			this.setY( y )
			trace( "\n\n\n\n\n\n");
			trace( "EMAIL : addViews() : _yPos is "+_yPos)
		}
		
		protected function addAssetsToViewArray() : void
		{
			viewsArray = new Array( nameBg,
									addressBg,
									friendsBg,
									messageBg,
									hr,
									exitButton,
									descTxt,
									nameTxt,
									addressTxt,
									friendsTxt,
									messageTxt,
									optionalTxt,
									copyLinkBtn,
									nameInputTxt,
									optionalTxt,
									addressInputTxt,
									friendsInputTxt,
									messageInputTxt,
									sendBtn );
		}
		
		protected function addMask() : void
		{
			emailMask = new Box( background.width, background.height );
			addChild( emailMask );
			
			mask = emailMask;
		}
		
		protected function removeMask() : void
		{
			removeChild( emailMask );
			
			mask = null;
		}
		
		protected function addBackground() : void
		{
			background = MovieClip( AssetManager.gi.getAsset( "EmailBackgroundAsset", SiteConstants.ASSETS_ID ) );
			addChild( background );
			
			_interstitialHeight = Math.round( background.height * .35 );
		}
		
		protected function setBackgroundObjects() : void
		{
			icon = background.icon;
			nameBg = background.nameBg;
			addressBg = background.addressBg;
			friendsBg = background.friendsBg;
			messageBg = background.messageBg;
			hr = background.hr;
			kit = background.kit;
		}
		
		protected function addExitButton() : void
		{
			exitButton = new AbstractExitButton();
			exitButton.addViews( SiteConstants.EXIT_BUTTON_CLOSE );
			exitButton.addEventListener( Event.COMPLETE, onExitClick );
			addChild( exitButton );
		}
		
		protected function setCopy() : void
		{
			var headerId : String = "email-header"
			var headerDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( headerId ) as CopyDTO;
			headerTxt = new AutoTextContainer( );
			headerTxt.populate( headerDTO, headerId );
			headerTxt.x = Math.round( ( background.x + background.width - headerTxt.width ) * .5 );
			addChild( headerTxt );
			
			var descId : String = "email-desc"
			var descWidth : uint = AREA_WIDTH;
			var descDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( descId ) as CopyDTO;
			descTxt = new AutoTextContainer( );
			descTxt.setWidth( descWidth );
			descTxt.populate( descDTO, descId, true, true );
			addChild( descTxt );
			
			var nameId : String = "email-name"
			var nameDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( nameId ) as CopyDTO;
			nameTxt = new AutoTextContainer( );
			nameTxt.populate( nameDTO, nameId );
			nameTxt.x = nameBg.x;
			nameTxt.y = nameBg.y + TITLE_Y_SPACE;
			addChild( nameTxt );
			
			var addressId : String = "email-address"
			var addressDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( addressId ) as CopyDTO;
			addressTxt = new AutoTextContainer( );
			addressTxt.populate( addressDTO, addressId );
			addressTxt.x = nameBg.x;
			addressTxt.y = addressBg.y + TITLE_Y_SPACE;
			addChild( addressTxt );
			
			var friendsId : String = "email-friends"
			var friendsDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( friendsId ) as CopyDTO;
			friendsTxt = new AutoTextContainer( );
			friendsTxt.populate( friendsDTO, friendsId );
			friendsTxt.x = nameBg.x;
			friendsTxt.y = friendsBg.y + TITLE_Y_SPACE;
			addChild( friendsTxt );
			
			var messageId : String = "email-message"
			var messageDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( messageId ) as CopyDTO;
			messageTxt = new AutoTextContainer( );
			messageTxt.populate( messageDTO, messageId );
			messageTxt.x = nameBg.x;
			messageTxt.y = messageBg.y + TITLE_Y_SPACE;
			addChild( messageTxt );
			
			var optionalId : String = "email-optional"
			var optionalDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( optionalId ) as CopyDTO;
			optionalTxt = new AutoTextContainer( );
			optionalTxt.populate( optionalDTO, optionalId );
			optionalTxt.x = messageBg.x + messageBg.width - optionalTxt.width;
			optionalTxt.y = messageBg.y + TITLE_Y_SPACE;
			addChild( optionalTxt );
			
			var copyId : String = "email-copy"
			var copyDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( copyId ) as CopyDTO;
			copyLinkBtn = new CopyLinkButton( );
			copyLinkBtn.init();
			copyLinkBtn.activate();
			copyLinkBtn.x = Math.round( messageBg.x + messageBg.width - copyLinkBtn.width );
			copyLinkBtn.y = copyDTO.copyY;
			addChild( copyLinkBtn );
			
			var sendingId : String = "email-sending"
			var sendingDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( sendingId ) as CopyDTO;
			sendingTxt = new AutoTextContainer( );
			sendingTxt.populate( sendingDTO, sendingId );
			sendingTxt.x = Math.round( ( background.x + background.width - sendingTxt.width ) * .5);
			sendingTxt.alpha = 0;
			addChild( sendingTxt );
			
			var successId : String = "email-success"
			var successDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( successId ) as CopyDTO;
			successTxt = new AutoTextContainer( );
			successTxt.populate( successDTO, successId );
			successTxt.x = Math.round( ( background.x + background.width - successTxt.width ) * .5);
			successTxt.alpha = 0;
			addChild( successTxt );
			
			var failId : String = "email-fail"
			var failDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( failId ) as CopyDTO;
			failTxt = new AutoTextContainer( );
			failTxt.populate( failDTO, failId );
			failTxt.x = Math.round( ( background.x + background.width - failTxt.width ) * .5);
			failTxt.alpha = 0;
			addChild( failTxt );
		}

		protected function addInputText() : void
		{	
			var nameWidth : uint = nameBg.width - ( INPUT_X_MARGIN * 2 );
			nameInputTxt = getInputText( nameWidth, nameBg.height, false, false, false );
			nameInputTxt.x = nameBg.x + INPUT_X_MARGIN;
			nameInputTxt.y = nameBg.y + INPUT_Y_MARGIN;
			addChild( nameInputTxt );
			nameInputTxt.addEventListener( Event.CHANGE, updateFormat );
			
			var remainingWidth : uint = addressBg.width - ( INPUT_X_MARGIN * 2 );
			addressInputTxt = new TextField();
			addressInputTxt = getInputText( remainingWidth, addressBg.height, false, false, false );
			addressInputTxt.x = nameBg.x + INPUT_X_MARGIN;
			addressInputTxt.y = addressBg.y + INPUT_Y_MARGIN;
			addChild( addressInputTxt );
			addressInputTxt.addEventListener( Event.CHANGE, updateFormat );
			
			friendsInputTxt = new TextField();
			friendsInputTxt = getInputText( remainingWidth, friendsBg.height, false, false, false );
			friendsInputTxt.x = nameBg.x + INPUT_X_MARGIN;
			friendsInputTxt.y = friendsBg.y + INPUT_Y_MARGIN;
			addChild( friendsInputTxt );
			friendsInputTxt.addEventListener( Event.CHANGE, updateFormat );
			
			messageInputTxt = new TextField();
			messageInputTxt = getInputText( remainingWidth, messageBg.height, true, true, false );
			messageInputTxt.x = nameBg.x + INPUT_X_MARGIN;
			messageInputTxt.y = messageBg.y + INPUT_Y_MARGIN;
			addChild( messageInputTxt );
			messageInputTxt.addEventListener( Event.CHANGE, updateFormat );
		}

		protected function addSendButton() : void
		{
			var sendId : String = "email-send";
			var sendDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( sendId ) as CopyDTO;
			
			sendBtn = new EmailSendButton();
			sendBtn.addViews( sendDTO.copy );
			sendBtn.addEventListener( Event.COMPLETE, onSendClick );
			sendBtn.x = nameBg.x;
			sendBtn.y = sendDTO.copyY;
			addChild( sendBtn );
			
			sendBtn.activate();
		}

		protected override function transitionInComplete() : void
		{
//			activate();
		}

		protected function hideViews() : void
		{
			var i : uint = 0
			var I : uint = viewsArray.length;
			for( i; i < I; i++ )
			{
				var view : * = viewsArray[ i ];
				view.visible = false;
			}
		}

		protected function showViews() : void
		{
			var i : uint = 0
			var I : uint = viewsArray.length;
			for( i; i < I; i++ )
			{
				var view : * = viewsArray[ i ];
				view.visible = true;
			}
		}
		
		protected function interstitalIn() : void
		{
			hideViews();
			addMask();
			var yPos : uint = y + Math.round( ( getY() + _interstitialHeight * .5 ) );
			TweenLite.to( this, SiteConstants.NAV_TIME_IN, { y: yPos , ease:Quad.easeOut } );
			TweenLite.to( emailMask, SiteConstants.NAV_TIME_IN, { height: _interstitialHeight, ease:Quad.easeOut, onComplete: interstitalInComplete  } );
		}
		
		protected function interstitalInComplete() : void
		{
			_interstitialIn = true;
			checkInterstital();
		}
		
		protected function interstitalOut() : void
		{
			successTxt.alpha = 0;
			failTxt.alpha = 0;
			var yPos : uint = y - Math.round( ( getY() + _interstitialHeight * .5 ) );
			TweenLite.to( this, SiteConstants.NAV_TIME_IN, { y: yPos, ease:Quad.easeOut } );
			TweenLite.to( emailMask, SiteConstants.NAV_TIME_IN, { height: background.height, ease:Quad.easeOut, onComplete: interstitalOutComplete } );
		}
		
		protected function interstitalOutComplete() : void
		{
			showViews();
			removeMask();
		}

		protected function startTimer() : void
		{
			_timer = new Timer( PAUSE_TIME );
			_timer.addEventListener( TimerEvent.TIMER, onTimerComplete );
			_timer.start();
		}
		
		protected function stopTimer() : void
		{
			_timer.removeEventListener( TimerEvent.TIMER, onTimerComplete );
			_timer.stop();
		}
		
		protected function onTimerComplete( e : TimerEvent ) : void
		{
			_timer.removeEventListener( TimerEvent.TIMER, onTimerComplete );
			interstitalOut();
			
		}
		
		public function getInputText( w : uint, 
									  h : uint, 
									  wrap : Boolean = true, 
									  multiline : Boolean= false, 
									  border : Boolean= false ) : TextField
		{
//			trace( "EMAIL : getInputText() : w is "+w+" : h is "+h );
			var tf : TextField = new TextField();
			tf.width = w;
			tf.height = h;
			
			var format : TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 11;
			
			tf.setTextFormat(format);
			
			tf.type = TextFieldType.INPUT;
			tf.border = border;
			tf.multiline = multiline;
			tf.wordWrap = wrap;
			return tf;
		}
		
		protected function checkValidity( ) : void
		{
			var emails : Array = new Array( addressInputTxt.text, friendsInputTxt.text  );
			var emailTitles : Array = new Array( addressTxt, friendsTxt  );
			
			var i : uint = 0;
			var I : uint = emails.length;
			var validCount : uint = 0;
			for( i; i < I; i++ )
			{
				var title : AutoTextContainer = emailTitles[ i ] as AutoTextContainer;
				var email : String = emails[ i ] as String;
				var isValid : Boolean = EmailValidator.valid( email );
				if( !isValid)
				{
					changeColor( title, SiteConstants.COLOR_RED );
				}
				else
				{
					changeColor( title, SiteConstants.COLOR_WHITE );
					validCount++;
				}
				
				if( validCount == emails.length )	
				{
					sendToFriend();
					interstitalIn();
//					startTimer();
				}
			}
		}
		
		protected function changeColor( object : *, color : uint ) : void
		{
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.color = color;
			object.transform.colorTransform = colorTransform;
		}

//		SAMPLE CALL
//		http://www.nike.com/jumpman23/services/email/sendToFriend.jsp
//		?message=Hello%2C%20check%20this%20out.
//		&sendersName=pulsegrenade%40gmail.com
//		&sendersEmail=pulsegrenade%40gmail.com
//		&friendsEmail=arch%40blastradius.com
//		&title=Jordan%20Melo%20M8
//		&friendsName=arch%40blastradius.com
//		&subject=Check%20out%20Jordan%20Melo%20M8%20at%20Jumpman23.com
//		&link=http%3A%2F%2Fwww.nike.com%2Fjumpman23%2Ffootwear%2Fall%2F469786-006.html%3Fcid%3D469786-006
		protected function sendToFriend( ) : void
		{
//			trace( "EMAIL : sendToFriend()" );
			sendBtn.deactivate();
			
			var titleId : String = "email-title"
			var titleDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( titleId ) as CopyDTO;
			var subjectId : String = "email-title"
			var subjectDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( subjectId ) as CopyDTO;
			var linkId : String = "email-link"
			var linkDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( linkId ) as CopyDTO;
			
			var sendersName : String = nameInputTxt.text;
			if( sendersName == "" )	sendersName = addressInputTxt.text;
			var sendersEmail : String = addressInputTxt.text;
			var friendsName : String = friendsInputTxt.text;
			var friendsEmail : String = friendsInputTxt.text;
			var title : String = titleDTO.copy;
			var subject : String = subjectDTO.copy;
			var message : String = messageInputTxt.text;
			var link : String = linkDTO.copy;
			var url : String = Tokens.SEND_TO_FRIEND_URL;
			
			trace( "EMAIL : sendToFriend() : sendersName is "+sendersName );
			trace( "EMAIL : sendToFriend() : sendersEmail is "+sendersEmail );
			trace( "EMAIL : sendToFriend() : friendsName is "+friendsName );
			trace( "EMAIL : sendToFriend() : friendsEmail is "+friendsEmail );
			trace( "EMAIL : sendToFriend() : title is "+title );
			trace( "EMAIL : sendToFriend() : subject is "+subject );
			trace( "EMAIL : sendToFriend() : message is "+message );
			trace( "EMAIL : sendToFriend() : link is "+link );
			trace( "EMAIL : sendToFriend() : url is "+url );

			var variables : URLVariables = new URLVariables();
			variables.sendersName = sendersName;
			variables.sendersEmail = sendersEmail;
			variables.friendsName = friendsName;
			variables.friendsEmail = friendsEmail;
			variables.title = title;
			variables.subject = subject;
			variables.sendersName = sendersName;
			variables.message = message;
			variables.link = link;

			var request : URLRequest = new URLRequest( url );
			request.method = URLRequestMethod.GET;
			request.data = variables;

			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResultsReceived );
//           	loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );

//			loader.load(request);
//			}
			try
			{
			        loader.load(request);
			}
				catch(argErr:ArgumentError)
				{
				        trace("Bad headers");
				}
				catch(error:IOError) 
				{
					trace( "EMAIL : sendToFriend() : error.message is "+error.message);
				}
				catch(err:Error) 
				{
					trace( "EMAIL : sendToFriend() : err.message is "+err.message);
				} 
				catch(memErr:MemoryError)
				{
				        trace("UTF-8 parsing error... or just not enough RAM for your POST data.");
				}
				catch(securityErr:SecurityError)
				{
				        trace("Either you're local-networking, or hitting a no-no port.");
				}
				catch(typeErr:TypeError)
				{
				        trace("The URL is null");
				}
				
				TrackingManager.gi.trackCustom(TrackingConstants.SHARE_EMAIL );
		}
		
		protected function onEmailSuccess( ) : void
		{
			trace( "EMAIL : onEmailSuccess()" );
			sendBtn.activate();
			sendBtn.setOutState();
			TweenLite.to( successTxt, SiteConstants.NAV_TIME_OUT, { alpha: 1, ease:Quad.easeOut } );
			
		}
		
		protected function onEmailFail( ) : void
		{
			trace( "EMAIL : onEmailFail()" );
			sendBtn.activate();
			sendBtn.setOutState();
			TweenLite.to( failTxt, SiteConstants.NAV_TIME_OUT, { alpha: 1, ease:Quad.easeOut } );
		}
		
		protected function checkInterstital( ) : void
		{
			if( _callbackReceived && _interstitialIn )
			{
				showResult();
				hideKit();
			}
			else
			{
				showKit();
			}
		}
		
		protected function showKit( ) : void
		{
			if( !_kitVisible )
			{
				kit.transitionIn();
				TweenLite.to( sendingTxt, SiteConstants.NAV_TIME_OUT, { alpha: 1, ease:Quad.easeOut } );
				_kitVisible = true;
			}
		}
		
		protected function hideKit( ) : void
		{
			kit.transitionOut( );
			sendingTxt.visible = false;
		}
		
		protected function showResult() : void
		{
			if( String( _result ) == "success" )
			{
				onEmailSuccess();
			}
			else
			{
				onEmailFail();
			}
			
			startTimer();
		}

		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function updateFormat( e : Event = null ) : void
		{
			var inputText : TextField = e.target as TextField;
			var styleId : String = "email-input";
			var format : TextFormat = PlodeStyleManager.gi.getFormatFromStyle(styleId);
			inputText.setTextFormat(format);
		}
		
		protected function onMouseOver( e : MouseEvent = null ) : void
		{
			
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void
		{
			
		}
		
		protected function onSendClick( e : Event = null ) : void
		{
			trace( "EMAIL : onSendClick()" );
			checkValidity();
		}
		
		protected function onExitClick( e : Event = null ) : void
		{
			trace( "EMAIL : onExitClick()" );
			_stateModel.state = StateModel.STATE_OVERLAY_OUT;
		}
		
		protected function onResultsReceived( e : Event = null ) : void
		{
			trace( "EMAIL : onResultsReceived()" );
			var data : String = e.target.data;
			trace( "EMAIL : onResultsReceived() : data is "+data );
			var result : XML = XML( data );
			trace( "EMAIL : onResultsReceived() : result is "+result );

			_result = String( result );
			
			_callbackReceived = true;
			checkInterstital();
		}
	}
}

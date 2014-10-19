package com.jasontighe.navigations {	import com.jasontighe.navigations.INavItem;	import com.jasontighe.navigations.Nav;	import flash.events.Event;		public class LimitNav extends Nav 	{		protected var changeEventHander:Function = DEFAULT_EVENT_HANDLER;		protected var _limit:int = -1;		protected var _activeIndices:Array = new Array( );		override public function reset():void		{			var i:int = 0;			var I:int = _activeIndices.length;						for ( i; i < I ; i++ )			{				getItemAt( _activeIndices[ i ] ).deactivate( );			}						_activeIndices = new Array( );						dispatchEvent( new Event( Event.CHANGE ) );		}		public function setLimit( value:int = -1 ):void		{			_limit = value;		}		public function setChangeEventHandler( value:Function = null ):void		{			removeEventListener( Event.CHANGE, changeEventHander );						changeEventHander = checkEventHandler( value );						addEventListener( Event.CHANGE, changeEventHander );		}		override public function setActiveItem( item:INavItem ):void		{		 				_activeIndices.push( item.getIndex( ) );						if ( _limit != -1 && _activeIndices.length > _limit )			{				INavItem( getItemAt( _activeIndices.shift( ) ) ).deactivate( );			}							item.activate( );						dispatchEvent( new Event( Event.CHANGE ) );		}		public function removeActiveItem( item:INavItem ):void		{		 				var i:int = 0;			var I:int = _activeIndices.length;			var index:uint = item.getIndex( );						for ( i; i < I ; i++ )			{				if ( _activeIndices[ i ] == index )				{					_activeIndices.splice( i, 1 );										item.deactivate( );				}			}						dispatchEvent( new Event( Event.CHANGE ) );		}		public function getActiveItems( ):Array		{			var activeItems:Array = new Array( );			var i:int = 0;			var I:int = _activeIndices.length;						for ( i; i < I ; i++ )			{				activeItems.push( getItemAt( _activeIndices[ i ] ) );			}			return activeItems;		}		public function getActiveIndices():Array		{			return _activeIndices;		}	}}
﻿package com.plode.framework.players 
		protected var _ns : NetStream;
		protected var _video : Video;
		{
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_nc.connect(null);

			_ns = new NetStream(_nc);
			_ns.bufferTime = 3;
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorHandler);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			
			var client : Object = new Object();
			client.onMetaData = onMetaData;
			_ns.client = client;
		}

		}

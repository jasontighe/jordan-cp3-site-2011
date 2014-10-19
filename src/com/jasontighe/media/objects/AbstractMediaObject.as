package com.jasontighe.media.objects 
		private static const MUST_OVERRIDE_METHOD:String = new String( 'must override method' );
		public function AbstractMediaObject( url:String )
		protected function addProperties():void
		override protected function addEventListeners():void
		override protected function removeEventListeners():void
		override protected function removeEventHandlers():void
		/*
		override protected function onRemovedFromStage( e:Event ):void
		/*
		public function resume():void
		public function pause():void
		public function reset():void
		public function seek( time:Number ):void
		/*
		public function get duration():Number
		public function get time():Number
		public function get vol():Number
		public function set vol( volume:Number ):void
		public function get bufferTime():Number
		public function set bufferTime( bufferTime:Number ):void
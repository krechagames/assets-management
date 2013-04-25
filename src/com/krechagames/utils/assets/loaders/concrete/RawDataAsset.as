/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 12:31
 */
package com.krechagames.utils.assets.loaders.concrete {
	import com.krechagames.utils.assets.loaders.*;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class RawDataAsset extends Asset {
		protected var loader:URLLoader;

		public function RawDataAsset(id:String = null, url:String = null) {
			super(id, url);

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;

		}

		protected function loadEventHandler(event:Event):void {
			dispatchEvent(event);
		}

		override public function load(version:int = 0):void {
			loader.addEventListener(Event.COMPLETE, loadEventHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, loadEventHandler);

			loader.load(new URLRequest(url + "?v="+version));
		}

		override public function dispose():void {
			loader.removeEventListener(Event.COMPLETE, loadEventHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, loadEventHandler);

			try {
				loader.close ();
				ByteArray (loader.data).clear ();
			}catch(e:Error){}

			loader = null;

			dispatchEvent(new Event(Event.REMOVED))
		}

		public function get castBytes():ByteArray {
			return loader.data as ByteArray;
		}
	}
}

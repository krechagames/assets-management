/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 13:22
 */
package com.krechagames.utils.assets.loaders {
	import com.krechagames.utils.assets.Asset;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;

	public class ImageAsset extends Asset {
		protected var loader:Loader;

		public function ImageAsset(id:String = null, url:String = null, group:String = null) {
			super(id, url, group);

			loader = new Loader();
		}

		protected function loadEventHandler(event:Event):void {
			dispatchEvent(event);
		}

		override public function load(version:int = 0):void {
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadEventHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadEventHandler);

			loader.load(new URLRequest(url + "?v="+version), loaderContext);
		}

		override public function dispose():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadEventHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadEventHandler);

			try {
				if(castBitmap){
					castBitmap.bitmapData.dispose();
				}

				loader.close();
				loader.unloadAndStop();
			}catch(e:Error){}

			loader = null;

			dispatchEvent(new Event(Event.REMOVED))
		}

		public function get castBitmap():Bitmap {
			return loader.content as Bitmap;
		}

		public function get castSWF():MovieClip {
			return loader.content as MovieClip;
		}
	}
}

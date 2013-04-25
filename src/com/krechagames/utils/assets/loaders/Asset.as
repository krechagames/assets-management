/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 13:33
 */
package com.krechagames.utils.assets.loaders {
	import com.krechagames.utils.assets.interfaces.IAsset;

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;

	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="complete",type="flash.events.Event")]
	public class Asset extends EventDispatcher implements IAsset {
		private var _id:String;

		private var _url:String;

		public function Asset(id:String = null, url:String = null) {
			this.id = id;
			this.url = url;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

		public function dispose():void {
			throw new IllegalOperationError("Error: dispose() is an abstract method. Overwrite it in concrete class.");
		}

		public function load(version:int = 0):void {
			throw new IllegalOperationError("Error: load() is an abstract method. Overwrite it in concrete class.");
		}

		override public function toString():String {
			return "[Asset id="+id+", url="+url+"]";
		}
	}
}

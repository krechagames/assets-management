/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 13:48
 */
package com.krechagames.utils.assets {
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.interfaces.IAssetsLoader;
	import com.krechagames.utils.assets.interfaces.IAssetsStorage;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="complete",type="flash.events.Event")]
	public class AssetsLoader extends EventDispatcher implements IAssetsLoader {
		protected var _queue:Vector.<IAsset>;

		private var _storage:IAssetsStorage;

		protected var busy:Boolean;

		public var autoSkip:Boolean = false;

		public var version:int = 0;

		public function AssetsLoader(storage:IAssetsStorage) {
			this._queue = new Vector.<IAsset>();
			this._storage = storage
		}

		public function load(list:Vector.<IAsset>):void {
			_queue = _queue.concat(list);

			if(!busy){
				busy = true;
				loadCurrent();
			}
		}

		protected function loadCompleteHandler(e:Event):void {
			var asset:IAsset = IAsset(e.currentTarget);
			asset.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			asset.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);

			storage.setAsset(asset);

			_queue.shift();

			loadNext();
		}

		protected function loadErrorHandler(e:Event):void {
			var asset:IAsset = IAsset(e.currentTarget);
			asset.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			asset.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);

			dispatchEvent(new IOErrorEvent("An error occuring loading asset " + current.url + (autoSkip ? ". Skip to next asset." : ".")));
			if(autoSkip) skip();
		}

		protected function loadCurrent():void {
			var asset:IAsset = current;

			asset.addEventListener(Event.COMPLETE, loadCompleteHandler);
			asset.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			asset.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
			asset.load(version);
		}

		protected function skip():void {
			_queue.shift().dispose();

			loadNext();
		}

		protected function loadNext():void {
			if(total > 0){
				if(storage.getAsset(current.id) && autoSkip){
					dispatchEvent(new IOErrorEvent("An asset " + current.id + " was found in the storage. Skip to next asset."));
					skip();
				}else {
					loadCurrent();
				}
			}else {
				busy = false;
				complete();
			}
		}

		protected function complete():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get total():uint {
			return _queue.length;
		}

		public function get current():IAsset {
			return total > 0 ? _queue[0] : null;
		}

		public function dispose():void {
			storage = null;

			var asset:IAsset;
			var i:int = -1;
			while(++i < _queue.length) {
				asset = _queue[i];
				asset.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				asset.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
				asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
				asset.dispose();

				delete _queue[i];
			}

			_queue = new Vector.<IAsset>();;
		}

		public function get storage():IAssetsStorage {
			return _storage;
		}

		public function set storage(value:IAssetsStorage):void {
			_storage = value;
		}
	}
}

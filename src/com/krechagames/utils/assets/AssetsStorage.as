/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 14:56
 */
package com.krechagames.utils.assets {
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.interfaces.IAssetsStorage;
	import com.krechagames.utils.assets.loaders.Asset;

	import flash.events.Event;
	import flash.utils.Dictionary;

	public class AssetsStorage implements IAssetsStorage {
		protected var container:Dictionary;

		public function AssetsStorage() {
			container = new Dictionary(true);
		}

		public function setAsset(asset:IAsset):void {
			container[asset.id] = asset;
			asset.addEventListener(Event.REMOVED, removedAssetHandler, false, 0, true);
		}

		private function removedAssetHandler(event:Event):void {
			var id:String = Asset(event.target).id;

			if(hasAsset(id)) delete container[id];
		}

		public function hasAsset(id:String):Boolean {
			return !(container[id] == null);
		}

		public function getAsset(id:String):IAsset {
			return IAsset(container[id]);
		}

		public function removeAsset(id:String):void {
			var asset:IAsset = getAsset(id);
			asset.dispose();

			delete container[id];

			asset.removeEventListener(Event.REMOVED, removedAssetHandler);
		}

		public function dispose():void {
			for(var i:String in container){
				IAsset(container[i]).dispose();
				delete container[i];
			}

			container = new Dictionary(true);
		}
	}
}

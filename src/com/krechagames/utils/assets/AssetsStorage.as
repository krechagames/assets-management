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

		protected var groups:Dictionary;

		public function AssetsStorage() {
			container = new Dictionary(true);
			groups = new Dictionary(true);
		}

		public function setAsset(asset:IAsset):void {
			container[asset.id] = asset;

			if(asset.group != null) {
				var group:Vector.<IAsset> = groups[asset.group];

				if(group == null)
					group = groups[asset.group] = new Vector.<IAsset>;

				group.push(asset);
			}

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
			var asset:IAsset = IAsset(container[id]);

			disposeAsset(asset);

			if(asset.group == null){
				return;
			}else {
				var group:Vector.<IAsset> = getGroup(asset.group);

				if(group == null){
					return;
				}else {
					var i:int = -1;

					while(++i < group.length){
						if(group[i].id == id){
							group.splice(i, 1);
							break;
						}
					}

					if(group.length == 0){
						delete groups[asset.group];
					}
				}
			}
		}

		protected function disposeAsset(asset:IAsset):void {
			asset.dispose();
			asset.removeEventListener(Event.REMOVED, removedAssetHandler);

			delete container[asset.id];
		}

		public function removeGroup(name:String):void {
			var group:Vector.<IAsset> = getGroup(name);

			if(group == null){
				return;
			}else {
				while(group.length > 0){
					removeAsset(group[0].id)
				}

				delete groups[name];
			}
		}

		public function getGroup(name:String):Vector.<IAsset> {
			return name == null ? null : groups[name];
		}

		public function dispose():void {
			for(var i:String in container){
				IAsset(container[i]).dispose();
				delete container[i];
			}

			groups = new Dictionary(true);

			container = new Dictionary(true);
		}
	}
}

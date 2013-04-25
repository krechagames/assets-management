/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 17.04.2013
 * Time: 17:49
 */
package {
	import com.krechagames.utils.assets.AssetsConfig;
	import com.krechagames.utils.assets.AssetsLoader;
	import com.krechagames.utils.assets.StarlingStorage;
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.loaders.concrete.SoundAsset;
	import com.krechagames.utils.assets.loaders.concrete.TextAsset;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class StarlingDemoRoot extends Sprite {
		/**
		 * Storage assets
		 */
		public var storage:StarlingStorage;

		/**
		 * Assets loader
		 */
		public var loader:AssetsLoader;

		/**
		 * Config file (optional)
		 */
		public var config:AssetsConfig;

		public function StarlingDemo() {
			if(stage == null) addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			else init(null);
		}

		/**
		 * Initialize
		 * @param e
		 */
		private function init(e:starling.events.Event):void {
			//basic assets storage
			storage = new StarlingStorage(Starling.contentScaleFactor < 1.5 ? 1 : 2);

			//assets loader and pass it to storage after load complete
			loader = new AssetsLoader(storage);
			loader.addEventListener(flash.events.Event.COMPLETE, loadAssetsCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);

			//option #1: we can use config file to get assets to load
			config = new AssetsConfig("config", "./assets/assets.xml", Vector.<String>(["common", "x" + storage.scale])); //or load particular groups:
			config.addEventListener(flash.events.Event.COMPLETE, loadConfigCompleteHandler, false, 0, true);
			config.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);
			config.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler, false, 0, true);
			config.load();
		}

		/**
		 * Assets to load
		 * @param list
		 */
		private function loadAssets(list:Vector.<IAsset>):void {
			loader.load(list);
		}

		/**
		 * Assets have been loaded
		 * @param event
		 */
		private function loadAssetsCompleteHandler(event:flash.events.Event):void {
			//prepare atlases and dispose assets
			storage.prepareAtlas("atlas", "atlas_xml", true);
			storage.prepareAtlas("compressed_texture", null, true);
			storage.prepareAtlas("bg", null, true);
			storage.prepareAtlas("logotype", null, true);

			//images assets
			var bg:Image = new Image(storage.getTexture("bg"));
			addChild(bg);

			var logotype:Image = new Image(storage.getTexture("logotype"));
			logotype.x = stage.stageWidth - logotype.width - 10;
			logotype.y = 10;
			addChild(logotype);

			//sound asset
			var music:Sound = SoundAsset(storage.getAsset("music")).castSound;
			music.play();

			//image asset + text asset
			var mc:MovieClip = new MovieClip(storage.getTextures("atlas", "flight_"));
			mc.x = 30;
			mc.y = 30;
			addChild(mc);
			Starling.juggler.add(mc);

			//raw data asset
			var atf:Image = new Image(storage.getTexture("compressed_texture"));
			atf.x = stage.stageWidth - atf.width - 20;
			atf.y = stage.stageHeight - atf.height - 20;
			addChild(atf);

			//text assets
			trace(TextAsset(storage.getAsset("db")).castText);
		}

		/**
		 * Config file has been loaded
		 * @param event
		 */
		private function loadConfigCompleteHandler(event:flash.events.Event):void {
			//load assets
			var list:Vector.<IAsset> = config.list;
			loadAssets(list);

			//clear config
			config.dispose();
			config.removeEventListener(flash.events.Event.COMPLETE, loadConfigCompleteHandler);
			config.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			config.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
			config = null;
		}

		/**
		 * Error, asset not found!
		 * @param event
		 */
		private function loadErrorHandler(event:ErrorEvent):void {
			trace("Error: ", event);
		}
	}
}

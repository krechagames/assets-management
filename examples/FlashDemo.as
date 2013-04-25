/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 17.04.2013
 * Time: 16:55
 */
package  {
	import com.krechagames.utils.assets.AssetsConfig;
	import com.krechagames.utils.assets.AssetsLoader;
	import com.krechagames.utils.assets.AssetsStorage;
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.interfaces.IAssetsStorage;
	import com.krechagames.utils.assets.loaders.concrete.ImageAsset;
	import com.krechagames.utils.assets.loaders.concrete.SoundAsset;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;

	[SWF(width="1024", height="768", backgroundColor="0x000000", frameRate="30")]
	public class FlashDemo extends Sprite {
		/**
		 * Storage assets
		 */
		public var storage:IAssetsStorage;

		/**
		 * Assets loader
		 */
		public var loader:AssetsLoader;

		/**
		 * Config file (optional)
		 */
		public var config:AssetsConfig;

		public function FlashDemo() {
			super();

			if(stage == null) addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			else init(null);
		}

		/**
		 * Initialize
		 * @param e
		 */
		private function init(e:Event):void {
			//basic assets storage
			storage = new AssetsStorage();

			//assets loader and pass it to storage after load complete
			loader = new AssetsLoader(storage);
			loader.addEventListener(Event.COMPLETE, loadAssetsCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);

			//option #1: we can use config file to get assets to load
			config = new AssetsConfig("config", "assets/assets.xml", null); //load all assets from any group
			//config = new AssetsConfig("config", "assets/assets.xml", Vector.<String>(["common", "x2"])); //or load particular groups:
			config.addEventListener(Event.COMPLETE, loadConfigCompleteHandler, false, 0, true);
			config.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);
			config.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler, false, 0, true);
			config.load();

			//option #2: we can load assets manually, without config file
			/*
			loadAssets(Vector.<IAsset>([
				new TextAsset("lang", "assets/data/lang.xml"),
				new TextAsset("db", "assets/data/db.csv"),
				new ImageAsset("bg", "assets/textures/bg@x2.jpg"),
				new ImageAsset("logotype", "assets/textures/logotype@x2.jpg"),
				new SoundAsset("music", "assets/sounds/music.mp3")
			]))
			*/
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
		private function loadAssetsCompleteHandler(event:Event):void {
			var bg:Bitmap = ImageAsset(storage.getAsset("bg")).castBitmap;
			addChild(bg);

			var logotype:Bitmap = ImageAsset(storage.getAsset("logotype")).castBitmap;
			logotype.x = stage.stageWidth - logotype.width - 10;
			logotype.y = 10;
			addChild(logotype);

			var music:Sound = SoundAsset(storage.getAsset("music")).castSound;
			music.play();
		}

		/**
		 * Config file has been loaded
		 * @param event
		 */
		private function loadConfigCompleteHandler(event:Event):void {
			//load assets
			var list:Vector.<IAsset> = config.list;
			loadAssets(list);

			//clear config
			config.dispose();
			config.removeEventListener(Event.COMPLETE, loadConfigCompleteHandler);
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

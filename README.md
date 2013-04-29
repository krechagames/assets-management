assets-management
=================
Load and store assets (also for Starling). Manager assets in your project. Load and store any type of asset, prepare loaded file to use in IAssetsStorage class (create own storage like StarlingStorage).

Full description and manual here:
http://blog.krecha-games.com/assets-management/

example (native flash)
======================
This is the most simpliest use of AssetsManager. In this example we use external assets manifest assets.xml (below) to describe which file you want to load and what type are they.

```actionscript
//storage assets
var storage:IAssetsStorage = new AssetsStorage();

//load assets
var loader:AssetsLoader = new AssetsLoader(storage);
loader.addEventListener(Event.COMPLETE, loadAssetsCompleteHandler, false, 0, true);
loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);

//(optional) load assets.xml with assets manifest
var config:AssetsConfig = new AssetsConfig("config", "./assets/assets.xml", null);
config.addEventListener(Event.COMPLETE, loadConfigCompleteHandler, false, 0, true);
config.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);
config.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler, false, 0, true);
config.load();

//1. Load assets.xml complete, load assets from manifest
function loadConfigCompleteHandler(event:Event):void {
  loadAssets(config.list);
}

//2. Load assets list. List can be pass manually or load from assets.xml
function loadAssets(list:Vector.<IAsset>):void {
  loader.load(list);
}

//3a. Load assets complete, do whatever you want to do with. AssetsLoader's job is done!
function loadAssetsCompleteHandler(event:Event):void {
	var bg:Bitmap = ImageAsset(storage.getAsset("bg")).castBitmap;

	var logotype:Bitmap = ImageAsset(storage.getAsset("logotype")).castBitmap;

	var music:Sound = SoundAsset(storage.getAsset("music")).castSound;

}

//3b. Error, asset not found!
function loadErrorHandler(event:ErrorEvent):void {
	trace("Error: ", event);
}

//Dispose all objects
function dispose():void {
	config.dispose();
	config.removeEventListener(Event.COMPLETE, loadConfigCompleteHandler);
	config.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
	config.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
	config = null;

	loader.removeEventListener(Event.COMPLETE, loadAssetsCompleteHandler);
	loader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
	loader = null;

	storage.dispose();
	storage = null;
}
```
```xml
<?xml version="1.0" encoding="utf-8" ?>
<data>
    <group name="common">
        <asset id="db" url="assets/data/db.csv" type="text" />
        <asset id="lang" url="assets/data/lang.xml" type="text" />
        <asset id="music" url="assets/sounds/music.mp3" type="sound" />
    </group>

    <group name="x1">
        <asset id="bg" url="assets/textures/bg@x1.jpg" type="image" />
        <asset id="logotype" url="assets/textures/logotype@x1.jpg" type="image" />

        <asset id="atlas" url="assets/textures/atlas@x1.png" type="image" />
        <asset id="atlas_xml" url="assets/textures/atlas@x1.xml" type="text" />

        <asset id="compressed_texture" url="assets/textures/compressed_texture@x1.atf" type="raw" />
    </group>

    <group name="x2">
        <asset id="bg" url="assets/textures/bg@x2.jpg" type="image" />
        <asset id="logotype" url="assets/textures/logotype@x2.jpg" type="image" />

        <asset id="atlas" url="assets/textures/atlas@x2.png" type="image" />
        <asset id="atlas_xml" url="assets/textures/atlas@x2.xml" type="text" />

        <asset id="compressed_texture" url="assets/textures/compressed_texture@x2.atf" type="raw" />
    </group>
</data>
```

example (Starling)
==================
You can use any type of assets storage! Just what you need is to create class that implements IAssetsStorage (or extends AssetsStorage class which is the basic implementation of IAssetsStorage). Example of this approach is StarlingStorage class. Features of this storage is few new methods which prepering textures to use. More info here: http://bit.ly/11l7Ul2

Prepare loader and config like in above example:
```actionscript
//storage assets
var storage:StarlingStorage = new StarlingStorage();

//load assets
var loader:AssetsLoader = new AssetsLoader(storage);
loader.addEventListener(Event.COMPLETE, loadAssetsCompleteHandler, false, 0, true);
loader.load(Vector.<IAsset>([ /* assets from manifest or pass manually */  ]));

//3a. Load assets complete, do whatever you want to do with. AssetsLoader's job is done!
function loadAssetsCompleteHandler(event:Event):void {
  var img:Image = new Image(storage.getTexture("atlasName", "textureName"));

  var tf:TextField = new TextField(100, 100, "text", storage.getBitmapFont("fontName"));

  var sound:SoundAsset = SoundAsset(storage.getAsset("music")).castSound;
}
```

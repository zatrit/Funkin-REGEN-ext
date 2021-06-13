package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var http = new haxe.Http("https://raw.githubusercontent.com/zatrit/Funkin-REGEN-ext/master/version.downloadMe");
		var githubVersion:String;
		var ver = Application.current.meta.get('version');
			
		http.onData = function (data:String)
		{
			githubVersion=data;
		}
		http.onError = (msg:String)->{
			githubVersion="";
			trace(msg);
		};
		http.request();

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running an outdated version of the game!\nCurrent version is "
			+ ver
			+ " while the most recent version is "
			+ githubVersion
			#if !mobile
			+ "! Press SPACE to go to github repo, or ESCAPE to ignore this!!"
			#else
			+ "! Touch screen to ignore this!!"
			#end
			,32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT#if mobile || FlxG.touches.justStarted().length>0 #end)
		{
			#if !mobile
			FlxG.openURL("https://github.com/zatrit/Funkin-REGEN-ext");
			#else
			leftState = true;
			FlxG.switchState(new MainMenuState());
			#end
		}
		#if !mobile
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		#end
		super.update(elapsed);
	}
}

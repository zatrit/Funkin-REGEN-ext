package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DisclaimerSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"WARNING\n\n"
			+ "There are a lot of flashing lights in the game.\n"
			+ "If you have photosensitivity or have had epileptic\n"
			+ "seizures, it is better not to play this, \n"
			+ "or at least turn on the Photosensitivity Mode \n"
			+ "in the game options. "
			+ "If you feel unwell while playing, \nquit the game immediately. ",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT #if mobile || FlxG.touches.justStarted().length > 0 #end)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}

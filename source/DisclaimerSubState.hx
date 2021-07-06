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
			"DISCLAIMER\n\n"
			+ "Some moments in this game can cause epilepsy.\n"

			+ "If you have had epileptic seizures or feeling badly while playing, you better not playю\n"
			+ "The game developer is not responsible for this. ",
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

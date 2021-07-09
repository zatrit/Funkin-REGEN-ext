// Source: https://github.com/luckydog7/Funkin-android
package options;

import lime.app.Application;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class AboutState extends MusicBeatState
{
	var logoBl:FlxSprite;

	var text:FlxText;

	override function create()
	{
		// LOAD MUSIC
		// LOAD CHARACTERS
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/${MainMenuState.bgStyle}/menuBGBlue', 'preload'));

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.y = logoBl.y - 100;

		text = new FlxText(0, 0, 0, "version "
			+ Application.current.meta.get('version')
			+ "\n"
			#if mobile + "ported by zatrit" + "\n" #end
			+ "about screen(OMG, it's awesome) by luckydog7", 16);

		text.setFormat("Delfino", 24, FlxColor.WHITE, CENTER);
		text.antialiasing = true;
		text.screenCenter();
		text.y = text.y + 150;

		add(bg);
		add(logoBl);
		add(text);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
	}

	override function onBack()
	{
		FlxG.switchState(new OptionsState());
	}
}

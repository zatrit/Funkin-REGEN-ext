package options;

import flixel.FlxG;

class DefaultOptions
{
	public static function setOptionsDefaults()
	{
		if (FlxG.save.data.scoreDisplay == null)
			FlxG.save.data.scoreDisplay = true;

		if (FlxG.save.data.healthDisplay == null)
			FlxG.save.data.healthDisplay = true;

		if (FlxG.save.data.animEvents == null)
			FlxG.save.data.animEvents = true;

		if (FlxG.save.data.notes == null)
			FlxG.save.data.notes = 0;

		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.safeFrames == null)
			FlxG.save.data.safeFrames = 10;

		if (FlxG.save.data.splashing == null)
			FlxG.save.data.splashing = true;

		FlxG.save.flush();
	}
}

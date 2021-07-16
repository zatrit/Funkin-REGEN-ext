package options;

import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.addons.ui.FlxSlider;
import flixel.FlxG;
import StringTools;

class GameplayOptionsSubstate extends OptionsSubState
{
	final NEW_INPUT_NUMBER = #if mobile 1 #else 0 #end;
	final GHOST_NUMBER = #if mobile 2 #else 1 #end;
	final SKIP_CUTSCENES_NUMBER = #if mobile 3 #else 2 #end;

	public function new(parent:OptionsState)
	{
		final items:Array<String> = [
			#if mobile 'Controls',
			#end
			(FlxG.save.data.newInput ? 'new input' : 'old input'),
			'ghost tap: ' + (FlxG.save.data.ghost ? 'on' : 'off'),
			'skip cutscenes: ' + (FlxG.save.data.skipCutscenes ? 'on' : 'off'), // 'safe frames: ' + FlxG.save.data.safeFrames,
		];

		super(parent, items);
	}

	override function onSelect(value:String = "", number:Int = 0)
	{
		switch (value)
		{
			#if mobile
			case "Controls":
				FlxG.state.closeSubState();
				FlxG.state.openSubState(new MobileControlsSubState(parent));
			#end
			case 'new input' | 'old input':
				{
					var newInput:Bool = FlxG.save.data.newInput;

					FlxG.save.data.newInput = toggleBoolOption(NEW_INPUT_NUMBER, "", newInput, "new input", "old input");
					FlxG.save.flush();
				}

			case 'ghost tap: off' | 'ghost tap: on':
				{
					var ghost:Bool = FlxG.save.data.ghost;

					FlxG.save.data.ghost = toggleBoolOption(GHOST_NUMBER, "ghost tap: ", ghost);
					FlxG.save.flush();
				}
			case 'skip cutscenes: off' | 'skip cutscenes: on':
				{
					var skipCutscenes:Bool = FlxG.save.data.skipCutscenes;

					FlxG.save.data.skipCutscenes = toggleBoolOption(SKIP_CUTSCENES_NUMBER, "skip cutscenes: ", skipCutscenes);
					FlxG.save.flush();
				}
				// case 'safeFrames:':
				//	{
				//	}
		}
	}
}

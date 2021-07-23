package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuBGSelectorSubState extends OptionsSubState
{
	public function new(parent:OptionsState)
	{
		final items:Array<String> = [
			'default',
			'garcello',
			'whitty',
			'kapi',
			'tricky',
			'tricky amogus',
			'tord',
			'agoti'
		];

		super(parent, items, true, true);
		acceptNonReleased = true;

		curSelected = textMenuItems.indexOf(MainMenuState.bgStyle);
		changeSelection();
	}

	override function onSelect(value:String = "", number:Int = 0)
	{
		super.onSelect(value, number);

		var bgStyle:String = textMenuItems[curSelected];

		MainMenuState.bgStyle = bgStyle;
		FlxG.save.data.bgStyle = bgStyle;
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);

		var bgStyle:String = textMenuItems[curSelected];
		parent.menuBG.loadGraphic(Paths.image('menuBG/${bgStyle}/menuDesat', 'preload'));
	}
}

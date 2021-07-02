package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuBGSelectorSubState extends OptionsSubState
{
	public function new(parent:OptionsState)
	{
		final items:Array<String> = ['default', 'garcello', 'whitty', 'kapi','tricky','tricky amogus'];

		super(parent,items);

		curSelected=textMenuItems.indexOf(MainMenuState.bgStyle);
	}

	override function onSelect(value:String = "", number:Int = 0) {
		super.onSelect(value, number);

		var bgStyle:String=textMenuItems[curSelected];
		
		MainMenuState.bgStyle=bgStyle;
		FlxG.save.data.bgStyle=bgStyle;
		FlxG.save.flush();
		
		FlxG.sound.play(Paths.sound('confirmMenu'));

		close();
	}
	
	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);

        var bgStyle:String=textMenuItems[curSelected];
        parent.menuBG.loadGraphic(Paths.image(bgStyle+'/menuDesat','menuBackgrounds'));
	}
}

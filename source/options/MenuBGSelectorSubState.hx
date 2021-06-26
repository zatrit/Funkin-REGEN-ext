package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuBGSelectorSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['default', 'garcello', 'whitty', 'kapi','tricky','tricky amogus'];
	final DIST_BEETWEN_ITEMS = #if !mobile 1 #else 0.7 #end;
	var grpOptions:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;

	var parent:OptionsState;

	public function new(parent:OptionsState)
	{
		super();

		this.parent=parent;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, ((105 * i)+30), textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			#if mobile
			optionText.targetY=(i-2)*DIST_BEETWEN_ITEMS;
			#end

			grpOptions.add(optionText);
		}

		curSelected=textMenuItems.indexOf(MainMenuState.bgStyle);
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var accept:Bool=controls.ACCEPT;

		#if mobile
		for (item in grpOptions.members)
			for(touch in FlxG.touches.list){
				if(touch.overlaps(item)){
					curSelected=item.ID;
					changeSelection();
					accept=true;
				}
			}
		#end

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (accept)
		{
            var bgStyle:String=textMenuItems[curSelected];
			
			MainMenuState.bgStyle=bgStyle;
            FlxG.save.data.bgStyle=bgStyle;
			FlxG.save.flush();
			
			FlxG.sound.play(Paths.sound('confirmMenu'));

			close();
		}
	}
	
	function changeSelection(change:Int = 0)
	{
	
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
		curSelected += change;
	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

        var bgStyle:String=textMenuItems[curSelected];
        parent.menuBG.loadGraphic(Paths.image(bgStyle+'/menuDesat','menuBackgrounds'));
	
		// selector.y = (70 * curSelected) + 30;
	
		var bullShit:Int = 0;

		#if !mobile
		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));
	
			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		#end
	}
}

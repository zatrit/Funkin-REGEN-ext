package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [#if mobile 'Controls', #end 'GitHub repo','About'];
	var grpOptions:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;

	public function new()
	{
		super();

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (105 * i)+30, textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			#if mobile
			optionText.targetY=i-2;
			#end

			grpOptions.add(optionText);
		}

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
			switch (textMenuItems[curSelected])
			{
				#if mobile
				case "Controls":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new MobileControlsSubState());
				#end
				case "GitHub repo":
					FlxG.openURL("https://github.com/zatrit/Funkin-REGEN");
				case "About":
					FlxG.switchState(new AboutState());
			}
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

package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [#if mobile 'Controls', #end 'kade input: off','skip cutscenes: off','ghost tap: off','Menu background selector', 'About'];
	var grpOptions:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;

	final KADE_INPUT_NUMBER = #if mobile 1 #else 0 #end;
	final SKIP_CUTSCENES_NUMBER = #if mobile 2 #else 1 #end;
	final GHOST_NUMBER = #if mobile 3 #else 2 #end;

	#if mobile
	final DIST_BEETWEN_ITEMS = 0.7;
	#end

	public var parent:OptionsState;

	public function new(parent:OptionsState)
	{
		super();		
		
		if(FlxG.save.data.kadeInput)
			textMenuItems[KADE_INPUT_NUMBER]='kade input: on';
		if(FlxG.save.data.skipCutscenes)
			textMenuItems[SKIP_CUTSCENES_NUMBER]='skip cutscenes: on';
		if(FlxG.save.data.ghost)
			textMenuItems[GHOST_NUMBER]='ghost tap: on';


		this.parent=parent;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (105 * i)+30, textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			#if mobile
			optionText.targetY=(i-2.5)*DIST_BEETWEN_ITEMS;
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
				if(touch.overlaps(item)&&touch.justPressed){
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
				case "Menu background selector":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new MenuBGSelectorSubState(parent));
				case "About":
					FlxG.switchState(new AboutState());
				case 'kade input: off' | 'kade input: on':
					{
						var kadeInput:Bool=FlxG.save.data.kadeInput;

						FlxG.save.data.kadeInput=toggleOption(KADE_INPUT_NUMBER,"kade input",kadeInput);
						FlxG.save.flush();
					}
				case 'skip cutscenes: off' | 'skip cutscenes: on':
					{
						var skipCutscenes:Bool=FlxG.save.data.skipCutscenes;
						
						FlxG.save.data.skipCutscenes=toggleOption(SKIP_CUTSCENES_NUMBER,"skip cutscenes",skipCutscenes);
						FlxG.save.flush();
					}
				
				case 'ghost tap: off' | 'ghost tap: on':
					{
						var ghost:Bool=FlxG.save.data.ghost;
		
						FlxG.save.data.ghost=toggleOption(GHOST_NUMBER,"ghost tap",ghost);
						FlxG.save.flush();
					}
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
	function toggleOption(num:Int=0,text:String="",oldVal:Bool=false):Bool{
		var oldAlphabet=grpOptions.members[num];

		var newVal=!oldVal;
		
		textMenuItems[num]='$text: ' + (newVal ? 'on' : 'off');
			
		var alphabet:Alphabet = new Alphabet(0, 0, textMenuItems[num], true, false);
		alphabet.ID = num;
		alphabet.isMenuItem = true;

		alphabet.x=oldAlphabet.x;
		alphabet.y=oldAlphabet.y;
		alphabet.targetY=oldAlphabet.targetY;

		grpOptions.replace(oldAlphabet,alphabet);

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		return newVal;
	}
}

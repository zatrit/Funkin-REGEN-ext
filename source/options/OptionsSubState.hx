package options;

#if mobile
import mobile.MobileControls;
#end
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String>;
	var grpOptions:FlxTypedGroup<Alphabet>;

	var itemHighlightOnMobile:Bool;

	public var values:Array<Int> = new Array<Int>();

	var curSelected:Int = 0;
	var oldCurSelected:Int = 0;

	#if mobile
	var itemDiff = 0.7;
	#end

	var enableScrolling:Bool = false;
	var scroll:Float = 1;
	#if mobile
	var mobileControls:MobileControls;
	#end
	var acceptNonReleased:Bool = false;

	public var parent:OptionsState;

	final BOLD:Bool = true;

	public function new(parent:OptionsState, items:Array<String>, itemHighlightOnMobile:Bool = false, enableScrolling = false)
	{
		super();

		this.parent = parent;
		this.textMenuItems = items;
		this.itemHighlightOnMobile = itemHighlightOnMobile;
		this.enableScrolling = enableScrolling;

		createItems();
		changeSelection();

		#if mobile
		if (enableScrolling)
		{
			this.mobileControls = new MobileControls(camera, camera.width - 510, camera.height - 410, 1);
			mobileControls.left.visible = false;
			mobileControls.right.visible = false;
			add(mobileControls);
		}
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var accept:Bool = controls.ACCEPT;

		#if mobile
		if ((enableScrolling && !(mobileControls.up.pressed || mobileControls.down.pressed)) || !enableScrolling)
			for (item in grpOptions.members)
				for (touch in FlxG.touches.list)
				{
					if (touch.overlaps(item) && touch.pressed)
					{
						curSelected = item.ID;
						changeSelection();
						if (acceptNonReleased)
							accept = true;
					}
					if (touch.overlaps(item) && touch.justReleased && !acceptNonReleased)
					{
						accept = true;
					}
				}
		if (enableScrolling)
		{
			if (mobileControls.down.justPressed)
			{
				scroll--;
				changeSelection();
			}
			if (mobileControls.up.justPressed)
			{
				scroll++;
				changeSelection();
			}
		}
		#end

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (accept)
		{
			onSelect(textMenuItems[curSelected], curSelected);
		}
	}

	function changeSelection(change:Int = 0)
	{
		// NGio.logEvent('Fresh');\

		curSelected += change;

		// if(scroll<2.5)
		//	scroll=-2.5;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		if (curSelected != oldCurSelected)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			#if mobile
			if (enableScrolling)
			{
				if (scroll > 1)
					scroll = 1;
				if (scroll < -textMenuItems.length + 4)
					scroll = -textMenuItems.length + 4;
			#end
				#if !mobile
				item.targetY = bullShit - curSelected;
				#else
				item.targetY = bullShit + scroll - 2;
				#end
				bullShit++;
			#if mobile
			}
			#end

			#if mobile
			if (itemHighlightOnMobile)
			#end
			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			#if !mobile
			if (item.targetY == 0)
			#else
			if (item.ID == curSelected && itemHighlightOnMobile)
			#end
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		oldCurSelected = curSelected;
	}

	function toggleBoolOption(num:Int = 0, text:String = "", oldVal:Bool = false, on:String = 'on', off:String = 'off'):Bool
	{
		var oldAlphabet = grpOptions.members[num];

		var newVal = !oldVal;

		textMenuItems[num] = text + (newVal ? on : off);

		var alphabet:Alphabet = new Alphabet(0, 0, textMenuItems[num], BOLD, false);
		alphabet.ID = num;
		alphabet.isMenuItem = true;

		alphabet.x = oldAlphabet.x;
		alphabet.y = oldAlphabet.y;
		alphabet.targetY = oldAlphabet.targetY;

		grpOptions.replace(oldAlphabet, alphabet);
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		return newVal;
	}

	function toggleArrayOption(num:Int = 0, text:String = "", oldVal:Int = 0, values:Array<String>):Int
	{
		var oldAlphabet = grpOptions.members[num];

		var newVal = oldVal + 1;
		if (newVal >= values.length)
			newVal = 0;

		textMenuItems[num] = text + values[newVal];

		var alphabet:Alphabet = new Alphabet(0, 0, textMenuItems[num], BOLD, false);
		alphabet.ID = num;
		alphabet.isMenuItem = true;

		alphabet.x = oldAlphabet.x;
		alphabet.y = oldAlphabet.y;
		alphabet.targetY = oldAlphabet.targetY;

		grpOptions.replace(oldAlphabet, alphabet);
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		return newVal;
	}

	function toggleFloatOption(num:Int = 0, text:String = "", oldVal:Float = 0, min:Float = 0, max:Float = 1, step:Float = 0.25):Float
	{
		var oldAlphabet = grpOptions.members[num];

		var newVal = oldVal + step;

		if (newVal > max)
			newVal = min;
		if (newVal < min)
			newVal = max;

		textMenuItems[num] = text + newVal;

		var alphabet:Alphabet = new Alphabet(0, 0, textMenuItems[num], BOLD, false);
		alphabet.ID = num;
		alphabet.isMenuItem = true;

		alphabet.x = oldAlphabet.x;
		alphabet.y = oldAlphabet.y;
		alphabet.targetY = oldAlphabet.targetY;

		grpOptions.replace(oldAlphabet, alphabet);
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		return newVal;
	}

	function onSelect(value:String = "", number:Int = 0)
	{
	}

	override function close()
	{
		FlxG.save.flush();

		super.close();
	}

	override function onBack()
	{
		parent.onBack();
		close();
	}

	function createItems()
	{
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (105 * i) + 30, textMenuItems[i], BOLD, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			#if mobile
			optionText.targetY = (i - (textMenuItems.length / 2)) * itemDiff;
			#end

			grpOptions.add(optionText);
		}
	}
}

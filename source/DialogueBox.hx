package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'fading':
				FlxG.sound.playMusic(Paths.music('city_ambience', 'weekG'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'screenplay':
				FlxG.sound.playMusic(Paths.music('screenplaydialogue', 'agoti'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.45);
			case 'parasite':
				FlxG.sound.playMusic(Paths.music('prisonbreak', 'agoti'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.45);
			case 'a.g.o.t.i':
				FlxG.sound.playMusic(Paths.music('void', 'agoti'), 0);
				FlxG.sound.music.fadeIn(1, 0, 1);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'headache':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('garBox', 'weekG');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'nerves':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('garWeak', 'weekG'));

				box.frames = Paths.getSparrowAtlas('garBox', 'weekG');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'release':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('garBox', 'weekG');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'fading':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('garBox', 'weekG');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'lo-fight' | 'overhead' | 'ballistic':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
				box.antialiasing = true;

			case 'wocky' | 'beathoven' | 'hairball' | 'nyaw':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('weeb/dialogueBox-kapi', 'kapiWeek');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance', 24, false);
				box.animation.addByPrefix('normal', 'Text Box Appear instance', 24, false);
				box.antialiasing = true;
			case 'screenplay' | 'parasite' | 'a.g.o.t.i':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('Dialogue_Box', 'agoti');
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.animation.addByPrefix('normal', 'P5_Box', 24, true);
				box.animation.addByIndices('normalOpen', 'P5_Box', [4], "", 24, false);
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'lo-fight' | 'overhead' | 'ballistic':
				box.flipX = true;
				box.x = 40;
				box.y = FlxG.height - 340;
			case 'wocky' | 'beathoven' | 'hairball' | 'nyaw':
				box.y = 0;
				box.screenCenter(X);
			case 'screenplay' | 'parasite' | 'a.g.o.t.i':
				box.flipX = true;
				box.scale.set(1.25, 1.25);
				box.updateHitbox();
				box.screenCenter(X);
				box.y = FlxG.height - 400;
			default:
				box.y = FlxG.height - 340;
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'headache':
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Default', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'nerves':
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Nervous', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'release':
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Ghost', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'fading':
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Dippy', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'lo-fight' | 'overhead' | 'ballistic':
				portraitLeft = new FlxSprite(200, FlxG.height - 525);
				portraitLeft.frames = Paths.getSparrowAtlas('whittyPort', 'bonusWeek');
				portraitLeft.antialiasing = true;
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'wocky' | 'beathoven' | 'hairball' | 'nyaw':
				portraitLeft = new FlxSprite(0, 160);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapi', 'kapiWeek');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 1));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			case 'screenplay' | 'parasite' | 'a.g.o.t.i':
				portraitLeft = new FlxSprite();
				portraitLeft.frames = Paths.getSparrowAtlas('Agoti_Dialogue', 'agoti');
				portraitLeft.animation.addByPrefix('normal', 'Agoti_Dialogue_A', 24, false);
				portraitLeft.animation.addByPrefix('angry', 'Agoti_Dialogue_B', 24, false);
				portraitLeft.animation.addByPrefix('scared', 'Agoti_Dialogue_C', 24, false);
				portraitLeft.animation.addByPrefix('crazy', 'Agoti_Dialogue_D', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.screenCenter(X);
				portraitLeft.y += 125;
				portraitLeft.x -= 275;
				add(portraitLeft);
				portraitLeft.visible = false;
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses':
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'headache' | 'nerves' | 'release' | 'fading':
				portraitRight = new FlxSprite(770, 200);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bf_norm');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait Enter', 24, false);
				// portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.4));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'lo-fight' | 'overhead' | 'ballistic':
				portraitRight = new FlxSprite(800, FlxG.height - 489);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bf_norm', 'shared');
				portraitRight.animation.addByPrefix('enter', 'BF portrait enter', 24, false);
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'wocky' | 'beathoven' | 'hairball' | 'nyaw':
				portraitRight = new FlxSprite(700, 220);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bf_norm', 'shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 1));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'screenplay' | 'parasite' | 'a.g.o.t.i':
				portraitRight = new FlxSprite(700, 200);
				portraitRight.frames = Paths.getSparrowAtlas('BF_Dialogue', 'agoti');
				portraitRight.animation.addByPrefix('normal', 'BF_Dialogue_A', 24, false);
				portraitRight.animation.addByPrefix('scared', 'BF_Dialogue_B', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'nyaw' | 'hairball' | 'beathoven' | 'wocky':
				portraitMiddle = new FlxSprite(350, 90);
				portraitMiddle.frames = Paths.getSparrowAtlas('weeb/gf', 'kapiWeek');
				portraitMiddle.animation.addByPrefix('enter', 'Girlfriend portrait enter', 24, false);
				portraitMiddle.setGraphicSize(Std.int(portraitRight.width * 1.5), Std.int(portraitRight.height * 1.5));
				portraitMiddle.updateHitbox();
				portraitMiddle.scrollFactor.set();
				add(portraitMiddle);
				portraitMiddle.visible = false;
		}

		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		if (![
			'lo-fight', 'overhead', 'ballistic', 'wocky', 'beathoven', 'hairball', 'nyaw', 'screenplay', 'parasite', 'a.g.o.t.i'
		].contains(PlayState.SONG.song.toLowerCase()))
		{
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.screenCenter(X);
		}

		portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		var font:String = 'Pixel Arial 11 Bold';
		var size:Int = 32;
		if (['wocky', 'beathoven', 'hairball', 'nyaw'].contains(PlayState.SONG.song.toLowerCase()))
		{
			font = 'Delfino';
			size = 48;
		}
		if (['a.g.o.t.i', 'screenplay', 'parasite'].contains(PlayState.SONG.song.toLowerCase()))
		{
			font = 'p5hatty';
			size = 65;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", size);
		dropText.font = font;
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", size);
		swagDialogue.font = font;
		//swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'roses' | 'senpai':
				portraitLeft.visible = false;

				dropText.color = 0xFFD89494;
				swagDialogue.color = 0xFF3F2021;
			case 'thorns':
				portraitLeft.color = FlxColor.BLACK;
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			case 'headache' | 'nerves':
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			case 'release':
				swagDialogue.color = 0xFF0DF07E;
				dropText.color = FlxColor.BLACK;
			case 'fading':
				swagDialogue.color = 0xFF0DF07E;
				dropText.color = FlxColor.BLACK;
			case 'parasite' | 'screenplay' | 'a.g.o.t.i':
				swagDialogue.color = FlxColor.fromRGB(30, 30, 30);
				dropText.color = FlxColor.fromRGB(90, 90, 90);
			default:
				swagDialogue.color = 0xFF000000;
				dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		var touch:Bool = false;

		#if mobile
		for (scrTouch in FlxG.touches.list)
		{
			touch = scrTouch.justPressed || touch;
		}
		#end

		if ((FlxG.keys.justPressed.ANY || touch) && dialogueStarted == true)
		{
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'thorns'
						|| PlayState.SONG.song.toLowerCase() == 'fading')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						if (portraitMiddle != null)
							portraitMiddle.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (portraitMiddle != null)
					portraitMiddle.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (portraitMiddle != null)
					portraitMiddle.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'kapimad':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapimad', 'kapiWeek');
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'kapiconfused':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapiconfused', 'kapiWeek');
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'kapicute':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapicute', 'kapiWeek');
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'kapistare':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapistare', 'kapiWeek');
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'wap':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/wap', 'kapiWeek');
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.frames = Paths.getSparrowAtlas('weeb/gf', 'kapiWeek');

				if (!portraitMiddle.visible)
				{
					portraitMiddle.visible = true;
					portraitMiddle.animation.play('enter');
				}
			case 'gfwave':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.frames = Paths.getSparrowAtlas('weeb/gfwave', 'kapiWeek');

				if (!portraitMiddle.visible)
				{
					portraitMiddle.visible = true;
					portraitMiddle.animation.play('enter');
				}
			case 'gflaugh':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.frames = Paths.getSparrowAtlas('weeb/gflaugh', 'kapiWeek');

				if (!portraitMiddle.visible)
				{
					portraitMiddle.visible = true;
					portraitMiddle.animation.play('enter');
				}
			case 'bf-scared':
				portraitLeft.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText', 'agoti'), 0.6)];
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			case 'agoti':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
				portraitLeft.animation.play('normal');
			case 'agoti-angry':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiAngryText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
				portraitLeft.animation.play('angry');
			case 'agoti-scared':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiScaredText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
				portraitLeft.animation.play('scared');
			case 'agoti-crazy':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiScaredText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
				portraitLeft.animation.play('crazy');
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}

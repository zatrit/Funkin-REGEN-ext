package playstate;

import ripper.Spirit;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayStateCutscenes implements Spirit
{
	function garIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		this.add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		red.scrollFactor.set();

		var sexycutscene:FlxSprite = new FlxSprite();
		sexycutscene.antialiasing = true;
		sexycutscene.frames = Paths.getSparrowAtlas('GAR_CUTSCENE', 'weekG');
		sexycutscene.animation.addByPrefix('video', 'garcutscene', 15, false);
		sexycutscene.setGraphicSize(Std.int(sexycutscene.width * 2));
		sexycutscene.scrollFactor.set();
		sexycutscene.updateHitbox();
		sexycutscene.screenCenter();

		if (PlayState.SONG.song.toLowerCase() == 'nerves' || PlayState.SONG.song.toLowerCase() == 'release')
		{
			remove(black);

			if (PlayState.SONG.song.toLowerCase() == 'release')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.1);
			}
			else
			{
				if (dialogueBox != null)
				{
					this.inCutscene = true;

					if (PlayState.SONG.song.toLowerCase() == 'release')
					{
						this.camHUD.visible = false;
						this.add(red);
						this.add(sexycutscene);
						sexycutscene.animation.play('video');

						FlxG.sound.play(Paths.sound('Garcello_Dies', 'weekG'), 1, false, null, true, function()
						{
							remove(red);
							remove(sexycutscene);
							FlxG.sound.play(Paths.sound('Wind_Fadeout', 'weekG'));

							FlxG.camera.fade(FlxColor.WHITE, 5, true, function()
							{
								add(dialogueBox);
								camHUD.visible = true;
							}, true);
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}


	function agotiIntroDialogue(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.setGraphicSize(Std.int(black.width * 5));
		black.scrollFactor.set();
		this.add(black);

		this.healthBarBG.visible = false;
		this.healthBar.visible = false;
		this.iconP1.visible = false;
		this.iconP2.visible = false;
		this.scoreTxt.visible = false;

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					this.inCutscene = true;

					this.add(dialogueBox);
				}
				else
					this.startCountdown();

				this.remove(black);
			}
		});
	}
}

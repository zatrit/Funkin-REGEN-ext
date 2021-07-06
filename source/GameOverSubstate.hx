package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var arcade:Bool = false;
	var clown:Bool = false;

	var bfThought:FlxSprite;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'arcade' | 'arcadeclosed':
				daBf = 'bf';
				arcade = true;
			case 'auditorHell' | 'nevada' | 'nevadaSpook':
				daBf = 'signDeath';
				clown = true;
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		if (!clown)
		{
			FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
			Conductor.changeBPM(100);
		}
		else
		{
			FlxG.sound.play(Paths.sound('BF_Deathsound', 'clown'));
			FlxG.sound.play(Paths.sound('Micdrop', 'clown'));
			Conductor.changeBPM(200);
		}

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		if (!arcade)
			bf.playAnim('firstDeath');
		else
		{
			bf.playAnim('arcadeDeath');

			bfThought = new FlxSprite(bf.x - bf.width - 200, 30).loadGraphic(Paths.image('bfThought', 'kapiWeek'));
			bfThought.flipX = true;
			add(bfThought);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT #if mobile || FlxG.touches.justStarted().length > 0 #end)
		{
			endBullshit();
		}

		var firstDeath = (bf.animation.curAnim.name == 'firstDeath' || bf.animation.curAnim.name == 'arcadeDeath');

		if (firstDeath && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (firstDeath && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix, clown ? "clown" : "shared"));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if (!arcade)
				bf.playAnim('deathConfirm', true);
			else
			{
				bf.playAnim('arcadeDeathConfirm', true);
			}
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix, clown ? "clown" : "shared"));
			if (bfThought != null)
				FlxTween.tween(bfThought, {alpha: 0}, 0.7);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					PlayState.firstTry = false;
					PlayState.attempt++;
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}

	override function onBack()
	{
		FlxG.sound.music.stop();

		if (PlayState.isStoryMode)
			FlxG.switchState(new StoryMenuState());
		else
			FlxG.switchState(new FreeplayState());
	}
}

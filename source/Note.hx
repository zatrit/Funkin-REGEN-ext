package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var burning:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public static final NOTE_STYLES:Array<String> = [
		'notes/NOTE_assets',
		'notes/NOTE_assets-kapi',
		'notes/NOTE_assets-agoti',
		'notes/NOTE_assets-genocide'
	];

	public static final NOTE_SPLASHES:Array<String> = [
		'notes/noteSplashes',
		'notes/noteSplashes-kapi',
		'notes/noteSplashes',
		'notes/noteSplashes'
	];

	public function new(strumTime:Float, _noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		burning = _noteData > 7;

		this.noteData = (_noteData % 4);

		if (isSustainNote && prevNote.burning)
		{
			burning = true;
		}

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				var notes:Int = PlayState.staticVar.noteSkins;

				frames = Paths.getSparrowAtlas(NOTE_STYLES[notes], 'shared');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				if (burning)
				{
					if (daStage == 'auditorHell')
					{
						frames = Paths.getSparrowAtlas('fourth/mech/ALL_deathnotes', "clown");
						animation.addByPrefix('greenScroll', 'Green Arrow');
						animation.addByPrefix('redScroll', 'Red Arrow');
						animation.addByPrefix('blueScroll', 'Blue Arrow');
						animation.addByPrefix('purpleScroll', 'Purple Arrow');
						x -= 165;
					}
					else
					{
						frames = Paths.getSparrowAtlas('NOTE_fire', "clown");

						if (!FlxG.save.data.downscroll)
						{
							animation.addByPrefix('blueScroll', 'blue fire');
							animation.addByPrefix('greenScroll', 'green fire');
						}
						else
						{
							animation.addByPrefix('greenScroll', 'blue fire');
							animation.addByPrefix('blueScroll', 'green fire');
						}

						animation.addByPrefix('redScroll', 'red fire');
						animation.addByPrefix('purpleScroll', 'purple fire');

						if (FlxG.save.data.downscroll)
							flipY = true;

						x -= 50;
					}
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		if (burning)
			setGraphicSize(Std.int(width * 0.86));

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			if (FlxG.save.data.downscroll)
			{
				flipY = false;
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				if (FlxG.save.data.downscroll)
					flipY = true;

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (!burning)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (PlayState.curStage == 'auditorHell') // these though, REALLY hard to hit.
				{
					if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.3)
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) // also they're almost impossible to hit late!
						canBeHit = true;
					else
						canBeHit = false;
				}
				else
				{
					// The * 0.5 is so that it's easier to hit them too late, instead of too early
					if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						canBeHit = true;
					else
						canBeHit = false;

					if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
						tooLate = true;
				}
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}

	public function splash():FlxSprite
	{
		var sploosh = new FlxSprite(x, y);
		switch (PlayState.curStage)
		{
			default:
				var notes:Int = PlayState.staticVar.noteSkins;

				var tex:FlxAtlasFrames = Paths.getSparrowAtlas(NOTE_SPLASHES[notes], 'shared');
				sploosh.frames = tex;

				sploosh.animation.addByPrefix('splash 0 0', 'note impact 1 purple', 24, false);
				sploosh.animation.addByPrefix('splash 0 1', 'note impact 1 blue', 24, false);
				sploosh.animation.addByPrefix('splash 0 2', 'note impact 1 green', 24, false);
				sploosh.animation.addByPrefix('splash 0 3', 'note impact 1 red', 24, false);
				sploosh.animation.addByPrefix('splash 1 0', 'note impact 2 purple', 24, false);
				sploosh.animation.addByPrefix('splash 1 1', 'note impact 2 blue', 24, false);
				sploosh.animation.addByPrefix('splash 1 2', 'note impact 2 green', 24, false);
				sploosh.animation.addByPrefix('splash 1 3', 'note impact 2 red', 24, false);

				PlayState.staticVar.add(sploosh);
				sploosh.cameras = [PlayState.staticVar.noteCam];
				sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + noteData);
				sploosh.alpha = 0.6;
				sploosh.offset.x += 90;
				sploosh.offset.y += 80;
				sploosh.animation.finishCallback = function(name) sploosh.kill();
			case 'school' | 'schoolEvil':
				sploosh.loadGraphic(Paths.image('weeb/pixelUI/noteSplashes-pixels', 'week6'), true, 50, 50);
				sploosh.animation.add('splash 0 0', [0, 1, 2, 3], 24, false);
				sploosh.animation.add('splash 1 0', [4, 5, 6, 7], 24, false);
				sploosh.animation.add('splash 0 1', [8, 9, 10, 11], 24, false);
				sploosh.animation.add('splash 1 1', [12, 13, 14, 15], 24, false);
				sploosh.animation.add('splash 0 2', [16, 17, 18, 19], 24, false);
				sploosh.animation.add('splash 1 2', [20, 21, 22, 23], 24, false);
				sploosh.animation.add('splash 0 3', [24, 25, 26, 27], 24, false);
				sploosh.animation.add('splash 1 3', [28, 29, 30, 31], 24, false);

				sploosh.setGraphicSize(Std.int(sploosh.width * PlayState.daPixelZoom));
				sploosh.updateHitbox();
				PlayState.staticVar.add(sploosh);
				sploosh.cameras = [PlayState.staticVar.noteCam];
				sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + noteData);
				sploosh.alpha = 0.6;
				sploosh.offset.x += 90;
				sploosh.offset.y += 80;
				sploosh.animation.finishCallback = function(name) sploosh.kill();
		}

		return sploosh;
	}
}

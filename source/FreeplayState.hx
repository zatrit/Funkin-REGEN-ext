package;

import openfl.filters.BitmapFilter;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if mobile
import mobile.MobileControls;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	
	var chromeValue:Float = 0;
	var filters:Array<BitmapFilter> = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	#if mobile
	var grpMobileButtons:MobileControls;
	#end
	#if PRELOAD_ALL
	var timer:FlxTimer;
	#end

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}

		filters = [chromaticAberration];
		FlxG.camera.setFilters(filters);
		FlxG.camera.filtersEnabled = true;

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		#if !MOD_ONLY
		if (StoryMenuState.weekUnlocked(1) || isDebug)
			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		if (StoryMenuState.weekUnlocked(2) || isDebug)
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);

		if (StoryMenuState.weekUnlocked(3) || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (StoryMenuState.weekUnlocked(4) || isDebug)
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (StoryMenuState.weekUnlocked(5) || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		if (StoryMenuState.weekUnlocked(6) || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);
		#end

		// if (StoryMenuState.weekUnlocked(7) || isDebug)
		//	addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);

		if (StoryMenuState.weekUnlocked(8) || isDebug)
			addWeek(['Headache', 'Nerves', 'Release' #if (debug && desktop), 'Fading' #end], 8, [
				'garcello',
				'garcellotired',
				'garcellodead'
				#if (debug && desktop), 'garcelloghosty'
				#end
			]);

		if (StoryMenuState.weekUnlocked(9) || isDebug)
			addWeek(['Lo-Fight', 'Overhead', 'Ballistic', 'Ballistic-Old'], 9, ['whitty', 'whitty', 'whittyCrazy', 'whittyCrazy']);

		if (StoryMenuState.weekUnlocked(10) || isDebug)
			addWeek(['Wocky', 'Beathoven', 'Hairball', 'Nyaw'], 10, ['kapi', 'kapi', 'kapi-angry', 'kapi']);

		if (StoryMenuState.weekUnlocked(11) || isDebug)
			addWeek(['Flatzone'], 11, ['mrgame']);

		if (StoryMenuState.weekUnlocked(12) || isDebug)
			addWeek(['Improbable-Outset', 'Madness', 'Hellclown'], 12, ['trickyMask', 'tricky', 'trickyH']);

		#if !UNLOCK
		if (Highscore.getWeekScore(12, 2) > 0 || isDebug)
		#end
		addWeek(['expurgation'], 12, ['exTricky']);

		if (StoryMenuState.weekUnlocked(13) || isDebug)
			addWeek(['Norway', 'Tordbot'], 13, ['tord', 'tordbot']);

		if (StoryMenuState.weekUnlocked(14) || isDebug)
			addWeek(['Screenplay', 'Parasite', 'A.G.O.T.I', 'Guns'], 14, ['agoti', 'agoti', 'agoti-crazy', 'agoti']);

		if (StoryMenuState.weekUnlocked(15) || isDebug)
			addWeek(['My-Battle', 'Last-Chance', 'Genocide'], 15, ['tabi', 'tabi', 'tabi-crazy']);

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/${MainMenuState.bgStyle}/menuBGBlue', 'preload'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.screenCenter();
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		#if mobile
		grpMobileButtons = new MobileControls(FlxG.camera, FlxG.camera.width - 510, FlxG.camera.height - 410, 1);
		add(grpMobileButtons);
		#end

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		setChrome(chromeValue);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;
		#if mobile
		if (FlxG.touches.justReleased().length > 0)
		{
			accepted = accepted || FlxG.touches.getFirst().overlaps(grpSongs, camera);
		}
		#end

		#if mobile
		upP = upP || grpMobileButtons.up.justPressed;
		downP = downP || grpMobileButtons.down.justPressed;
		leftP = leftP || grpMobileButtons.left.justPressed;
		rightP = rightP || grpMobileButtons.right.justPressed;
		#end

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (leftP)
			changeDiff(-1);
		if (rightP)
			changeDiff(1);
		if (accepted)
		{
			PlayState.firstTry = true;

			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		if (isOnlyHard())
			curDifficulty = 2;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (isOnlyHard())
		{
			curDifficulty = 2;
			changeDiff();
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if (PRELOAD_ALL)
		if (timer != null)
			timer.cancel();
		else
			timer = new FlxTimer(FlxTimer.globalManager);

		timer.start(1, (timer) ->
		{
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase()).bpm);
		});
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
	}

	function isOnlyHard():Bool
	{
		return songs[curSelected].week == 9 || songs[curSelected].week == 10 || songs[curSelected].songName.toLowerCase() == "expurgation";
	}

	override function beatHit()
	{
		super.beatHit();
		
		if (['my-battle', 'last-chance', 'genocide'].contains(songs[curSelected].songName.toLowerCase()))
		{
			FlxG.camera.zoom += 0.03;
			FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);
			if (songs[curSelected].songName.toLowerCase() == 'genocide')
			{
				FlxG.camera.shake(0.005, 0.1);
				chromeValue += 6 / 1000;
				FlxTween.tween(this, { chromeValue: 0 }, 0.15);
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

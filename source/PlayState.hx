package;

import flixel.util.FlxGradient;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import kade.EtternaFunctions;
import kade.CachedFrames;
import kade.Ratings;
import flixel.FlxState;
import flixel.tweens.misc.VarTween;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import kade.Ratings;
import kade.HelperFunctions;
#if mobile
import mobile.MobileButton;
import mobile.MobileControls;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public var useDownscroll = FlxG.save.data.downscroll;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	public var dad:Character;

	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var dadStrums:FlxTypedGroup<FlxSprite>;
	private var dadStrumsTimers:Array<FlxTimer> = new Array<FlxTimer>();

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var misses:Int = 0;
	private var mashViolations:Int = 0;
	private var mashing:Int = 0;
	private var totalNotesHit:Float = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public var generatedMusic:Bool = false;

	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var phillyCityTween:VarTween;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	public static var goods:Int = 0;
	public static var bads:Int = 0;
	public static var sicks:Int = 0;
	public static var shits:Int = 0;

	public var accuracy:Float = 0.00;

	private var totalPlayed:Int = 0;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	#if mobile
	var grpMobileButtons:MobileControls;
	var pauseButton:MobileButton;
	#end

	public static var firstTry:Bool = true;
	public static var attempt:Int = 0;

	// Kapi vars
	var wstageFront:FlxSprite;
	var wBg:FlxSprite;
	var nwBg:FlxSprite;
	var funneEffect:FlxSprite;

	var littleGuys:FlxSprite;

	// Tricky vars
	var tstatic:FlxSprite;
	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound", "preload"));
	var bfScared:Bool = false;
	var resetSpookyText:Bool = true;
	var spookyText:FlxText;
	var spookyRendered:Bool = false;
	var spookySteps:Int = 0;
	var MAINLIGHT:FlxSprite;

	public var hank:FlxSprite;

	public final trickyCutsceneText:Array<String> = ["OMFG CLOWN!!!!", "YOU DO NOT KILL CLOWN", "CLOWN KILLS YOU!!!!!!"];

	public final TrickyLinesSing:Array<String> = [
		"SUFFER", "INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE",
		"MISJUDGED"
	];
	public final ExTrickyLinesSing:Array<String> = [
		"YOU AREN'T HANK",
		"WHERE IS HANK",
		"HANK???",
		"WHO ARE YOU",
		"WHERE AM I",
		"THIS ISN'T RIGHT",
		"MIDGET",
		"SYSTEM UNRESPONSIVE",
		"WHY CAN'T I KILL?????"
	];
	public final TrickyLinesMiss:Array<String> = [
		"TERRIBLE", "WASTE", "MISS CALCULTED", "PREDICTED", "FAILURE", "DISGUSTING", "ABHORRENT", "FORESEEN", "CONTEMPTIBLE", "PROGNOSTICATE", "DISPICABLE",
		"REPREHENSIBLE"
	];

	public static var staticVar:PlayState;

	var interupt:Bool = false;
	var shouldBeDead:Bool = false;
	var totalDamageTaken:Float = 0;

	var cover:FlxSprite;
	var hole:FlxSprite;
	var converHole:FlxSprite;

	var cloneOne:FlxSprite;
	var cloneTwo:FlxSprite;
	var stepOfLast = 0;
	var grabbed = false;

	var beatOfFuck:Int = 0;

	// TIKY LOVE COOKIES
	var bgRocks:FlxSprite;
	var speaker:FlxSprite;
	var dadMicless:Character;
	var bgpillar:FlxSprite;

	var useAgotiArrows:Bool;
	var useKapiArrows:Bool;

	var pixelShitPart2:String = '';
	var pixelShitPart1:String = '';

	override public function create()
	{
		Conductor.recalculateTimings();

		useAgotiArrows = ['guns', 'a.g.o.t.i', 'parasite', 'screenplay'].contains(SONG.song.toLowerCase());
		useAgotiArrows = (useAgotiArrows && FlxG.save.data.arrowsStyle == 0) || FlxG.save.data.arrowsStyle == 1;

		useKapiArrows = ['wocky', 'beathoven', 'hairball', 'nyaw'].contains(SONG.song.toLowerCase());
		useKapiArrows = (useKapiArrows && FlxG.save.data.arrowsStyle == 0) || FlxG.save.data.arrowsStyle == 2;

		staticVar = this;

		if (firstTry)
			attempt = 0;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));

			case 'headache':
				dialogue = CoolUtil.coolTextFile(Paths.txt('headache/headacheDialogue'));
			case 'nerves':
				dialogue = CoolUtil.coolTextFile(Paths.txt('nerves/nervesDialogue'));
			case 'release':
				dialogue = CoolUtil.coolTextFile(Paths.txt('release/releaseDialogue'));
			case 'fading':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fading/fadingDialogue'));

			case 'lo-fight':
				dialogue = CoolUtil.coolTextFile(Paths.txt('lo-fight/pleaseSubscribe'));
			case 'overhead':
				dialogue = CoolUtil.coolTextFile(Paths.txt('overhead/pleaseSubscribe'));
			case 'ballistic':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ballistic/pleaseSubscribe'));

			case 'wocky':
				dialogue = CoolUtil.coolTextFile(Paths.txt('wocky/dialogue'));
			case 'hairball':
				dialogue = CoolUtil.coolTextFile(Paths.txt('hairball/dialogue'));
			case 'nyaw':
				dialogue = CoolUtil.coolTextFile(Paths.txt('nyaw/dialogue'));
			case 'beathoven':
				dialogue = CoolUtil.coolTextFile(Paths.txt('beathoven/dialogue'));

			case 'screenplay':
				dialogue = CoolUtil.coolTextFile(Paths.txt('screenplay/subscribe'));
			case 'parasite':
				dialogue = CoolUtil.coolTextFile(Paths.txt('parasite/to'));
			case 'a.g.o.t.i':
				dialogue = CoolUtil.coolTextFile(Paths.txt('a.g.o.t.i/brightfyre'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		if (['expurgation', 'improbable-outset', 'madness', 'hellclown'].contains(SONG.song.toLowerCase()))
			tstatic = new FlxSprite(0, 0).loadGraphic(Paths.image('TrickyStatic', 'clown'), true, 320, 180);

		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					isHalloween = true;
				}
			case 'pico' | 'blammed' | 'philly':
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

					if (FlxG.save.data.animEvents)
					{
						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
					add(street);
				}
			case 'milf' | 'satin-panties' | 'high':
				{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
				}
			case 'cocoa' | 'eggnog':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
				}
			case 'winter-horrorland':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
					evilSnow.antialiasing = true;
					add(evilSnow);
				}
			case 'senpai' | 'roses':
				{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
					{
						bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}
			case 'thorns':
				{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
						var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
						bg.scale.set(6, 6);
						// bg.setGraphicSize(Std.int(bg.width * 6));
						// bg.updateHitbox();
						add(bg);

						var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
						fg.scale.set(6, 6);
						// fg.setGraphicSize(Std.int(fg.width * 6));
						// fg.updateHitbox();
						add(fg);

						wiggleShit.effectType = WiggleEffectType.DREAMY;
						wiggleShit.waveAmplitude = 0.01;
						wiggleShit.waveFrequency = 60;
						wiggleShit.waveSpeed = 0.8;
					 */

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
						var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
						var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

						// Using scale since setGraphicSize() doesnt work???
						waveSprite.scale.set(6, 6);
						waveSpriteFG.scale.set(6, 6);
						waveSprite.setPosition(posX, posY);
						waveSpriteFG.setPosition(posX, posY);

						waveSprite.scrollFactor.set(0.7, 0.8);
						waveSpriteFG.scrollFactor.set(0.9, 0.8);

						// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
						// waveSprite.updateHitbox();
						// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
						// waveSpriteFG.updateHitbox();

						add(waveSprite);
						add(waveSpriteFG);
					 */
				}
			case 'headache' | 'nerves':
				{
					defaultCamZoom = 0.9;
					curStage = 'garAlley';

					var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebg', 'weekG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.7, 0.7);
					bg.active = false;
					add(bg);

					var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStage', 'weekG'));
					bgAlley.antialiasing = true;
					bgAlley.scrollFactor.set(0.9, 0.9);
					bgAlley.active = false;
					add(bgAlley);
				}
			case 'release':
				{
					defaultCamZoom = 0.9;
					curStage = 'garAlleyDead';

					var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebgAlt', 'weekG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.7, 0.7);
					bg.active = false;
					add(bg);

					var smoker:FlxSprite = new FlxSprite(0, -290);
					smoker.frames = Paths.getSparrowAtlas('garSmoke', 'weekG');
					smoker.setGraphicSize(Std.int(smoker.width * 1.7));
					smoker.alpha = 0.3;
					smoker.animation.addByPrefix('garsmoke', "smokey", 13);
					smoker.animation.play('garsmoke');
					smoker.scrollFactor.set(0.7, 0.7);
					add(smoker);

					var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStagealt', 'weekG'));
					bgAlley.antialiasing = true;
					bgAlley.scrollFactor.set(0.9, 0.9);
					bgAlley.active = false;
					add(bgAlley);

					var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('gardead', 'weekG'));
					corpse.antialiasing = true;
					corpse.scrollFactor.set(0.9, 0.9);
					corpse.active = false;
					add(corpse);
				}
			case 'fading':
				{
					defaultCamZoom = 0.9;
					curStage = 'garAlleyDip';

					var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebgRise', 'weekG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.7, 0.7);
					bg.active = false;
					add(bg);

					var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStageRise', 'weekG'));
					bgAlley.antialiasing = true;
					bgAlley.scrollFactor.set(0.9, 0.9);
					bgAlley.active = false;
					add(bgAlley);

					var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('gardead', 'weekG'));
					corpse.antialiasing = true;
					corpse.scrollFactor.set(0.9, 0.9);
					corpse.active = false;
					add(corpse);
				}
			case 'lo-fight' | 'overhead' | 'ballistic':
				{
					defaultCamZoom = 0.9;
					curStage = 'alley';

					if (SONG.song.toLowerCase() == 'ballistic')
						curStage = 'ballisticAlley';

					wBg = new FlxSprite(-500, -300).loadGraphic(Paths.image('whittyBack', 'bonusWeek'));

					if (curStage == 'alley')
					{
						wBg.antialiasing = true;
						wBg.scrollFactor.set(0.9, 0.9);
						wBg.active = false;

						wstageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront', 'bonusWeek'));
						wstageFront.setGraphicSize(Std.int(wstageFront.width * 1.1));
						wstageFront.updateHitbox();
						wstageFront.antialiasing = true;
						wstageFront.scrollFactor.set(0.9, 0.9);
						wstageFront.active = false;
						add(wBg);
						add(wstageFront);
					}
					else
					{
						var bgTex = Paths.getSparrowAtlas('BallisticBackground', 'bonusWeek');
						nwBg = new FlxSprite(-600, -200);
						nwBg.frames = bgTex;
						nwBg.antialiasing = true;
						nwBg.scrollFactor.set(0.9, 0.9);
						nwBg.active = true;
						nwBg.animation.addByPrefix('start', 'Background Whitty Start', 24, false);
						nwBg.animation.addByPrefix('gaming', 'Background Whitty Startup', 24, false);
						nwBg.animation.addByPrefix('gameButMove', 'Background Whitty Moving', 16, true);
						add(wBg);
						add(nwBg);
						nwBg.alpha = 0;
						wstageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront', 'bonusWeek'));
						wstageFront.setGraphicSize(Std.int(wstageFront.width * 1.1));
						wstageFront.updateHitbox();
						wstageFront.antialiasing = true;
						wstageFront.scrollFactor.set(0.9, 0.9);
						wstageFront.active = false;
						add(wBg);
						add(wstageFront);

						funneEffect = new FlxSprite(-600, -200).loadGraphic(Paths.image('thefunnyeffect', 'bonusWeek'));
						funneEffect.alpha = 0.5;
						funneEffect.scrollFactor.set();
						funneEffect.visible = true;
						add(funneEffect);

						funneEffect.cameras = [camHUD];

						trace('funne: ' + funneEffect);
					}
				}
			case 'beathoven' | 'wocky' | 'nyaw' | 'hairball':
				{
					defaultCamZoom = 0.9;
					if (SONG.song.toLowerCase() == 'nyaw')
						curStage = 'arcadeclosed';
					else
						curStage = 'arcade';
					var bg:FlxSprite = new FlxSprite(-600, -200);
					bg.frames = Paths.getSparrowAtlas("stageback", "kapiWeek");

					switch (SONG.song.toLowerCase())
					{
						case 'nyaw':
							bg.animation.addByPrefix("stageback", "stageback closed");
						case 'hairball':
							bg.animation.addByPrefix("stageback", "stageback sunset");
						default:
							bg.animation.addByPrefix("stageback", "stageback default");
					}

					bg.animation.play("stageback");

					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront', 'kapiWeek'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains', 'kapiWeek'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...4)
					{
						var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('lamps' + i, 'kapiWeek'));
						light.scrollFactor.set(0.9, 0.9);
						light.visible = false;
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					if (SONG.song.toLowerCase() == 'beathoven' || SONG.song.toLowerCase() == 'hairball')
					{
						littleGuys = new FlxSprite(25, 200);
						littleGuys.frames = Paths.getSparrowAtlas('littleguys', 'kapiWeek');
						littleGuys.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						littleGuys.antialiasing = true;
						littleGuys.scrollFactor.set(0.9, 0.9);
						littleGuys.setGraphicSize(Std.int(littleGuys.width * 1));
						littleGuys.updateHitbox();
						add(littleGuys);
					}
					if (SONG.song.toLowerCase() == 'nyaw')
					{
						bottomBoppers = new FlxSprite(-600, -200);
						bottomBoppers.frames = Paths.getSparrowAtlas('bgFreaks', 'kapiWeek');
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.antialiasing = true;
						bottomBoppers.scrollFactor.set(0.92, 0.92);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
						add(bottomBoppers);
						// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
					}
					if (SONG.song.toLowerCase() == 'nyaw' || SONG.song.toLowerCase() == 'hairball')
					{
						upperBoppers = new FlxSprite(-600, -200);
						upperBoppers.frames = Paths.getSparrowAtlas('upperBop', 'kapiWeek');
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.antialiasing = true;
						upperBoppers.scrollFactor.set(1.05, 1.05);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
						upperBoppers.updateHitbox();
						add(upperBoppers);
					}
				}
			case 'flatzone':
				curStage = 'gas';
				var hallowTex = Paths.getSparrowAtlas('gas_bg', 'g3wWeek');
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg');
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case 'improbable-outset' | 'madness':
				defaultCamZoom = 0.75;
				curStage = 'nevada';

				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0, 0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');

				tstatic.alpha = 0;

				var bg:FlxSprite = new FlxSprite(-350, -300).loadGraphic(Paths.image('red', 'clown'));
				//var bg:FlxSprite = new FlxSprite(-350,-300);
				
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();

				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				var stageFront:FlxSprite;
				if (SONG.song.toLowerCase() != 'madness')
				{
					add(bg);
					stageFront = new FlxSprite(-422, 207).loadGraphic(Paths.image('island_but_dumb', 'clown'));
				}
				else
					stageFront = new FlxSprite(-456, -460).loadGraphic(Paths.image('island_but_rocks_float', 'clown'));

				stageFront.setGraphicSize(Std.int(stageFront.width * 1.4));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				//MAINLIGHT = new FlxSprite(-470, -150).loadGraphic(Paths.image('hue', 'clown'));
				MAINLIGHT = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,0xAA0000);
				MAINLIGHT.alpha = 33/255;
				MAINLIGHT.blend = "screen";
				MAINLIGHT.screenCenter();
				MAINLIGHT.antialiasing = true;
				MAINLIGHT.scrollFactor.set(0,0);
				add(MAINLIGHT);
			case 'hellclown':
				// trace("line 538");
				defaultCamZoom = 0.35;
				curStage = 'nevadaSpook';

				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0, 0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 10));
				tstatic.screenCenter(Y);
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');

				tstatic.alpha = 0;

				var bg:FlxSprite = new FlxSprite(-1000, -1000).loadGraphic(Paths.image('fourth/bg', 'clown'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 10));
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-1050, -550).loadGraphic(Paths.image('hellclwn/island_but_red', 'clown'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 2.6));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				if(FlxG.save.data.animEvents){
					hank = new FlxSprite(60, -170);
					hank.frames = Paths.getSparrowAtlas('hellclwn/Hank', 'clown');
					hank.animation.addByPrefix('dance', 'Hank', 24);
					hank.animation.play('dance');
					hank.scrollFactor.set(0.9, 0.9);
					hank.setGraphicSize(Std.int(hank.width * 1.55));
					hank.antialiasing = true;
				}

				add(hank);
			case 'expurgation':
				// trace("line 538");
				defaultCamZoom = 0.55;
				curStage = 'auditorHell';

				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0, 0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');

				tstatic.alpha = 0;

				cover = new FlxSprite(-55, 755).loadGraphic(Paths.image('fourth/cover', 'clown'));
				hole = new FlxSprite(21.5, 530).loadGraphic(Paths.image('fourth/Spawnhole_Ground_BACK', 'clown'));
				converHole = new FlxSprite(-21.5, 578).loadGraphic(Paths.image('fourth/Spawnhole_Ground_COVER', 'clown'));

				if(FlxG.save.data.animEvents){
					var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('fourth/bg', 'clown'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 8));
					add(bg);
				}
				hole.antialiasing = true;
				hole.scrollFactor.set(0.9, 0.9);

				converHole.antialiasing = true;
				converHole.scrollFactor.set(0.9, 0.9);
				converHole.setGraphicSize(Std.int(converHole.width * 1.3));
				hole.setGraphicSize(Std.int(hole.width * 1.55));

				cover.antialiasing = true;
				cover.scrollFactor.set(0.9, 0.9);
				cover.setGraphicSize(Std.int(cover.width * 1.55));

				if(FlxG.save.data.animEvents){
					var energyWall:FlxSprite = new FlxSprite(1350, -690).loadGraphic(Paths.image("fourth/Energywall", "clown"));
					// energyWall.x+=energyWall.width/2;
					// energyWall.y+=energyWall.height/2;
					energyWall.setGraphicSize(Std.int(energyWall.width * 2), Std.int(energyWall.height * 2));
					energyWall.updateHitbox();
					energyWall.antialiasing = true;
					energyWall.scrollFactor.set(0.9, 0.9);
					add(energyWall);
				}

				var stageFront:FlxSprite = new FlxSprite(-225, -355).loadGraphic(Paths.image('fourth/daBackground', 'clown'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				add(stageFront);
			case 'norway' | 'tordbot':
				curStage = 'eddhouse';
				var sky:FlxSprite = new FlxSprite(-162.1, -386.1);
				sky.frames = Paths.getSparrowAtlas("sky", 'tord');
				sky.animation.addByPrefix("bg_sky1", "bg_sky1");
				sky.animation.addByPrefix("bg_sky2", "bg_sky2");
				if (SONG.song.toLowerCase() == 'norway')
				{
					sky.animation.play("bg_sky1");
				}
				else
				{
					sky.animation.play("bg_sky2");
				}

				var bg:FlxSprite = new FlxSprite(-162.1, -386.1);
				bg.frames = Paths.getSparrowAtlas("bgFront", 'tord');
				bg.animation.addByPrefix("bg_normal", "bg_normal");
				bg.animation.addByPrefix("bg_destroy", "bg_destroy");
				if (SONG.song.toLowerCase() == 'norway')
				{
					bg.animation.play("bg_normal");
				}
				else
				{
					bg.animation.play("bg_destroy");
				}

				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				sky.scrollFactor.set(0.5, 0);
				if (SONG.song.toLowerCase() == 'tordbot')
					sky.scrollFactor.set();
				bg.active = false;
				sky.active = false;
				// bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sky.updateHitbox();
				add(sky);
				add(bg);
			case 'screenplay' | 'parasite' | 'guns':
				{
					defaultCamZoom = 0.55;
					curStage = 'void';

					var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.WHITE);
					white.screenCenter();
					white.scrollFactor.set();
					add(white);

					if(FlxG.save.data.animEvents)
					{
						var void:FlxSprite = new FlxSprite(0, 0);
						void.frames = CachedFrames.cachedInstance.fromSparrow('void','The_void','agoti');
						void.animation.addByPrefix('move', 'VoidShift', 50, true);
						void.animation.play('move');
						void.setGraphicSize(Std.int(void.width * 2.5));
						void.screenCenter();
						void.y += 250;
						void.x += 55;
						void.antialiasing = true;
						void.scrollFactor.set(0.7, 0.7);
						add(void);

						bgpillar = new FlxSprite(-1000, -700);
						bgpillar.frames = Paths.getSparrowAtlas('Pillar_BG_Stage', 'agoti');
						bgpillar.animation.addByPrefix('move', 'Pillar_BG', 24, true);
						bgpillar.setGraphicSize(Std.int(bgpillar.width * 1.5));
						bgpillar.antialiasing = true;
						bgpillar.scrollFactor.set(0.7, 0.7);
						bgpillar.alpha = 0;
						add(bgpillar);
					}

					bgRocks = new FlxSprite(-1000, -700).loadGraphic(Paths.image('Void_Back', 'agoti'));
					bgRocks.setGraphicSize(Std.int(bgRocks.width * 0.5));
					bgRocks.antialiasing = true;
					bgRocks.scrollFactor.set(0.7, 0.7);
					add(bgRocks);

					var frontRocks:FlxSprite = new FlxSprite(-1000, 676).loadGraphic(Paths.image('Void_Front', 'agoti'));
					// frontRocks.setGraphicSize(Std.int(frontRocks.width * 3));
					frontRocks.updateHitbox();
					frontRocks.antialiasing = true;
					frontRocks.scrollFactor.set(0.9, 0.9);
					add(frontRocks);
				}
			case 'a.g.o.t.i':
				{
					defaultCamZoom = 0.55;
					curStage = 'pillars';

					var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.fromRGB(255, 230, 230));
					white.screenCenter();
					white.scrollFactor.set();
					add(white);

					/*var void:FlxSprite = new FlxSprite(0, 0);
					void.frames = Paths.getSparrowAtlas('The_void', 'agoti');
					void.animation.addByPrefix('move', 'VoidShift', 0, true);
					void.animation.play('move');
					void.setGraphicSize(Std.int(void.width * 2.5));
					void.screenCenter();
					void.y += 250;
					void.x += 55;
					void.antialiasing = true;
					void.scrollFactor.set(0.7, 0.7);
					add(void);*/

					if(FlxG.save.data.animEvents){
						bgpillar = new FlxSprite(-1000, -700);
						bgpillar.frames = Paths.getSparrowAtlas('Pillar_BG_Stage', 'agoti');
						bgpillar.animation.addByPrefix('move', 'Pillar_BG', 24, true);
						bgpillar.animation.play('move');
						bgpillar.setGraphicSize(Std.int(bgpillar.width * 1.25));
						bgpillar.antialiasing = true;
						bgpillar.scrollFactor.set(0.7, 0.7);
						add(bgpillar);
					}

					speaker = new FlxSprite(-650, 600);
					speaker.frames = Paths.getSparrowAtlas('LoudSpeaker_Moving', 'agoti');
					speaker.animation.addByPrefix('bop', 'StereoMoving', 24, false);
					speaker.updateHitbox();
					speaker.antialiasing = true;
					speaker.scrollFactor.set(0.9, 0.9);
					add(speaker);
				}
			default:
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school' | 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'alley' | 'ballisticAlley':
				gfVersion = 'gf-whitty';
			case 'arcade' | 'arcadeclosed':
				gfVersion = 'gf-arcade';
			case 'nevadaSpook':
				gfVersion = 'gf-hell';
			case 'auditorHell':
				gfVersion = 'gf-tied';
			case 'void':
				gfVersion = 'gf-rocks';
			case 'pillars':
				gfVersion = 'gf-rocks-scared';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (curStage == 'void' || curStage == 'pillars')
		{
			gf.scrollFactor.set(0.8, 0.8);
		}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-pixel':
				dad.x += 200;
				dad.y += 220;
			case "mrgame":
				dad.y += 200;

			case 'tricky':
				camPos.x += 400;
				camPos.y += 600;
			case 'trickyMask':
				camPos.x += 400;
			case 'trickyH':
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 500);
				dad.y -= 2000;
				dad.x -= 1400;
				gf.x -= 380;
			case 'exTricky':
				dad.x -= 300;
				dad.y -= 365;
				gf.x += 345;
				gf.y -= 25;
				dad.visible = false;

			case 'tord':
				dad.x = 214.2;
				dad.y = 55.4;
				camPos.set(218.75, 25.7);
			case 'tordbot':
				dad.x = -429.05;
				dad.y = -1424.75;
				camPos.set(391.2, -1094.15);
			case 'agoti':
				camPos.x += 400;
				dad.y += 100;
				dad.x -= 100;
				gf.y -= 250;
			case 'agoti-crazy':
				camPos.x += 400;
				dad.y += 130;
				dad.x -= 100;
				gf.y -= 250;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'garAlleyDead' | 'garAlleyDip':
				boyfriend.x += 50;
			case 'nevada':
				boyfriend.y -= 0;
				boyfriend.x += 260;
			case 'auditorHell':
				boyfriend.y -= 160;
				boyfriend.x += 350;
			case 'eddhouse':
				boyfriend.x = 1096.1;
				boyfriend.y = 271.7;
				gf.visible = false;
			case 'void' | 'pillars':
				boyfriend.y += 50;
				boyfriend.x += 100;
		}

		add(gf);

		if (curStage == 'auditorHell')
			add(hole);

		if (dad.curCharacter == 'trickyH')
			dad.addOtherFrames();

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);

		if (curStage == 'auditorHell')
		{
			// Clown init
			cloneOne = new FlxSprite(0, 0);
			cloneTwo = new FlxSprite(0, 0);
			cloneOne.frames = CachedFrames.cachedInstance.fromSparrow('cln', 'fourth/Clone');
			cloneTwo.frames = CachedFrames.cachedInstance.fromSparrow('cln', 'fourth/Clone');
			cloneOne.alpha = 0;
			cloneTwo.alpha = 0;
			cloneOne.animation.addByPrefix('clone', 'Clone', 24, false);
			cloneTwo.animation.addByPrefix('clone', 'Clone', 24, false);

			// cover crap

			add(cloneOne);
			add(cloneTwo);
			add(cover);
			add(converHole);
			add(dad.exSpikes);
		}
		
		if (SONG.song.toLowerCase() == 'screenplay' && isStoryMode)
		{
			dadMicless = new Character(dad.x, dad.y, 'agoti-micless');
			dadMicless.alpha = 1;
			dad.alpha = 0;
			add(dadMicless);
		}

		add(boyfriend);

		if (dad.curCharacter == 'trickyH')
		{
			gf.setGraphicSize(Std.int(gf.width * 0.8));
			boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.8));
			gf.x += 220;
		}

		if (curStage == 'garAlleyDead')
		{
			var smoke:FlxSprite = new FlxSprite(0, 0);
			smoke.frames = Paths.getSparrowAtlas('garSmoke', 'weekG');
			smoke.setGraphicSize(Std.int(smoke.width * 1.6));
			smoke.animation.addByPrefix('garsmoke', "smokey", 15);
			if (FlxG.save.data.animEvents)
				smoke.animation.play('garsmoke');
			smoke.scrollFactor.set(1.1, 1.1);
			add(smoke);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		if (SONG.song.toLowerCase() == 'screenplay')
		{
			doof.finishThing = agotiIntro;
		}

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		dadStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		notes.sort(FlxSort.byY, (useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);

		if (SONG.song.toLowerCase() == 'headache'
			|| SONG.song.toLowerCase() == 'nerves'
			|| SONG.song.toLowerCase() == 'release'
			|| SONG.song.toLowerCase() == 'fading')
		{
			healthBar.createFilledBar(0xFF8E40A5, 0xFF66FF33);
		}
		if (['a.g.o.t.i', 'parasite', 'screenplay', 'guns'].contains(SONG.song.toLowerCase()))
		{
			healthBar.createFilledBar(0xFF494949, 0xFF66FF33);
		}

		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(healthBar.x + healthBar.width - 80, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();
		scoreTxt.text = Ratings.CalculateRanking(songScore, health, accuracy);
		scoreTxt.x -= scoreTxt.width;
		add(scoreTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (curStage == "nevada" || curStage == "nevadaSpook" || curStage == 'auditorHell')
			add(tstatic);

		if (curStage == 'auditorHell')
			tstatic.alpha = 0.1;

		if (curStage == 'nevadaSpook' || curStage == 'auditorHell')
		{
			tstatic.setGraphicSize(Std.int(tstatic.width * 12));
			tstatic.x += 600;
		}

		if (isStoryMode && firstTry && !FlxG.save.data.skipCutscenes)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'headache':
					var introText:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('garIntroText', 'weekG'));
					introText.setGraphicSize(Std.int(introText.width * 1.5));
					introText.scrollFactor.set();
					camHUD.visible = false;

					add(introText);
					FlxG.sound.playMusic(Paths.music('city_ambience', 'weekG'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						// FlxG.sound.play(Paths.sound('Lights_Turn_On'));

						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									FlxG.sound.music.fadeOut(2.2, 0);
									remove(introText);
									camHUD.visible = true;
									garIntro(doof);
								}
							});
						});
					});
				case 'nerves' | "release" | "fading":
					garIntro(doof);

				case 'lo-fight' | 'overhead' | 'ballistic':
					whittyAnimation(doof);

				case 'wocky' | 'beathoven' | 'nyaw':
					kapiIntro(doof);
				case 'hairball':
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					if (!FlxG.save.data.skipCutscenes)
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							remove(blackScreen);
							FlxG.sound.play(Paths.sound('brokenpad', 'kapiWeek'));
							camFollow.y = 590;
							camFollow.x -= 200;
							FlxG.camera.focusOn(camFollow.getPosition());
							FlxG.camera.zoom = 1.1;
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								dad.playAnim('meow', true);
							});
							new FlxTimer().start(0.6, function(tmr:FlxTimer)
							{
								camHUD.visible = true;
								remove(blackScreen);
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										kapiIntro(doof);
									}
								});
							});
						});
					else
						kapiIntro(doof);
				case 'improbable-outset':
					camFollow.setPosition(boyfriend.getMidpoint().x + 70, boyfriend.getMidpoint().y - 50);
					trickyCutscene();
				case 'screenplay' | 'parasite' | 'a.g.o.t.i':
					agotiIntroDialogue(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'ballistic':
					trace('Skipping ballistic background animation');
					nwBg.alpha = 1;
					nwBg.animation.play("gameButMove");
					startCountdown();
				case 'expurgation':
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					var spawnAnim = new FlxSprite(-200, -380);
					spawnAnim.frames = Paths.getSparrowAtlas('fourth/EXENTER', 'clown');

					spawnAnim.animation.addByPrefix('start', 'Entrance', 24, false);

					add(spawnAnim);

					spawnAnim.animation.play('start');
					var p = new FlxSound().loadEmbedded(Paths.sound("fourth/Trickyspawn", "clown"));
					var pp = new FlxSound().loadEmbedded(Paths.sound("fourth/TrickyGlitch", "clown"));
					p.play();
					spawnAnim.animation.finishCallback = function(pog:String)
					{
						pp.fadeOut();
						dad.visible = true;
						remove(spawnAnim);
						startCountdown();
					}
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						if (spawnAnim.animation.frameIndex == 24)
						{
							pp.play();
						}
						else
							tmr.reset(0.001);
					});
				default:
					startCountdown();
			}
		}

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		pixelShitPart1 += FlxG.save.data.useKadeRatings ? 'kade/' : '';

		super.create();
	}

	function kapiIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		if (SONG.song.toLowerCase() == 'hairball')
		{
			remove(black);
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.1;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					add(dialogueBox);
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

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
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
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

	function garIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

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

		if (SONG.song.toLowerCase() == 'nerves' || SONG.song.toLowerCase() == 'release')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'release')
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
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'release')
					{
						camHUD.visible = false;
						add(red);
						add(sexycutscene);
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

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		healthBar.visible = true;
		healthBarBG.visible = true;
		scoreTxt.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;

		canPause = true;

		#if mobile
		var controlType = 1;

		if (FlxG.save.data.mobileControlsType != null)
			controlType = FlxG.save.data.mobileControlsType;

		grpMobileButtons = new MobileControls(camHUD, camHUD.width - 510, camHUD.height - 410, controlType);

		pauseButton = new MobileButton(camHUD.width - 140, 2, "Pause", false, 0.75, () -> {}, () -> {});
		pauseButton.cameras = [camHUD];
		pauseButton.scale.x = 0.75;
		pauseButton.scale.y = 0.75;

		add(pauseButton);
		add(grpMobileButtons);
		#end

		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);

		if (SONG.song.toLowerCase() == 'expurgation') // start the grem time
		{
			new FlxTimer().start(25, function(tmr:FlxTimer)
			{
				if (curStep < 2400)
				{
					if (canPause && !paused && health >= 1.5 && !grabbed)
						doGremlin(40, 3);
					trace('checka ' + health);
					tmr.reset(25);
				}
			});
		}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		if (isStoryMode && !FlxG.save.data.skipCutscenes)
			switch (SONG.song.toLowerCase())
			{
				case 'madness':
					FlxG.sound.music.onComplete = trickySecondCutscene;
				case 'parasite':
					FlxG.sound.music.onComplete = agotiCrazy;
				default:
					FlxG.sound.music.onComplete = endSong;
			}
		else
			FlxG.sound.music.onComplete = endSong;
		vocals.play();

		attempt = 0;
		firstTry = true;

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var playerNotes:Array<Int> = [0, 1, 2, 3, 8, 9, 10, 11];

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1]);

				var gottaHitNote:Bool = section.mustHitSection;

				if (!playerNotes.contains(songNotes[1]))
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();

					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				if (useDownscroll)
					for (note in unspawnNotes)
						if (note.animation.name.endsWith("end"))
							note.offset.y = -2;

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					if (useKapiArrows)
						babyArrow.frames = Paths.getSparrowAtlas('arrowsStyle/NOTE_assets-kapi', 'shared');
					else if (useAgotiArrows)
						babyArrow.frames = Paths.getSparrowAtlas('arrowsStyle/NOTE_assets-agoti', 'shared');
					else
						babyArrow.frames = Paths.getSparrowAtlas('arrowsStyle/NOTE_assets', 'shared');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			if (player == 0 && FlxG.save.data.botArrowsAnim != 2)
			{
				babyArrow.animation.finishCallback = (name:String) ->
				{
					if (name == "confirm")
					{
						babyArrow.animation.play("static");
						babyArrow.centerOffsets();
					}
				}
				dadStrums.add(babyArrow);

				dadStrumsTimers[i] = new FlxTimer().start(0, (tmr) ->
				{
					babyArrow.animation.play('static');
				});
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
			#if mobile
			grpMobileButtons.visible = true;
			pauseButton.visible = true;
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && FlxG.save.data.animEvents)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'void':
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					bgRocks.y = -700 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 3.0;
				});

				gf.y = -120 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 5.0;
			case 'pillars':
				FlxG.camera.angle = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * -1.0) * 1.5;
				camHUD.angle = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 2.0;

				gf.y = -120 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 5.0;

				for (i in 0...strumLineNotes.length)
				{
					strumLineNotes.members[i].y += Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + strumLineNotes.members[i].ID) / 2;
				}
		}

		super.update(elapsed);

		if ((FlxG.keys.justPressed.ENTER) && startedCountdown && canPause)
		{
			onBack();
		}
		#if mobile
		if (pauseButton != null)
			if (pauseButton.justPressed)
				onBack();
		#end

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				if (SONG.player2 != "tordbot")
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				else
					camFollow.setPosition(dad.x + 1000, dad.y + 300);
				// camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'trickyMask':
						camFollow.y = dad.getMidpoint().y + 25;
					case 'trickyH':
						camFollow.y = dad.getMidpoint().y + 375;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial' || SONG.song.toLowerCase() == 'tordbot')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (spookyRendered) // move shit around all spooky like
		{
			spookyText.angle = FlxG.random.int(-5, 5); // change its angle between -5 and 5 so it starts shaking violently.
			// tstatic.x = tstatic.x + FlxG.random.int(-2,2); // move it back and fourth to repersent shaking.
			if (tstatic.alpha != 0)
				tstatic.alpha = FlxG.random.float(0.1, 0.5); // change le alpha too :)
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				daNote.visible = daNote.y <= FlxG.height;
				daNote.active = daNote.y <= FlxG.height;

				if (useDownscroll)
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
							+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
					else
						daNote.y = (dadStrums.members[Math.floor(Math.abs(daNote.noteData))].y
							+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;
					}
				}
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				daNote.y -= (daNote.burning ? ((curStage != 'auditorHell' && useDownscroll) ? 185 : 65) : 0);

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (useDownscroll)
					{
						// Clip to strumline
						var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
						swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;

						daNote.clipRect = swagRect;
					}
					else
					{
						var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
				}

				var noteData = Math.floor(Math.abs(daNote.noteData));
				var strum = dadStrums.members[noteData];

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (noteData)
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					if (FlxG.save.data.botArrowsAnim != 2)
						strum.animation.play("confirm", true);

					if (!daNote.isSustainNote && useAgotiArrows && FlxG.save.data.botArrowsAnim == 0)
						dadStrumsTimers[noteData].reset(0.2);

					switch (dad.curCharacter)
					{
						case 'trickyMask': // 1% chance
							if (FlxG.random.bool(1) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
							{
								createSpookyText(TrickyLinesSing[FlxG.random.int(0, TrickyLinesSing.length)]);
							}
						case 'tricky': // 20% chance
							if (FlxG.random.bool(20) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
							{
								createSpookyText(TrickyLinesSing[FlxG.random.int(0, TrickyLinesSing.length)]);
							}
						case 'trickyH': // 45% chance
							if (FlxG.random.bool(45) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
							{
								createSpookyText(TrickyLinesSing[FlxG.random.int(0, TrickyLinesSing.length)]);
							}
							FlxG.camera.shake(0.02, 0.2);
						case 'exTricky': // 60% chance
							if (FlxG.random.bool(60) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
							{
								createSpookyText(ExTrickyLinesSing[FlxG.random.int(0, ExTrickyLinesSing.length)]);
							}
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height && !useDownscroll || daNote.y >= strumLine.y + 106 && useDownscroll)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if (!daNote.burning && daNote.mustPress)
						{
							if (!daNote.isSustainNote || curStage != 'nevedaSpook')
							{
								health -= 0.075;
								totalDamageTaken += 0.075;
								interupt = true;
								if (!FlxG.save.data.newInput)
									noteMiss(daNote.noteData);
								else
									kadeNoteMiss(daNote);
							}
							else if (daNote.isSustainNote && curStage == 'nevedaSpook') // nerf long notes on hellclown cuz they're too op
							{
								interupt = true;
								health -= 0.035;
								totalDamageTaken += 0.005;
							}
							vocals.volume = 0;
						}
					}
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		for (strum in dadStrums)
		{
			updateArrowOffsets(strum, strum.ID);
		}

		if (!inCutscene)
			if (FlxG.save.data.newInput)
				kadeKeyShit();
			else
				keyShit();

		// scoreTxt.text = "Score:" + songScore + "  |  Health: "+Std.int(health/2*100)+"%";
		scoreTxt.text = Ratings.CalculateRanking(songScore, health, accuracy);

		#if debug
		if (FlxG.keys.justPressed.ONE)
		{
			if (FlxG.sound.music.onComplete != null)
				FlxG.sound.music.onComplete();
			else
				endSong();
		}
		#end
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				if (curSong.toLowerCase() != 'fading' && SONG.song.toLowerCase() != "hellclown")
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

				if (storyWeek != 12)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
				}

				#if !mobile
				if (SONG.song.toLowerCase() != "hellclown")
				#end
				FlxG.switchState(new StoryMenuState());
				#if !mobile
				else
					LoadingState.loadAndSwitchState(new VideoState(Paths.getVideo("TricksterMan"), new MainMenuState()));
				#end

				if (SONG.validScore)
				{
					#if (!mobile && !switch)
					NGio.unlockMedal(60961);
					#end
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				FlxG.sound.music.stop();

				if (!FlxG.save.data.skipCutscenes)
					switch (SONG.song.toLowerCase())
					{
						#if !mobile
						case 'improbable-outset':
							LoadingState.loadAndSwitchState(new VideoState(Paths.getVideo("HankFuckingShootsTricky"), new PlayState()));
						case 'madness':
							LoadingState.loadAndSwitchState(new VideoState(Paths.getVideo("HELLCLOWN_ENGADGED"), new PlayState()));
						#end
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}
				else
					LoadingState.loadAndSwitchState(new PlayState());

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
		}

		totalNotesHit++;
		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite();
			numScore.frames=Paths.getSparrowAtlas(pixelShitPart1.replace('kade/','') + 'nums' + pixelShitPart2);
			numScore.animation.addByPrefix('num','num'+ Std.int(i));
			numScore.animation.play('num');
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		#if mobile
		if (grpMobileButtons != null)
		{
			up = up || grpMobileButtons.up.pressed;
			upP = upP || grpMobileButtons.up.justPressed;
			upR = upR || grpMobileButtons.up.justReleased;
			down = down || grpMobileButtons.down.pressed;
			downP = downP || grpMobileButtons.down.justPressed;
			downR = downR || grpMobileButtons.down.justReleased;
			left = left || grpMobileButtons.left.pressed;
			leftP = leftP || grpMobileButtons.left.justPressed;
			leftR = leftR || grpMobileButtons.left.justReleased;
			right = right || (grpMobileButtons.right.pressed && !pauseButton.pressed);
			rightP = rightP || (grpMobileButtons.right.justPressed && !pauseButton.pressed);
			rightR = rightR || grpMobileButtons.right.justReleased;
		}
		#end

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				if (daNote.burning)
				{
					if (curStage == 'auditorHell')
					{
						// lol death
						health = -100;
						shouldBeDead = true;
						FlxG.sound.play(Paths.sound('death', 'clown'));
					}
					else
					{
						health -= 0.45;
						totalDamageTaken += 0.45;
						interupt = true;
						daNote.wasGoodHit = true;
						daNote.canBeHit = false;
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						FlxG.sound.play(Paths.sound('burnSound', 'clown'));
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if ([leftP, downP, upP, rightP][spr.ID] && spr.ID == daNote.noteData)
							{
								var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
								smoke.frames = Paths.getSparrowAtlas('Smoke', 'clown');
								smoke.animation.addByPrefix('boom', 'smoke', 24, false);
								smoke.animation.play('boom');
								smoke.setGraphicSize(Std.int(smoke.width * 0.6));
								smoke.cameras = [camHUD];
								add(smoke);
								smoke.animation.finishCallback = function(name:String)
								{
									remove(smoke);
								}
							}
						});
					}
				}

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
							{
								goodNoteHit(coolNote);
							}
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}

					//this is already done in noteCheck / goodNoteHit
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				 */
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			updateArrowOffsets(spr, spr.ID);
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		#if mobile
		if (grpMobileButtons != null)
		{
			upP = upP || grpMobileButtons.up.justPressed;
			downP = downP || grpMobileButtons.down.justPressed;
			leftP = leftP || grpMobileButtons.left.justPressed;
			rightP = rightP || (grpMobileButtons.right.justPressed && !pauseButton.pressed);
		}
		#end

		if (!FlxG.save.data.ghost)
		{
			if (leftP)
				noteMiss(0);
			if (downP)
				noteMiss(1);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);

			updateAccuracy();
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			if (!grabbed)
			{
				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;
			}

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		hardCodedTrickyEvents();

		if (dad.curCharacter == 'garcellodead' && SONG.song.toLowerCase() == 'release')
		{
			if (curStep == 838)
			{
				dad.playAnim('garTightBars', true);
			}
		}

		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 247)
			{
				dad.playAnim('garFarewell', true);
			}
		}

		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 240)
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					dad.alpha -= 0.05;
					iconP2.alpha -= 0.05;

					if (dad.alpha > 0)
					{
						tmr.reset(0.1);
					}
				});
			}
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(FlxSort.byY, (useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (curStage == 'nevedaSpook'&&FlxG.save.data.animEvents)
			hank.animation.play('dance');

		if (curStage == 'auditorHell')
		{
			if (curBeat % 8 == 4 && beatOfFuck != curBeat)
			{
				beatOfFuck = curBeat;
				doClone(FlxG.random.int(0, 1));
			}
		}

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		// NYAW
		if (curSong.toLowerCase() == 'nyaw')
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0 && curBeat != 283 && curBeat != 282)
			{
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight = FlxG.random.int(0, phillyCityLights.length - 1);
				phillyCityLights.members[curLight].visible = true;
				// phillyCityLights.members[curLight].alpha = 1;
			}
			FlxG.camera.zoom += 0.02;
			camHUD.zoom += 0.022;
			if (curBeat == 282)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
					ease: FlxEase.quadInOut,
				});
			}
		}
		// HAIRBALL
		if (curSong.toLowerCase() == 'hairball')
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
			{
				FlxG.camera.zoom += 0.017;
				camHUD.zoom += 0.02;
			}
			if (curBeat % 1 == 0)
			{
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight = FlxG.random.int(0, phillyCityLights.length - 1);

				phillyCityLights.members[curLight].visible = true;
				// phillyCityLights.members[curLight].alpha = 1;
			}
		}
		// WOCKY
		if (curSong.toLowerCase() == 'wocky')
		{
			if (curBeat % 2 == 0)
			{
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight = FlxG.random.int(0, phillyCityLights.length - 1);

				phillyCityLights.members[curLight].visible = true;
				// phillyCityLights.members[curLight].alpha = 1;
			}
		}
		// BEATHOVEN
		if (curSong.toLowerCase() == 'beathoven')
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
			{
				FlxG.camera.zoom += 0.014;
				camHUD.zoom += 0.015;
			}
			if (curBeat % 1 == 0)
			{
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight = FlxG.random.int(0, phillyCityLights.length - 1);

				phillyCityLights.members[curLight].visible = true;
				// phillyCityLights.members[curLight].alpha = 1;
			}
		}
		// END OF VS KAPI PART

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		// NYAW
		if (curSong == 'Nyaw')
		{
			if (curBeat == 283)
				boyfriend.playAnim('hey', true);

			if (curBeat == 434)
			{
				dad.playAnim('stare', true);
				new FlxTimer().start(1.1, function(tmr:FlxTimer)
				{
					var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					black.scrollFactor.set();
					add(black);
				});
			}

			if (curBeat == 31)
				dad.playAnim('meow', true);
			if (curBeat == 135)
				dad.playAnim('meow', true);
			if (curBeat == 363)
				dad.playAnim('meow', true);
			if (curBeat == 203)
				dad.playAnim('meow', true);

			if (curBeat % 2 == 0)
				bottomBoppers.animation.play('bop', true);
			if (curBeat % 2 == 1)
				upperBoppers.animation.play('bop', true);
		}
		// HAIRBALL
		if (curSong == 'Hairball')
		{
			if (curBeat % 2 == 0)
				littleGuys.animation.play('bop', true);

			if (curBeat % 2 == 1)
				upperBoppers.animation.play('bop', true);
		}

		if (curBeat % 2 == 0 && curSong == 'Beathoven')
			littleGuys.animation.play('bop', true);

		if (curSong.toLowerCase() == 'ballistic')
		{
			if (gf.animation.name != 'scared')
				gf.playAnim('scared');
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall' | 'arcadeclosed':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				if (curStage == 'mall')
					santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving && FlxG.save.data.animEvents)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					if (phillyCityTween != null)
						phillyCityTween.cancel();

					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
						light.alpha = 1;
					});

					var curLight2:Int = curLight;
					while (curLight == curLight2)
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					phillyCityTween = FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, SONG.bpm / 60 / 2);
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8 && FlxG.save.data.animEvents)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'pillars':
				{
					if (FlxG.save.data.animEvents)
						speaker.animation.play('bop');
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	override function onBack()
	{
		if (startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
			#if mobile
			grpMobileButtons.visible = false;
			pauseButton.visible = false;
			#end
		}
	}

	var curLight:Int = 0;

	/*Kade input
		I modified it for use here, 
		Source: https://github.com/KadeDev/Kade-Engine
	 */
	private function kadeKeyShit():Void // I've invested in emma stocks
	{
		var holdArray:Array<Bool>;
		var pressArray:Array<Bool>;
		#if mobile
		if (grpMobileButtons != null)
		{
		#end
			// control arrays, order L D R U
			holdArray = [
				 controls.LEFT                          #if mobile || grpMobileButtons.left.pressed #end,
				 controls.DOWN                          #if mobile || grpMobileButtons.down.pressed #end,
				   controls.UP                            #if mobile || grpMobileButtons.up.pressed #end,
				controls.RIGHT #if mobile || (grpMobileButtons.right.pressed && !pauseButton.pressed) #end];
			pressArray = [
				 controls.LEFT_P                          #if mobile || grpMobileButtons.left.justPressed #end,
				 controls.DOWN_P                          #if mobile || grpMobileButtons.down.justPressed #end,
				   controls.UP_P                            #if mobile || grpMobileButtons.up.justPressed #end,
				controls.RIGHT_P #if mobile || (grpMobileButtons.right.justPressed && !pauseButton.pressed) #end];
		#if mobile
		}
		else
		{
			// control arrays, order L D R U
			holdArray = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
			pressArray = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		}
		#end

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && !inCutscene)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					kadeGoodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && !inCutscene)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								if (coolNote.burning)
								{
									if (curStage == 'auditorHell')
									{
										// lol death
										health = 0;
										shouldBeDead = true;
										FlxG.sound.play(Paths.sound('death', 'clown'));
									}
									else
									{
										health -= 0.45;
										totalDamageTaken += 0.45;
										interupt = true;
										coolNote.wasGoodHit = true;
										coolNote.canBeHit = false;
										coolNote.kill();
										notes.remove(coolNote, true);
										coolNote.destroy();
										FlxG.sound.play(Paths.sound('burnSound', 'clown'));
										playerStrums.forEach(function(spr:FlxSprite)
										{
											if (pressArray[spr.ID] && spr.ID == coolNote.noteData)
											{
												var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
												smoke.frames = Paths.getSparrowAtlas('Smoke', 'clown');
												smoke.animation.addByPrefix('boom', 'smoke', 24, false);
												smoke.animation.play('boom');
												smoke.setGraphicSize(Std.int(smoke.width * 0.6));
												smoke.cameras = [camHUD];
												add(smoke);
												smoke.animation.finishCallback = function(name:String)
												{
													remove(smoke);
												}
											}
										});
									}
								}
								else
									kadeGoodNoteHit(coolNote);
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				kadeGoodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
					{ // if a direction is hit that shouldn't be
						if (pressArray[shit] && !directionList.contains(shit))
							kadeNoteMiss(shit, null);
					}
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						if (coolNote.burning)
						{
							if (curStage == 'auditorHell')
							{
								// lol death
								health = 0;
								shouldBeDead = true;
								FlxG.sound.play(Paths.sound('death', 'clown'));
							}
							else
							{
								health -= 0.45;
								totalDamageTaken += 0.45;
								interupt = true;
								coolNote.wasGoodHit = true;
								coolNote.canBeHit = false;
								coolNote.kill();
								notes.remove(coolNote, true);
								coolNote.destroy();
								FlxG.sound.play(Paths.sound('burnSound', 'clown'));
								playerStrums.forEach(function(spr:FlxSprite)
								{
									if (pressArray[spr.ID] && spr.ID == coolNote.noteData)
									{
										var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
										smoke.frames = Paths.getSparrowAtlas('Smoke', 'clown');
										smoke.animation.addByPrefix('boom', 'smoke', 24, false);
										smoke.animation.play('boom');
										smoke.setGraphicSize(Std.int(smoke.width * 0.6));
										smoke.cameras = [camHUD];
										add(smoke);
										smoke.animation.finishCallback = function(name:String)
										{
											remove(smoke);
										}
									}
								});
							}
						}
						else
							kadeGoodNoteHit(coolNote);
					}
				}
			}
			else if (!FlxG.save.data.ghost)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						kadeNoteMiss(shit, null);
			}

			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost)
			{
				if (mashViolations > 4)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					kadeNoteMiss(0, null);
				}
				else
					mashViolations++;
			}
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true)))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');

			updateArrowOffsets(spr, spr.ID);
		});
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
	}

	function kadeNoteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			interupt = true;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			// var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			// if (luaModchart != null)
			//	luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	function kadeGoodNoteHit(note:Note, resetMashViolation = true):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - note.strumTime);

		note.rating = Ratings.CalculateRating(noteDiff);

		if (mashing != 0)
			mashing = 0;

		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				kadePopUpScore(note);
				combo += 1;
			}
			else
				totalNotesHit += 1;

			switch (note.noteData)
			{
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 0:
					boyfriend.playAnim('singLEFT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	private function kadePopUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		coolText.cameras = [camHUD];
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;

		totalNotesHit += wife;

		var daRating = daNote.rating;

		switch (daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.2;
				interupt = true;
				shits++;
			case 'bad':
				daRating = 'bad';
				score = 0;
				health -= 0.06;
				interupt = true;
				bads++;
			case 'good':
				daRating = 'good';
				score = 200;
				goods++;
				if (health < 2 && !grabbed)
					health += 0.04;
			case 'sick':
				if (health < 2 && !grabbed)
					health += 0.1;
				sicks++;
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += Math.round(score);

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
			comboSpr.updateHitbox();
			rating.updateHitbox();

			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite();
				numScore.frames=Paths.getSparrowAtlas(pixelShitPart1.replace('kade/','') + 'nums' + pixelShitPart2);
				numScore.animation.addByPrefix('num','num'+ Std.int(i));
				numScore.animation.play('num');
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	// Whitty code

	function whittyAnimation(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
		black.scrollFactor.set();
		var black2:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black2.scrollFactor.set();
		black2.alpha = 0;
		var black3:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black3.scrollFactor.set();
		if (curSong.toLowerCase() != 'ballistic')
			add(black);

		var epic:Bool = false;
		var white:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		white.scrollFactor.set();
		white.alpha = 0;

		trace('what animation to play, hmmmm');

		var wat:Bool = true;

		trace('cur song: ' + curSong);
		trace('cur stage: ' + curStage);

		switch (curSong.toLowerCase()) // WHITTY ANIMATION CODE LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		{
			case 'ballistic':
				trace('funny ballistic!!!');
				add(white);
				trace(white);
				var noMore:Bool = false;
				inCutscene = true;

				var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('windLmao', 'bonusWeek'), true);
				var mBreak:FlxSound = new FlxSound().loadEmbedded(Paths.sound('micBreak', 'bonusWeek'));
				var mThrow:FlxSound = new FlxSound().loadEmbedded(Paths.sound('micThrow', 'bonusWeek'));
				var mSlam:FlxSound = new FlxSound().loadEmbedded(Paths.sound('slammin', 'bonusWeek'));
				var TOE:FlxSound = new FlxSound().loadEmbedded(Paths.sound('ouchMyToe', 'bonusWeek'));
				var soljaBOY:FlxSound = new FlxSound().loadEmbedded(Paths.sound('souljaboyCrank', 'bonusWeek'));
				var rumble:FlxSound = new FlxSound().loadEmbedded(Paths.sound('rumb', 'bonusWeek'));

				remove(dad);
				var animation:FlxSprite = new FlxSprite(-480, -100);
				animation.frames = Paths.getSparrowAtlas('cuttinDeezeBalls', 'bonusWeek');
				animation.animation.addByPrefix('startup', 'Whitty Ballistic Cutscene', 24, false);
				animation.antialiasing = true;
				add(animation);

				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

				remove(funneEffect);

				wind.fadeIn();
				camHUD.visible = false;

				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					// animation

					if (!wat)
					{
						tmr.reset(1.5);
						wat = true;
					}
					else
					{
						if (animation.animation.curAnim == null) // check thingy go BEE BOOP
						{
							animation.animation.play('startup'); // if beopoe then make go BEP
							trace('start ' + animation.animation.curAnim.name);
						}
						if (!animation.animation.finished && animation.animation.curAnim.name == 'startup') // beep?
						{
							tmr.reset(0.01); // fuck
							noMore = true; // fuck outta here animation
							switch (animation.animation.frameIndex)
							{
								case 87:
									if (!mThrow.playing)
										mThrow.play();
								case 86:
									if (!mSlam.playing)
										mSlam.play();
								case 128:
									if (!soljaBOY.playing)
									{
										soljaBOY.play();
										remove(wstageFront);
										nwBg.alpha = 1;
										wBg.alpha = 0;
										nwBg.animation.play('gaming');
										camFollow.camera.shake(0.01, 3);
									}
								case 123:
									if (!rumble.playing)
										rumble.play();
								case 135:
									camFollow.camera.stopFX();
								case 158:
									if (!TOE.playing)
									{
										TOE.play();
										camFollow.camera.stopFX();
										camFollow.camera.shake(0.03, 6);
									}
								case 52:
									if (!mBreak.playing)
									{
										mBreak.play();
									}
							}
						}
						else
						{
							// white screen thingy

							camFollow.camera.stopFX();

							if (white.alpha < 1 && !epic)
							{
								white.alpha += 0.4;
								tmr.reset(0.1);
							}
							else
							{
								if (!epic)
								{
									epic = true;
									trace('epic ' + epic);
									turnToCrazyWhitty();
									remove(animation);
									TOE.fadeOut();
									tmr.reset(0.1);
									nwBg.animation.play("gameButMove");
								}
								else
								{
									if (white.alpha != 0)
									{
										white.alpha -= 0.1;
										tmr.reset(0.1);
									}
									else
									{
										if (dialogueBox != null)
										{
											camHUD.visible = true;
											wind.fadeOut();
											healthBar.visible = false;
											healthBarBG.visible = false;
											scoreTxt.visible = false;
											iconP1.visible = false;
											iconP2.visible = false;
											add(dialogueBox);
										}
										else
										{
											startCountdown();
										}
										remove(white);
									}
								}
							}
						}
					}
				});
			case 'lo-fight':
				trace('funny lo-fight!!!');
				inCutscene = true;
				remove(dad);
				var animation:FlxSprite = new FlxSprite(-290, -100);
				animation.frames = Paths.getSparrowAtlas('whittyCutscene', 'bonusWeek');
				animation.animation.addByPrefix('startup', 'Whitty Cutscene Startup ', 24, false);
				animation.antialiasing = true;
				add(animation);
				black2.visible = true;
				black3.visible = true;
				add(black2);
				add(black3);
				black2.alpha = 0;
				black3.alpha = 0;
				trace(black2);
				trace(black3);

				var city:FlxSound = new FlxSound().loadEmbedded(Paths.sound('city', 'bonusWeek'), true);
				var rip:FlxSound = new FlxSound().loadEmbedded(Paths.sound('rip', 'bonusWeek'));
				var fire:FlxSound = new FlxSound().loadEmbedded(Paths.sound('fire', 'bonusWeek'));
				var BEEP:FlxSound = new FlxSound().loadEmbedded(Paths.sound('beepboop', 'bonusWeek'));
				city.fadeIn();
				camFollow.setPosition(dad.getMidpoint().x + 40, dad.getMidpoint().y - 180);

				camHUD.visible = false;

				gf.y = 90000000;
				boyfriend.x += 314;

				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					if (!wat)
					{
						tmr.reset(3);
						wat = true;
					}
					else
					{
						// animation

						black.alpha -= 0.15;

						if (black.alpha > 0)
						{
							tmr.reset(0.3);
						}
						else
						{
							if (animation.animation.curAnim == null)
								animation.animation.play('startup');

							if (!animation.animation.finished)
							{
								tmr.reset(0.01);

								switch (animation.animation.frameIndex)
								{
									case 0:
										trace('play city sounds');
									case 41:
										trace('fire');
										if (!fire.playing)
											fire.play();
									case 34:
										trace('paper rip');
										if (!rip.playing)
											rip.play();
									case 147:
										trace('BEEP');
										if (!BEEP.playing)
										{
											camFollow.setPosition(dad.getMidpoint().x + 460, dad.getMidpoint().y - 100);
											BEEP.play();
											boyfriend.playAnim('singLEFT', true);
										}
									case 154:
										if (boyfriend.animation.curAnim.name != 'idle')
											boyfriend.playAnim('idle');
								}
							}
							else
							{
								// CODE LOL!!!!
								if (black2.alpha != 1)
								{
									black2.alpha += 0.4;
									tmr.reset(0.1);
									trace('increase blackness lmao!!!');
								}
								else
								{
									if (black2.alpha == 1 && black2.visible)
									{
										black2.visible = false;
										black3.alpha = 1;
										trace('transision ' + black2.visible + ' ' + black3.alpha);
										remove(animation);
										add(dad);
										gf.y = 140;
										boyfriend.x -= 314;
										camHUD.visible = true;
										tmr.reset(0.3);
									}
									else if (black3.alpha != 0)
									{
										black3.alpha -= 0.1;
										tmr.reset(0.3);
									}
									else
									{
										if (dialogueBox != null)
										{
											add(dialogueBox);
											city.fadeOut();
										}
										else
										{
											startCountdown();
										}
										remove(black);
									}
								}
							}
						}
					}
				});
			default:
				trace('funny *goat looking at camera*!!!');
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					if (!wat)
					{
						tmr.reset(3);
						wat = true;
					}

					black.alpha -= 0.15;

					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
							inCutscene = true;
							add(dialogueBox);
						}
						remove(black);
					}
				});
		}
	}

	function turnToCrazyWhitty()
	{
		remove(iconP2);
		remove(iconP1);
		remove(healthBarBG);
		remove(healthBar);

		iconP2 = new HealthIcon('whittyCrazy', false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		add(healthBarBG);
		add(healthBar);

		add(iconP2);
		add(iconP1);

		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];

		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];

		remove(dad);
		remove(gf);
		dad = new Character(100, 100, 'whittyCrazy');
		add(gf);

		add(dad);

		if (isStoryMode)
		{
			iconP1.visible = false;
			iconP2.visible = false;
		}
	}

	// tricky
	function trickyCutscene():Void // god this function is terrible
	{
		trace('starting cutscene');

		var playonce:Bool = false;

		var faded:Bool = false;
		var black:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
		black.scrollFactor.set();
		black.alpha = 0;
		var black3:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
		black3.scrollFactor.set();
		black3.alpha = 0;
		var red:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
		red.scrollFactor.set();
		red.alpha = 1;
		inCutscene = true;
		// camFollow.setPosition(bf.getMidpoint().x + 80, bf.getMidpoint().y + 200);
		dad.alpha = 0;
		gf.alpha = 0;
		remove(boyfriend);
		var nevada:FlxSprite = new FlxSprite(260, FlxG.height * 0.7).loadGraphic(Paths.image('somewhere', 'clown'));
		nevada.antialiasing = true;
		nevada.alpha = 0;
		var animation:FlxSprite = new FlxSprite(-50, 200); // create the fuckin thing
		animation.frames = Paths.getSparrowAtlas('intro', 'clown'); // add animation from sparrow
		animation.antialiasing = true;
		animation.animation.addByPrefix('fuckyou', 'Symbol', 24, false);
		animation.setGraphicSize(Std.int(animation.width * 1.2));
		nevada.setGraphicSize(Std.int(nevada.width * 0.5));
		add(animation); // add it to the scene

		// sounds

		var ground:FlxSound = new FlxSound().loadEmbedded(Paths.sound('ground', 'clown'));
		var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wind', 'clown'));
		var cloth:FlxSound = new FlxSound().loadEmbedded(Paths.sound('cloth', 'clown'));
		var metal:FlxSound = new FlxSound().loadEmbedded(Paths.sound('metal', 'clown'));
		var buildUp:FlxSound = new FlxSound().loadEmbedded(Paths.sound('trickyIsTriggered', 'clown'));

		camHUD.visible = false;

		add(boyfriend);

		add(red);
		add(black);
		add(black3);

		add(nevada);

		var nevadaEnded:Bool = false;
		var nevadaStep:Int = 0;

		FlxTween.tween(nevada, {alpha: 1}, 1 / 3, {
			onComplete: (tween:FlxTween) ->
			{
				var tmr:FlxTimer = new FlxTimer();
				nevadaStep++;
				tmr.start(1.5, (tmr:FlxTimer) ->
				{
					nevadaStep++;
					FlxTween.tween(nevada, {alpha: 0}, 1 / 3, {
						onComplete: (tw:FlxTween) ->
						{
							nevadaStep++;
							new FlxTimer().start(1 / 24 * 7, (tmr:FlxTimer) ->
							{
								nevadaStep++;
								nevadaEnded = true;
							});
						}
					});
				});
			}
		});

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (boyfriend.animation.finished && !bfScared)
				boyfriend.animation.play('idle');
			else if (boyfriend.animation.finished)
				boyfriend.animation.play('scared');
			if (!nevadaEnded || red.alpha != 0)
			{
				if (nevadaStep >= 3 && red.alpha != 0)
				{
					// trace(red.alpha);
					// don't spam, lol
					red.alpha -= 0.1;
				}
				if (nevadaStep == 2)
					wind.fadeIn();
				tmr.reset(0.1);
			}
			if (nevadaStep >= 3 && red.alpha == 0)
			{
				remove(red);
				animation.animation.play('fuckyou', false, false, 40);
			}
			if (!animation.animation.finished && animation.animation.curAnim.name == 'fuckyou' && red.alpha == 0 && !faded)
			{
				// trace("animation loop");
				// wtf, don't spam
				tmr.reset(0.01);

				// animation code is bad I hate this
				// :(

				switch (animation.animation.frameIndex) // THESE ARE THE SOUNDS NOT THE ACTUAL CAMERA MOVEMENT!!!!
				{
					case 73:
						ground.play();
					case 84:
						metal.play();
					case 170:
						if (!playonce)
						{
							resetSpookyText = false;
							createSpookyText(trickyCutsceneText[0], 260, FlxG.height * 0.9);
							playonce = true;
						}
						cloth.play();
					case 192:
						resetSpookyTextManual();
						buildUp.fadeIn();
					case 219:
						trace('reset thingy');
						buildUp.fadeOut();
				}

				// im sorry for making this code.
				// TODO: CLEAN THIS FUCKING UP (switch case it or smth)

				if (animation.animation.frameIndex == 190)
					bfScared = true;

				if (animation.animation.frameIndex >= 115 && animation.animation.frameIndex < 200)
				{
					camFollow.setPosition(dad.getMidpoint().x + 150, boyfriend.getMidpoint().y + 50);
					if (FlxG.camera.zoom < 1.1)
						FlxG.camera.zoom += 0.01;
					else
						FlxG.camera.zoom = 1.1;
				}
				else if (animation.animation.frameIndex > 200 && FlxG.camera.zoom != defaultCamZoom)
				{
					FlxG.camera.shake(0.01, 3);
					if (FlxG.camera.zoom < defaultCamZoom || camFollow.y < boyfriend.getMidpoint().y - 50)
					{
						FlxG.camera.zoom = defaultCamZoom;
						camFollow.y = boyfriend.getMidpoint().y - 50;
					}
					else
					{
						FlxG.camera.zoom -= 0.008;
						camFollow.y = dad.getMidpoint().y -= 1;
					}
				}
				if (animation.animation.frameIndex >= 235)
					faded = true;
			}
			else if (red.alpha == 0 && faded)
			{
				// trace('red gay');
				// don't spam, lol

				// animation finished, start a dialog or start the countdown (should also probably fade into this, aka black fade in when the animation gets done and black fade out. Or just make the last frame tranisiton into the idle animation)
				if (black.alpha != 1)
				{
					if (tstatic.alpha != 0)
						manuallymanuallyresetspookytextmanual();
					black.alpha += 0.4;
					tmr.reset(0.1);
					// trace('increase blackness lmao!!!');
					// don't spam, lol
				}
				else
				{
					if (black.alpha == 1 && black.visible)
					{
						black.visible = false;
						black3.alpha = 1;
						trace('transision ' + black.visible + ' ' + black3.alpha);
						remove(animation);
						dad.alpha = 1;
						// why did I write this comment? I'm so confused
						// shitty layering but ninja muffin can suck my dick like mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
						remove(red);
						remove(black);
						remove(black3);
						dad.alpha = 1;
						gf.alpha = 1;
						add(black);
						add(black3);
						remove(tstatic);
						add(tstatic);
						tmr.reset(0.3);
						FlxG.camera.stopFX();
						camHUD.visible = true;
					}
					else if (black3.alpha != 0)
					{
						black3.alpha -= 0.1;
						tmr.reset(0.3);

						// trace('decrease blackness lmao!!!');
						// don't spam, lol
					}
					else
					{
						wind.fadeOut();
						startCountdown();
					}
				}
			}
		});
	}

	function resetSpookyTextManual():Void
	{
		trace('reset spooky');
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		tStaticSound.play(true);
		resetSpookyText = true;
	}

	function manuallymanuallyresetspookytextmanual()
	{
		remove(spookyText);
		spookyRendered = false;
		tstatic.alpha = 0;
	}

	function createSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
	{
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		tStaticSound.play(true);
		spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40, dad.x + 120) : x),
			(y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));
		spookyText.setFormat("assets/fonts/tahoma-bold.ttf", 128, FlxColor.RED);
		if (curStage == 'nevedaSpook')
		{
			spookyText.size = 200;
			spookyText.x += 250;
		}
		spookyText.bold = true;
		spookyText.text = text;
		add(spookyText);
	}

	function trickySecondCutscene():Void // why is this a second method? idk cry about it loL!!!!
	{
		var done:Bool = false;

		trace('starting cutscene');

		var black:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		black.scrollFactor.set();
		black.alpha = 0;

		var animation:FlxSprite = new FlxSprite(200, 300); // create the fuckin thing

		animation.frames = Paths.getSparrowAtlas('trickman', 'clown'); // add animation from sparrow
		animation.antialiasing = true;
		animation.animation.addByPrefix('cut1', 'Cutscene 1', 24, false);
		animation.animation.addByPrefix('cut2', 'Cutscene 2', 24, false);
		animation.animation.addByPrefix('cut3', 'Cutscene 3', 24, false);
		animation.animation.addByPrefix('cut4', 'Cutscene 4', 24, false);
		animation.animation.addByPrefix('pillar', 'Pillar Beam Tricky', 24, false);

		animation.setGraphicSize(Std.int(animation.width * 1.5));

		animation.alpha = 0;

		camFollow.setPosition(dad.getMidpoint().x + 300, boyfriend.getMidpoint().y - 200);

		inCutscene = true;
		startedCountdown = false;
		generatedMusic = false;
		canPause = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		var sounders:FlxSound = FlxG.sound.play(Paths.sound('honkers', 'clown'));
		var energy:FlxSound = new FlxSound().loadEmbedded(Paths.sound('energy shot', 'clown'));
		var roar:FlxSound = new FlxSound().loadEmbedded(Paths.sound('sound_clown_roar', 'clown'));
		var pillar:FlxSound = new FlxSound().loadEmbedded(Paths.sound('firepillar', 'clown'));

		var fade:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
		fade.scrollFactor.set();
		fade.alpha = 0;

		add(animation);

		add(black);

		add(fade);

		var startFading:Bool = false;
		var varNumbaTwo:Bool = false;
		var fadeDone:Bool = false;

		sounders.play(true);

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (fade.alpha != 1 && !varNumbaTwo)
			{
				camHUD.alpha -= 0.1;
				fade.alpha += 0.1;
				if (fade.alpha == 1)
				{
					// THIS IS WHERE WE LOAD SHIT UN-NOTICED
					varNumbaTwo = true;

					animation.alpha = 1;

					dad.alpha = 0;
				}
				tmr.reset(0.1);
			}
			else
			{
				fade.alpha -= 0.1;
				if (fade.alpha <= 0.5)
					fadeDone = true;
				tmr.reset(0.1);
			}
		});

		var roarPlayed:Bool = false;

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (!fadeDone)
				tmr.reset(0.1)
			else
			{
				if (animation.animation == null || animation.animation.name == null)
				{
					trace('playin cut cuz its funny lol!!!');
					animation.animation.play("cut1");
					resetSpookyText = false;
					createSpookyText(trickyCutsceneText[1], 260, FlxG.height * 0.9);
				}

				if (!animation.animation.finished)
				{
					tmr.reset(0.1);

					switch (animation.animation.frameIndex)
					{
						case 104:
							if (animation.animation.name == 'cut1')
								manuallymanuallyresetspookytextmanual();
					}

					if (animation.animation.name == 'pillar')
					{
						if (animation.animation.frameIndex >= 85) // why is this not in the switch case above? idk cry about it
							startFading = true;
						FlxG.camera.shake(0.05);
					}
				}
				else
				{
					manuallymanuallyresetspookytextmanual();
					switch (animation.animation.name)
					{
						case 'cut1':
							animation.animation.play('cut2');
						case 'cut2':
							animation.animation.play('cut3');
							energy.play();
						case 'cut3':
							animation.animation.play('cut4');
							resetSpookyText = false;
							createSpookyText(trickyCutsceneText[2], 260, FlxG.height * 0.9);
							animation.x -= 100;
						case 'cut4':
							manuallymanuallyresetspookytextmanual();
							sounders.fadeOut();
							pillar.fadeIn(4);
							animation.animation.play('pillar');
							animation.y -= 670;
							animation.x -= 100;
					}
					tmr.reset(0.1);
				}

				if (startFading)
				{
					trace("Fading out");
					sounders.fadeOut();
					if (black.alpha != 1)
					{
						tmr.reset(0.1);
						black.alpha += 0.02;

						if (black.alpha >= 0.7 && !roarPlayed)
						{
							roar.play();
							roarPlayed = true;
						}
					}
					else if (done)
					{
						endSong();
						FlxG.camera.stopFX();
					}
					else
					{
						done = true;
						tmr.reset(5);
					}
				}
			}
		});
	}

	function doStopSign(sign:Int = 0, fuck:Bool = false)
	{
		trace('sign ' + sign);
		var daSign:FlxSprite = new FlxSprite(0, 0);
		// CachedFrames.cachedInstance.get('sign')

		daSign.frames = CachedFrames.cachedInstance.fromSparrow('sign', 'fourth/mech/Sign_Post_Mechanic');

		daSign.setGraphicSize(Std.int(daSign.width * 0.67));

		daSign.cameras = [camHUD];

		switch (sign)
		{
			case 0:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 1', 24, false);
				daSign.x = FlxG.width - 650;
				daSign.angle = -90;
				daSign.y = -300;
			case 1:
			/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
				daSign.x = FlxG.width - 670;
				daSign.angle = -90; */ // this one just doesn't work???
			case 2:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 3', 24, false);
				daSign.x = FlxG.width - 780;
				daSign.angle = -90;

				if (useDownscroll)
					daSign.y = -395;
				else
					daSign.y = -980;
			case 3:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 4', 24, false);
				daSign.x = FlxG.width - 1070;
				daSign.angle = -90;
				daSign.y = -145;
		}
		add(daSign);
		daSign.flipX = fuck;
		daSign.animation.play('sign');
		daSign.animation.finishCallback = function(pog:String)
		{
			trace('ended sign');
			remove(daSign);
		}
	}

	function doClone(side:Int)
	{
		switch (side)
		{
			case 0:
				if (cloneOne.alpha == 1)
					return;
				cloneOne.x = dad.x - 20;
				cloneOne.y = dad.y + 140;
				cloneOne.alpha = 1;

				cloneOne.animation.play('clone');
				cloneOne.animation.finishCallback = function(pog:String)
				{
					cloneOne.alpha = 0;
				}
			case 1:
				if (cloneTwo.alpha == 1)
					return;
				cloneTwo.x = dad.x + 390;
				cloneTwo.y = dad.y + 140;
				cloneTwo.alpha = 1;

				cloneTwo.animation.play('clone');
				cloneTwo.animation.finishCallback = function(pog:String)
				{
					cloneTwo.alpha = 0;
				}
		}
	}

	function hardCodedTrickyEvents()
	{
		if (curStage == 'auditorHell' && curStep != stepOfLast)
		{
			switch (curStep)
			{
				case 384:
					doStopSign(0);
				case 511:
					doStopSign(2);
					doStopSign(0);
				case 610:
					doStopSign(3);
				case 720:
					doStopSign(2);
				case 991:
					doStopSign(3);
				case 1184:
					doStopSign(2);
				case 1218:
					doStopSign(0);
				case 1235:
					doStopSign(0, true);
				case 1200:
					doStopSign(3);
				case 1328:
					doStopSign(0, true);
					doStopSign(2);
				case 1439:
					doStopSign(3, true);
				case 1567:
					doStopSign(0);
				case 1584:
					doStopSign(0, true);
				case 1600:
					doStopSign(2);
				case 1706:
					doStopSign(3);
				case 1917:
					doStopSign(0);
				case 1923:
					doStopSign(0, true);
				case 1927:
					doStopSign(0);
				case 1932:
					doStopSign(0, true);
				case 2032:
					doStopSign(2);
					doStopSign(0);
				case 2036:
					doStopSign(0, true);
				case 2162:
					doStopSign(2);
					doStopSign(3);
				case 2193:
					doStopSign(0);
				case 2202:
					doStopSign(0, true);
				case 2239:
					doStopSign(2, true);
				case 2258:
					doStopSign(0, true);
				case 2304:
					doStopSign(0, true);
					doStopSign(0);
				case 2326:
					doStopSign(0, true);
				case 2336:
					doStopSign(3);
				case 2447:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2480:
					doStopSign(0, true);
					doStopSign(0);
				case 2512:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2544:
					doStopSign(0, true);
					doStopSign(0);
				case 2575:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2608:
					doStopSign(0, true);
					doStopSign(0);
				case 2604:
					doStopSign(0, true);
				case 2655:
					doGremlin(20, 13, true);
			}
			stepOfLast = curStep;
		}

		if (spookyRendered && spookySteps + 3 < curStep)
		{
			if (resetSpookyText)
			{
				remove(spookyText);
				spookyRendered = false;
			}
			tstatic.alpha = 0;
			if (curStage == 'auditorHell')
				tstatic.alpha = 0.1;
		}
	}

	function doGremlin(hpToTake:Int, duration:Int, persist:Bool = false)
	{
		interupt = false;

		grabbed = true;

		totalDamageTaken = 0;

		var gramlan:FlxSprite = new FlxSprite(0, 0);

		gramlan.frames = CachedFrames.cachedInstance.fromSparrow('grem', 'fourth/mech/HP GREMLIN');

		gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));

		gramlan.cameras = [camHUD];

		gramlan.x = iconP1.x;
		gramlan.y = healthBarBG.y - 325;

		gramlan.animation.addByIndices('come', 'HP Gremlin ANIMATION', [0, 1], "", 24, false);
		gramlan.animation.addByIndices('grab', 'HP Gremlin ANIMATION', [
			2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
		], "", 24, false);
		gramlan.animation.addByIndices('hold', 'HP Gremlin ANIMATION', [25, 26, 27, 28], "", 24);
		gramlan.animation.addByIndices('release', 'HP Gremlin ANIMATION', [29, 30, 31, 32, 33], "", 24, false);

		gramlan.antialiasing = true;

		add(gramlan);

		if (useDownscroll)
		{
			gramlan.flipY = true;
			gramlan.y -= 150;
		}

		// over use of flxtween :)

		var startHealth = health;
		var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health

		var perct = toHealth / 2 * 100;

		trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');

		var onc:Bool = false;

		FlxG.sound.play(Paths.sound('fourth/GremlinWoosh', 'clown'));

		gramlan.animation.play('come');
		new FlxTimer().start(0.14, function(tmr:FlxTimer)
		{
			gramlan.animation.play('grab');
			FlxTween.tween(gramlan, {x: iconP1.x - 140}, 1, {
				ease: FlxEase.elasticIn,
				onComplete: function(tween:FlxTween)
				{
					trace('I got em');
					gramlan.animation.play('hold');
					FlxTween.tween(gramlan, {
						x: (healthBar.x + (healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) - 26)) - 75
					}, duration, {
						onUpdate: function(tween:FlxTween)
						{
							// lerp the health so it looks pog
							if (interupt && !onc && !persist)
							{
								onc = true;
								gramlan.animation.play('release');
								gramlan.animation.finishCallback = function(pog:String)
								{
									gramlan.alpha = 0;
								}
							}
							else if (!interupt || persist)
							{
								var pp = FlxMath.lerp(startHealth, toHealth, tween.percent);
								if (pp <= 0)
									pp = 0.1;
								health = pp;
							}
						},
						onComplete: function(tween:FlxTween)
						{
							if (interupt && !persist)
							{
								remove(gramlan);
								grabbed = false;
							}
							else
							{
								trace('oh shit');
								gramlan.animation.play('release');
								if (persist && totalDamageTaken >= 0.7)
									health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
								gramlan.animation.finishCallback = function(pog:String)
								{
									remove(gramlan);
								}
								grabbed = false;
							}
						}
					});
				}
			});
		});
	}

	// A.G.O.T.I
	function agotiCrazy():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;

		dadStrums.visible = false;
		playerStrums.visible = false;
		strumLineNotes.visible = false;

		inCutscene = true;

		var pillarFG:FlxSprite = new FlxSprite(0, 0);
		pillarFG.frames = Paths.getSparrowAtlas("Pillar_FG", "agoti");
		pillarFG.animation.addByPrefix("move", "Pillar_FG", 24, false);
		pillarFG.setGraphicSize(Std.int(pillarFG.width * 1.5));
		pillarFG.antialiasing = true;
		pillarFG.scrollFactor.set(1.1, 1.1);
		pillarFG.alpha = 0;

		var agotiSummon:FlxSprite = new FlxSprite(dad.x, dad.y);
		agotiSummon.frames = Paths.getSparrowAtlas('Agoti_Cutscene_B', 'agoti');
		agotiSummon.animation.addByPrefix('move', 'Agoti_Cut_B', 24, false);
		agotiSummon.setGraphicSize(Std.int(agotiSummon.width * 1.5));
		// agotiSummon.scrollFactor.set();
		agotiSummon.updateHitbox();
		agotiSummon.screenCenter();
		agotiSummon.antialiasing = true;
		// agotiSummon.x -= 750;
		////agotiSummon.y -= 90;

		agotiSummon.x -= 450;
		agotiSummon.y += 250;
		agotiSummon.alpha = 0;

		add(agotiSummon);
		add(pillarFG);

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.setGraphicSize(Std.int(black.width * 5));
		black.scrollFactor.set();
		add(black);
		black.alpha = 0;

		var offsetX = 0;
		var offsetY = 0;

		camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

		new FlxTimer().start(2, function(deadTime:FlxTimer)
		{
			dad.alpha = 0;
			agotiSummon.alpha = 1;
			FlxG.sound.play(Paths.sound('outrocut', 'agoti'));
			new FlxTimer().start(0.01, function(deadTime:FlxTimer)
			{
				agotiSummon.animation.play('move');

				if(FlxG.save.data.animEvents)
				new FlxTimer().start(2.5, (tmr) ->
				{
					bgpillar.alpha = 1;
					bgpillar.animation.play('move', true);
				});

				new FlxTimer().start(4, function(deadTime:FlxTimer)
				{
					FlxTween.tween(black, {alpha: 1}, 1);
					new FlxTimer().start(0.25, (tmr) ->
					{
						pillarFG.alpha = 1;
						pillarFG.animation.play('move');
					});

					new FlxTimer().start(1.5, function(deadTime:FlxTimer)
					{
						dad.alpha = 1;
						remove(agotiSummon);
						endSong();
					});
				});
			});
		});
	}

	function agotiIntro():Void
	{
		trace('agoti intro');

		inCutscene = true;
		canPause = false;
		var agotiIntro:FlxSprite = new FlxSprite(dad.x, dad.y);
		agotiIntro.frames = Paths.getSparrowAtlas('Agoti_Cutscene_A', 'agoti');
		agotiIntro.animation.addByPrefix('move', 'Agoti_Cut_A', 24, false);
		agotiIntro.setGraphicSize(Std.int(agotiIntro.width * 1.35));
		agotiIntro.scrollFactor.set();
		agotiIntro.updateHitbox();
		agotiIntro.screenCenter();
		agotiIntro.antialiasing = true;
		agotiIntro.x -= 690;
		agotiIntro.y -= 185;
		agotiIntro.alpha = 0;

		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;

		add(agotiIntro);
		new FlxTimer().start(0.4, function(deadTime:FlxTimer)
		{
			dad.alpha = 0;
			dadMicless.alpha = 0;
			agotiIntro.alpha = 1;
			FlxG.sound.play(Paths.sound('introcut', 'agoti'));
			new FlxTimer().start(0.01, function(deadTime:FlxTimer)
			{
				agotiIntro.animation.play('move');
				new FlxTimer().start(3.75, function(deadTime:FlxTimer)
				{
					dad.alpha = 1;
					dadMicless.alpha = 0;
					remove(agotiIntro);
					startCountdown();
				});
			});
		});
	}

	function agotiIntroDialogue(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.setGraphicSize(Std.int(black.width * 5));
		black.scrollFactor.set();
		add(black);

		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;

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
					inCutscene = true;

					add(dialogueBox);
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function updateArrowOffsets(arrow:FlxSprite, id:Int)
	{
		if (arrow.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
		{
			arrow.centerOffsets();
			arrow.offset.x -= 13;
			arrow.offset.y -= 13;
			if (useAgotiArrows)
				arrow.offset.y -= 5;
			if (useAgotiArrows && id == 2)
				arrow.offset.y -= 5;
		}
		else
			arrow.centerOffsets();
	}
}

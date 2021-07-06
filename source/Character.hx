package;

import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxAnimationController;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import kade.CachedFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var exSpikes:FlxSprite;
	public var otherFrames:Array<Character>;

	var garTrailTarget:FlxSprite;
	var garTrail:FlxTrail;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		trace('creating character: '+curCharacter);

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets');
				frames = tex;
				quickAnimAdd('cheer', 'GF Cheer', 24, false);
				quickAnimAdd('singLEFT', 'GF left note', 24, false);
				quickAnimAdd('singRIGHT', 'GF Right Note', 24, false);
				quickAnimAdd('singUP', 'GF Up Note', 24, false);
				quickAnimAdd('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				quickAnimAdd('scared', 'GF FEAR', 24,true);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-hell':
				tex = Paths.getSparrowAtlas('hellclwn/GF/gf_phase_3','clown');
				frames = tex;
				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('scared', 'GF FEAR', 24, true);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
	
				addOffset('scared', -2, -17);
	
				playAnim('danceRight');
			
				
			case 'gf-tied':
				tex = Paths.getSparrowAtlas('fourth/EX Tricky GF','clown');
				frames = tex;

				trace(frames.frames.length);

				animation.addByIndices('danceLeft','GF Ex Tricky',[0,1,2,3,4,5,6,7,8], "", 24, false);
				animation.addByIndices('danceRight','GF Ex Tricky',[9,10,11,12,13,14,15,16,17,18,19], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				trace(animation.curAnim);

			case 'gf-arcade':
				// ARCADE GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_arcade','kapiWeek');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
	
				playAnim('danceRight');
			#if !MOD_ONLY
			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('christmas/gfChristmas');
				frames = tex;
				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				quickAnimAdd('scared', 'GF FEAR', 24,true);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('weeb/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
			#end
			case 'gf-whitty':
				tex = Paths.getSparrowAtlas('GF_Standing_Sway', 'bonusWeek');
				frames = tex;
				quickAnimAdd('sad', 'Sad');
				quickAnimAdd('danceLeft', 'Idle Left');
				quickAnimAdd('danceRight', 'Idle Right');
				quickAnimAdd('scared', 'Scared');

				addOffset('sad', -140, -153);
				addOffset('danceLeft', -140, -153);
				addOffset('danceRight', -140, -153);
				addOffset('scared', -140, -153);

				playAnim('danceRight');
			case 'gf-whitty-zoom':
				tex = Paths.getSparrowAtlas('GF_Standing_ZOOOOOOOOOOOOOOM', 'bonusWeek');
				frames = tex;
				quickAnimAdd('sad', 'Sad');
				quickAnimAdd('danceLeft', 'Idle Left');
				quickAnimAdd('danceRight', 'Idle Right');
				quickAnimAdd('scared', 'Scared');
	
				addOffset('sad', -140, -153);
				addOffset('danceLeft', -140, -153);
				addOffset('danceRight', -140, -153);
				addOffset('scared', -140, -153);
	
				playAnim('danceRight');
			case 'gf-rocks':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets', 'agoti');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
	
				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
	
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);
	
				addOffset('scared', -2, -17);
	
				playAnim('danceRight');
			#if !MOD_ONLY
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST');
				frames = tex;
				quickAnimAdd('idle', 'Dad idle dance', 24,true);
				quickAnimAdd('singUP', 'Dad Sing Note UP', 24,true);
				quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT', 24,true);
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN', 24,true);
				quickAnimAdd('singLEFT', 'Dad Sing Note LEFT', 24,true);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			#end
			case 'garcello':
				// GARCELLO ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('garcello_assets',"weekG");
				frames = tex;
				quickAnimAdd('idle', 'garcello idle dance', 24, true);
				quickAnimAdd('singUP', 'garcello Sing Note UP', 24, true);
				quickAnimAdd('singRIGHT', 'garcello Sing Note RIGHT', 24, true);
				quickAnimAdd('singDOWN', 'garcello Sing Note DOWN', 24, true);
				quickAnimAdd('singLEFT', 'garcello Sing Note LEFT', 24, true);

				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);

				playAnim('idle');

			case 'garcellotired':
				// GARCELLO TIRED ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('garcellotired_assets','weekG');
				frames = tex;
				quickAnimAdd('idle', 'garcellotired idle dance');
				quickAnimAdd('singUP', 'garcellotired Sing Note UP');
				quickAnimAdd('singRIGHT', 'garcellotired Sing Note RIGHT');
				quickAnimAdd('singDOWN', 'garcellotired Sing Note DOWN');
				quickAnimAdd('singLEFT', 'garcellotired Sing Note LEFT');

				quickAnimAdd('singUP-alt', 'garcellotired Sing Note UP');
				quickAnimAdd('singRIGHT-alt', 'garcellotired Sing Note RIGHT');
				quickAnimAdd('singLEFT-alt', 'garcellotired Sing Note LEFT');
				quickAnimAdd('singDOWN-alt', 'garcellotired cough');

				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("singUP-alt", 0, 0);
				addOffset("singRIGHT-alt", 0, 0);
				addOffset("singLEFT-alt", 0, 0);
				addOffset("singDOWN-alt", 0, 0);

				playAnim('idle');

			case 'garcellodead':
				// GARCELLO DEAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('garcellodead_assets','weekG');
				frames = tex;
				animation.addByPrefix('idle', 'garcello idle dance', 24);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

				animation.addByPrefix('garTightBars', 'garcello coolguy', 15);

				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("garTightBars", 0, 0);

				if(FlxG.save.data.graphicsQuality>1){
					garTrailTarget = new FlxSprite(x,y);
					garTrailTarget.graphic=graphic;
					garTrailTarget.frames=frames;

					garTrailTarget.animation.addByPrefix('idle', 'garcello idle dance', 24);
					garTrailTarget.animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
					garTrailTarget.animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
					garTrailTarget.animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
					garTrailTarget.animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

					garTrail=new FlxTrail(garTrailTarget,null,8,24,0.2,0.25);
					garTrail.scrollFactor.set(1.1,1.1);

					PlayState.staticVar.add(garTrail);
				}

				playAnim('idle');

			case 'garcelloghosty':
				// GARCELLO DEAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('garcelloghosty_assets','weekG');
				frames = tex;
				animation.addByPrefix('idle', 'garcello idle dance', 24);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

				animation.addByPrefix('garFarewell', 'garcello coolguy', 15);

				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("garTightBars", 0, 0);

				playAnim('idle');
			#if !MOD_ONLY
			case 'spooky':
				tex = Paths.getSparrowAtlas('spooky_kids_assets');
				frames = tex;
				quickAnimAdd('singUP', 'spooky UP NOTE');
				quickAnimAdd('singDOWN', 'spooky DOWN note');
				quickAnimAdd('singLEFT', 'note sing left');
				quickAnimAdd('singRIGHT', 'spooky sing right');
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('christmas/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;
			#end
			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('arcadeDeath', 'BF arcade death', 24, false);
				animation.addByPrefix('arcadeDeathConfirm', 'BF arcade Dead confirm', 12, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				addOffset('arcadeDeath', 37, 11);
				addOffset('arcadeDeathConfirm', 100, 540);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('christmas/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar',PlayState.storyWeek==5 ? "week5" : "agoti");
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-hell':
				var tex = Paths.getSparrowAtlas('hellclwn/BF/BF_3rd_phase','clown');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
	
				animation.addByPrefix('scared', 'BF idle shaking', 24);
	
				animation.addByPrefix('stunned', 'BF hit', 24, false);
	
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
	
				addOffset('scared', -4);
	
				playAnim('idle');
	
				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('weeb/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('weeb/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('weeb/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('christmas/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

			case 'whitty': // whitty reg (lofight,overhead)
				tex = Paths.getSparrowAtlas('WhittySprites', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				addOffset('idle', 0,0 );
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');

			case 'whittyCrazy': // whitty crazy (ballistic)
				tex = Paths.getSparrowAtlas('WhittyCrazy', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('idle', 'Whitty idle dance', 24);
				animation.addByPrefix('singUP', 'Whitty Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'whitty sing note right', 24);
				animation.addByPrefix('singDOWN', 'Whitty Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Whitty Sing Note LEFT', 24);

				addOffset('idle', 50);
				addOffset("singUP", 50, 85);
				addOffset("singRIGHT", 100, -75);
				addOffset("singLEFT", 50);
				addOffset("singDOWN", 75, -150);
				
				playAnim('idle');
			case 'kapi':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('KAPI','kapiWeek');
				frames = tex;
				animation.addByIndices('idle', 'Dad idle dance', [2, 4, 6, 8, 10, 0], "", 12, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('meow', 'Dad meow', 24, false);
				animation.addByPrefix('stare', 'Dad stare', 24, false);
				
				addOffset('idle');
				
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
	
				addOffset("stare");
				addOffset("meow");
				playAnim('idle');
			case 'kapi-angry':
				// DADMAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('KAPI_ANGRY','kapiWeek');
				frames = tex;
				animation.addByIndices('idle', 'Dad idle dance', [2, 4, 6, 8, 10, 0], "", 12, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('meow', 'Dad meow', 24, false);
	
					
				addOffset('idle');
					
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
	
				addOffset("meow");
				playAnim('idle');
			case 'mrgame':
				tex = Paths.getSparrowAtlas('mrgame','g3wWeek');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
	
				addOffset('danceRight');
	
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
	
				playAnim('danceRight');

			case 'trickyMask':
				tex = Paths.getSparrowAtlas('TrickyMask','clown');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24); 
					
				addOffset("idle", 0, -117);
				addOffset("singUP", 93, -100);
				addOffset("singRIGHT", 16, -164);
				addOffset("singLEFT", 194, -95);
				addOffset("singDOWN", 32, -168);
	
				playAnim('idle');
			case 'tricky':
				tex = Paths.getSparrowAtlas('tricky','clown');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24); 
				
				addOffset("idle", 0, -75);
				addOffset("singUP", 93, -76);
				addOffset("singRIGHT", 16, -176);
				addOffset("singLEFT", 103, -72);
				addOffset("singDOWN", 6, -84);

				playAnim('idle');
			case 'signDeath':
				frames = Paths.getSparrowAtlas('signDeath','clown');
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, false);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);
					
				playAnim('firstDeath');
	
				addOffset('firstDeath');
				addOffset('deathLoop');
				addOffset('deathConfirm', 0, 40);
	
				animation.pause();
	
				updateHitbox();
				antialiasing = false;
				flipX = true;
				
			case 'exTricky':
				frames = Paths.getSparrowAtlas('fourth/EXTRICKY','clown');
				exSpikes = new FlxSprite(x - 350,y - 170);
				exSpikes.frames = Paths.getSparrowAtlas('fourth/FloorSpikes','clown');
				exSpikes.visible = false;

				exSpikes.animation.addByPrefix('spike','Floor Spikes', 24, false);

				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('Hank', 'Hank', 24, true);

				addOffset('idle');
				addOffset('Hank');
				addOffset("singUP", 0, 100);
				addOffset("singRIGHT", -209,-29);
				addOffset("singLEFT",127,20);
				addOffset("singDOWN",-100,-340);

				playAnim('idle');
			case 'trickyH':
				tex = CachedFrames.cachedInstance.fromSparrow('idle','hellclwn/Tricky/Idle');
	
				frames = tex;
	
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
	
				animation.addByPrefix('idle','Phase 3 Tricky Idle', 24);
					
				// they have to be left right up down, in that order.
				// cuz im too lazy to dynamicly get these names
				// cry about it
	
				otherFrames = new Array<Character>();
	
					
				otherFrames.push(new Character(x, y, 'trickyHLeft'));
				otherFrames.push(new Character(x, y, 'trickyHRight'));
				otherFrames.push(new Character(x, y, 'trickyHUp'));
				otherFrames.push(new Character(x, y, 'trickyHDown'));
	
				addOffset("idle", 325, 0);
				playAnim('idle');

				this.x += width/2;
				this.y += height/2;

				setGraphicSize(Std.int(width*2),Std.int(height*2));
				updateHitbox();

			case 'trickyHDown':
				tex = CachedFrames.cachedInstance.fromSparrow('down','hellclwn/Tricky/Down');
	
				frames = tex;
	
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
	
				animation.addByPrefix('idle','Proper Down', 24);
	
				addOffset("idle",475, -450);
	
				y -= 2000;
				x -= 1400;
	
				playAnim('idle');
				
				setGraphicSize(Std.int(width*2),Std.int(height*2));
				updateHitbox();
			case 'trickyHUp':
				tex = CachedFrames.cachedInstance.fromSparrow('up','hellclwn/Tricky/Up');
	
	
				frames = tex;
	
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
	
				animation.addByPrefix('idle','Proper Up', 24);
	
				addOffset("idle", 575, -450);
	
				y -= 2000;
				x -= 1400;
	
				playAnim('idle');

				setGraphicSize(Std.int(width*2),Std.int(height*2));
				updateHitbox();
			case 'trickyHRight':
				tex = CachedFrames.cachedInstance.fromSparrow('right','hellclwn/Tricky/right');
	
				frames = tex;
	
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
	
				animation.addByPrefix('idle','Proper Right', 24);
	
				addOffset("idle",485, -300);
	
				y -= 2000;
				x -= 1400;
	
				playAnim('idle');

				setGraphicSize(Std.int(width*2),Std.int(height*2));
				updateHitbox();
			case 'trickyHLeft':
				tex = CachedFrames.cachedInstance.fromSparrow('left','hellclwn/Tricky/Left');
	
				frames = tex;
	
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
	
				quickAnimAdd('idle','Proper Left', 24,true);
	
				addOffset("idle", 516, 25);
	
				y -= 2000;
				x -= 1400;
					
				playAnim('idle');

				setGraphicSize(Std.int(width*2),Std.int(height*2));
				updateHitbox();
			case 'tord':
				tex = Paths.getSparrowAtlas('tord_assets','tord');
				frames = tex;
	
				trace("got texture");
				animation.addByPrefix('idle', "tord idle", 24, false);
				animation.addByPrefix('singUP', "tord up", 24, false);
				animation.addByPrefix('singDOWN', "tord down", 24, false);
				animation.addByPrefix('singLEFT', 'tord left', 24, false);
				animation.addByPrefix('singRIGHT', 'tord right', 24, false);
	
				trace("got anims");
				addOffset('idle');
				addOffset("singDOWN",-4,-21);
				addOffset("singRIGHT",-30,-13);
				addOffset("singUP",9,21);
				addOffset("singLEFT",20,-17);
	
				playAnim('idle');
			case 'tordbot':
				tex = Paths.getSparrowAtlas('tordbot_assets','tord');
				frames = tex;
				trace("got texture");
				animation.addByPrefix('idle', "tordbot idle", 24, false);
				animation.addByPrefix('singUP', "tordbot up", 24, false);
				animation.addByPrefix('singDOWN', "tordbot down", 24, false);
				animation.addByPrefix('singLEFT', 'tordbot left', 24, false);
				animation.addByPrefix('singRIGHT', 'tordbot right', 24, false);
	
				trace("got anims");
				addOffset('idle');
				addOffset("singRIGHT",-20,-20);
				addOffset("singDOWN",-10,-90);
				addOffset("singLEFT",-90);
				addOffset("singUP",-30,29);
	
				playAnim('idle');
			case 'agoti':
				tex = Paths.getSparrowAtlas('AGOTI', 'agoti');
				frames = tex;
				animation.addByPrefix('idle', 'Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24);
	
				addOffset('idle', 0, 140);
				addOffset("singUP", 90, 220);
				addOffset("singRIGHT", 130, 90);
				addOffset("singLEFT", 240, 170);
				addOffset("singDOWN", 70, -50);
	
				playAnim('idle');

			case 'agoti-crazy':
				tex = Paths.getSparrowAtlas('Alt_Agoti_Sprites_B', 'agoti');
				frames = tex;
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24);
		
				//Offsets source: https://github.com/TheZoroForce240/FNF-Absolute-Rage-Mod/blob/master/source/Character.hx
				addOffset('idle', 0, 100);
				addOffset("singUP", 60, 230);
				addOffset("singRIGHT", 90, 0);
				addOffset("singLEFT", 0, 130);
				addOffset("singDOWN", 30, 0);
		
				playAnim('idle');
	
			case 'agoti-micless':
				tex = Paths.getSparrowAtlas('Agoti_Micless', 'agoti');
				frames = tex;
				animation.addByPrefix('idle', 'Agoti_Idle', 24);
	
				addOffset('idle', 0, 140);
	
				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf')&&curCharacter!="signDeath")
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				if (curCharacter != 'trickyHLeft' && curCharacter != 'trickyHRight' && curCharacter != 'trickyHDown' && curCharacter != 'trickyHUp'){
					dance();
					holdTimer = 0;
				}
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			case 'exTricky':
				if (exSpikes.animation.frameIndex >= 3 && animation.curAnim.name == 'singUP')
				{
					trace('paused');
					exSpikes.animation.pause();
				}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf'|'gf-whitty'|'gf-arcade'|'gf-christmas'|'gf-car'|'gf-pixel'|'gf-hell'|'gf-tied'|'gf-rocks':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'mrgame':
					playAnim('danceRight');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if(otherFrames != null && PlayState.staticVar.dad != null)
			otherFramesAnim(AnimName,Force,Reversed,Frame);
		else
		{
			
			animation.play(AnimName, Force, Reversed, Frame);

			var daOffset = animOffsets.get(AnimName);
			if (animOffsets.exists(AnimName))
			{
				offset.set(daOffset[0], daOffset[1]);
			}
			else
				offset.set(0, 0);

			if (curCharacter == 'gf')
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
			if(curCharacter=="garcellodead"&&FlxG.save.data.graphicsQuality>1){
				garTrailTarget.offset.set(daOffset[0], daOffset[1]);
				garTrailTarget.animation.play(AnimName);
			}
			if(curCharacter=="exTricky"){
				if (AnimName == 'singUP')
					{
						trace('spikes');
						exSpikes.visible = true;
						if (exSpikes.animation.finished)
							exSpikes.animation.play('spike');
					}
					else if (!exSpikes.animation.finished)
					{
						exSpikes.animation.resume();
						trace('go back spikes');
						exSpikes.animation.finishCallback = function(pog:String) {
							trace('finished');
							exSpikes.visible = false;
							exSpikes.animation.finishCallback = null;
						}
					}
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
	public function addOtherFrames()
	{
		
		for (i in otherFrames)
		{
			PlayState.staticVar.add(i);
			i.visible = false;
		}
	}
	function otherFramesAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0) {
		if (PlayState.staticVar.generatedMusic)
		{
			visible = false;
			for(i in otherFrames)
			{
				i.visible = false;
				i.x = x;
				i.y = y + 60;
			}

			switch(AnimName)
			{
				case 'singLEFT':
					otherFrames[0].visible = true;
					otherFrames[0].playAnim('idle', Force, Reversed, Frame);
				case 'singRIGHT':
					otherFrames[1].visible = true;
					otherFrames[1].playAnim('idle', Force, Reversed, Frame);
				case 'singUP':
					otherFrames[2].visible = true;
					otherFrames[2].playAnim('idle', Force, Reversed, Frame);
					otherFrames[2].y += 20;
				case 'singDOWN':
					otherFrames[3].visible = true;
					otherFrames[3].playAnim('idle', Force, Reversed, Frame);
				default:
					visible = true;

					animation.play(AnimName, Force, Reversed, Frame);

					var daOffset = animOffsets.get(AnimName);
					if (animOffsets.exists(AnimName))
						offset.set(daOffset[0], daOffset[1]);
					else
						offset.set(0, 0);
			}
		}
		else
		{
			visible = true;
			animation.play('idle', Force, Reversed, Frame);
				
			var daOffset = animOffsets.get('idle');
			if (animOffsets.exists('idle'))
				offset.set(daOffset[0], daOffset[1]);
			else
				offset.set(0, 0);
		}
	}
	public function quickAnimAdd(name:String="",prefix:String="",fps:Int=24,looped:Bool=false) {
		animation.addByPrefix(name,prefix,fps,looped);
	}
}

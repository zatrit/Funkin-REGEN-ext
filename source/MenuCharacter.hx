package;

import flixel.FlxSprite;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	public var character:String;
	private var flipped:Bool = false;

	private static var settings:Map<String, CharacterSetting> = [
		'bf' => new CharacterSetting(0, -20, 1.0, true),
		'gf' => new CharacterSetting(50, 80, 1.5, true),
		#if !MOD_ONLY
		'dad' => new CharacterSetting(-15, 130),
		'spooky' => new CharacterSetting(20, 30),
		'pico' => new CharacterSetting(0, 0, 1.0, true),
		'mom' => new CharacterSetting(-30, 140, 0.85),
		'parents-christmas' => new CharacterSetting(100, 130, 1.8),
		'senpai' => new CharacterSetting(-40, -45, 1.4),
		#end
		'garcello' => new CharacterSetting(0,60, false),
		'whitty' => new CharacterSetting(-15,130, false),
		'kapi' => new CharacterSetting(0,-15),
		'mrgame' => new CharacterSetting(0,-15),
		'trickyMask' => new CharacterSetting(75,120, 1.6),
		'tord' => new CharacterSetting(0,160,false),
		'agoti' => new CharacterSetting(0, 150)
	];

	public function new(x:Float, y:Float, scale:Float, flipped:Bool)
	{
		super(x,y);

		this.flipped = flipped;

		antialiasing = true;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('bf', "BF idle dance white", 24);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('gf', "GF Dancing Beat WHITE", 24);
		animation.addByPrefix('dad', "Dad idle dance BLACK LINE", 24);
		animation.addByPrefix('spooky', "spooky dance idle BLACK LINES", 24);
		animation.addByPrefix('pico', "Pico Idle Dance", 24);
		animation.addByPrefix('mom', "Mom Idle BLACK LINES", 24);
		animation.addByPrefix('parents-christmas', "Parent Christmas Idle", 24);
		animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24);
		animation.addByPrefix('garcello', "garcello idle", 24);
		animation.addByPrefix('whitty', 'Whitty idle dance BLACK LINE', 24);
		animation.addByPrefix('kapi', 'Kapi idle dance BLACK LINE', 24);
		animation.addByPrefix('mrgame', 'mrgame idle dance BLACK LINE', 24);
		animation.addByPrefix('trickyMask', 'tricky week', 24);
		animation.addByPrefix('tord', 'Tord idle dance BLACK LINE', 24);
		animation.addByPrefix('agoti', 'Agoti idle dance BLACK LINE', 24);
		// Parent Christmas Idle
		
		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}
	public function setCharacter(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}
	
		animation.play(character);
	
		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;

	var weekColor:FlxColor;

	public function new(x:Float, y:Float, weekNum:Int = 0, color:FlxColor = 0xFF33ffff)
	{
		super(x, y);
		week = new FlxSprite();
		week.frames = Paths.getSparrowAtlas("storymenu");
		week.animation.addByPrefix("idle", weekNum + "week");
		week.animation.play("idle");
		week.updateHitbox();
		add(week);

		weekColor = color;
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		if (!FlxG.save.data.photo)
			isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			week.color = weekColor;
		else
			week.color = FlxColor.WHITE;
	}
}

package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class MobileControlsSubState extends MusicBeatSubstate
{
	#if mobile
	public var controlTypes:Array<String>=["Left buttons","Right buttons","Hitboxes","Hitboxes 2", "None"];
	public var buttonScales:Array<Float>=[1,0.9,0.8,0.7,0.6,0.5];
	public var leftArrow:FlxSprite;
	public var rightArrow:FlxSprite;
	#end
	public function new()
	{
		

		super();
	}
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		var touchLeft:Bool=false;
		var touchRight:Bool=false;
		
		#if mobile
		if(FlxG.touches.justReleased().length>0){
			touchLeft=FlxG.touches.getFirst().overlaps(leftArrow,camera);
			touchRight=FlxG.touches.getFirst().overlaps(rightArrow,camera);
		}
		#end
	}
	override function onBack() {
		FlxG.state.closeSubState();
		FlxG.state.openSubState(new OptionsSubState());
	}
}
package options;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;

class MobileControlsSubState extends MusicBeatSubstate
{
	public var controlTypes:Array<String>=["None","Arrows","Hitboxes A","Hitboxes B"];
	private var controlProfile:FlxSprite;

	public var buttonScales:Array<Float>=[1,0.9,0.8,0.7,0.6,0.5];
	public var leftArrow:FlxSprite;
	public var rightArrow:FlxSprite;
	public var curSelected:Int=1;


	public function new()
	{
		super();
	}
	override function create() {

		super.create();

		if(FlxG.save.data.mobileControlsType!=null)
			curSelected=FlxG.save.data.mobileControlsType;

		var mobile_profiles = Paths.getSparrowAtlas('mobileControlProfiles');
		
		controlProfile = new FlxSprite(80, 40);
		controlProfile.frames=mobile_profiles;
		for(profile in controlTypes){
			controlProfile.animation.addByPrefix(profile,profile);
		}
		controlProfile.animation.play(controlTypes[curSelected]);
		add(controlProfile);
		
		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		rightArrow = new FlxSprite(450,30);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.updateHitbox();

		leftArrow = new FlxSprite(30, 30);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.updateHitbox();

		add(leftArrow);
		add(rightArrow);
	}
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		var touchLeft:Bool=false;
		var touchRight:Bool=false;
		
		if(FlxG.touches.justReleased().length>0){
			touchLeft=FlxG.touches.getFirst().overlaps(leftArrow,camera);
			touchRight=FlxG.touches.getFirst().overlaps(rightArrow,camera);
		}

		if(touchLeft)
			changeSelected(-1);
		if(touchRight)
			changeSelected(1);

		if(touchLeft)
			leftArrow.animation.play("press");
		if(touchRight)
			rightArrow.animation.play("press");
		
		if(!touchLeft&&!touchRight){
			rightArrow.animation.play("idle");
			leftArrow.animation.play("idle");
		}
			
	}
	override function onBack() {
		FlxG.save.data.mobileControlsType=curSelected;
		FlxG.save.flush();

		FlxG.state.closeSubState();
		FlxG.state.openSubState(new OptionsSubState());
	}
	private function changeSelected(change:Int) {
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = controlTypes.length - 1;
		if (curSelected >= controlTypes.length)
			curSelected = 0;

		controlProfile.animation.play(controlTypes[curSelected]);

		// selector.y = (70 * curSelected) + 30;
	}
}
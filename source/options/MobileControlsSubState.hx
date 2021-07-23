#if mobile
package options;

import flixel.FlxG;
import flixel.FlxSprite;

class MobileControlsSubState extends OptionsSubState
{
	private var controlProfile:FlxSprite;

	// private var leftArrow:FlxSprite;
	// private var rightArrow:FlxSprite;

	public function new(parent:OptionsState)
	{
		super(parent, ["None", "Arrows", "Hitboxes A", "Hitboxes B"], true);
		curSelected = 1;
		changeSelection();
	}

	override function create()
	{
		super.create();

		if (FlxG.save.data.mobileControlsType != null)
			curSelected = FlxG.save.data.mobileControlsType;

		/*var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
			var mobile_profiles = Paths.getSparrowAtlas('mobileControlProfiles');
			controlProfile = new FlxSprite(80, 40);
			controlProfile.frames=mobile_profiles;

			for(profile in controlTypes){
				controlProfile.animation.addByPrefix(profile,profile);
			}

			controlProfile.animation.play(controlTypes[curSelected]);
			add(controlProfile);

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
			add(rightArrow); */
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		// controlProfileUpdate();
	}

	override function close()
	{
		FlxG.save.data.mobileControlsType = curSelected;
		super.close();
	}
	/*
		private function controlProfileUpdate(){
			var touchLeft:Bool=false;
			var touchRight:Bool=false;
			
			if(FlxG.touches.justReleased().length>0){
				touchLeft=FlxG.touches.getFirst().overlaps(leftArrow,camera);
				touchRight=FlxG.touches.getFirst().overlaps(rightArrow,camera);
			}

			if(touchLeft)
				controlProfileChangeSelection(-1);
			if(touchRight)
				controlProfileChangeSelection(1);

			if(touchLeft)
				leftArrow.animation.play("press");
			if(touchRight)
				rightArrow.animation.play("press");
			
			if(!touchLeft&&!touchRight){
				rightArrow.animation.play("idle");
				leftArrow.animation.play("idle");
			}
	}*/
}
#end

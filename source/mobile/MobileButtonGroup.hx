#if mobile
package mobile;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;

class MobileButtonGroup extends FlxTypedGroup<MobileButton>{

	public var leftArrow:MobileButton;
	public var rightArrow:MobileButton;
	public var upArrow:MobileButton;
	public var downArrow:MobileButton;

    public function new(camHUD:FlxCamera,x:Int,y:Int) {
        super();
		upArrow = new MobileButton(x+160, 
			y,
			"Up",false,()->{},
			()->{});
		upArrow.updateHitbox();
		upArrow.cameras = [camHUD];

		downArrow = new MobileButton(x+160, 
			y+210,
			"Down",false,()->{},
			()->{});
		downArrow.updateHitbox();
		downArrow.cameras = [camHUD];

		leftArrow = new MobileButton(x, 
			y+100,
			"Left",false,()->{},
			()->{});
		leftArrow.updateHitbox();
		leftArrow.cameras = [camHUD];

		rightArrow = new MobileButton(x+320, 
			y+100,
			"Right",false,()->{},
			()->{});
		rightArrow.updateHitbox();
		rightArrow.cameras = [camHUD];

		add(upArrow);
		add(downArrow);
		add(leftArrow);
		add(rightArrow);
    }
}
#end
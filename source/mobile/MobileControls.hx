#if mobile
package mobile;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MobileControls extends FlxTypedGroup<Control>{

	public var left:Control;
	public var right:Control;
	public var up:Control;
	public var down:Control;

	var x:Int;
	var y:Int;
	var camHUD:FlxCamera;

    public function new(camHUD:FlxCamera,x:Int,y:Int,layoutType:Int) {
        super();

		this.x=x;
		this.y=y;
		this.camHUD=camHUD;

		switch(layoutType){
			case 1:
				createArrows();
			case 2:
				createHitboxesA();
			case 3:
				createHitboxesB();
			default:
				left=new Control();
				right=new Control();
				up=new Control();
				down=new Control();
		}

		add(left);
		add(right);
		add(up);
		add(down);
    }
	public function createArrows(){
		var upArrow:MobileButton = new MobileButton(x+160, 
			y,
			"Up",false,()->{},
			()->{});
		upArrow.updateHitbox();
		upArrow.cameras = [camHUD];

		var downArrow:MobileButton = new MobileButton(x+160, 
			y+210,
			"Down",false,()->{},
			()->{});
		downArrow.updateHitbox();
		downArrow.cameras = [camHUD];

		var leftArrow:MobileButton = new MobileButton(x, 
			y+100,
			"Left",false,()->{},
			()->{});
		leftArrow.updateHitbox();
		leftArrow.cameras = [camHUD];

		var rightArrow:MobileButton = new MobileButton(x+320, 
			y+100,
			"Right",false,()->{},
			()->{});
		rightArrow.updateHitbox();
		rightArrow.cameras = [camHUD];

		this.left=leftArrow;
		this.right=rightArrow;
		this.up=upArrow;
		this.down=downArrow;
	}
	public function createHitboxesA(){
		final width=FlxG.width*0.25;
		var leftHitbox=new MobileHitbox(0,width,FlxColor.PURPLE);
		leftHitbox.cameras = [camHUD];
		var downHitbox=new MobileHitbox(FlxG.width*0.25,width,FlxColor.CYAN);
		downHitbox.cameras = [camHUD];
		var upHitbox=new MobileHitbox(FlxG.width*0.5,width,FlxColor.GREEN);
		upHitbox.cameras = [camHUD];
		var rightHitbox=new MobileHitbox(FlxG.width*0.75,width,FlxColor.RED);
		rightHitbox.cameras = [camHUD];

		this.left=leftHitbox;
		this.right=rightHitbox;
		this.up=upHitbox;
		this.down=downHitbox;
	}
	public function createHitboxesB(){
		var hitboxX = 50+(FlxG.width / 2);

		var width=Note.swagWidth;

		var leftHitbox=new MobileHitbox(hitboxX,width,FlxColor.PURPLE);
		leftHitbox.cameras = [camHUD];
		var downHitbox=new MobileHitbox(hitboxX+width,width,FlxColor.CYAN);
		downHitbox.cameras = [camHUD];
		var upHitbox=new MobileHitbox(hitboxX+width*2,width,FlxColor.GREEN);
		upHitbox.cameras = [camHUD];
		var rightHitbox=new MobileHitbox(hitboxX+width*3,width,FlxColor.RED);
		rightHitbox.cameras = [camHUD];

		this.left=leftHitbox;
		this.right=rightHitbox;
		this.up=upHitbox;
		this.down=downHitbox;

	}
}
#end
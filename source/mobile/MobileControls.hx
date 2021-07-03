#if mobile
package mobile;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class MobileControls extends FlxTypedGroup<FlxSprite>{

	public var left:Control;
	public var right:Control;
	public var up:Control;
	public var down:Control;

	public var pressable(get, set):Bool;

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
		final height=FlxG.height;

		var leftHitbox=new MobileHitbox(0,width*0.85,FlxColor.PURPLE);
		leftHitbox.cameras = [camHUD];

		var leftHitboxFlag:FlxSprite=new FlxSprite(0,height-5).makeGraphic(Std.int(width*0.85),5,FlxColor.PURPLE);
		leftHitboxFlag.cameras=[camHUD];
		add(leftHitboxFlag);

		var downHitbox=new MobileHitbox(FlxG.width*0.25-width*0.15,width*1.15,FlxColor.CYAN);
		downHitbox.cameras = [camHUD];

		var downHitboxFlag:FlxSprite=new FlxSprite(FlxG.width*0.25-width*0.15,height-5).makeGraphic(Std.int(width*1.15),5,FlxColor.CYAN);
		downHitboxFlag.cameras=[camHUD];
		add(downHitboxFlag);

		var upHitbox=new MobileHitbox(FlxG.width*0.5,width*1.15,FlxColor.LIME);
		upHitbox.cameras = [camHUD];

		var upHitboxFlag:FlxSprite=new FlxSprite(FlxG.width*0.5,height-5).makeGraphic(Std.int(width*1.15),5,FlxColor.LIME);
		upHitboxFlag.cameras=[camHUD];
		add(upHitboxFlag);

		var rightHitbox=new MobileHitbox(FlxG.width*0.75+width*0.15,width*0.85,FlxColor.RED);
		rightHitbox.cameras = [camHUD];

		var rightHitboxFlag:FlxSprite=new FlxSprite(FlxG.width*0.75+width*0.15,height-5).makeGraphic(Std.int(width*0.85),5,FlxColor.RED);
		rightHitboxFlag.cameras=[camHUD];
		add(rightHitboxFlag);

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
		var upHitbox=new MobileHitbox(hitboxX+width*2,width,FlxColor.LIME);
		upHitbox.cameras = [camHUD];
		var rightHitbox=new MobileHitbox(hitboxX+width*3,width,FlxColor.RED);
		rightHitbox.cameras = [camHUD];

		this.left=leftHitbox;
		this.right=rightHitbox;
		this.up=upHitbox;
		this.down=downHitbox;

	}

	public function set_pressable(val:Bool) : Bool {
		left.pressable=val;
		down.pressable=val;
		up.pressable=val;
		right.pressable=val;

		return this.pressable;
	}
	public function get_pressable() : Bool {
		return left.pressable&&down.pressable&&up.pressable&&right.pressable;
	}
}
#end
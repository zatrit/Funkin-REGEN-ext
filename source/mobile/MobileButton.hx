#if mobile
package mobile;

import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;

class MobileButton extends Control{
    var onPress:Void->Void;
    var onJustPress:Void->Void;
    public function new (x:Float=0,y:Float=0,direction:String="Up",alt:Bool=false,alpha:Float=1,onPress:Void->Void,onJustPress:Void->Void){
        this.alpha=alpha;

        super(x,y);

        this.visible=true;

		var mobile_tex:FlxAtlasFrames = Paths.getSparrowAtlas("mobileControls");

        var name:String=direction;
        
        if(alt)
            name+=" Alt";

		frames = mobile_tex;
		animation.addByPrefix('idle', name+" Idle");
		animation.addByPrefix('press', name+" Press");

        animation.play("idle");

        this.onPress=onPress;
        this.onJustPress=onJustPress;
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        this.pressed=false;
        this.justPressed=false;
        this.justReleased=true;
        
        if(pressable)
        for(touch in FlxG.touches.list)
        {
            var point:FlxPoint=touch.getScreenPosition(cameras[0]);
            if(overlapsPoint(point,true,cameras[0])){
                animation.play("press");
                this.pressed=true;
                this.justPressed=touch.justPressed||this.justPressed||!this.pressedBefore;
                this.justReleased=(touch.released&&this.justReleased);
            }
        }
        if(!pressed){
            animation.play("idle");
        }
        else
        onPress();
        if(justPressed)
            onJustPress();
        pressedBefore=pressed;
    }
}
#end
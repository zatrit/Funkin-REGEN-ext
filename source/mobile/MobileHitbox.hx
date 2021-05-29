#if mobile
package mobile;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class MobileHitbox extends Control{
    public function new(x:Float=0,width:Float=0,color:FlxColor=FlxColor.LIME,alpha:Float=0.15){
        this.alpha=alpha;

        super(x,0);

        this.visible=true;
        this.makeGraphic(Std.int(width),Std.int(FlxG.height),color);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        this.pressed=false;
        this.justPressed=false;
        this.justReleased=true;
        
        for(touch in FlxG.touches.list)
        {
            var point:FlxPoint=touch.getScreenPosition(cameras[0]);
            if(overlapsPoint(point,true,cameras[0])){
                this.alpha=0.25;
                this.pressed=true;
                this.justPressed=touch.justPressed||this.justPressed||!this.pressedBefore;
                this.justReleased=(touch.released&&this.justReleased);
            }
        }
        if(!pressed){
            this.alpha=0.1;
        }
        pressedBefore=pressed;
    }
}
#end
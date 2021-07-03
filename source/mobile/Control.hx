#if mobile
package mobile;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class Control extends FlxSprite{
    public var pressed:Bool=false;
    public var justPressed:Bool=false;
    public var justReleased:Bool=false;
    public var pressedBefore:Bool=false;

    public var pressable:Bool=true;

    public function new(x:Float=0,y:Float=0){
        super(x,y);

        this.visible=false;

        var a=this.alpha;
        this.alpha=0;
        FlxTween.tween(this,{alpha: a},0.25);
    }
}
#end
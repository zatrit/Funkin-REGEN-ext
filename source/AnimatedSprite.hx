package;

import flixel.FlxSprite;

class AnimatedSprite extends FlxSprite {
    public function new(sprite:String,x:Float=0,y:Float=0,scrollX:Float=1,scrollY:Float=1,?animations:Array<String>) {
        super(x,y);
        scrollFactor.set(scrollX,scrollY);
        this.frames=Paths.getSparrowAtlas(sprite);
        if(animations!=null)
            for(anim in animations){
                animation.addByPrefix(anim,anim);
            }
        else
            loadGraphic(Paths.image(sprite));

        animation.play(animations[0]);
    }
}
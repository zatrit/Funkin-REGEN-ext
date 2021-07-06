package options;

import flixel.FlxG;

class DefaultOptions{
    public static function setOptionsDefaults() {
        if(FlxG.save.data.scoreDisplay==null)
            FlxG.save.data.scoreDisplay=true;

        if(FlxG.save.data.healthDisplay==null)
            FlxG.save.data.healthDisplay=true;
        
        if(FlxG.save.data.accuracyDisplay==null)
            FlxG.save.data.accuracyDisplay=false;

        if(FlxG.save.data.graphicsQuality==null)
            FlxG.save.data.graphicsQuality=2;

        FlxG.save.flush();
    }
}
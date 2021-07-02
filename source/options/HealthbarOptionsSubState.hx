package options;

import flixel.FlxG;

class HealthbarOptionsSubState extends OptionsSubState {

    public function new(parent:OptionsState) {
        var items:Array<String> = [
            'display score: '+(FlxG.save.data.scoreDisplay ? 'on' : 'off'),
            'display health: '+(FlxG.save.data.healthDisplay ? 'on' : 'off'),
            'display accuracy: '+(FlxG.save.data.accuracyDisplay ? 'on' : 'off')];

        super(parent,items);
    }

    override function onSelect(value:String = "", number:Int = 0) {
        switch(value.toLowerCase()){                
			case 'display score: off' | 'display score: on':
				{
					var value:Bool=FlxG.save.data.scoreDisplay;
						
					FlxG.save.data.scoreDisplay=toggleOption(0,"display score: ",value);
					FlxG.save.flush();
				}  
			case 'display health: off' | 'display health: on':
				{
					var value:Bool=FlxG.save.data.healthDisplay;
						
					FlxG.save.data.healthDisplay=toggleOption(1,"display health: ",value);
					FlxG.save.flush();
				}
			case 'display accuracy: off' | 'display accuracy: on':
				{
					var value:Bool=FlxG.save.data.accuracyDisplay;
						
					FlxG.save.data.accuracyDisplay=toggleOption(2,"display accuracy: ",value);
					FlxG.save.flush();
				}
        }
    }
}
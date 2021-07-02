package options;

import flixel.FlxG;

class AppearanceOptionsSubState extends OptionsSubState {

	final SKIP_CUTSCENES_NUMBER = 2;
	final DOWNSCROLL_NUMBER = 3;

    public function new(parent:OptionsState) {
        var items:Array<String> = [
            'Menu background selector',
            'healthbar appearance',
            'skip cutscenes: '+(FlxG.save.data.skipCutscenes ? 'on' : 'off'),
            (FlxG.save.data.downscroll ? 'downscroll' : 'upscroll')];

        super(parent,items);
    }

    override function onSelect(value:String = "", number:Int = 0) {
        switch(value.toLowerCase()){
            case 'menu background selector':
            {
				FlxG.state.closeSubState();
				FlxG.state.openSubState(new MenuBGSelectorSubState(parent));
            }
            case 'healthbar appearance':
                {
                    FlxG.state.closeSubState();
                    FlxG.state.openSubState(new HealthbarOptionsSubState(parent));
                }
                
			case 'skip cutscenes: off' | 'skip cutscenes: on':
				{
					var skipCutscenes:Bool=FlxG.save.data.skipCutscenes;
						
					FlxG.save.data.skipCutscenes=toggleOption(SKIP_CUTSCENES_NUMBER,"skip cutscenes: ",skipCutscenes);
					FlxG.save.flush();
				}
            case 'downscroll' | 'upscroll':
                {
					var downscroll:Bool=FlxG.save.data.downscroll;
                    
					FlxG.save.data.downscroll=toggleOption(DOWNSCROLL_NUMBER,"",downscroll,'downscroll','upscroll');
					FlxG.save.flush();
                }
        }
    }
}
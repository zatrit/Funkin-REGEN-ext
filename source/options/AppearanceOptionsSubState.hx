package options;

import flixel.FlxG;

class AppearanceOptionsSubState extends OptionsSubState {

	final SKIP_CUTSCENES_NUMBER = 2;
	final DOWNSCROLL_NUMBER = 3;
	final BOT_ARROWS_ANIM_NUMBER = 4;

    final BOT_ARROWS_ANIM_VALUES:Array<String>=['advanced','optimized','none'];

    public function new(parent:OptionsState) {
        var items:Array<String> = [
            'Menu background selector',
            'healthbar appearance',
            'skip cutscenes: '+(FlxG.save.data.skipCutscenes ? 'on' : 'off'),
            (FlxG.save.data.downscroll ? 'downscroll' : 'upscroll'),
            "bot arrows anim: "+BOT_ARROWS_ANIM_VALUES[FlxG.save.data.botArrowsAnim],];

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
						
					FlxG.save.data.skipCutscenes=toggleBoolOption(SKIP_CUTSCENES_NUMBER,"skip cutscenes: ",skipCutscenes);
					FlxG.save.flush();
				}
            case 'downscroll' | 'upscroll':
                {
					var downscroll:Bool=FlxG.save.data.downscroll;
                    
					FlxG.save.data.downscroll=toggleBoolOption(DOWNSCROLL_NUMBER,"",downscroll,'downscroll','upscroll');
					FlxG.save.flush();
                }
            case 'bot arrows anim: default'|'bot arrows anim: advanced'|'bot arrows anim: none'|'bot arrows anim: null':
                {
					var botArrowsAnim:Int=FlxG.save.data.botArrowsAnim;
                    
					FlxG.save.data.botArrowsAnim=toggleIntOption(BOT_ARROWS_ANIM_NUMBER,"bot arrows anim: ",botArrowsAnim,BOT_ARROWS_ANIM_VALUES);
					FlxG.save.flush();
                }
        }
    }
}
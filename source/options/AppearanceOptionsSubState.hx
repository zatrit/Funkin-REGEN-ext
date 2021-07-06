package options;

import flixel.FlxG;

class AppearanceOptionsSubState extends OptionsSubState {

	final SKIP_CUTSCENES_NUMBER = 2;
	final DOWNSCROLL_NUMBER = 3;
	final BOT_ARROWS_ANIM_NUMBER = 4;
	final ANIM_EVENTS_NUMBER = 5;

    final BOT_ARROWS_ANIM_VALUES:Array<String>=['advanced','optimized','none'];

    public function new(parent:OptionsState) {
        var items:Array<String> = [
            'Menu background selector',
            'healthbar appearance',
            'skip cutscenes: '+(FlxG.save.data.skipCutscenes ? 'on' : 'off'),
            (FlxG.save.data.downscroll ? 'downscroll' : 'upscroll'),
            "arrows anim: "+BOT_ARROWS_ANIM_VALUES[FlxG.save.data.botArrowsAnim],
            "animated events: "+(FlxG.save.data.animEvents ? "on" : "off")
        ];

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
            case "arrows anim: advanced" | "arrows anim: none" | "arrows anim: optimized":
                {
					var botArrowsAnim:Int=FlxG.save.data.botArrowsAnim;
                    
					FlxG.save.data.botArrowsAnim=toggleIntOption(BOT_ARROWS_ANIM_NUMBER,"arrows anim: ",botArrowsAnim,BOT_ARROWS_ANIM_VALUES);
					FlxG.save.flush();
                }
            case 'animated events: on' | 'animated events: off':
                {
				    var animEvents:Bool=FlxG.save.data.animEvents;
                   
					FlxG.save.data.animEvents=toggleBoolOption(ANIM_EVENTS_NUMBER,"animated events: ",animEvents);
					FlxG.save.flush();
                }
        }
    }
}
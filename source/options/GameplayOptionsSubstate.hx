package options;

import flixel.FlxG;

class GameplayOptionsSubstate extends OptionsSubState {

	final KADE_INPUT_NUMBER = #if mobile 1 #else 0 #end;
	final GHOST_NUMBER = #if mobile 2 #else 1 #end;

    public function new(parent:OptionsState) {
        final items:Array<String>=[#if mobile 'Controls', #end 
        'kade input: '+(FlxG.save.data.kadeInput ? 'on' : 'off'),
        'ghost tap: '+(FlxG.save.data.ghost ? 'on' : 'off')];

        super(parent,items);
    }

    override function onSelect(value:String = "", number:Int = 0) {
        switch (value)
		{
			#if mobile
			case "Controls":
				FlxG.state.closeSubState();
				FlxG.state.openSubState(new MobileControlsSubState());
			#end
			case 'kade input: off' | 'kade input: on':
				{
					var kadeInput:Bool=FlxG.save.data.kadeInput;

                    FlxG.save.data.kadeInput=toggleOption(KADE_INPUT_NUMBER,"kade input: ",kadeInput);
					FlxG.save.flush();
				}
				
			case 'ghost tap: off' | 'ghost tap: on':
				{
					var ghost:Bool=FlxG.save.data.ghost;
		
					FlxG.save.data.ghost=toggleOption(GHOST_NUMBER,"ghost tap: ",ghost);
					FlxG.save.flush();
				}
		}
    }
}
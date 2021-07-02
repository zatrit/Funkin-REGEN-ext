package options;

import flixel.FlxG;

class MainOptionsSubState extends OptionsSubState {
    public function new(parent:OptionsState) {
        super(parent,['Appearance','Gameplay','About','Github repo']);
    }
    override function onSelect(value:String = "", number:Int = 0) {
        switch (value.toLowerCase()){
            case 'appearance':
				FlxG.state.closeSubState();
				FlxG.state.openSubState(new AppearanceOptionsSubState(parent));
            case 'gameplay':
				FlxG.state.closeSubState();
				FlxG.state.openSubState(new GameplayOptionsSubstate(parent));
			case 'about':
				FlxG.switchState(new AboutState());
            case 'github repo':
                FlxG.openURL("https://github.com/zatrit/Funkin-REGEN-ext");
        }
    }
    override function onBack() {
		parent.onBack();
    }
}
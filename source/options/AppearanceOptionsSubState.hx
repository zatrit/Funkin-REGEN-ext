package options;

import flixel.FlxG;

class AppearanceOptionsSubState extends OptionsSubState
{
	final DOWNSCROLL_NUMBER = 2;
	final BOT_ARROWS_ANIM_NUMBER = 3;
	final ARROWS_STYLE_NUMBER = 4;
	final ANIM_EVENTS_NUMBER = 5;
	final KADE_RATING_NUMBER = 6;

	final BOT_ARROWS_ANIM_VALUES:Array<String> = ['advanced', 'optimized', 'none'];
	final ARROWS_STYLES_VALUES:Array<String> = ['default', 'agoti', 'kapi'];

	public function new(parent:OptionsState)
	{
		var items:Array<String> = [
			'Menu background selector',
			'healthbar appearance',
			(FlxG.save.data.downscroll ? 'downscroll' : 'upscroll'),
			"arrows anim: " + BOT_ARROWS_ANIM_VALUES[FlxG.save.data.botArrowsAnim],
			"arrows style: " + ARROWS_STYLES_VALUES[FlxG.save.data.arrowsStyle],
			"animated events: " + (FlxG.save.data.animEvents ? "on" : "off"),
			"kade ratings: " + (FlxG.save.data.useKadeRatings ? "on" : "off")
		];

		super(parent, items, false, true);
	}

	override function onSelect(value:String = "", number:Int = 0)
	{
		switch (value.toLowerCase())
		{
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
			case 'downscroll' | 'upscroll':
				{
					var downscroll:Bool = FlxG.save.data.downscroll;

					FlxG.save.data.downscroll = toggleBoolOption(DOWNSCROLL_NUMBER, "", downscroll, 'downscroll', 'upscroll');
					FlxG.save.flush();
				}
			case "arrows anim: advanced" | "arrows anim: none" | "arrows anim: optimized":
				{
					var botArrowsAnim:Int = FlxG.save.data.botArrowsAnim;

					FlxG.save.data.botArrowsAnim = toggleIntOption(BOT_ARROWS_ANIM_NUMBER, "arrows anim: ", botArrowsAnim, BOT_ARROWS_ANIM_VALUES);
					FlxG.save.flush();
				}
			case "arrows style: default" | "arrows style: agoti" | "arrows style: kapi":
				{
					var arrowsStyle:Int = FlxG.save.data.arrowsStyle;

					FlxG.save.data.arrowsStyle = toggleIntOption(ARROWS_STYLE_NUMBER, "arrows style: ", arrowsStyle, ARROWS_STYLES_VALUES);
					FlxG.save.flush();
				}
			case 'animated events: on' | 'animated events: off':
				{
					var animEvents:Bool = FlxG.save.data.animEvents;

					FlxG.save.data.animEvents = toggleBoolOption(ANIM_EVENTS_NUMBER, "animated events: ", animEvents);
					FlxG.save.flush();
				}
			case 'kade ratings: on' | 'kade ratings: off':
				{
					var useKadeRatings:Bool = FlxG.save.data.useKadeRatings;

					FlxG.save.data.useKadeRatings = toggleBoolOption(KADE_RATING_NUMBER, "kade ratings: ", useKadeRatings);
					FlxG.save.flush();
				}
		}
	}
}

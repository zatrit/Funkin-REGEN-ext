package options;

import flixel.FlxG;

class AppearanceOptionsSubState extends OptionsSubState
{
	final DOWNSCROLL_NUMBER = 2;
	final BOT_ARROWS_ANIM_NUMBER = 3;
	final ARROWS_STYLE_NUMBER = 4;
	final ANIM_EVENTS_NUMBER = 5;
	final KADE_RATING_NUMBER = 6;
	final PHOTO_NUMBER = 7;
	final NOTE_SPLASHING_NUMBER = 8;

	final BOT_ARROWS_ANIM_VALUES:Array<String> = ['advanced', 'optimized', 'none'];
	final NOTE_STYLES_VALUES:Array<String> = ['default', 'kapi', 'agoti', 'genocide'];

	public function new(parent:OptionsState)
	{
		var items:Array<String> = [
			'Menu background selector',
			'healthbar appearance',
			(FlxG.save.data.downscroll ? 'downscroll' : 'upscroll'),
			"notes anim: " + BOT_ARROWS_ANIM_VALUES[FlxG.save.data.botArrowsAnim],
			"notes style: " + NOTE_STYLES_VALUES[FlxG.save.data.notes],
			"animated events: " + (FlxG.save.data.animEvents ? "on" : "off"),
			"kade ratings: " + (FlxG.save.data.useKadeRatings ? "on" : "off"),
			"photosens. mode: " + (FlxG.save.data.photo ? "on" : "off"),
			"note splashing: " + (FlxG.save.data.splashing ? "on" : "off")
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
				}
			case "notes anim: advanced" | "notes anim: none" | "notes anim: optimized":
				{
					var botArrowsAnim:Int = FlxG.save.data.botArrowsAnim;

					FlxG.save.data.botArrowsAnim = toggleArrayOption(BOT_ARROWS_ANIM_NUMBER, "notes anim: ", botArrowsAnim, BOT_ARROWS_ANIM_VALUES);
				}
			case "notes style: default" | "notes style: agoti" | "notes style: kapi" | "notes style: genocide":
				{
					var notes:Int = FlxG.save.data.notes;

					FlxG.save.data.notes = toggleArrayOption(ARROWS_STYLE_NUMBER, "notes style: ", notes, NOTE_STYLES_VALUES);
				}
			case 'animated events: on' | 'animated events: off':
				{
					var animEvents:Bool = FlxG.save.data.animEvents;

					FlxG.save.data.animEvents = toggleBoolOption(ANIM_EVENTS_NUMBER, "animated events: ", animEvents);
				}
			case 'photosens. mode: on' | 'photosens. mode: off':
				{
					var photo:Bool = FlxG.save.data.photo;

					FlxG.save.data.photo = toggleBoolOption(PHOTO_NUMBER, "photosens. mode: ", photo);
				}
			case 'note splashing: on' | 'note splashing: off':
				{
					var splashing:Bool = FlxG.save.data.splashing;
					FlxG.save.data.splashing = toggleBoolOption(NOTE_SPLASHING_NUMBER, "note splashing: ", splashing);
				}
		}
	}
}

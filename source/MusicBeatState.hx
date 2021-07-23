package;

import openfl.filters.ShaderFilter;
import tabi.ShadersHandler;
#if cpp
import cpp.vm.Gc;
#end
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	public var chromaticAberration(get, never):ShaderFilter;
	
	inline function get_chromaticAberration():ShaderFilter
		return ShadersHandler.chromaticAberration;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public var brightShader(get, never):ShaderFilter;
	
	inline function get_brightShader():ShaderFilter
		return ShadersHandler.brightShader;
		
	public function setBrightness(brightness:Float):Void
		ShadersHandler.setBrightness(brightness);
		
	public function setContrast(contrast:Float):Void
		ShadersHandler.setContrast(contrast);

	override function create()
	{
		#if cpp
		Gc.run(false);
		#end

		FlxG.watch.addQuick("curBeat",curBeat);
		FlxG.watch.addQuick("bpm",Conductor.bpm);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			onBack();

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}

	public function onBack():Void
	{
		FlxG.switchState(new MainMenuState());
	}

	override function finishTransOut()
	{
		super.finishTransOut();

		#if cpp
		Gc.run(true);
		#end
	}
	
	public function setChrome(daChrome:Float):Void
		ShadersHandler.setChrome(daChrome);
}

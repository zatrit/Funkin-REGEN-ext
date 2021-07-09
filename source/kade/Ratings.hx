package kade;

import flixel.FlxG;

class Ratings
{
	public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
	{
		var customTimeScale = Conductor.timeScale;

		if (customSafeZone != null)
			customTimeScale = customSafeZone / 166;

		// trace(customTimeScale + ' vs ' + Conductor.timeScale);

		// I HATE THIS IF CONDITION
		// IF LEMON SEES THIS I'M SORRY :(

		// trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

		// if (FlxG.save.data.botplay)
		//	return "sick"; // FUNNY

		var rating = checkRating(noteDiff, customTimeScale);

		return rating;
	}

	public static function checkRating(ms:Float, ts:Float)
	{
		var rating = "sick";
		if (ms <= 166 * ts && ms >= 135 * ts)
			rating = "shit";
		if (ms < 135 * ts && ms >= 90 * ts)
			rating = "bad";
		if (ms < 90 * ts && ms >= 45 * ts)
			rating = "good";
		if (ms < 45 * ts && ms >= -45 * ts)
			rating = "sick";
		if (ms > -90 * ts && ms <= -45 * ts)
			rating = "good";
		if (ms > -135 * ts && ms <= -90 * ts)
			rating = "bad";
		if (ms > -166 * ts && ms <= -135 * ts)
			rating = "shit";
		return rating;
	}

	public static function CalculateRanking(score:Int, health:Float, accuracy:Float):String
	{
		return ((FlxG.save.data.scoreDisplay ? 'Score: $score' : "") + // Score
			(FlxG.save.data.healthDisplay ? (" | Health: " + Std.int(health / 2 * 100) + "%") : "") + // Health
			(FlxG.save.data.accuracyDisplay ? " | Accuracy: "
				+ (accuracy == 0 ? "N/A" : Std.int(HelperFunctions.truncateFloat(accuracy, 2)) + " %") : "")); // Accuracy																	// 	Letter Rank
	}
}

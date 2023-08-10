import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
		if (FlxG.save.data.platformerUnlocked == null)
			FlxG.save.data.platformerUnlocked = false;

        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.dialogue == null)
			FlxG.save.data.dialogue = true;

		if (FlxG.save.data.cutscenes == null)
			FlxG.save.data.cutscenes = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;
		
		if (FlxG.save.data.itemBlock == null)
			FlxG.save.data.itemBlock = false;

		if (FlxG.save.data.beatGooey == null)
			FlxG.save.data.beatGooey = false;

		if (FlxG.save.data.beatFire == null)
			FlxG.save.data.beatFire = false;

		if (FlxG.save.data.beatSupermooshie == null)
			FlxG.save.data.beatSupermooshie == false;

		if (FlxG.save.data.beatGooeyWeek == null)
			FlxG.save.data.beatGooeyWeek == false;

		if (FlxG.save.data.beatSlimeWeek == null)
			FlxG.save.data.beatSlimeWeek == false;

		if (FlxG.save.data.beatMooWeek == null)
			FlxG.save.data.beatMooWeek == false;

		if (FlxG.save.data.beatStickoWeek == null)
			FlxG.save.data.beatStickoWeek == false;

		if (FlxG.save.data.beatRalphWeek == null)
			FlxG.save.data.beatRalphWeek = false;

		if (FlxG.save.data.beatRalphBoss == null)
			FlxG.save.data.beatRalphBoss = false;

		if (FlxG.save.data.beatSaWeek == null)
			FlxG.save.data.beatSaWeek = false;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}

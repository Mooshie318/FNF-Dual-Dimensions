package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class GameOverSubstate extends MusicBeatSubstate
{
	var retry:FlxSprite;
	var quit:FlxSprite;
	var retrySelected:Bool = false;

	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daSong = PlayState.SONG.song.toLowerCase();
		var daBf:String = '';
		/*switch (daStage)
		{
			default:
				daBf = 'bf';
		}*/
		switch(daSong)
		{
			case 'air-battle' | 'thunder-storm':
				daBf = 'bf-gf';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;
		
		retry = new FlxSprite(192, 180);
		retry.frames = Paths.getSparrowAtlas('dead/deadUI');
		retry.animation.addByPrefix('idle', 'retry idle', 0, false);
		retry.animation.addByPrefix('highlight', 'retry hightlight', 0, false); // typo lol
		retry.animation.addByPrefix('selected', 'retry selected', 24, false);
		retry.scrollFactor.set(0, 0);
		retry.animation.play('highlight');

		quit = new FlxSprite(1088, 180);
		quit.frames = Paths.getSparrowAtlas('dead/deadUI');
		quit.animation.addByPrefix('idle', 'quit idle', 0, false);
		quit.animation.addByPrefix('highlight', 'quit highlight', 0, false);
		quit.animation.addByPrefix('selected', 'quit selected', 24, false);
		quit.scrollFactor.set(0, 0);
		quit.animation.play('idle');

		bf = new Boyfriend(x, y, daBf);
		add(bf);
		add(retry);
		add(quit);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		trace("ded lol");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && retrySelected)
		{
			retry.animation.play('selected');

			endBullshit();
		}
		else if (controls.ACCEPT && !retrySelected)
		{
			quit.animation.play('selected');

			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
			changeThing();

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			retry.animation.play('selected');
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}

	function changeThing():Void
	{
		retrySelected = !retrySelected;

		if (retrySelected)
		{
			quit.animation.play('idle', true);
			retry.animation.play('highlight', true);
		}
		else
		{
			quit.animation.play('highlight', true);
			retry.animation.play('idle', true);
		}
	}
}
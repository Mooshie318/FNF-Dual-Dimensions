package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class BossGameOverSubstate extends MusicBeatSubstate
{
	var bf:FlxSprite;
	var retry:FlxSprite;
	var quit:FlxSprite;
	var retrySelected:Bool = true;

	var camFollow:FlxObject;
	var musicStarted:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		var bg:FlxSprite = new FlxSprite(-1000, -1000).makeGraphic(3000, 3000, FlxColor.BLACK);
		add(bg);

		retry = new FlxSprite(192, 180);
		retry.frames = Paths.getSparrowAtlas('dead/deadUI', 'shared');
		retry.animation.addByPrefix('idle', 'retry idle', 0, false);
		retry.animation.addByPrefix('highlight', 'retry hightlight', 0, false); // typo lol
		retry.animation.addByPrefix('selected', 'retry selected', 24, false);
		retry.scrollFactor.set(0, 0);
		retry.animation.play('highlight');

		quit = new FlxSprite(1088, 180);
		quit.frames = Paths.getSparrowAtlas('dead/deadUI', 'shared');
		quit.animation.addByPrefix('idle', 'quit idle', 0, false);
		quit.animation.addByPrefix('highlight', 'quit highlight', 0, false);
		quit.animation.addByPrefix('selected', 'quit selected', 24, false);
		quit.scrollFactor.set(0, 0);
		quit.animation.play('idle');

		bf = new FlxSprite(x, y);
		bf.frames = Paths.getSparrowAtlas('platformer/bf', 'shared');
		bf.animation.addByPrefix('ded', 'ded', 24, false);
		bf.antialiasing = true;
		bf.scrollFactor.set(1, 1);
		add(bf);
		add(retry);
		add(quit);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.animation.play('ded', true);
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
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
			changeThing();

		FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.finished)
		{
			if (!musicStarted)
			{
				FlxG.sound.playMusic(Paths.music('gameOverBoss', 'shared'));
				musicStarted = true;
			}
		}

		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.curFrame == 4)
			bf.alpha = 0.75;
		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.curFrame == 5)
			bf.alpha = 0.5;
		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.curFrame == 8)
			bf.alpha = 0.25;
		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.curFrame == 11)
			bf.alpha = 0.04;
		if (bf.animation.curAnim.name == 'ded' && bf.animation.curAnim.curFrame == 16)
			bf.alpha = 0;
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			retry.animation.play('selected');
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd', 'shared'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new BossState());
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
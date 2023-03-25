package;

import llua.Lua;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
#if windows
import Discord.DiscordClient;
#end

class FPSelectSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Back', 'All', 'Part 1', 'Part 2', 'Part 3'];
	var curSelected:Int = 0;

	public function new(x:Float, y:Float)
	{
		super();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
        else if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case 'Back':
                    FlxG.resetState();
				case 'All':
					FreeplayState.isP1 = false;
					FreeplayState.isP2 = false;
					FreeplayState.isP3 = false;
					FreeplayState.isP4 = false;
					FreeplayState.isP5 = false;
                    FlxG.switchState(new FreeplayState());
                case 'Part 1':
					FreeplayState.isP1 = true;
					FreeplayState.isP2 = false;
					FreeplayState.isP3 = false;
					FreeplayState.isP4 = false;
					FreeplayState.isP5 = false;
                    FlxG.switchState(new FreeplayState());
                case 'Part 2':
					FreeplayState.isP1 = false;
					FreeplayState.isP2 = true;
					FreeplayState.isP3 = false;
					FreeplayState.isP4 = false;
					FreeplayState.isP5 = false;
                    FlxG.switchState(new FreeplayState());
				case 'Part 3':
					FreeplayState.isP1 = false;
					FreeplayState.isP2 = false;
					FreeplayState.isP3 = true;
					FreeplayState.isP4 = false;
					FreeplayState.isP5 = false;
					FlxG.switchState(new FreeplayState());
			}
		}
	}

	override function destroy()
	{
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
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

class AchievementsState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	// name, description
	var challenges:Array<Dynamic> = [
		['View achievements',						'View achievements on Gamejolt'],
        ['Secret', 									'Find and beat one of the secret songs'],
		['Secret 2', 								'Find and beat one of the secret songs'],
		['References', 								'Correctly guess all FNM references'],
		['Keeping it 100', 							"FC a song with all sicks (MFC) (can't be tutorial)"],
		['Freezeless run', 							'Beat a song without freezing'],
		['Is it cold in here? Or is it just me?', 	"Freeze for the maximum time (3 seconds) and survive all while it's your turn"],
		['Lucky', 'Get the luckiest item on the item block'],
		['Unlucky', 'Get the unluckiest item on the item block'],
		['Battle master', 'Beat all battle songs']
    ];

	var descText:FlxText;
	var curSelected:Int = 0;

	override function create()
	{
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

        grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...challenges.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, challenges[i][0], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();

        super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accept = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
        else if (downP)
		{
			changeSelection(1);
		}
		else if (accept)
		{
			if (curSelected == 0)
				FlxG.openURL('https://gamejolt.com/games/FNM/671133/trophies');
		}
		else if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new ExtrasState());
		}
	}

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = challenges.length - 1;
        if (curSelected >= challenges.length)
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
		descText.text = challenges[curSelected][1];
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    }
}
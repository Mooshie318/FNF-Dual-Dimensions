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

class MinigameState extends MusicBeatState
{
    public static var isB:Bool = false;
    public static var isC:Bool = false;

    var b1Unlocked:Bool = FlxG.save.data.beatGooeyWeek;
    var b2Unlocked:Bool = FlxG.save.data.beatSlimeWeek;
    var b3Unlocked:Bool = FlxG.save.data.beatMooWeek;
    var b4Unlocked:Bool = FlxG.save.data.beatRalphWeek;

    var ch1Unlocked:Bool = false;

    var boss:Array<String> = [
        'b1',
        'b2',
        'b3',
        'b4'
    ];

    var challenge:Array<String> = [
        'ch1'
    ];

	var curSelected:Int = 0;
    var image:FlxSprite;
    var lArrow:FlxSprite;
    var rArrow:FlxSprite;

	override function create()
	{
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFF808080;
        bg.screenCenter();
		add(bg);

        lArrow = new FlxSprite(FlxG.width / 4 - 90.35, 0).loadGraphic(Paths.image('minigames/arrow L'));
        lArrow.screenCenter(Y);
		add(lArrow);

        rArrow = new FlxSprite(FlxG.width / 2 + FlxG.width / 4, 0).loadGraphic(Paths.image('minigames/arrow R'));
        rArrow.screenCenter(Y);
		add(rArrow);

        updateImage();
		changeSelection();

        super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accept = controls.ACCEPT;

        if (FlxG.save.data.beatMooWeek && FlxG.save.data.beatStickoWeek)
            ch1Unlocked = true;
        else
            ch1Unlocked = false;
		if (leftP)
		{
			changeSelection(-1);
		}
        else if (rightP)
		{
			changeSelection(1);
		}
		else if (accept)
		{
            if (isB)
            {
                PlayState.isStoryMode = true;
			    PlayState.storyDifficulty = 2;

			    switch (curSelected)
                {
                    case 0:
                        PlayState.SONG = Song.loadFromJson('gooey-battle-hard', 'gooey-battle');
                        if (b1Unlocked)
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                    case 1:
                        PlayState.SONG = Song.loadFromJson('fire-battle-hard', 'fire-battle');
                        if (b2Unlocked)
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                    case 2:
                        PlayState.SONG = Song.loadFromJson('moo-battle-hard', 'moo-battle');
                        if (b3Unlocked)
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                    case 3:
                        if (b4Unlocked)
                            FlxG.switchState(new BossState());
                }
            }
            if (isC)
            {
                switch (curSelected)
                {
                    case 0:
                        PlayState.isStoryMode = true;
                        PlayState.storyDifficulty = 2;
                        PlayState.SONG = Song.loadFromJson('hit-and-miss-hard', 'hit-and-miss');
                        if (ch1Unlocked)
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                }
            }
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
        {
            if (isB)
                curSelected = boss.length - 1;
            else if (isC)
                curSelected = challenge.length - 1;
        }
        if ((isB && curSelected >= boss.length) || (isC && curSelected >= challenge.length))
        {
            curSelected = 0;
        }

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        updateImage();
    }

    function updateImage():Void
    {
        if (isB)
        {
            remove(image);
            switch (curSelected)
            {
                case 0:
                    if (!b1Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected]));
                case 1:
                    if (!b2Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected]));
                case 2:
                    if (!b3Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected]));
                case 3:
                    if (!b4Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected]));
            }
            image.screenCenter();
            add(image);
        }
        else if (isC)
        {
            remove(image);
            switch (curSelected)
            {
                case 0:
                    if (!ch1Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/challenge/' + challenge[curSelected]));
            }
            image = new FlxSprite().loadGraphic(Paths.image('minigames/challenge/' + challenge[curSelected]));
            image.screenCenter();
            add(image);
        }
    }
}
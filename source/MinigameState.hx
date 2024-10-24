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

    var b1Unlocked:Bool = FlxG.save.data.beatGooeyWeek; // Gooey-Battle
    var b2Unlocked:Bool = FlxG.save.data.beatSlimeWeek; // Fire-Battle
    var b3Unlocked:Bool = FlxG.save.data.beatMooWeek;   // Moo-Battle
    var b4Unlocked:Bool = FlxG.save.data.beatRalphWeek; // Ralph boss

    var ch1Unlocked:Bool = (FlxG.save.data.beatMooWeek && FlxG.save.data.beatStickoWeek); // Hit-or-Miss
    var ch2Unlocked:Bool = (FlxG.save.data.beatSaWeek); // Dark-Purple

    var boss:Array<Dynamic> = [
        ['b1', 'Beat 1-7'],
        ['b2', 'Beat 1-1'],
        ['b3', 'Beat 1-8'],
        ['b4', 'Beat 3-1']
    ];

    var challenge:Array<Dynamic> = [
        ['ch1', 'Beat 1-8 and 2-1'],
        ['ch2', '(WILL CHANGE LATER) Beat 2-2']
    ];

	var curSelected:Int = 0;
    var image:FlxSprite;
    var lArrow:FlxSprite;
    var rArrow:FlxSprite;

    var descText:FlxText;

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

		changeSelection();

        var altTxt:FlxText = new FlxText(FlxG.width - 206, FlxG.height - 24, 0, "ALT + R to reset music", 12);
		altTxt.scrollFactor.set();
		altTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(altTxt);

        // Dynamic(?) menu music
        TitleState.piano.fadeOut(0.5, 0);
		TitleState.synth.fadeOut(0.5, 0);
		TitleState.guitar.fadeIn(0.5, TitleState.guitar.volume, 0.7);
		TitleState.bass.fadeOut(0.5, 0);

        super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if (FlxG.keys.pressed.ALT)
        {
            if (FlxG.keys.justPressed.R)
            {
                TitleState.piano.time = FlxG.sound.music.time;
                TitleState.synth.time = FlxG.sound.music.time;
                TitleState.guitar.time = FlxG.sound.music.time;
                TitleState.bass.time = FlxG.sound.music.time;
            }
        }

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accept = controls.ACCEPT;

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
                        {
                            LoadingState.loadAndSwitchState(new PlayState(), true);

                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
                    case 1:
                        PlayState.SONG = Song.loadFromJson('fire-battle-hard', 'fire-battle');
                        if (b2Unlocked)
                        {
                            LoadingState.loadAndSwitchState(new PlayState(), true);

                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
                    case 2:
                        PlayState.SONG = Song.loadFromJson('moo-battle-hard', 'moo-battle');
                        if (b3Unlocked)
                        {
                            LoadingState.loadAndSwitchState(new PlayState(), true);

                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
                    case 3:
                        if (b4Unlocked)
                        {
                            FlxG.switchState(new BossState());

                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
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
                        {
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
                    case 1:
                        PlayState.isStoryMode = true;
                        PlayState.storyDifficulty = 1;
                        PlayState.SONG = Song.loadFromJson('dark-purple-hard', 'dark-purple');
                        if (ch2Unlocked)
                        {
                            LoadingState.loadAndSwitchState(new PlayState(), true);
                            // Dynamic(?) menu music
                            TitleState.piano.fadeOut(0.5, 0);
                            TitleState.synth.fadeOut(0.5, 0);
                            TitleState.guitar.fadeOut(0.5, 0);
                            TitleState.bass.fadeOut(0.5, 0);
                        }
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
        updateText();
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
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected][0]));
                case 1:
                    if (!b2Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected][0]));
                case 2:
                    if (!b3Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected][0]));
                case 3:
                    if (!b4Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/boss/' + boss[curSelected][0]));
            }
            image.screenCenter();
            add(image);
        }
        if (isC)
        {
            remove(image);
            switch (curSelected)
            {
                case 0:
                    if (!ch1Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/challenge/' + challenge[curSelected][0]));
                case 1:
                    if (!ch2Unlocked)
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/locked'));
                    else
                        image = new FlxSprite().loadGraphic(Paths.image('minigames/challenge/' + challenge[curSelected][0]));
            }
            image.screenCenter();
            add(image);
        }
    }

    function updateText():Void
    {
        remove(descText);

        if (isB)
            descText = new FlxText(150, 650, 980, boss[curSelected][1], 32);
        if (isC)
            descText = new FlxText(150, 650, 980, challenge[curSelected][1], 32);

        descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descText.scrollFactor.set();
        descText.borderSize = 2.4;
        add(descText);
    }
}
package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxTimer;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ExtrasState extends MusicBeatState
{
    var text:FlxText;
    var guessButton:FlxUIButton;
    var platformerButton:FlxUIButton;
    var achievementsButton:FlxUIButton;
    var mgButton:FlxUIButton;

	override function create()
	{
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the extras menu", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

        persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
        bg.color = 0xFF009F00;
		add(bg);

        addUI();

		super.create();
	}

    function addUI():Void
    {
        text = new FlxText(590, 30, 0);
        text.text = "Extras";
        text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        // guessButton = new FlxUIButton(250, 300, 'Guess the code', sendToGuess);
        guessButton = new FlxUIButton(565, 300, 'Guess the code', sendToGuess);
        guessButton.resize(150, 75);
        guessButton.setLabelFormat(null, 12, FlxColor.BLACK);

        achievementsButton = new FlxUIButton(565, 105, 'Achievements', sendToAchievements);
        achievementsButton.resize(150, 75);
        achievementsButton.setLabelFormat(null, 12, FlxColor.BLACK);

        mgButton = new FlxUIButton(565, 500, 'Minigames', sendToMinigames);
        mgButton.resize(150, 75);
        mgButton.setLabelFormat(null, 12, FlxColor.BLACK);

        //platformerButton = new FlxUIButton(565, 500, 'Platformer mode', sendToPlatformer);
        //platformerButton.resize(150, 75);
        //platformerButton.setLabelFormat(null, 12, FlxColor.BLACK);

        add(text);
        add(guessButton);
        add(achievementsButton);
        add(mgButton);

        //if (FlxG.save.data.platformerUnlocked)
        //    add(platformerButton);
    }

	override function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
        }

        // if (FlxG.keys.justPressed.G)
        // {
        //     var right:FNMNotification = new FNMNotification(1, "Song unlocked!", "Check minigames");
        //     add(right);

        //     var left:FNMNotification = new FNMNotification(2, "New achievement!", "Ralph");
        //     add(left);
        // }

        FlxG.mouse.visible = true;

		super.update(elapsed);
	}

    function sendToGuess():Void
    {
        FlxG.switchState(new GuessState());
    }

    function sendToRG():Void
    {
        FlxG.switchState(new ReferenceGuessState());
    }

    function sendToAchievements():Void
    {
        FlxG.switchState(new AchievementsState());
    }

    function sendToMinigames():Void
    {
        openSubState(new MGSelectSubState(0,0));
    }

    function sendToPlatformer():Void
    {
        trace('if only');
    }
}
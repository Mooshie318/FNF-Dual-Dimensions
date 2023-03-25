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

class GuessState extends MusicBeatState
{
    var guessButton:FlxUIButton;
    var hintButton:FlxUIButton;
    var hintButton2:FlxUIButton;

    var uiTxt:FlxText;
    var uiHintTxt:FlxText;
    var uiHintTxt2:FlxText;
    var uiTxt2:FlxText;
    var codeBox:FlxUIInputText;
    var show:String = '';
    var char:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Guessing the code", null);
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
        bg.color = 0xFF0056A1;
		add(bg);

        addUI();
        addChar();

		super.create();
	}

	function addUI():Void
    {
        uiTxt = new FlxText(10, 30, 0);
        uiTxt.text = "Guess the code";
        uiTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
        uiTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        uiTxt2 = new FlxText(10, 100, 0);
        uiTxt2.text = "The code is 7 numbers long";
        uiTxt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
        uiTxt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        uiTxt2 = new FlxText(10, 100, 0);
        uiTxt2.text = "The code is 7 numbers long";
        uiTxt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
        uiTxt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        uiHintTxt = new FlxText(10, 150, 0);
        uiHintTxt.text = "Get lucky with the intro text";
        uiHintTxt.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
        uiHintTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        uiHintTxt.visible = false;

        uiHintTxt2 = new FlxText(10, 200, 0);
        uiHintTxt2.text = "0 1 2 3 3 7 9 (The code numbers (not in order))";
        uiHintTxt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
        uiHintTxt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        uiHintTxt2.visible = false;

        codeBox = new FlxUIInputText(10, 250, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);

        guessButton = new FlxUIButton(10, 325, 'Enter Guess', checkGuess);
        guessButton.resize(100, 50);
        guessButton.setLabelFormat(null, 12, FlxColor.BLACK);

        hintButton = new FlxUIButton(120, 325, 'Give Hint', giveHint);
        hintButton.resize(100, 50);
        hintButton.setLabelFormat(null, 12, FlxColor.BLACK);

        hintButton2 = new FlxUIButton(120, 325, 'Give Another Hint', giveHint2);
        hintButton2.resize(150, 50);
        hintButton2.setLabelFormat(null, 12, FlxColor.BLACK);

        add(uiTxt);
        add(uiTxt2);
        add(uiHintTxt);
        add(uiHintTxt2);
        add(codeBox);
        add(guessButton);
        add(hintButton);
    }

    function addChar():Void
    {
        var random = FlxG.random.float(0, 93.75);

        char = new FlxSprite(700, 200);

        if (random >= 0 && random <= 6.25)
            show = 'bf';
        if (random >= 6.26 && random <= 12.50)
            show = 'bf-neon';
        if (random >= 12.51 && random <= 18.75)
            show = 'slime';
        if (random >= 18.76 && random <= 25)
            show = 'james';
        if (random >= 25.01 && random <= 31.25)
            show = 'ghost';
        if (random >= 31.26 && random <= 37.50)
            show = 'sheary';
        if (random >= 37.51 && random <= 43.75)
            show = 'madcloud';
        if (random >= 43.76 && random <= 50)
            show = 'cluckington';
        if (random >= 50.01 && random <= 56.25)
            show = 'clooshie';
        if (random >= 56.26 && random <= 62.50)
            show = 'trooper';
        if (random >= 62.51 && random <= 68.75)
            show = 'gooey';
        if (random >= 68.76 && random <= 75)
            show = 'gooey-squished';
        if (random >= 75.01 && random <= 81.25)
            show = 'mooshie';
        if (random >= 81.26 && random <= 87.50)
            show = 'supermooshie';
        if (random >= 87.51 && random <= 93.75)
            show = 'supermooshie-mad';

        switch (show)
        {
            case 'bf':
                char.frames = Paths.getSparrowAtlas('BOYFRIEND', 'shared');
				char.animation.addByPrefix('idle','BF idle dance', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'bf-neon':
                char.frames = Paths.getSparrowAtlas('BF_assets_2', 'shared');
				char.animation.addByPrefix('idle','BF idle dance', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'slime':
                char.frames = Paths.getSparrowAtlas('slime_crew', 'shared');
				char.animation.addByPrefix('idle','slime idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
                char.y -= 100;
            case 'james':
                char.frames = Paths.getSparrowAtlas('james', 'week2');
				char.animation.addByPrefix('idle','James idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'ghost':
                char.frames = Paths.getSparrowAtlas('ghost-with-a-fucking-gun', 'week3');
				char.animation.addByPrefix('idle','ghost idle', 24);
				char.setGraphicSize(Std.int(char.width * 2.2));
            case 'sheary':
                char.frames = Paths.getSparrowAtlas('sheary', 'week4');
				char.animation.addByPrefix('idle','idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
                char.x -= 100;
            case 'madcloud':
                char.frames = Paths.getSparrowAtlas('madCloud', 'week4');
				char.animation.addByPrefix('idle','c idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
                char.x -= 300;
            case 'cluckington':
                char.frames = Paths.getSparrowAtlas('cluck/cluckington', 'week5');
				char.animation.addByPrefix('idle','idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'clooshie':
                char.frames = Paths.getSparrowAtlas('cluck/clooshie', 'week5');
				char.animation.addByPrefix('idle','idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'trooper':
                char.frames = Paths.getSparrowAtlas('trooper/trooper', 'week6');
				char.animation.addByPrefix('idle','idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
            case 'gooey':
                char.frames = Paths.getSparrowAtlas('airship/gooey', 'shared');
				char.animation.addByPrefix('idle','gooey idle', 24);
				char.setGraphicSize(Std.int(char.width * 0.6));
                char.y -= 350;
            case 'gooey-squished':
                char.frames = Paths.getSparrowAtlas('airship/squished-Gooey', 'shared');
				char.animation.addByPrefix('idle','idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
                char.y += 200;
            case 'mooshie':
                char.frames = Paths.getSparrowAtlas('mooshie/Mooshie_assets', 'shared');
				char.animation.addByPrefix('idle','Mooshie idle', 24);
				char.y -= 100;
            case 'supermooshie':
                char.frames = Paths.getSparrowAtlas('supermooshie', 'shared');
				char.animation.addByPrefix('idle','supermooshie idle', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
                char.x -= 100;
                char.y -= 100;
            case 'supermooshie-mad':
                char.frames = Paths.getSparrowAtlas('supermooshie-mad', 'shared');
				char.animation.addByPrefix('idle','supermooshie idle mad', 24);
				char.setGraphicSize(Std.int(char.width * 1.2));
        }
        char.antialiasing = true;
        char.animation.play('idle');
        add(char);
    }

	override function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new ExtrasState());
        }

        FlxG.mouse.visible = true;

		super.update(elapsed);
	}

    override function beatHit() 
    {
        super.beatHit();
        char.animation.play('idle');
    }

    function checkGuess():Void
    {
        if (codeBox.text == '7391203')
        {
            PlayState.isStoryMode = true;

            PlayState.storyDifficulty = 1;

            PlayState.SONG = Song.loadFromJson('7391203', '7391203');

            LoadingState.loadAndSwitchState(new PlayState(), true);
        }
    }

    function giveHint():Void
    {
        uiHintTxt.visible = true;

        remove(hintButton);
        add(hintButton2);
    }

    function giveHint2():Void
    {
        uiHintTxt2.visible = true;
        remove(hintButton2);
    }
}
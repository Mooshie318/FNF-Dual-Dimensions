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

import GameJolt.GameJoltLogin; // Gamejolt

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";
	public static var fnmVer:String = "1.4.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var extrasButton:FlxUIButton;
	var gjButton:FlxUIButton;

	var bg:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			// FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.sound.playMusic(Paths.music('menu drums'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(40, 130 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.x -= 500;
			menuItem.alpha = 0;

			FlxTween.tween(menuItem, {alpha: 1, x: menuItem.x + 500}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 24, 0, "FNF " + gameVer + "," + " KE " + kadeEngineVer + "," + " FNM " + fnmVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var altTxt:FlxText = new FlxText(FlxG.width - 206, FlxG.height - 24, 0, "ALT + R to reset music", 12);
		altTxt.scrollFactor.set();
		altTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(altTxt);

		changeItem();

		extrasButton = new FlxUIButton(1200, 10, "Extras", sendToExtras);
		extrasButton.resize(100, 50);
		extrasButton.setLabelFormat(null, 12, FlxColor.BLACK);

		gjButton = new FlxUIButton(1080, 10, "Login to\nGameJolt", sendToGJLogin);
		gjButton.resize(100, 50);
		gjButton.setLabelFormat(null, 12, FlxColor.BLACK);

		add(extrasButton);
		add(gjButton);

		// Dynamic(?) menu music
		TitleState.piano.fadeIn(0.5, TitleState.piano.volume, 0.7);
		TitleState.synth.fadeIn(0.5, TitleState.synth.volume, 0.7);
		TitleState.guitar.fadeOut(0.5, 0);
		TitleState.bass.fadeOut(0.5, 0);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

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

		FlxG.mouse.visible = true;

		if (FlxG.mouse.justPressed && FlxG.mouse.screenX <= 30 && FlxG.mouse.screenY <= 30)
		{
			// Dynamic(?) menu music
			TitleState.piano.fadeOut(0.5, 0);
			TitleState.synth.fadeOut(0.5, 0);
			TitleState.guitar.fadeOut(0.5, 0);
			TitleState.bass.fadeOut(0.5, 0);

			PlayState.isStoryMode = true;
			PlayState.storyDifficulty = 2;
			PlayState.SONG = Song.loadFromJson('boyfriend-hard', 'boyfriend');
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										// FlxG.switchState(new StoryMenuState());
										FlxG.switchState(new FNMStoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										openSubState(new FPSelectSubState(bg.getGraphicMidpoint().x, bg.getGraphicMidpoint().y));
										trace("Freeplay Menu Selected");
									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	function sendToExtras():Void
	{
		FlxG.switchState(new ExtrasState());
	}

	function sendToGJLogin():Void
	{
		FlxG.switchState(new GameJoltLogin());
	}
}

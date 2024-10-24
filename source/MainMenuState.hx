package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
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
	public static var fnmVer:String = "1.4.2";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var extrasButton:FlxUIButton;
	var gjButton:FlxUIButton;

	// DEBUG
	var songButton:FlxUIButton; // Go to sendToSong() to change the song

	var bg:FlxSprite;

	private var camHUD:FlxCamera;
	private var camTOP:FlxCamera;

	// FNM Notifications + save data (Check KadeEngineData.hx)
	var achievements:Array<String> = [
		"Secret",
		"Secret 2",
		"Dual dimensions",
		"Keeping it 100",
		"Freezeless run",
		"Is it cold in here?",
		"Battle master",
		"Hit or Miss",
		"Ralph"
	];

	// 1 = Boss minigames
	// 2 = Challenge minigames
	var unlockables:Array<String> = [
		"Gooey-Battle",
		"Fire-Battle",
		"Moo-Battle",
		"Ralph boss",
		"Hit-or-Miss",
		"Dark-Purple"
	];
	var places:Array<Int> = [
		1,
		1,
		1,
		1,
		2,
		2
	];

	var notifYMod:Float = 0;  // If more than 1 notif is on screen on the left side
	var notifYMod2:Float = 0; // If more than 1 notif is on screen on the right side

	override function create()
	{
		TitleState.piano.time = FlxG.sound.music.time;
		TitleState.synth.time = FlxG.sound.music.time;
		TitleState.guitar.time = FlxG.sound.music.time;
		TitleState.bass.time = FlxG.sound.music.time;

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

		songButton = new FlxUIButton(590, 10, "Test\nsong", sendToSong);
		songButton.resize(100, 50);
		songButton.setLabelFormat(null, 12, FlxColor.BLACK);
		#if debug
		add(songButton);
		#end

		// Dynamic(?) menu music
		TitleState.piano.fadeIn(0.5, TitleState.piano.volume, 0.7);
		TitleState.synth.fadeIn(0.5, TitleState.synth.volume, 0.7);
		TitleState.guitar.fadeOut(0.5, 0);
		TitleState.bass.fadeOut(0.5, 0);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camTOP = new FlxCamera();
		camTOP.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTOP);

		FlxCamera.defaultCameras = [camHUD];

		// Notifications
		for (i in 0...FlxG.save.data.achievementsToBeEarned.length)
		{
			if (FlxG.save.data.achievementsToBeEarned.length == 0 || i == FlxG.save.data.achievementsToBeEarned.length)
				break;

			for (j in achievements)
			{
				if (FlxG.save.data.achievementsToBeEarned[i] == j)
				{
					earnAchievement(j, notifYMod);
					FlxG.save.data.achievementsToBeEarned.splice(FlxG.save.data.achievementsToBeEarned.indexOf(j), 1); // Removes j from achievementsToBeEarned

					notifYMod += 80; // So that no notifications overlap each other
				}
			}
		}

		for (i in 0...FlxG.save.data.songsToBeUnlocked.length)
		{
			if (FlxG.save.data.songsToBeUnlocked.length == 0)
				break;

			var pNum:Int = -1;

			for (j in unlockables)
			{
				pNum += 1;

				if (FlxG.save.data.songsToBeUnlocked[i] == j)
				{
					trace("OOH IT EQUALS THE THING!!!!!");
					switch(places[pNum])
					{
						case 1:
							trace("OOH BOSS BOSS BOSS BOSS");
							unlockSong(FlxG.save.data.songsToBeUnlocked[i], "Check the boss minigames", notifYMod2);
						case 2:
							trace("OOH CHALLENGE CHALLENGE CHALLENGE CHALLENGE");
							unlockSong(FlxG.save.data.songsToBeUnlocked[i], "Check the challenge minigames", notifYMod2);
					}

					FlxG.save.data.songsToBeUnlocked.splice(FlxG.save.data.songsToBeUnlocked.indexOf(j), 1); // Removes j from songsToBeUnlocked

					notifYMod2 += 80; // So that no notifications overlap each other
				}
			}
		}

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

	function sendToSong():Void
	{
		var song:String   = "red";
		var suffix:String = "-hard";

		// Dynamic(?) menu music
		TitleState.piano.fadeOut(0.5, 0);
		TitleState.synth.fadeOut(0.5, 0);
		TitleState.guitar.fadeOut(0.5, 0);
		TitleState.bass.fadeOut(0.5, 0);

		PlayState.isStoryMode = false;
		if (suffix == "-hard") PlayState.storyDifficulty = 2;
		else PlayState.storyDifficulty = 1;
		PlayState.SONG = Song.loadFromJson(song + suffix, song);
		LoadingState.loadAndSwitchState(new PlayState(), true);
	}

	function earnAchievement(a:String, ymod:Float):Void
	{
		FlxG.sound.play(Paths.sound('notification'));

		var n:FNMNotification = new FNMNotification(2, "New achievement!", a);
		n.cameras = [camTOP];
		n.y += ymod;
		add(n);

		FlxG.save.data.achievementsEarned.push(a);
		trace(FlxG.save.data.achievementsEarned);
		trace(FlxG.save.data.achievementsToBeEarned);
	}

	function unlockSong(s:String, msg:String, ymod:Float):Void
	{
		FlxG.sound.play(Paths.sound('notification'));

		var n:FNMNotification = new FNMNotification(1, "Song unlocked!", msg);
		n.cameras = [camTOP];
		n.y += ymod;
		add(n);

		FlxG.save.data.songsUnlocked.push(s);
		trace(FlxG.save.data.songsUnlocked);
		trace(FlxG.save.data.songsToBeUnlocked);
	}
}

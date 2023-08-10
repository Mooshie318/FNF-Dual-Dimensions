package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.FlxCamera;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FNMStoryMenuState extends MusicBeatState
{
	var didTheThing:Bool = false; // > 36
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['icy', 'fire', 'slime-attack'],
		['interview', 'drive-thru'],
		['Boo', 'Ghost', "Haunted"],
		['Cloud', "Sheary", "Monster-Cloud"],
		['Cluck', 'Clooshie', 'Fight-For-Life'],
		['Trooper', 'Shell', 'Attack'],
		['Gooey', 'Sacrifice', 'Squash'],
		['moo', 'mooshie', 'showdown'],
		['red', 'light-speed', 'moo-storm', 'moosanity', 'Moovenge'],
		['Plane', 'Air-Battle', 'Thunder-Storm'],
		['lemons', 'freezing', 'burning', 'slimy', 'slime-rematch'],
		['all-around-you', 'alan'],
		['sticks-n-stones', 'branching-out', 'logging-in'],
		['stickletta', 'hot-pink', 'friends'],
		['duplication', 'darkness'],
		['enemy', 'trust', 'team-up'],
		['infecto', 'recovery', 'striker'],
		['yellow', 'teleportation', 'ffff00'],
		['ff0000', 'laser', '00ffff'],
		['fury', 'rage', 'fiery-madness'],
		['crock', 'switch', 'bite', 'crocker'],
		['sticklettabreaker'],
		['portal', 'ralph', 'amethyst', 'bite-wave']
	];

	var curDifficulty:Int = 2;

	// comment below applys to this as well
	// Update (2022-11-27): I found a better way
	public static var weekUnlocked:Array<Bool> = [];

	var weekNames:Array<String> = [
		"How to Funk",
		"Slime crew",
		"Sooubway",
		"Ghost with a fucking gun",
		"Sheary",
		"Cluck team",
		"Flying simulator ft. Trooper",
		"Airship",
		"Mooshie",
		"Moo Land",
		"Plane battle",
		"Slime crew rematch",
		"Bonus chapter",
		"Sticks and Squares",
		"Stickletta",
		"Clonerman",
		"Reverse FNF mod",
		"Striker",
		"Yellow dude",
		"Red dude",
		"Dark red void",
		"Crocker",
		"Bonus chapter",
		"Ralph Ralph Ralph"
	];

	// Based on hard mode (+ means more difficult and - means less difficult)
	var weekDifficulty:Array<String> = [
		"Super easy",    // Tutorial
		"Easy",          // C1  - Slime crew
		"Moderate",      // C2  - James
		"Moderate +",    // C3  - Ghost
		"Challenging",   // C4  - Sheary
		"Challenging +", // C5  - Cluckington & Clooshie
		"Hard -",        // C6  - Trooper
		"Hard",          // C7  - Gooey
		"Hard +",        // C8  - Mooshie
		"Super hard",    // C9  - Supermooshie
		"Super hard",    // C10 - Supermooshie & Sheary
		"Challenging",   // C11 - Slime crew
		"Hard +",        // B1  - All in Pt1 + Sticko
		"Challenging +", // C12 - Sticko
		"Hard -",        // C13 - Stickletta
		"Moderate +",    // C14 - Clonerman
		"Challenging -", // C15 - Sticklettabow & Swordletto
		"Hard -",        // C16 - Infecto & Striker
		"Hard",          // C17 - Yellow dude
		"Hard -",        // C18 - Red dude
		"Hard +",        // C19 - Stiburn
		"Super hard",    // C20 - Crocker
		"Super hard",    // B2  - All in Pt2
		"Hard -"         // C21 - Ralph
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var difficultyText:FlxText;

	var grpWeekText:FlxTypedGroup<FlxSprite>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		FlxG.camera.zoom = 0.5;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('menu drums'));
		}
		for (i in 0...weekData.length)
		{
			weekUnlocked.push(true);
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
		scoreText.cameras = [camHUD];

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;
		txtWeekTitle.cameras = [camHUD];

		difficultyText = new FlxText(0, 10, 0, "", 32);
		difficultyText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		difficultyText.screenCenter(X);
		difficultyText.cameras = [camHUD];

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<FlxSprite>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		blackBarThingie.cameras = [camHUD];
		add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		var k:Int = 0;
		for (i in 0...weekData.length)
		{
			var weekThing:FlxSprite = new FlxSprite().loadGraphic(Paths.image('FNM storymenu/' + i));
			weekThing.screenCenter();
			weekThing.y += weekThing.height + 30;
			weekThing.alpha = 0.5;
			add(weekThing);

			grpWeekText.add(weekThing);

			if (i == 13)
				k = 3;

			if (i >= 13 && i < 23)
				weekThing.x += ((weekThing.width + 100) * k);
			else if (i >= 23)
				weekThing.x += ((weekThing.width + 100) * (i - 10));
			else
				weekThing.x += ((weekThing.width + 100) * i);
			weekThing.antialiasing = true;

			if (i >= 13 && i < 23)
				weekThing.y -= weekThing.height + 30;

			k += 1;

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		txtTracklist = new FlxText(360, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.cameras = [camHUD];
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);
		add(difficultyText);

		changeWeek();
		updateText();

		trace("Line 165");

		var altTxt:FlxText = new FlxText(FlxG.width - 210, FlxG.height - 41, 0, "ALT + R to reset music", 12);
		altTxt.scrollFactor.set();
		altTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		altTxt.cameras = [camHUD];
		add(altTxt);
		
		var ctrlTxt:FlxText = new FlxText(FlxG.width - 215, FlxG.height - 24, 0, "CTRL + R to reset score", 12);
		ctrlTxt.scrollFactor.set();
		ctrlTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ctrlTxt.cameras = [camHUD];
		add(ctrlTxt);

		// Dynamic(?) menu music
		TitleState.piano.fadeIn(0.5, TitleState.piano.volume, 0.7);
		TitleState.synth.fadeIn(0.5, TitleState.synth.volume, 0.7);
		TitleState.guitar.fadeOut(0.5, 0);
		TitleState.bass.fadeIn(0.5, TitleState.bass.volume, 0.7);

		super.create();
	}

	override function update(elapsed:Float)
	{
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

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultyText.text = weekDifficulty[curWeek].toUpperCase();
		difficultyText.screenCenter(X);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					if (curWeek == 23)
						changeWeek(-11, false, true);
					else if (curWeek == 13)
						changeWeek(9);
					else
						changeWeek(-1);
				}

				if (controls.RIGHT_P)
				{
					if (curWeek == 12)
						changeWeek(11, false, true);
					else if (curWeek == 22)
						changeWeek(-9);
					else
						changeWeek(1);
				}

				if (controls.UP_P)
				{
					if (curWeek >= 3 && curWeek < 13)
						changeWeek(10, true);
				}

				if (controls.DOWN_P)
				{
					if (curWeek >= 13 && curWeek < 23)
						changeWeek(-10, true);
				}
			}
			if (FlxG.keys.pressed.CONTROL)
			{
				if (FlxG.keys.justPressed.R)
				{
					Highscore.saveWeekScore(curWeek, 0, curDifficulty, true);
				}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		// Dynamic(?) menu music
		TitleState.piano.fadeOut(0.5, 0);
		TitleState.synth.fadeOut(0.5, 0);
		TitleState.guitar.fadeOut(0.5, 0);
		TitleState.bass.fadeOut(0.5, 0);

		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				if (FlxG.random.bool(10))
				{
					FlxG.sound.play(Paths.sound('moo'));
				}
				else
					FlxG.sound.play(Paths.sound('confirmMenu'));

				//grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "-hard";

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;

			var video:VideoHandlerMP4 = new VideoHandlerMP4();
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (curWeek == 9)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('red'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 5)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('bfFuckingDies'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 12)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('theyAppear'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 16)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('theyTalk'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 17)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('striker strikes'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 21)
				{
					if (FlxG.save.data.cutscenes)
					{
						video.playMP4(Paths.video('crocker appears'), new PlayState());
						#if windows
						DiscordClient.changePresence("In cutscene", null, null, true);
						#end
					}
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else if (curWeek == 23)
				{
					if (FlxG.save.data.cutscenes)
						{
							video.playMP4(Paths.video('they portal'), new PlayState());
							#if windows
							DiscordClient.changePresence("In cutscene", null, null, true);
							#end
						}
						else
							LoadingState.loadAndSwitchState(new PlayState());
				}
				else
				{
					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0, vertical:Bool = false, substract:Bool = false):Void
	{
		curWeek += change;
		if (substract)
		{
			if (change < 0)
				change += 10;
			else
				change -= 10;
		}

		if (!vertical)
		{
			if (curWeek >= weekData.length)
			{
				curWeek = 0;
				change = (weekData.length - 1) * -1 + 10;
			}
			if (curWeek < 0)
			{
				curWeek = weekData.length - 1;
				change = weekData.length - 1 - 10;
			}

			for (item in grpWeekText.members)
			{
				item.alpha = 0.5;
			}
			grpWeekText.members[curWeek].alpha = 1;

			for (i in 0...grpWeekText.length)
			{
				FlxTween.completeTweensOf(grpWeekText.members[i]);
				FlxTween.tween(grpWeekText.members[i], {x: grpWeekText.members[i].x - ((grpWeekText.members[i].width + 100) * change)}, 0.4, {ease: FlxEase.sineOut});
			}
		}
		else
		{
			for (item in grpWeekText.members)
			{
				item.alpha = 0.5;
			}
			grpWeekText.members[curWeek].alpha = 1;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text += "\n";
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.y = 50;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}

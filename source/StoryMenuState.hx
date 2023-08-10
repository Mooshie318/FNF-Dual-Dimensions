package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
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
	var curDifficulty:Int = 1;

	// comment below applys to this as well
	// Update (2022-11-27): I found a better way
	public static var weekUnlocked:Array<Bool> = [];

	// i really hope there's a better way to do this
	var weekCharacters:Array<Dynamic> = [
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'bf', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'stick', ''],
		['', 'bf', '']
	];

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

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

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

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		difficultyText = new FlxText(0, 10, 0, "", 32);
		difficultyText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		difficultyText.screenCenter(X);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.x = 100;
			weekThing.antialiasing = true;

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

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(850, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(400 + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('duet', 'DUET');
		sprDifficulty.animation.addByPrefix('fuckyou', 'FUCKYOU');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(grpWeekCharacters);

		txtTracklist = new FlxText(360, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);
		add(difficultyText);

		updateText();

		trace("Line 165");

		var altTxt:FlxText = new FlxText(FlxG.width - 210, FlxG.height - 41, 0, "ALT + R to reset music", 12);
		altTxt.scrollFactor.set();
		altTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(altTxt);
		
		var ctrlTxt:FlxText = new FlxText(FlxG.width - 215, FlxG.height - 24, 0, "CTRL + R to reset score", 12);
		ctrlTxt.scrollFactor.set();
		ctrlTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
				if (curWeek > 11 && !didTheThing)
				{
					changeDifficulty(0);
					didTheThing = true;
				}
				if (curWeek <= 11)
					didTheThing = false;
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

				grpWeekText.members[curWeek].startFlashing();
				if (curWeek <= 12 || curWeek > 22)
					grpWeekCharacters.members[1].animation.play('bfConfirm');
				else if (curWeek >= 13 && curWeek <= 22)
					grpWeekCharacters.members[1].animation.play('sticklettoConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
				case 3:
					diffic = '-duet';
				case 4:
					diffic = '-fuckyou';
			}

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

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curWeek > 11)
			curDifficulty = 2;
		else
		{
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 3:
				sprDifficulty.animation.play('duet');
				sprDifficulty.offset.x = 20;
			case 4:
				sprDifficulty.animation.play('fuckyou');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

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

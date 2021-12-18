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
		['Plane', 'Air-Battle', 'Thunder-Storm']
		//['FNM-Marathon']
	];
	var curDifficulty:Int = 1;

	// comment below applys to this as well
	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true];


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
		['', 'bf', '']
		//['', 'bf', '']
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
		"Plane battle"
		//"Friday night mooin marathon"
	];

	// Based on hard mode (+ means more difficult and - means less difficult)
	var weekDifficulty:Array<String> = [
		"Super easy",
		"Easy",
		"Moderate",
		"Moderate +",
		"Challenging",
		"Challenging +",
		"Hard -",
		"Hard",
		"Hard +",
		"Super hard",
		"Super hard"
		//"Extreme +"
	];

	// Based on hard mode + coming in 1.1.0
	/*var weekMechanics:Array<String> = [
		"Mechanics\n\nNone\nE",
		"Mechanics\n\nNone\nE",
		"Mechanics\n\nNone\nE",
		"Mechanics\n\nNone\nE",
		"Mechanics\n\nNone\nE",
		"Mechanics\n\nHealth drain\nE",
		"Mechanics\n\nShell notes\nBattle (in 1.1.0)\nE",
		"Mechanics\n\nCustom notes\nBattle (in 1.1.0)\nE",
		"Mechanics\n\nCustom notes\nE",
		"Mechanics\n\nCustom notes\n/kill\nHealth drain\nBattle (in 1.1.0)\nE",
		"Mechanics\n\nCustom notes\n/kill\nHealth drain\nBattle (in 1.1.0)\nE"
		//"Mechanics\n\nEverything\nE"
	];*/

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var difficultyText:FlxText;

	//var mechanicText:FlxText;

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

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
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

		/*mechanicText = new FlxText(0, 480, 0, "", 32);
		mechanicText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		mechanicText.alignment = CENTER;
		mechanicText.color = 0xFFe55777;
		mechanicText.screenCenter(X);*/

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
		//add(mechanicText);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultyText.text = weekDifficulty[curWeek].toUpperCase();
		difficultyText.screenCenter(X);

		//mechanicText.text = weekMechanics[curWeek].toUpperCase();
		//mechanicText.screenCenter(X);

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
				grpWeekCharacters.members[1].animation.play('bfConfirm');
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
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (curWeek == 9)
				{
					if (FlxG.save.data.cutscenes)
					{
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/red.webm", new PlayState()));
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
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/bfFuckingDies.webm", new PlayState()));
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

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

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

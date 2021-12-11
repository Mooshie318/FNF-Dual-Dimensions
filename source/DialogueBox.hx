package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	var skipText:FlxText;

	public var finishThing:Void->Void;

	// dialogue portraits are so annoying :(
	var portraitRight:FlxSprite;

	var firePort:FlxSprite;
	var firePortMad:FlxSprite;
	var firePortAhh:FlxSprite;
	var icyPort:FlxSprite;
	var icyPortMad:FlxSprite;
	var icyPortAhh:FlxSprite;
	var lemonyPort:FlxSprite;
	var lemonyPortMad:FlxSprite;
	var lemonyPortAhh:FlxSprite;
	var slimyPort:FlxSprite;
	var slimyPortMad:FlxSprite;
	var slimyPortAhh:FlxSprite;
	var crewPort:FlxSprite;

	var babyPort:FlxSprite;
	var sooubwayPort:FlxSprite;
	var groupPort:FlxSprite;

	var ghostPort:FlxSprite;

	var shepPort:FlxSprite;

	var cluckPort:FlxSprite;
	var clooshPort:FlxSprite;

	var trooperPort:FlxSprite;

	var gooeyPort:FlxSprite;
	var goombaPort:FlxSprite;

	var mooshiePort:FlxSprite;

	var supermooshiePort:FlxSprite;
	var supermooshiePortMad:FlxSprite;

	var bfPort:FlxSprite;
	var bfPortMad:FlxSprite;
	var gfPort:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			/*case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);*/
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		if (FlxG.save.data.dialogue)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'icy' | 'fire' | 'slime-attack':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'tutorial':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'boo' | 'haunted':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;
				
				case 'cloud' | 'sheary' | 'monster-cloud':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'cluck' | 'clooshie' | 'fight-for-life':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'trooper' | 'shell' | 'attack':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'gooey' | 'sacrifice':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'moo' | 'mooshie' | 'showdown':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'red' | 'light-speed' | 'moo-storm' | 'moosanity' | 'moovenge' | '7391203':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'interview' | 'drive-thru':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;

				case 'plane' | 'air-battle' | 'thunder-storm':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('dialogueThing/dialogue-box', 'shared');
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByIndices('normal', 'box', [4], "", 24);
					box.y = 400;
			}
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		firePort = new FlxSprite(250, 310);
		firePort.frames = Paths.getSparrowAtlas('portraits/firePortrait');
		firePort.animation.addByPrefix('enter', 'fire dialogue', 24, false);
		firePort.updateHitbox();
		firePort.scrollFactor.set();
		add(firePort);
		firePort.visible = false;
		
		firePortMad = new FlxSprite(250, 310);
		firePortMad.frames = Paths.getSparrowAtlas('portraits/fireMadPortrait');
		firePortMad.animation.addByPrefix('enter', 'fire dialogue mad', 24, false);
		firePortMad.updateHitbox();
		firePortMad.scrollFactor.set();
		add(firePortMad);
		firePortMad.visible = false;

		firePortAhh = new FlxSprite(250, 310);
		firePortAhh.frames = Paths.getSparrowAtlas('portraits/fireAhhPortrait');
		firePortAhh.animation.addByPrefix('enter', 'fire dialogue ahh', 24, false);
		firePortAhh.updateHitbox();
		firePortAhh.scrollFactor.set();
		add(firePortAhh);
		firePortAhh.visible = false;

		icyPort = new FlxSprite(250, 310);
		icyPort.frames = Paths.getSparrowAtlas('portraits/icyPortrait');
		icyPort.animation.addByPrefix('enter', 'icy dialogue', 24, false);
		icyPort.updateHitbox();
		icyPort.scrollFactor.set();
		add(icyPort);
		icyPort.visible = false;

		icyPortMad = new FlxSprite(250, 310);
		icyPortMad.frames = Paths.getSparrowAtlas('portraits/icyMadPortrait');
		icyPortMad.animation.addByPrefix('enter', 'icy dialogue mad', 24, false);
		icyPortMad.updateHitbox();
		icyPortMad.scrollFactor.set();
		add(icyPortMad);
		icyPortMad.visible = false;

		icyPortAhh = new FlxSprite(250, 310);
		icyPortAhh.frames = Paths.getSparrowAtlas('portraits/icyAhhPortrait');
		icyPortAhh.animation.addByPrefix('enter', 'icy dialogue ahh', 24, false);
		icyPortMad.updateHitbox();
		icyPortAhh.scrollFactor.set();
		add(icyPortAhh);
		icyPortAhh.visible = false;

		lemonyPort = new FlxSprite(250, 310);
		lemonyPort.frames = Paths.getSparrowAtlas('portraits/lemonyPortrait');
		lemonyPort.animation.addByPrefix('enter', 'lemony dialogue', 24, false);
		lemonyPort.updateHitbox();
		lemonyPort.scrollFactor.set();
		add(lemonyPort);
		lemonyPort.visible = false;

		lemonyPortMad = new FlxSprite(250, 310);
		lemonyPortMad.frames = Paths.getSparrowAtlas('portraits/lemonyMadPortrait');
		lemonyPortMad.animation.addByPrefix('enter', 'lemony dialogue mad', 24, false);
		lemonyPortMad.updateHitbox();
		lemonyPortMad.scrollFactor.set();
		add(lemonyPortMad);
		lemonyPortMad.visible = false;

		lemonyPortAhh = new FlxSprite(250, 310);
		lemonyPortAhh.frames = Paths.getSparrowAtlas('portraits/lemonyAhhPortrait');
		lemonyPortAhh.animation.addByPrefix('enter', 'lemony dialogue ahh', 24, false);
		lemonyPortAhh.updateHitbox();
		lemonyPortAhh.scrollFactor.set();
		add(lemonyPortAhh);
		lemonyPortAhh.visible = false;

		slimyPort = new FlxSprite(250, 310);
		slimyPort.frames = Paths.getSparrowAtlas('portraits/slimyPortrait');
		slimyPort.animation.addByPrefix('enter', 'slimy dialogue', 24, false);
		slimyPort.updateHitbox();
		slimyPort.scrollFactor.set();
		add(slimyPort);
		slimyPort.visible = false;

		slimyPortMad = new FlxSprite(250, 310);
		slimyPortMad.frames = Paths.getSparrowAtlas('portraits/slimyMadPortrait');
		slimyPortMad.animation.addByPrefix('enter', 'slimy dialogue mad', 24, false);
		slimyPortMad.updateHitbox();
		slimyPortMad.scrollFactor.set();
		add(slimyPortMad);
		slimyPortMad.visible = false;

		slimyPortAhh = new FlxSprite(250, 310);
		slimyPortAhh.frames = Paths.getSparrowAtlas('portraits/slimyAhhPortrait');
		slimyPortAhh.animation.addByPrefix('enter', 'slimy dialogue ahh', 24, false);
		slimyPortAhh.updateHitbox();
		slimyPortAhh.scrollFactor.set();
		add(slimyPortAhh);
		slimyPortAhh.visible = false;

		crewPort = new FlxSprite(250, 40);
		crewPort.frames = Paths.getSparrowAtlas('portraits/crewPortrait');
		crewPort.animation.addByPrefix('enter', 'slime crew dialogue', 24, false);
		crewPort.updateHitbox();
		crewPort.scrollFactor.set();
		add(crewPort);
		crewPort.visible = false;

		babyPort = new FlxSprite(250, 150);
		babyPort.frames = Paths.getSparrowAtlas('portraits/james');
		babyPort.animation.addByPrefix('enter', 'baby james dialogue', 24, false);
		babyPort.updateHitbox();
		babyPort.scrollFactor.set();
		add(babyPort);
		babyPort.visible = false;

		sooubwayPort = new FlxSprite(250, 210);
		sooubwayPort.frames = Paths.getSparrowAtlas('portraits/james');
		sooubwayPort.animation.addByPrefix('enter', 'sooubway james dialogue', 24, false);
		sooubwayPort.updateHitbox();
		sooubwayPort.scrollFactor.set();
		add(sooubwayPort);
		sooubwayPort.visible = false;

		groupPort = new FlxSprite(250, 50);
		groupPort.frames = Paths.getSparrowAtlas('portraits/james');
		groupPort.animation.addByPrefix('enter', 'james group dialogue', 24, false);
		groupPort.updateHitbox();
		groupPort.scrollFactor.set();
		add(groupPort);
		groupPort.visible = false;

		mooshiePort = new FlxSprite(250, 110);
		mooshiePort.frames = Paths.getSparrowAtlas('portraits/mooshie');
		mooshiePort.animation.addByPrefix('enter', 'mooshie dialogue', 24, false);
		mooshiePort.updateHitbox();
		mooshiePort.scrollFactor.set();
		add(mooshiePort);
		mooshiePort.visible = false;

		supermooshiePort = new FlxSprite(250, 190);
		supermooshiePort.frames = Paths.getSparrowAtlas('portraits/supermooshie');
		supermooshiePort.animation.addByPrefix('enter', 'supermooshie dialogue0', 24, false);
		supermooshiePort.updateHitbox();
		supermooshiePort.scrollFactor.set();
		add(supermooshiePort);
		supermooshiePort.visible = false;

		supermooshiePortMad = new FlxSprite(250, 190);
		supermooshiePortMad.frames = Paths.getSparrowAtlas('portraits/supermooshie');
		supermooshiePortMad.animation.addByPrefix('enter', 'supermooshie dialogue mad', 24, false);
		supermooshiePortMad.updateHitbox();
		supermooshiePortMad.scrollFactor.set();
		add(supermooshiePortMad);
		supermooshiePortMad.visible = false;

		ghostPort = new FlxSprite(250, 310);
		ghostPort.frames = Paths.getSparrowAtlas('portraits/ghost');
		ghostPort.animation.addByPrefix('enter', 'ghost dialogue0', 24, false);
		ghostPort.updateHitbox();
		ghostPort.scrollFactor.set();
		add(ghostPort);
		ghostPort.visible = false;

		shepPort = new FlxSprite(250, 220);
		shepPort.frames = Paths.getSparrowAtlas('portraits/sheary');
		shepPort.animation.addByPrefix('enter', 'sheary dia', 24, false);
		shepPort.updateHitbox();
		shepPort.scrollFactor.set();
		add(shepPort);
		shepPort.visible = false;

		cluckPort = new FlxSprite(250, 250);
		cluckPort.frames = Paths.getSparrowAtlas('portraits/cluck');
		cluckPort.animation.addByPrefix('enter', 'cluck dia', 24, false);
		cluckPort.updateHitbox();
		cluckPort.scrollFactor.set();
		add(cluckPort);
		cluckPort.visible = false;

		clooshPort = new FlxSprite(250, 215);
		clooshPort.frames = Paths.getSparrowAtlas('portraits/cluck');
		clooshPort.animation.addByPrefix('enter', 'cloosh dia', 24, false);
		clooshPort.updateHitbox();
		clooshPort.scrollFactor.set();
		add(clooshPort);
		clooshPort.visible = false;

		trooperPort = new FlxSprite(250, 260);
		trooperPort.frames = Paths.getSparrowAtlas('portraits/trooper');
		trooperPort.animation.addByPrefix('enter', 'trooper dia', 24, false);
		trooperPort.updateHitbox();
		trooperPort.scrollFactor.set();
		add(trooperPort);
		trooperPort.visible = false;

		gooeyPort = new FlxSprite(250, 250);
		gooeyPort.frames = Paths.getSparrowAtlas('portraits/goomba');
		gooeyPort.animation.addByPrefix('enter', 'gooey dia', 24, false);
		gooeyPort.updateHitbox();
		gooeyPort.scrollFactor.set();
		add(gooeyPort);
		gooeyPort.visible = false;

		goombaPort = new FlxSprite(250, 270);
		goombaPort.frames = Paths.getSparrowAtlas('portraits/goomba');
		goombaPort.animation.addByPrefix('enter', 'goomba dia', 24, false);
		goombaPort.updateHitbox();
		goombaPort.scrollFactor.set();
		add(goombaPort);
		goombaPort.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		gfPort = new FlxSprite(650, 210);
		gfPort.frames = Paths.getSparrowAtlas('portraits/gf');
		gfPort.animation.addByPrefix('enter', 'gf dialogue', 24, false);
		gfPort.updateHitbox();
		gfPort.scrollFactor.set();
		add(gfPort);
		gfPort.visible = false;

		bfPort = new FlxSprite(700, 190);
		bfPort.frames = Paths.getSparrowAtlas('portraits/bf');
		bfPort.animation.addByPrefix('enter', 'bf dialogue0', 24, false);
		bfPort.updateHitbox();
		bfPort.scrollFactor.set();
		add(bfPort);

		bfPortMad = new FlxSprite(700, 190);
		bfPortMad.frames = Paths.getSparrowAtlas('portraits/bf');
		bfPortMad.animation.addByPrefix('enter', 'bf dialogue mad', 24, false);
		bfPortMad.updateHitbox();
		bfPortMad.scrollFactor.set();
		add(bfPortMad);
		bfPortMad.visible = false;

		// template (rename n to the name of your var, and remove /* and */)
		/*n = new FlxSprite(250, 40);
		n.frames = Paths.getSparrowAtlas('portraits/something');
		n.animation.addByPrefix('enter', 'something', 24, false);
		n.updateHitbox();
		n.scrollFactor.set();
		add(n);
		n.visible = false;*/
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 35);
		dropText.font = 'VCR OST Mono';
		dropText.color = 0xFFD89494;
		add(dropText);

		skipText = new FlxText(5, 10, 640, "Press SHIFT to skip dialogue", 40);
		skipText.scrollFactor.set(0, 0);
		skipText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipText.borderSize = 2;
		skipText.borderQuality = 1;
		add(skipText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 35);
		swagDialogue.font = 'VCR OST Mono';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.SHIFT && !isEnding)
		{
			isEnding = true;
			finishThing();
			kill();
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'bf':
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'boyfriend':
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				portraitRight.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!bfPort.visible)
				{
					bfPort.visible = true;
					bfPort.animation.play('enter');
				}
			case 'girlfriend':
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				portraitRight.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!gfPort.visible)
				{
					gfPort.visible = true;
					gfPort.animation.play('enter');
				}
			case 'fire':
				portraitRight.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!firePort.visible)
				{
					firePort.visible = true;
					firePort.animation.play('enter');
				}
			case 'firemad':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!firePortMad.visible)
				{
					firePortMad.visible = true;
					firePortMad.animation.play('enter');
				}
			case 'fireahh':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!firePortAhh.visible)
				{
					firePortAhh.visible = true;
					firePortAhh.animation.play('enter');
				}
			case 'icy':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!icyPort.visible)
				{
					icyPort.visible = true;
					icyPort.animation.play('enter');
				}
				case 'icymad':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!icyPortMad.visible)
				{
					icyPortMad.visible = true;
					icyPortMad.animation.play('enter');
				}
			case 'icyahh':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!icyPortAhh.visible)
				{
					icyPortAhh.visible = true;
					icyPortAhh.animation.play('enter');
				}
				case 'lemony':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!lemonyPort.visible)
				{
					lemonyPort.visible = true;
					lemonyPort.animation.play('enter');
				}
			case 'lemonymad':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!lemonyPortMad.visible)
				{
					lemonyPortMad.visible = true;
					lemonyPortMad.animation.play('enter');
				}
				case 'lemonyahh':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!lemonyPortAhh.visible)
				{
					lemonyPortAhh.visible = true;
					lemonyPortAhh.animation.play('enter');
				}
			case 'slimy':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!slimyPort.visible)
				{
					slimyPort.visible = true;
					slimyPort.animation.play('enter');
				}
			case 'slimymad':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!slimyPortMad.visible)
				{
					slimyPortMad.visible = true;
					slimyPortMad.animation.play('enter');
				}
			case 'slimyahh':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!slimyPortAhh.visible)
				{
					slimyPortAhh.visible = true;
					slimyPortAhh.animation.play('enter');
				}
			case 'crew':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!crewPort.visible)
				{
					crewPort.visible = true;
					crewPort.animation.play('enter');
				}
			case 'baby':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!babyPort.visible)
				{
					babyPort.visible = true;
					babyPort.animation.play('enter');
				}
			case 'sooubway':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!sooubwayPort.visible)
				{
					sooubwayPort.visible = true;
					sooubwayPort.animation.play('enter');
				}
			case 'group':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!groupPort.visible)
				{
					groupPort.visible = true;
					groupPort.animation.play('enter');
				}
			case 'mooshie':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!mooshiePort.visible)
				{
					mooshiePort.visible = true;
					mooshiePort.animation.play('enter');
				}
			case 'supermooshie':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!supermooshiePort.visible)
				{
					supermooshiePort.visible = true;
					supermooshiePort.animation.play('enter');
				}
			case 'supermadshie':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				bfPortMad.visible = false;
				if (!supermooshiePortMad.visible)
				{
					supermooshiePortMad.visible = true;
					supermooshiePortMad.animation.play('enter');
				}
			case 'bfmad':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				if (!bfPortMad.visible)
				{
					bfPortMad.visible = true;
					bfPortMad.animation.play('enter');
				}
			case 'ghost':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!ghostPort.visible)
				{
					ghostPort.visible = true;
					ghostPort.animation.play('enter');
				}
			case 'sheary':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				ghostPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!shepPort.visible)
				{
					shepPort.visible = true;
					shepPort.animation.play('enter');
				}
			case 'cluckington':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!cluckPort.visible)
				{
					cluckPort.visible = true;
					cluckPort.animation.play('enter');
				}
			case 'clooshie':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!clooshPort.visible)
				{
					clooshPort.visible = true;
					clooshPort.animation.play('enter');
				}
			case 'trooper':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!trooperPort.visible)
				{
					trooperPort.visible = true;
					trooperPort.animation.play('enter');
				}

			case 'gooey':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!gooeyPort.visible)
				{
					gooeyPort.visible = true;
					gooeyPort.animation.play('enter');
				}

			case 'goomba':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				trooperPort.visible = false;
				gooeyPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!goombaPort.visible)
				{
					goombaPort.visible = true;
					goombaPort.animation.play('enter');
				}

			// full template (rename s to ur var)
			/*case 's':
				portraitRight.visible = false;
				firePort.visible = false;
				firePortMad.visible = false;
				firePortAhh.visible = false;
				icyPort.visible = false;
				icyPortMad.visible = false;
				icyPortAhh.visible = false;
				lemonyPort.visible = false;
				lemonyPortMad.visible = false;
				lemonyPortAhh.visible = false;
				slimyPort.visible = false;
				slimyPortMad.visible = false;
				slimyPortAhh.visible = false;
				crewPort.visible = false;
				bfPort.visible = false;
				gfPort.visible = false;
				babyPort.visible = false;
				sooubwayPort.visible = false;
				groupPort.visible = false;
				shepPort.visible = false;
				cluckPort.visible = false;
				clooshPort.visible = false;
				gooeyPort.visible = false;
				goombaPort.visible = false;
				mooshiePort.visible = false;
				supermooshiePort.visible = false;
				supermooshiePortMad.visible = false;
				bfPortMad.visible = false;
				if (!s.visible)
				{
					s.visible = true;
					s.animation.play('enter');
				}*/

			// empty template (rename e and m to ur var(s))
			/*case 'e':
				m.visible = false;
				if (!e.visible)
				{
					e.visible = true;
					e.animation.play('enter');
				}*/
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}

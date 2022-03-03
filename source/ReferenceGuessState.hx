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

import GameJolt.GameJoltAPI; // gamejolt

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ReferenceGuessState extends MusicBeatState
{
	var w4Box:FlxUIInputText;
	var w5Box:FlxUIInputText;
	var w6Box:FlxUIInputText;
	var w7Box:FlxUIInputText;
	var w8Box:FlxUIInputText;
	var w9Box:FlxUIInputText;
	var w10Box:FlxUIInputText;
	var w11Box:FlxUIInputText;

	var w4Answer:String = 'reactor';
	var w5Answer:String = 'roses';
	var w6Answer:String = 'marx, overhead';
	var w7Answer:String = 'ballistic';
	var w8Answer:String = 'roses, ballistic';
	var w9Answer:String = 'hello world, ballistic';
	var w10Answer:String = 'the end';
	var w11Answer:String = 'target practice, sporting';

	var button:FlxUIButton;

	var rgTxt:FlxText;
	var txt:FlxText;
	var txtPt2:FlxText;
	var txtPt3:FlxText;
	var txt2:FlxText;
	var txt3:FlxText;
	var txt3Pt2:FlxText;
	var txt3Pt3:FlxText;

	var correct:FlxText;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Guessing the refrences", null);
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

		super.create();
	}

	function addUI():Void
    {
		w4Box = new FlxUIInputText(10, 50, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w5Box = new FlxUIInputText(10, 150, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w6Box = new FlxUIInputText(10, 250, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w7Box = new FlxUIInputText(10, 350, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w8Box = new FlxUIInputText(10, 450, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w9Box = new FlxUIInputText(10, 550, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w10Box = new FlxUIInputText(10, 650, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);
		w11Box = new FlxUIInputText(10, 750, 300, null, 32, FlxColor.BLACK, FlxColor.WHITE);

		rgTxt = new FlxText(500, 10);
		rgTxt.text = 'Reference guesser';
		rgTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		rgTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txt = new FlxText(470, 100, 0);
		txt.text = 'Type in order of "ref, ref"';
		txt.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txtPt2 = new FlxText(450, 130, 0);
		txtPt2.text = 'in song & time order (time in the song).';
		txtPt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txtPt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txtPt3 = new FlxText(430, 160, 0);
		txtPt3.text = "References to FNM or vs slime crew dont count.";
		txtPt3.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txtPt3.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txt2 = new FlxText(450, 200, 0);
		txt2.text = 'The boxes are in week order from 4-11.';
		txt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txt3 = new FlxText(500, 240, 0);
		txt3.text = 'CONTROLS:';
		txt3.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txt3.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txt3Pt2 = new FlxText(450, 270, 0);
		txt3Pt2.text = '- UP/DOWN ARROW: move boxes';
		txt3Pt2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txt3Pt2.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		txt3Pt3 = new FlxText(450, 300, 0);
		txt3Pt3.text = '- R: reset box positions';
		txt3Pt3.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		txt3Pt3.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		button = new FlxUIButton(565, 322.5, 'Enter Guesses', checkGuess);
        button.resize(150, 75);
        button.setLabelFormat(null, 12, FlxColor.BLACK);

		add(w4Box);
		add(w5Box);
		add(w6Box);
		add(w7Box);
		add(w8Box);
		add(w9Box);
		add(w10Box);
		add(w11Box);

		add(rgTxt);
		add(txt);
		add(txtPt2);
		add(txtPt3);
		add(txt2);
		add(txt3);
		add(txt3Pt2);
		add(txt3Pt3);

		add(button);
    }

	override function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new ExtrasState());
        }

		if (FlxG.keys.pressed.UP)
		{
			w4Box.y += 5;
			w5Box.y += 5;
			w6Box.y += 5;
			w7Box.y += 5;
			w8Box.y += 5;
			w9Box.y += 5;
			w10Box.y += 5;
			w11Box.y += 5;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			w4Box.y -= 5;
			w5Box.y -= 5;
			w6Box.y -= 5;
			w7Box.y -= 5;
			w8Box.y -= 5;
			w9Box.y -= 5;
			w10Box.y -= 5;
			w11Box.y -= 5;
		}
		if (FlxG.keys.justPressed.R)
		{
			w4Box.y = 50;
			w5Box.y = 150;
			w6Box.y = 250;
			w7Box.y = 350;
			w8Box.y = 450;
			w9Box.y = 550;
			w10Box.y = 650;
			w11Box.y = 750;
		}

        FlxG.mouse.visible = true;

		super.update(elapsed);
	}

	function checkGuess():Void
	{
		// there better be an easier way to do this
		if (w4Box.text == w4Answer && w5Box.text == w5Answer && w6Box.text == w6Answer && w7Box.text == w7Answer && w8Box.text == w8Answer && w9Box.text == w9Answer && w10Box.text == w10Answer && w11Box.text == w11Answer)
		{
			FlxG.save.data.platformerUnlocked = true;
			GameJoltAPI.getTrophy(155059);

			correct = new FlxText(400, 300, 0);
			correct.text = 'CORRECT!!';
			correct.setFormat("VCR OSD Mono", 100, FlxColor.LIME, CENTER);
			correct.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
			add(correct);

			new FlxTimer().start(2, changeTxt, 1);
		}
	}

	function changeTxt(timer:FlxTimer):Void
	{
		remove(correct);

		correct = new FlxText(370, 300, 0);
		correct.text = 'Something will appear in the extras menu in 2.0.0...';
		correct.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER);
		correct.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(correct);

		new FlxTimer().start(2, removeTxt, 1);
	}

	function removeTxt(timer:FlxTimer):Void
	{
		remove(correct);
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class WelcomeState extends MusicBeatState
{
	var txt:FlxText;
	var pagesLeft:Int = 3;
	var curPage:Int = 0;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		txt = new FlxText(0, 0, FlxG.width - 50, "", 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		nextPage();
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			if (pagesLeft == 0)
			{
				FlxG.save.data.beenWelcomed = true;
				FlxG.switchState(new MainMenuState());
			}
			else
				nextPage();
		}
		if (FlxG.keys.justPressed.TAB)
		{
			FlxG.save.data.beenWelcomed = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}


	var endTxt:String = "\n\nPress TAB to skip this, or ENTER to go to the next page...";

	function nextPage():Void
	{
		curPage += 1;
		pagesLeft -= 1;

		switch(curPage)
		{
			case 1:
				txt.text = 
				"Welcome to FNF - Dual Dimensions!" +
				"\nThe upcoming text has some important info, so you might wanna read it." +
				endTxt;
			case 2:
				txt.text = 
				"SECRET CODES:" +
				"\n\nThere are some secret codes used to play some songs." +
				"\nFrom the main menu, press 'Extras', then 'Guess the code', then enter the code from there." +
				endTxt;
			case 3:
				txt.text =
				"BUG THAT I CAN FIX BUT AM TOO LAZY" +
				"\n\nRestart the game before playing Level 1-8 in story mode (Moo-Storm in freeplay)." +
				"\nThe way I did a black screen is just weird if you played a cutscene before the song." +
				"\nIt won't crash the game, it'll just not be a black screen." +
				"\nI can fix it, but I just don't wanna." +
				endTxt;
		}
		txt.screenCenter();
	}
}

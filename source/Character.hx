package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var iconColor:String = 'FFFF0000'; // for healthbar shit

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByPrefix('space', 'GF press space', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset("space", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				iconColor = 'FFD5007C';

				playAnim('danceRight');

			case 'gf-airship':
				tex = Paths.getSparrowAtlas('airship/gf', 'shared');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				iconColor = 'FFD5007C';

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('christmas/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				iconColor = 'FFD5007C';

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				iconColor = 'FFD5007C';

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('weeb/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

				iconColor = 'FFD5007C';

			case 'slime':
				tex = Paths.getSparrowAtlas('slime_crew');
				frames = tex;
				animation.addByPrefix('idle', 'slime idle', 24);
				animation.addByPrefix('singUP', 'slime up', 24);
				animation.addByPrefix('singRIGHT', 'slime right', 24);
				animation.addByPrefix('singDOWN', 'slime down', 24);
				animation.addByPrefix('singLEFT', 'slime left', 24);

				addOffset('idle');
				addOffset("singUP", 23, 18);
				addOffset("singRIGHT", 0, 22);
				addOffset("singLEFT", 85, 11);
				addOffset("singDOWN", 0, -18);

				iconColor = 'FF0000FF';

				playAnim('idle');

			case 'james':
				tex = Paths.getSparrowAtlas('james');
				frames = tex;
				animation.addByPrefix('idle', 'James idle', 24);
				animation.addByPrefix('singUP', 'James up', 24, false);
				animation.addByPrefix('singDOWN', 'James down', 24, false);
				animation.addByPrefix('singLEFT', 'James left', 24, false);
				animation.addByPrefix('singRIGHT', 'James right', 24, false);
				
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				iconColor = 'FFFFFFFF';

				playAnim('idle');

			case 'sheary':
				tex = Paths.getSparrowAtlas('sheary', 'week4');
				frames = tex;

				animation.addByPrefix('idle', "idle", 24, false);
				animation.addByPrefix('singUP', "up", 24, false);
				animation.addByPrefix('singDOWN', "down", 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 37, 140);
				addOffset("singRIGHT", 0, -6);
				addOffset("singLEFT", 16, 1);
				addOffset("singDOWN", 4, -30);

				iconColor = 'FFFFFFFF';

				playAnim('idle');

			case 'madcloud':
				tex = Paths.getSparrowAtlas('madCloud', 'week4');
				frames = tex;

				animation.addByPrefix('idle', "c idle", 24, false);
				animation.addByPrefix('singUP', "c up", 24, false);
				animation.addByPrefix('singDOWN', "c down", 24, false);
				animation.addByPrefix('singLEFT', 'c left', 24, false);
				animation.addByPrefix('singRIGHT', 'c right', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				iconColor = 'FF666666';

				playAnim('idle');

				case 'ghost':
					tex = Paths.getSparrowAtlas('ghost-with-a-fucking-gun');
					frames = tex;
					animation.addByPrefix('idle', "ghost idle", 24);
					animation.addByPrefix('singUP', 'ghost up', 24, false);
					animation.addByPrefix('singDOWN', 'ghost down', 24, false);
					animation.addByPrefix('singLEFT', 'ghost left', 24, false);
					animation.addByPrefix('singRIGHT', 'ghost right', 24, false);
	
					addOffset('idle');
					addOffset("singUP");
					addOffset("singRIGHT");
					addOffset("singLEFT");
					addOffset("singDOWN");
	
					setGraphicSize(Std.int(width * 2));
					updateHitbox();

					iconColor = 'FFFFFFFF';
	
					playAnim('idle');
	
					width -= 100;
					height -= 100;
	
					antialiasing = false;

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);				

				animation.addByPrefix('hit', 'BF hit', 24, false);
				animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);
				animation.addByPrefix('attack', 'boyfriend attack', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
				addOffset('hit', 30, 25);
				addOffset('dodge', 0, -8);
				addOffset('attack', 300, 274);

				iconColor = 'FF009BFF';

				playAnim('idle');

				flipX = true;

			case 'bf-neon':
				var tex = Paths.getSparrowAtlas('BF_assets_2');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'miss up reg color', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left miss reg color', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'bf right miss reg color', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down miss reg color', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
	
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -18, -56);
				addOffset("singUPmiss", -42, 17);
				addOffset("singRIGHTmiss", -44, -14);
				addOffset("singLEFTmiss", -13, -21);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('scared', -4);

				iconColor = 'FF00E500';
	
				playAnim('idle');
	
				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('christmas/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				iconColor = 'FF009BFF';

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);

				iconColor = 'FF009BFF';

				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				iconColor = 'FF009BFF';

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'trooper':
				frames = Paths.getSparrowAtlas('trooper/trooper', 'week6');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('attack', 'attack', 24, false);

				addOffset('idle');
				addOffset("singUP", -3, 37);
				addOffset("singRIGHT", 50, -100);
				addOffset("singLEFT", 123, 0);
				addOffset("singDOWN", -20, -100);
				addOffset('attack');

				iconColor = 'FFFFFF00';

				playAnim('idle');

			case 'cluckington':
				frames = Paths.getSparrowAtlas('cluck/cluckington', 'week5');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle'); 
				addOffset("singUP", 20, 170);
				addOffset("singRIGHT", -20, -20);
				addOffset("singLEFT", 23, -12);
				addOffset("singDOWN", 40, 80);

				iconColor = 'FFFFFFFF';

				playAnim('idle');

			case 'clooshie':
				frames = Paths.getSparrowAtlas('cluck/clooshie', 'week5');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle'); 
				addOffset("singUP", 10, 170);
				addOffset("singRIGHT", -24, 0);
				addOffset("singLEFT", 23, -1);
				addOffset("singDOWN", 50, 100);

				iconColor = 'FFFF0000';

				playAnim('idle');

			case 'gooey':
				frames = Paths.getSparrowAtlas('airship/gooey', 'shared');

				animation.addByPrefix('idle', 'gooey idle', 24, false);
				animation.addByPrefix('singUP', 'gooey up', 24, false);
				animation.addByPrefix('singDOWN', 'gooey down', 24, false);
				animation.addByPrefix('singLEFT', 'gooey left', 24, false);
				animation.addByPrefix('singRIGHT', 'gooey right', 24, false);
				animation.addByPrefix('getem', 'gooey get em', 24, false);
				animation.addByPrefix('sacrifice', 'gooey sacrifice', 24, false);

				addOffset('idle');
				addOffset("singUP", 173, -7);
				addOffset("singRIGHT", 0, -79);
				addOffset("singLEFT", 230, -34);
				addOffset("singDOWN", 0, -12);
				addOffset("getem", 0, 49);
				addOffset("sacrifice", 0, 58);

				iconColor = 'FF936122';

				playAnim('idle');

			case 'gooey-squished':
				frames = Paths.getSparrowAtlas('airship/squished-Gooey', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", -1, 15);
				addOffset("singRIGHT", -6, 8);
				addOffset("singLEFT", 2, 15);
				addOffset("singDOWN", -3, -10);

				iconColor = 'FF936122';

				playAnim('idle');

			case 'mooshie':
				frames = Paths.getSparrowAtlas('mooshie/Mooshie_assets', 'shared');

				animation.addByPrefix('idle', 'Mooshie idle', 24, false);
				animation.addByPrefix('singUP', 'Mooshie up', 24, false);
				animation.addByPrefix('singDOWN', 'Mooshie down', 24, false);
				animation.addByPrefix('singLEFT', 'Mooshie left', 24, false);
				animation.addByPrefix('singRIGHT', 'Mooshie right', 24, false);

				addOffset('idle'); 
				addOffset("singUP", 3, -1);
				addOffset("singRIGHT", -12, -6);
				addOffset("singLEFT", 6, -9);
				addOffset("singDOWN", -1, -14);

				iconColor = 'FFFFFFFF';

				playAnim('idle');

			case 'supermooshie':
				frames = Paths.getSparrowAtlas('supermooshie', 'shared');
	
				animation.addByPrefix('idle', 'supermooshie idle', 24, false);
				animation.addByPrefix('singUP', 'supermooshie up', 24, false);
				animation.addByPrefix('singDOWN', 'supermooshie down', 24, false);
				animation.addByPrefix('singLEFT', 'supermooshie left', 24, false);
				animation.addByPrefix('singRIGHT', 'supermooshie right', 24, false);
				animation.addByPrefix('mad', 'supermooshie mad', 24, false);
	
				addOffset('idle'); 
				addOffset("singUP", 0, 13);
				addOffset("singRIGHT", -4, 0);
				addOffset("singLEFT", 14, 0);
				addOffset("singDOWN", 0, 5);
				addOffset("mad", 0, 69);

				iconColor = 'FFFF0000';
	
				playAnim('idle');

			case 'supermooshie-mad':
				frames = Paths.getSparrowAtlas('supermooshie-mad', 'shared');
		
				animation.addByPrefix('idle', 'supermooshie idle mad', 24, false);
				animation.addByPrefix('singUP', 'supermooshie up mad', 24, false);
				animation.addByPrefix('singDOWN', 'supermooshie down mad', 24, false);
				animation.addByPrefix('singLEFT', 'supermooshie left mad', 24, false);
				animation.addByPrefix('singRIGHT', 'supermooshie right mad', 24, false);
				animation.addByPrefix('singUP-alt', 'supermooshie up laser', 24, false);
				animation.addByPrefix('singDOWN-alt', 'supermooshie down laser', 24, false);
				animation.addByPrefix('singLEFT-alt', 'supermooshie left laser', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'supermooshie right laser', 24, false);
	
				if (PlayState.SONG.song.toLowerCase() != 'plane')
				{
					addOffset('idle'); 
					addOffset("singUP", 0, 24);
					addOffset("singRIGHT", -12, -11);
					addOffset("singLEFT", 21, -19);
					addOffset("singDOWN", 0, -15);
					addOffset("singUP-alt", 0, 200);
					addOffset("singRIGHT-alt", 0, -80);
					addOffset("singLEFT-alt", 0, -80);
					addOffset("singDOWN-alt", 0, -83);
				}
				else
				{
					addOffset('idle'); 
					addOffset("singUP", 0, 11);
					addOffset("singRIGHT", -1, -14);
					addOffset("singLEFT", 15, -14);
					addOffset("singDOWN", 0, -6);
					addOffset("singUP-alt", 0, 278);
					addOffset("singRIGHT-alt", 0, -14);
					addOffset("singLEFT-alt", 12, -14);
					addOffset("singDOWN-alt", 0, -12);
				}
				
				iconColor = 'FFFF0000';

				playAnim('idle');

			case 'bf-dodge':
				var tex = Paths.getSparrowAtlas('BF_assets_3','shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'bf dodge up', 24, false);
				animation.addByPrefix('singLEFT', 'bf dodge left', 24, false);
				animation.addByPrefix('singRIGHT', 'bf dodge right', 24, false);
				animation.addByPrefix('singDOWN', 'bf dodge down', 24, false);
				animation.addByPrefix('singUPmiss', 'bf dodge up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'bf dodge left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'bf dodge right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'bf dodge down', 24, false);

				addOffset('idle');
				addOffset("singUP", 0, 100);
				addOffset("singRIGHT");
				addOffset("singLEFT", -10, -55);
				addOffset("singDOWN", 10, -30);
				addOffset("singUPmiss", 0, 100);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss", -10, -55);
				addOffset("singDOWNmiss", 10, -30);

				iconColor = 'FF009BFF';

				playAnim('idle');

				flipX = true;
			
			case 'bf-gf':
				var tex = Paths.getSparrowAtlas('bf-gf','shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle mic', 24, false);
				animation.addByPrefix('singUP', 'up mic0', 24, false);
				animation.addByPrefix('singLEFT', 'left mic0', 24, false);
				animation.addByPrefix('singRIGHT', 'right mic0', 24, false);
				animation.addByPrefix('singDOWN', 'down mic0', 24, false);
				animation.addByPrefix('singUPmiss', 'up mic miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left mic miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'right mic miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down mic miss', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('idle');
				addOffset("singUP", 70, 0);
				addOffset("singRIGHT", 0, -3);
				addOffset("singLEFT", 83, -3);
				addOffset("singDOWN");
				addOffset("singUPmiss", 90, 0);
				addOffset("singRIGHTmiss", 20, -7);
				addOffset("singLEFTmiss", 110, 0);
				addOffset("singDOWNmiss");

				addOffset('firstDeath', 0, 3);
				addOffset('deathLoop', 0, -10);
				addOffset('deathConfirm', 0, 17);

				iconColor = 'FF969BFF';

				playAnim('idle');

				flipX = true;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-airship':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

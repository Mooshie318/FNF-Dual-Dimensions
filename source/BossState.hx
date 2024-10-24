package;

import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.input.keyboard.FlxKey;
// I just copied all that from playstate lol, most of them prob aren't needed, but idc

import GameJolt.GameJoltAPI; // gamejolt

#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class BossState extends MusicBeatState
{
	// Health
	var pHealth:Float = 20;
	var bHealth:Float = 200;
	var healthBarP:FlxBar;
	var healthBarB:FlxBar;
	var healthBarPBG:FlxSprite;
	var healthBarBBG:FlxSprite;
	var pTxt:FlxText;
	var bTxt:FlxText;

	var image:FlxSprite;
	var bg:FlxSprite;
	var g:FlxSprite;

	var bf:FlxSprite;
	var ralph:FlxSprite;

	var fallPlease:Bool = false;
	var started:Bool = false;
	var bit:Bool = false;
	var chorused:Bool = false;
	var didTheThing:Bool = false;
	var onCooldown:Bool = false;

	var mic:FlxSprite;

	var won:Bool = false;
	var lost:Bool = false;

	// Ralph's attacks
	var biteWave:FlxSprite;
	var miniBiteWave:FlxSprite;
	var superBiteWave:FlxSprite;
	var chorusSmall:FlxSprite;
	var chorusMedium:FlxSprite;
	var chorusLarge:FlxSprite;

	var biteWaveSize = FlxG.random.int(1,3);
	var timeToBWAttackS = FlxG.random.int(10,30);
	var timeToBWAttackM = FlxG.random.int(15,40);
	var timeToBWAttackL = FlxG.random.int(25,60);
	var timeForBWAttackS = FlxG.random.int(5,10);
	var didBiteWave:Bool = false;
	var bfAttacked:Bool = false;
	var phase1Attack:Bool = false;
	var phase2Attack:Bool = false;
	var phase3Attack:Bool = false;

	// Camera
	var defaultCamZoom:Float = 0.5;
	private var camFollow:FlxObject;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In a boss battle", null);
		#end

		FlxG.sound.music.stop();

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		image = new FlxSprite();
		image.frames = Paths.getSparrowAtlas('diaImage/boss', 'shared');
		image.animation.addByPrefix('idle', 'image', 24, true);
		image.antialiasing = true;
		image.scrollFactor.set(1, 1);
		image.animation.play('idle', true);
		image.screenCenter();
		image.alpha = 0;

		bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('battle/bgs/end sky', 'shared'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0, 0);
		bg.active = false;
		add(bg);

		g = new FlxSprite(756.95, 1576.25).loadGraphic(Paths.image('battle/bgs/end ground', 'shared'));
		g.antialiasing = true;
		g.scrollFactor.set(1, 1);
		g.active = false;
		add(g);

		chorusSmall = new FlxSprite(1850, g.y - 786.65).loadGraphic(Paths.image('battle/chorus fruit small', 'shared'));
		chorusSmall.antialiasing = true;
		chorusSmall.scrollFactor.set(1, 1);
		chorusSmall.active = false;
		chorusSmall.visible = false;
		add(chorusSmall);

		chorusMedium = new FlxSprite(1850, g.y - 1437.65).loadGraphic(Paths.image('battle/chorus fruit medium', 'shared'));
		chorusMedium.antialiasing = true;
		chorusMedium.scrollFactor.set(1, 1);
		chorusMedium.active = false;
		chorusMedium.visible = false;
		add(chorusMedium);

		chorusLarge = new FlxSprite(1850, g.y - 2088.05).loadGraphic(Paths.image('battle/chorus fruit large', 'shared'));
		chorusLarge.antialiasing = true;
		chorusLarge.scrollFactor.set(1, 1);
		chorusLarge.active = false;
		chorusLarge.visible = false;
		add(chorusLarge);

		ralph = new FlxSprite(899.3, 1150.9);
		ralph.frames = Paths.getSparrowAtlas('ralph', 'shared');
		ralph.animation.addByPrefix('idle', 'idle', 24, true);
		ralph.animation.addByPrefix('bite', 'bite', 24, false);
		ralph.animation.addByPrefix('dodge', 'dodge', 24, false);
		ralph.antialiasing = true;
		ralph.scrollFactor.set(1, 1);
		ralph.animation.play('idle', true);
		add(ralph);

		bf = new FlxSprite(1850, 1207.85);
		bf.frames = Paths.getSparrowAtlas('platformer/bf', 'shared');
		bf.animation.addByPrefix('idle', 'idle', 24, true);
		bf.animation.addByPrefix('walk', 'walk', 24, true);
		bf.animation.addByPrefix('jump', 'jump', 24, true);
		bf.animation.addByPrefix('fall', 'fall', 24, false);
		bf.animation.addByPrefix('hit', 'chorused', 24, true);
		bf.animation.addByPrefix('attack', 'attack', 24, false);
		bf.animation.addByPrefix('win', 'peace', 24, false);
		bf.antialiasing = true;
		bf.scrollFactor.set(1, 1);
		bf.animation.play('idle', true);
		add(bf);

		bf.acceleration.y = 0;

		healthBarPBG = new FlxSprite(1249, 0).loadGraphic(Paths.image('healthBar2', 'shared'));
		healthBarPBG.scrollFactor.set();
		healthBarPBG.screenCenter(Y);
		add(healthBarPBG);

		healthBarP = new FlxBar(healthBarPBG.x + 4, healthBarPBG.y + 4, BOTTOM_TO_TOP, Std.int(healthBarPBG.width - 8), Std.int(healthBarPBG.height - 8), this,
			'pHealth', 0, 20);
		healthBarP.scrollFactor.set();
		healthBarP.createFilledBar(FlxColor.RED, FlxColor.CYAN);
		add(healthBarP);

		healthBarBBG = new FlxSprite(50, 0).loadGraphic(Paths.image('healthBar2', 'shared'));
		healthBarBBG.scrollFactor.set();
		healthBarBBG.screenCenter(Y);
		add(healthBarBBG);

		healthBarB = new FlxBar(healthBarBBG.x + 4, healthBarBBG.y + 4, BOTTOM_TO_TOP, Std.int(healthBarBBG.width - 8), Std.int(healthBarBBG.height - 8), this,
			'bHealth', 0, 200);
		healthBarB.scrollFactor.set();
		healthBarB.createFilledBar(FlxColor.RED, FlxColor.MAGENTA);
		add(healthBarB);

		pTxt = new FlxText(healthBarPBG.x - 500, healthBarPBG.y - 40, 500, "", 20);
		pTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		pTxt.scrollFactor.set();
		pTxt.borderSize = 2.4;
		add(pTxt);

		bTxt = new FlxText(healthBarBBG.x, healthBarBBG.y - 40, 500, "", 20);
		bTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		bTxt.scrollFactor.set();
		bTxt.borderSize = 2.4;
		add(bTxt);

		image.cameras = [camHUD];
		healthBarPBG.cameras = [camHUD];
		healthBarBBG.cameras = [camHUD];
		healthBarP.cameras = [camHUD];
		healthBarB.cameras = [camHUD];
		pTxt.cameras = [camHUD];
		bTxt.cameras = [camHUD];

		camFollow = new FlxObject(bf.getGraphicMidpoint().x - 50, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		start();

		super.create();
	}

	function start():Void
	{
		add(image);

		FlxTween.tween(image, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(5, function(t:FlxTimer)
			{
				FlxTween.tween(image, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
				{
					remove(image);
					camFollow.x = bf.getMidpoint().x - (ralph.width * 1.5);
					camFollow.y = bf.getMidpoint().y;
	
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						camFollow.x = ralph.getMidpoint().x;
						camFollow.y = ralph.getMidpoint().y;
	
						new FlxTimer().start(1, function(t:FlxTimer)
						{
							camFollow.x = bf.getMidpoint().x - 50;
							camFollow.y = bf.getMidpoint().y;
	
							new FlxTimer().start(1, function(t:FlxTimer)
							{
								FlxG.sound.playMusic(Paths.music('ralphBoss'));
								started = true;
							}, 1);
						}, 1);
					}, 1);
				}});
			}, 1);
		}});
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.mouse.visible = false;
		if (started)
		{
			camFollow.x = bf.getMidpoint().x - 50;
			if (bf.y < 1400)
				camFollow.y = bf.getMidpoint().y;
		}
		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		if ((bf.x > 2187.8) || (bf.x < g.x - bf.width + 200))
		{
			bf.acceleration.y = 1000;
		}
		if (bf.x < ralph.x + ralph.width)
		{
			bf.x = ralph.x + ralph.width;
		}

		// Music stuff
		if (bHealth <= 50)
		{
			FlxG.sound.music.loopTime = 120000;
		}
		if (FlxG.sound.music.time >= 120000 && bHealth > 50)
		{
			FlxG.sound.music.time = 0;
		}

		if (ralph.animation.curAnim.name == 'bite' && ralph.animation.curAnim.finished)
		{
			if (ralph.animation.curAnim.name != 'idle')
				ralph.animation.play('idle', true);
		}

		pTxt.text = 'YOUR HEALTH: ' + pHealth;
		bTxt.text = 'BOSS HEALTH: ' + bHealth;

		if (started)
		{
			if (pHealth < 20)
				pHealth += 0.001;
			if (pHealth > 20)
				pHealth = 20;
			if (pHealth < 0)
				pHealth = 0;
			if (bHealth > 200)
				bHealth = 200;
			if (bHealth < 0)
				bHealth = 0;
			if (pHealth == 0 || bf.y >= 2000)
			{
				if (!lost)
				{
					lost = true;
					persistentUpdate = false;
					persistentDraw = false;
					FlxG.sound.music.stop();
					openSubState(new BossGameOverSubstate(bf.getScreenPosition().x, bf.getScreenPosition().y));
				}
			}
			if (bHealth == 0)
			{
				if (!won)
				{
					won = true;
					win();
				}
			}

			// Key stuff
			// Move left
			if (FlxG.keys.pressed.A)
			{
				bf.x -= 5;
				bf.flipX = false;
				if (!chorused)
				{
					if (bf.animation.curAnim.name != 'walk')
						bf.animation.play('walk', true);
				}
			}
			// Move right
			else if (FlxG.keys.pressed.D)
			{
				bf.x += 5;
				bf.flipX = true;
				if (!chorused)
				{
					if (bf.animation.curAnim.name != 'walk')
						bf.animation.play('walk', true);
				}
			}
			// Idle
			if (FlxG.keys.justReleased.A || FlxG.keys.justReleased.D)
			{
				if (!chorused)
					bf.animation.play('idle', true);
			}
			// Jump
			if (FlxG.keys.pressed.SPACE)
			{
				if (!chorused)
				{
					if (bf.animation.curAnim.name != 'jump' && bf.animation.curAnim.name != 'fall')
						bf.animation.play('jump', true);
					if (bf.y < ralph.y - ralph.height + 10)
						fallPlease = true;
					if (fallPlease)
					{
						if (bf.animation.curAnim.name != 'fall' && bf.y < 1207.85)
							bf.animation.play('fall', true);
						if (bf.y >= 1207.85)
						{
							bf.y += 0;
							fallPlease = false;
							if (bf.animation.curAnim.name != 'idle')
								bf.animation.play('idle', true);
						}
						else
							bf.y += 10;
					}
					else
						bf.y -= 10;
				}
			}
			// Fall
			if (!FlxG.keys.pressed.SPACE)
			{
				if (!chorused)
				{
					fallPlease = true;
					if (bf.animation.curAnim.name != 'fall' && bf.y < 1207.85)
						bf.animation.play('fall', true);
					if (bf.y >= 1207.85)
					{
						bf.y += 0;
						fallPlease = false;
					}
					else
						bf.y += 10;
				}
			}
			// Fast fall/Stomp
			if (FlxG.keys.pressed.SHIFT)
			{
				if (!chorused)
				{
					fallPlease = true;
					if (bf.y >= 1207.85)
					{
						bf.y += 0;
						fallPlease = false;
						if (bf.animation.curAnim.name == 'fall')
						{
							bfAttack(2);
							new FlxTimer().start(0.5, function(t:FlxTimer)
							{
								bf.animation.play('idle', true);
							}, 1);
						}
					}
					else
						bf.y += 15;
				}
			}
			// Mic throw
			if (FlxG.mouse.justPressed)
			{
				bfAttack(1);
			}

			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.switchState(new ExtrasState());
			}
			if (FlxG.keys.justPressed.R)
			{
				FlxG.resetState();
			}

			// Ralph attacks
			if (bHealth <= 200 && !phase1Attack)
			{
				bite(2);

				new FlxTimer().start(1, function(t:FlxTimer)
				{
					phase1Attack = true;
					didBiteWave = true;
				}, 1);
			}
			if (bHealth <= 150 && !phase2Attack)
			{
				bite(3);
				new FlxTimer().start(1, function(t:FlxTimer)
				{
					phase2Attack = true;
					didBiteWave = true;
				}, 1);
			}
			if (bHealth <= 100 && !phase3Attack)
			{
				bite(2);
				new FlxTimer().start(1, function(t:FlxTimer)
				{
					phase3Attack = true;
					didBiteWave = true;
				}, 1);
			}
			if (bHealth <= 50 && FlxG.sound.music.time >= 120000)
			{
				bite(1);
			}
			if (didBiteWave)
			{
				chorusFruit(FlxG.random.int(1,3));
			}
			if (bfAttacked)
			{
				if (!didBiteWave)
				{
					switch(biteWaveSize)
					{
						case 1:
							bite(1);

							new FlxTimer().start(timeForBWAttackS, function(t:FlxTimer)
							{
								didBiteWave = true;
								bfAttacked = false;
							}, 1);
						case 2:
							bite(2);

							new FlxTimer().start(1, function(t:FlxTimer)
							{
								didBiteWave = true;
								bfAttacked = false;
							}, 1);
					}
				}
			}
		}

		super.update(elapsed);
	}

	function bfAttack(a:Int):Void
	{
		switch(a)
		{
			// Mic throw
			case 1:
				if (!onCooldown)
				{
					onCooldown = true;
					remove(mic);
					mic = new FlxSprite(bf.x, bf.y + bf.height / 2).loadGraphic(Paths.image('battle/mic', 'shared'));
					mic.antialiasing = true;
					mic.scrollFactor.set(1, 1);
					mic.active = false;
					mic.flipX = true;

					if (bf.animation.curAnim.name != 'attack')
						bf.animation.play('attack', true, false, 9);

					if (bf.animation.curAnim.name == 'attack' && bf.animation.curAnim.curFrame == 9)
					{
						add(mic);
						FlxTween.tween(mic, {x: bf.x - 800}, 0.2, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							if (mic.x <= ralph.x + ralph.width && mic.y >= ralph.y)
							{
								var dodgeChance = FlxG.random.bool(75);
								
								if (dodgeChance == false)
									bHealth -= 5;
								else
								{
									if (ralph.animation.curAnim.name != 'dodge')
										ralph.animation.play('dodge', true);
								}
							}
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								mic.flipX = false;
								FlxTween.tween(mic, {x: bf.x}, 0.2, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
								{
									remove(mic);
									bf.animation.play('idle', true);
									if (ralph.animation.curAnim.name != 'idle')
										ralph.animation.play('idle', true);

									if (bHealth > 50)
									{
										new FlxTimer().start(1.5, function(t:FlxTimer)
										{
											bfAttacked = true;
											biteWaveSize = FlxG.random.int(1,2);
										}, 1);
									}

									new FlxTimer().start(3, function(t:FlxTimer)
									{
										onCooldown = false;
									}, 1);
								}});
							}, 1);
						}});
					}
				}
			// Stomp
			case 2:
				if (!onCooldown)
				{
					onCooldown = true;

					var healthLost = FlxG.random.int(2,10);
					bHealth -= healthLost;

					new FlxTimer().start(0.5, function(t:FlxTimer)
					{
						bf.animation.play('idle', true);
					}, 1);

					new FlxTimer().start(6, function(t:FlxTimer)
					{
						onCooldown = false;
					}, 1);
				}
		}
	}

	function bite(size:Int):Void
	{
		switch(size)
		{
			case 1:
				if (ralph.animation.curAnim.name == 'idle' && ralph.animation.curAnim.curFrame == 0)
				{
					remove(miniBiteWave);
					miniBiteWave = new FlxSprite(ralph.x + ralph.width, ralph.getMidpoint().y - 62).loadGraphic(Paths.image('battle/mini bite wave', 'shared'));
					miniBiteWave.antialiasing = true;
					miniBiteWave.scrollFactor.set(1, 1);
					miniBiteWave.active = false;
					add(miniBiteWave);

					FlxTween.tween(miniBiteWave, {x: bf.x}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
					{
						if (bf.y + 198.25 > miniBiteWave.y)
						{
							pHealth -= 0.2;
							remove(miniBiteWave);
						}
						remove(miniBiteWave);
					}});
				}
			case 2:
				if (ralph.animation.curAnim.name != 'bite')
					ralph.animation.play('bite', true);
				if (ralph.animation.curAnim.name == 'bite' && ralph.animation.curAnim.curFrame == 15)
				{
					bit = true;
					remove(biteWave);
					biteWave = new FlxSprite(ralph.x + ralph.width, ralph.getMidpoint().y - 62).loadGraphic(Paths.image('battle/bite wave', 'shared'));
					biteWave.antialiasing = true;
					biteWave.scrollFactor.set(1, 1);
					biteWave.active = false;
					add(biteWave);

					FlxTween.tween(biteWave, {x: bf.x}, 0.3, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
					{
						if (bf.y + 198.25 > biteWave.y)
						{
							pHealth -= 0.6;
							remove(biteWave);
						}
						remove(biteWave);
						bit = false;
					}});
				}
			case 3:
				if (ralph.animation.curAnim.name != 'bite')
					ralph.animation.play('bite', true);
				if (ralph.animation.curAnim.name == 'bite' && ralph.animation.curAnim.curFrame == 15)
				{
					bit = true;
					remove(superBiteWave);
					superBiteWave = new FlxSprite(ralph.x + ralph.width, ralph.getMidpoint().y - 62).loadGraphic(Paths.image('battle/super bite wave', 'shared'));
					superBiteWave.antialiasing = true;
					superBiteWave.scrollFactor.set(1, 1);
					superBiteWave.active = false;
					add(superBiteWave);

					FlxTween.tween(superBiteWave, {x: bf.x}, 0.2, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
					{
						if (bf.y + bf.height > superBiteWave.y)
						{
							pHealth -= 1;
							remove(superBiteWave);
						}
						remove(superBiteWave);
						bit = false;
					}});
				}
		}
	}

	function chorusFruit(size:Int):Void
	{
		switch (size)
		{
			case 1:
				if (!didTheThing && didBiteWave)
				{
					chorusSmall.visible = true;
					didTheThing = true;
				}

				if (chorusSmall.visible && bf.x > chorusSmall.x - 1 && bf.x < chorusSmall.x + chorusSmall.width + 1)
				{
					if (!chorused)
						chorused = true;
					if (chorused)
					{
						if (bf.animation.curAnim.name != 'hit')
							bf.animation.play('hit', true);
					}
				}
				if (chorusSmall.visible)
				{
					if (bf.x < chorusSmall.x - bf.width || bf.x > chorusSmall.x + chorusSmall.width)
					{
						chorused = false;
						chorusSmall.visible = false;
						didTheThing = false;
						didBiteWave = false;
					}
					else
					{
						pHealth -= 0.005;
						bf.y = chorusSmall.y - bf.height;
					}
				}
			case 2:
				if (!didTheThing && didBiteWave)
				{
					chorusMedium.visible = true;
					didTheThing = true;
				}

				if (chorusMedium.visible && bf.x > chorusMedium.x - 1 && bf.x < chorusMedium.x + chorusMedium.width + 1)
				{
					if (!chorused)
						chorused = true;
					if (chorused)
					{
						if (bf.animation.curAnim.name != 'hit')
							bf.animation.play('hit', true);
					}
				}
				if (chorusMedium.visible)
				{
					if (bf.x < chorusMedium.x - bf.width || bf.x > chorusMedium.x + chorusMedium.width)
					{
						chorused = false;
						chorusMedium.visible = false;
						didTheThing = false;
						didBiteWave = false;
					}
					else
					{
						pHealth -= 0.0075;
						bf.y = chorusMedium.y - bf.height;
					}
				}
			case 3:
				if (!didTheThing && didBiteWave)
				{
					chorusLarge.visible = true;
					didTheThing = true;
				}
	
				if (chorusLarge.visible && bf.x > chorusLarge.x - 1 && bf.x < chorusLarge.x + chorusLarge.width + 1)
				{
					if (!chorused)
						chorused = true;
					if (chorused)
					{
						if (bf.animation.curAnim.name != 'hit')
							bf.animation.play('hit', true);
					}
				}
				if (chorusLarge.visible)
				{
					if (bf.x < chorusLarge.x - bf.width || bf.x > chorusLarge.x + chorusLarge.width)
					{
						chorused = false;
						chorusLarge.visible = false;
						didTheThing = false;
						didBiteWave = false;
					}
					else
					{
						pHealth -= 0.01;
						bf.y = chorusLarge.y - bf.height;
					}
				}
		}
	}

	function win():Void
	{
		started = false;
		FlxG.sound.music.fadeOut(0.5, 0);

		FlxTween.tween(ralph, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(0.5, function(t:FlxTimer)
			{
				defaultCamZoom = 0.9;
				FlxG.sound.play(Paths.sound('chi', 'shared'));
				FlxG.sound.music.stop();
				bf.animation.play('win', true);
				FlxG.save.data.beatRalphBoss = true;
				// "Ralph" achievement
				GameJoltAPI.getTrophy(189083);
				checkAchievement("Ralph");
				new FlxTimer().start(1, function(t:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				}, 1);
			}, 1);
		}});
	}

	// Notifications and Achievements
	function checkAchievement(a:String):Void
	{
		var e:Array<String> = FlxG.save.data.achievementsEarned;
		var tbe:Array<String> = FlxG.save.data.achievementsToBeEarned;

		FlxG.save.data.achievementsToBeEarned.push(a);

		for (i in e)
		{
			for (j in tbe)
			{
				if (i == a && j == i)
					FlxG.save.data.achievementsToBeEarned.splice(FlxG.save.data.achievementsToBeEarned.indexOf(j), 1); // Removes j from achievementsToBeEarned
			}
		}
	}
}
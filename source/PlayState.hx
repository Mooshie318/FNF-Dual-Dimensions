package;

import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
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

import GameJolt.GameJoltAPI; // gamejolt

#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var doof:DialogueBox;
	var doof2:DialogueBox; // end of week dialogue

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	// 2v1
	var james:Character;
	var ghost:Character;
	var sheary:Character;
	var cluck:Character;
	var cloosh:Character;
	var trooper:Character;
	var gooey:Character;
	var supermooshie:Character;

	var stickletto:Character;
	var sticko:Character;
	var stickletta:Character;
	var clonerman:Character;
	var clone1:Character;
	var clone2:Character;
	var sticklettabow:Character;
	var swordletto:Character;
	var striker:Character;
	var stlaw:Character;
	var stickannon:Character;
	var stibow:Character;

	var isBf:Bool = false;
	var isDad:Bool = false;
	var isJames:Bool = false;
	var isGhost:Bool = false;
	var isSheary:Bool = false;
	var isCluck:Bool = false;
	var isCloosh:Bool = false;
	var isTrooper:Bool = false;
	var isGooey:Bool = false;
	var isSupermooshie:Bool = false;

	var isStickletto:Bool = false;
	var isSticko:Bool = false;
	var isStickletta:Bool = false;
	var isCloneerman:Bool = false;
	var isClone1:Bool = false;
	var isSticklettabow:Bool = false;
	var isSwordletto:Bool = false;

	var p1Char:String = 'bf';

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	private var floatShit:Float = 0;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTOP:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var diaEnd:Array<String> = ['lolol', 'my ass']; // end of week dialogue

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	// FNM Custom vars
	// bgs
	var moo:FlxSprite; // for changing background mid-song
	var cyan:FlxSprite; //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	var redR:FlxSprite;
	var clouds:FlxSprite;
	var shading:FlxSprite;
	var l:FlxSprite;
	// moovenge /kill
	var qwerty:FlxText;
	var spaceCounter:Int = 0;
	// battle mechanic
	var checkmark:FlxSprite;
	var dodgeSprite:FlxSprite;
	var dodgeSprite2:FlxSprite;
	var dodgeSprite3:FlxSprite;
	var attackSprite:FlxSprite;
	var canAttack:Bool = false;
	var canDodge:Bool = false;
	var canDodgeL:Bool = false;
	var canDodgeR:Bool = false;
	var dodged:Bool = false;
	var dodgedL:Bool = false;
	var dodgedR:Bool = false;
	var attacked:Bool = false;
	var hit:Bool = false;
	var attacking:Bool = false;
	var dodging:Bool = false;
	var dodgeCounter:Int = 0;
	var dodgeLCounter:Int = 0;
	var dodgeRCounter:Int = 0;
	var attackCounter:Int = 0;
	// Ralph battle mechanic
	var isInRalphBattle:Bool = false;
	var biteWave:FlxSprite;
	var isJumping:Bool = false;
	var jumpTimer:Float = 0; // For variable jump heights
	var bfMaxY:Float = 610.45;
	var ralphCanAttack:Bool = false;
	var lostHealpth:Bool = false;
	var playedAnim:Bool = false;
	// cool color chaniging shit
	var leCoolBl:FlxSprite;
	var leCoolB:FlxSprite;
	var leCoolG:FlxSprite;
	var leCoolP:FlxSprite;
	var leCoolR:FlxSprite;
	var leCoolO:FlxSprite;
	// ice note
	var frozen:Bool = false;
	var freezeOverlay:FlxSprite;
	var freezeCount:Int = 0;
	var freezeTime = FlxG.random.int(1, 3);
	// item mechanic
	var block:FlxSprite;
	var item = FlxG.random.int(1,13);
	var itemTime:Int = 5;
	var timeOver:Bool = false;
	var timeToAppear = FlxG.random.int(30,90);
	var timerUgh:FlxTimer;
	var usedTotem:Bool = false;
	var totemEnded:Bool = false;
	var hasStar:Bool = false;
	var drainAmount:Float = 0.004;
	var hasDrainEffect:Bool = false;
	var noteMoveAmount1 = FlxG.random.int(30,100);
	var noteMoveAmount2 = FlxG.random.int(30,100);
	var noteMoveAmount3 = FlxG.random.int(30,100);
	var noteMoveAmount4 = FlxG.random.int(30,100);
	var wall:FlxSprite;
	var hasWallEffect:Bool = false;
	var hasX2Effect:Bool = false;
	var fire:FlxSprite;
	// note blocking mechanic
	var leftBlocked:Bool = false;
	var downBlocked:Bool = false;
	var upBlocked:Bool = false;
	var rightBlocked:Bool = false;
	// Dark-Purple stuff
	var dpATtime:Float = 1;
	var dpBLtime:Float = 10;
	var dpCancels:Int = 10;
	var dpIsBLing:Bool = false;
	var dpTimerStarted:Bool = false;
	var dpTimerTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;

	public var executeModchart = false;

	// LUA SHIT
		
	public static var lua:State = null;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);

		if (getLuaErrorMessage(lua) != null)
			trace(func_name + ' LUA CALL ERROR ' + Lua.tostring(lua,result));

		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
				return boyfriend;
			case 'girlfriend':
				return gf;
			case 'dad':
				return dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
			return strumLineNotes.members[Std.parseInt(id)];
		return luaSprites.get(id);
	}

	public static var luaSprites:Map<String,FlxSprite> = [];



	function makeLuaSprite(spritePath:String,toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
		{
			scale = 1;
		}

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
		if (drawBehind)
		{
			remove(gf);
			remove(boyfriend);
			remove(dad);
		}
		add(sprite);
		if (drawBehind)
		{
			add(gf);
			add(boyfriend);
			add(dad);
		}
		#end
		return toBeCalled;
	}

	// LUA SHIT

	override public function create()
	{

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Duet";
			case 4:
				storyDifficultyText = "Fuckyou";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camTOP = new FlxCamera();
		camTOP.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTOP);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale);

		if (FlxG.save.data.dialogue)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dialogue = CoolUtil.coolTextFile(Paths.txt('tutorial/dia'));
				case 'icy':
					dialogue = CoolUtil.coolTextFile(Paths.txt('icy/dia'));
				case 'fire':
					dialogue = CoolUtil.coolTextFile(Paths.txt('fire/dia'));
				case 'slime-attack':
					dialogue = CoolUtil.coolTextFile(Paths.txt('slime-attack/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('slime-attack/diaEnd')); // end of week dialogue
				case 'interview':
					dialogue = CoolUtil.coolTextFile(Paths.txt('interview/dia'));
				case 'drive-thru':
					dialogue = CoolUtil.coolTextFile(Paths.txt('drive-thru/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('drive-thru/diaEnd')); // end of week dialogue
				case 'boo':
					dialogue = CoolUtil.coolTextFile(Paths.txt('boo/dia'));
				case 'haunted':
					diaEnd = CoolUtil.coolTextFile(Paths.txt('haunted/diaEnd')); // end of week dialogue
				case 'cloud':
					dialogue = CoolUtil.coolTextFile(Paths.txt('cloud/dia'));
				case 'sheary':
					dialogue = CoolUtil.coolTextFile(Paths.txt('sheary/dia'));
				case 'monster-cloud':
					dialogue = CoolUtil.coolTextFile(Paths.txt('monster-cloud/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('monster-cloud/diaEnd')); // end of week dialogue
				case 'cluck':
					dialogue = CoolUtil.coolTextFile(Paths.txt('cluck/dia'));
				case 'clooshie':
					dialogue = CoolUtil.coolTextFile(Paths.txt('clooshie/dia'));
				case 'fight-for-life':
					dialogue = CoolUtil.coolTextFile(Paths.txt('fight-for-life/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('fight-for-life/diaEnd')); // end of week dialogue
				case 'trooper':
					dialogue = CoolUtil.coolTextFile(Paths.txt('trooper/dia'));
				case 'shell':
					dialogue = CoolUtil.coolTextFile(Paths.txt('shell/dia'));
				case 'attack':
					dialogue = CoolUtil.coolTextFile(Paths.txt('attack/dia'));
				case 'gooey':
					dialogue = CoolUtil.coolTextFile(Paths.txt('gooey/dia'));
				case 'sacrifice':
					dialogue = CoolUtil.coolTextFile(Paths.txt('sacrifice/dia'));
				case 'moo':
					dialogue = CoolUtil.coolTextFile(Paths.txt('moo/dia'));
				case 'mooshie':
					dialogue = CoolUtil.coolTextFile(Paths.txt('mooshie/dia'));
				case 'showdown':
					dialogue = CoolUtil.coolTextFile(Paths.txt('showdown/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('showdown/diaEnd')); // end of week dialogue
				case 'red':
					dialogue = CoolUtil.coolTextFile(Paths.txt('red/dia'));
				case 'light-speed':
					dialogue = CoolUtil.coolTextFile(Paths.txt('light-speed/dia'));
				case 'moo-storm':
					dialogue = CoolUtil.coolTextFile(Paths.txt('moo-storm/dia'));
				case '7391203':
					dialogue = CoolUtil.coolTextFile(Paths.txt('7391203/dia'));
				case 'moosanity':
					dialogue = CoolUtil.coolTextFile(Paths.txt('moosanity/dia'));
				case 'moovenge':
					dialogue = CoolUtil.coolTextFile(Paths.txt('moovenge/dia'));
				case 'plane':
					dialogue = CoolUtil.coolTextFile(Paths.txt('plane/dia'));
				case 'air-battle':
					dialogue = CoolUtil.coolTextFile(Paths.txt('air-battle/dia'));
				case 'thunder-storm':
					dialogue = CoolUtil.coolTextFile(Paths.txt('thunder-storm/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('thunder-storm/diaEnd')); // end of week dialogue
				case 'lemons':
					dialogue = CoolUtil.coolTextFile(Paths.txt('lemons/dia'));
				case 'freezing':
					dialogue = CoolUtil.coolTextFile(Paths.txt('freezing/dia'));
				case 'burning':
					dialogue = CoolUtil.coolTextFile(Paths.txt('burning/dia'));
				case 'slimy':
					dialogue = CoolUtil.coolTextFile(Paths.txt('slimy/dia'));
				case 'slime-rematch':
					dialogue = CoolUtil.coolTextFile(Paths.txt('slime-rematch/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('slime-rematch/diaEnd')); // end of week dialogue
				case 'all-around-you':
					dialogue = CoolUtil.coolTextFile(Paths.txt('all-around-you/dia'));
				case 'sticks-n-stones':
					dialogue = CoolUtil.coolTextFile(Paths.txt('sticks-n-stones/dia'));
				case 'branching-out':
					dialogue = CoolUtil.coolTextFile(Paths.txt('branching-out/dia'));
				case 'logging-in':
					dialogue = CoolUtil.coolTextFile(Paths.txt('logging-in/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('logging-in/diaEnd')); // end of week dialogue
				case 'gooey-battle':
					dialogue = CoolUtil.coolTextFile(Paths.txt('gooey-battle/dia'));
				case 'fire-battle':
					dialogue = CoolUtil.coolTextFile(Paths.txt('fire-battle/dia'));
				case 'moo-battle':
					dialogue = CoolUtil.coolTextFile(Paths.txt('moo-battle/dia'));
				case 'stickletta':
					dialogue = CoolUtil.coolTextFile(Paths.txt('stickletta/dia'));
				case 'hot-pink':
					dialogue = CoolUtil.coolTextFile(Paths.txt('hot-pink/dia'));
				case 'friends':
					dialogue = CoolUtil.coolTextFile(Paths.txt('friends/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('friends/diaEnd')); // end of week dialogue
				case 'duplication':
					dialogue = CoolUtil.coolTextFile(Paths.txt('duplication/dia'));
				case 'darkness':
					dialogue = CoolUtil.coolTextFile(Paths.txt('darkness/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('darkness/diaEnd')); // end of week dialogue
				case 'trust':
					dialogue = CoolUtil.coolTextFile(Paths.txt('trust/dia'));
				case 'team-up':
					dialogue = CoolUtil.coolTextFile(Paths.txt('team-up/dia'));
				case 'fury':
					dialogue = CoolUtil.coolTextFile(Paths.txt('fury/dia'));
				case 'rage':
					dialogue = CoolUtil.coolTextFile(Paths.txt('rage/dia'));
				case 'fiery-madness':
					dialogue = CoolUtil.coolTextFile(Paths.txt('fiery-madness/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('fiery-madness/diaEnd')); // end of week dialogue
				case 'ff0000':
					dialogue = CoolUtil.coolTextFile(Paths.txt('ff0000/dia'));
				case 'laser':
					dialogue = CoolUtil.coolTextFile(Paths.txt('laser/dia'));
				case '00ffff':
					dialogue = CoolUtil.coolTextFile(Paths.txt('00ffff/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('00ffff/diaEnd')); // end of week dialogue
				case 'hit-and-miss':
					dialogue = CoolUtil.coolTextFile(Paths.txt('hit-and-miss/dia'));
				case 'yellow':
					dialogue = CoolUtil.coolTextFile(Paths.txt('yellow/dia'));
				case 'teleportation':
					dialogue = CoolUtil.coolTextFile(Paths.txt('teleportation/dia'));
				case 'ffff00':
					dialogue = CoolUtil.coolTextFile(Paths.txt('ffff00/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('ffff00/diaEnd')); // end of week dialogue
				case 'recovery':
					dialogue = CoolUtil.coolTextFile(Paths.txt('recovery/dia'));
				case 'striker':
					dialogue = CoolUtil.coolTextFile(Paths.txt('striker/dia'));
					diaEnd = CoolUtil.coolTextFile(Paths.txt('striker/diaEnd')); // end of week dialogue
				case 'sticklettabreaker':
					diaEnd = CoolUtil.coolTextFile(Paths.txt('sticklettabreaker/diaEnd')); // end of week dialogue
				case 'bite-wave':
					dialogue = CoolUtil.coolTextFile(Paths.txt('bite-wave/dia'));
				case 'dark-purple':
					dialogue = CoolUtil.coolTextFile(Paths.txt('dark-purple/dia'));

				/*
					TEMPLATE

					dialogue = CoolUtil.coolTextFile(Paths.txt('/dia')); // normal dialogue
					diaEnd = CoolUtil.coolTextFile(Paths.txt('/diaEnd')); // end of week/song dialogue
				*/
			}
		}

		switch(SONG.song.toLowerCase())
		{
			case 'interview' | 'drive-thru':
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'boo' | 'haunted' | 'ghost': 
			{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
					add(street);
			}
			case 'cloud' | 'sheary':
			{
				defaultCamZoom = 0.6;
				curStage = 'sky';
				var sky:FlxSprite = new FlxSprite(22, 0).loadGraphic(Paths.image('sky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				add(sky);

				clouds = new FlxSprite(389, 856).loadGraphic(Paths.image('clouds'));
				clouds.antialiasing = true;
				clouds.scrollFactor.set(1, 1);
				clouds.active = false;
				add(clouds);
			}
			case 'monster-cloud':
			{
				defaultCamZoom = 0.6;
				curStage = 'skymad';
				var sky:FlxSprite = new FlxSprite(22, 0).loadGraphic(Paths.image('sky2'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				add(sky);

				clouds = new FlxSprite(1096, 865).loadGraphic(Paths.image('clouds2'));
				clouds.antialiasing = true;
				clouds.scrollFactor.set(1, 1);
				clouds.active = false;
				add(clouds);
			}
			case 'cluck' | 'clooshie':
			{
				curStage = 'cluck';

				defaultCamZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-5, -16).loadGraphic(Paths.image('cluck/sky', 'week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var bfgfP:FlxSprite = new FlxSprite(1975, 1103).loadGraphic(Paths.image('cluck/bfgf-p', 'week5'));
				bfgfP.updateHitbox();
				bfgfP.antialiasing = true;
				bfgfP.scrollFactor.set(1, 1);
				bfgfP.active = false;
				add(bfgfP);

				var clP:FlxSprite = new FlxSprite(752, 1115).loadGraphic(Paths.image('cluck/cl-p', 'week5'));
				clP.updateHitbox();
				clP.antialiasing = true;
				clP.scrollFactor.set(1, 1);
				clP.active = false;
				add(clP);
			}
			case 'fight-for-life':
			{
				curStage = 'cluckEvil';

				defaultCamZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-5, -16).loadGraphic(Paths.image('cluck/bg', 'week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var bfgfP:FlxSprite = new FlxSprite(1975, 1103).loadGraphic(Paths.image('cluck/bfgf-p2', 'week5'));
				bfgfP.updateHitbox();
				bfgfP.antialiasing = true;
				bfgfP.scrollFactor.set(1, 1);
				bfgfP.active = false;
				add(bfgfP);

				var clP:FlxSprite = new FlxSprite(752, 1115).loadGraphic(Paths.image('cluck/cl-p2', 'week5'));
				clP.updateHitbox();
				clP.antialiasing = true;
				clP.scrollFactor.set(1, 1);
				clP.active = false;
				add(clP);
			}
			case 'trooper' | 'shell' | 'attack':
			{
				curStage = 'sky2';

				defaultCamZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-5, -16).loadGraphic(Paths.image('trooper/sky', 'week6'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var cl:FlxSprite = new FlxSprite(2047, 1041).loadGraphic(Paths.image('trooper/cloud', 'week6'));
				cl.updateHitbox();
				cl.antialiasing = true;
				cl.scrollFactor.set(1, 1);
				cl.active = false;
				add(cl);
			}
			case 'gooey' | 'sacrifice' | 'squash':
			{
				curStage = 'airship';

				defaultCamZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-5, -16).loadGraphic(Paths.image('airship/sky', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var b:FlxSprite = new FlxSprite(770, 1177).loadGraphic(Paths.image('airship/base', 'shared'));
				b.updateHitbox();
				b.antialiasing = true;
				b.scrollFactor.set(1, 1);
				b.active = false;
				add(b);
			}
			case 'moo' | 'mooshie':
			{
				defaultCamZoom = 0.7;
				curStage = 'mooStage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('mooshie/mooStage'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}
			case 'showdown' | 'red-old' | 'red' | 'light-speed-old' | 'light-speed' | 'moo-storm' | '7391203':
			{
				defaultCamZoom = 0.7;
				curStage = 'mooStageEvil';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('mooshie/mooStageEvil'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				leCoolBl = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/black'));
				leCoolBl.antialiasing = true;
				leCoolBl.alpha = 0;
				leCoolBl.scrollFactor.set(0, 0);
				leCoolBl.active = false;
				leCoolBl.visible = false;
				add(leCoolBl);

				leCoolB = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/blue'));
				leCoolB.antialiasing = true;
				leCoolB.scrollFactor.set(0, 0);
				leCoolB.active = false;
				leCoolB.visible = false;
				add(leCoolB);

				leCoolG = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/green'));
				leCoolG.antialiasing = true;
				leCoolG.scrollFactor.set(0, 0);
				leCoolG.active = false;
				leCoolG.visible = false;
				add(leCoolG);

				leCoolP = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/pink'));
				leCoolP.antialiasing = true;
				leCoolP.scrollFactor.set(0, 0);
				leCoolP.active = false;
				leCoolP.visible = false;
				add(leCoolP);

				leCoolR = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/red'));
				leCoolR.antialiasing = true;
				leCoolR.scrollFactor.set(0, 0);
				leCoolR.active = false;
				leCoolR.visible = false;
				add(leCoolR);

				leCoolO = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/oramge'));
				leCoolO.antialiasing = true;
				leCoolO.scrollFactor.set(0, 0);
				leCoolO.active = false;
				leCoolO.visible = false;
				add(leCoolO);
			}

			case 'moosanity-old' | 'moosanity' | 'moovenge':
			{
				defaultCamZoom = 0.6;
				curStage = 'mooStageInsane';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('mooshie/mooStageInsane'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(150, 750).loadGraphic(Paths.image('mooshie/mooStageInsaneGround'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1.0, 1.0);
				stageFront.active = false;
				add(stageFront);
			}
			case 'plane':
			{
				defaultCamZoom = 0.6;
				curStage = 'plane';
				var sky:FlxSprite = new FlxSprite(9, 9).loadGraphic(Paths.image('plane/sky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				add(sky);

				var c1:FlxSprite = new FlxSprite(2560, 218);
				c1.frames = Paths.getSparrowAtlas('plane/cl1');
				c1.animation.addByPrefix('idle', 'clouds', 24, true);
				c1.antialiasing = true;
				c1.scrollFactor.set(1, 1);
				c1.animation.play('idle', true);
				add(c1);

				var c2:FlxSprite = new FlxSprite(537, 538);
				c2.frames = Paths.getSparrowAtlas('plane/cl2');
				c2.animation.addByPrefix('idle', 'cl2', 24, true);
				c2.antialiasing = true;
				c2.scrollFactor.set(1, 1);
				c2.animation.play('idle', true);
				add(c2);

				var plane:FlxSprite = new FlxSprite(125, 453).loadGraphic(Paths.image('plane/plane'));
				plane.antialiasing = true;
				plane.scrollFactor.set(1, 1);
				plane.active = false;
				add(plane);
			}
			case 'air-battle' | 'thunder-storm':
			{
				defaultCamZoom = 0.6;
				curStage = 'plane-air-battle';
				var sky:FlxSprite = new FlxSprite(9, 9).loadGraphic(Paths.image('plane/sky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				add(sky);

				var c1:FlxSprite = new FlxSprite(2560, 218);
				c1.frames = Paths.getSparrowAtlas('plane/cl1');
				c1.animation.addByPrefix('idle', 'clouds', 24, true);
				c1.antialiasing = true;
				c1.scrollFactor.set(1, 1);
				c1.animation.play('idle', true);
				add(c1);

				var c2:FlxSprite = new FlxSprite(537, 538);
				c2.frames = Paths.getSparrowAtlas('plane/cl2');
				c2.animation.addByPrefix('idle', 'cl2', 24, true);
				c2.antialiasing = true;
				c2.scrollFactor.set(1, 1);
				c2.animation.play('idle', true);
				add(c2);

				var plane:FlxSprite = new FlxSprite(125, 453).loadGraphic(Paths.image('plane/plane'));
				plane.antialiasing = true;
				plane.scrollFactor.set(1, 1);
				plane.active = false;
				add(plane);
			}
			case 'gooey-battle':
			{
				curStage = 'airship-front';

				defaultCamZoom = 0.8;

				var bg:FlxSprite = new FlxSprite(-5, -16).loadGraphic(Paths.image('battle/bgs/sky', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var b:FlxSprite = new FlxSprite(1622, 731).loadGraphic(Paths.image('battle/bgs/base', 'shared'));
				b.updateHitbox();
				b.antialiasing = true;
				b.scrollFactor.set(1, 1);
				b.active = false;
				add(b);
			}
			case 'fire-battle':
			{
				curStage = 'void';

				defaultCamZoom = 0.8;

				leCoolBl = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/black'));
				leCoolBl.antialiasing = true;
				leCoolBl.alpha = 0;
				leCoolBl.scrollFactor.set(1, 1);
				leCoolBl.active = false;
				leCoolBl.visible = false;
				add(leCoolBl);
			}
			case 'moo-battle':
			{
				curStage = 'mooStageFront';

				defaultCamZoom = 0.8;

				var bg:FlxSprite = new FlxSprite(4, 4).loadGraphic(Paths.image('battle/bgs/mooStageFront', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var g:FlxSprite = new FlxSprite(1603, 1318).loadGraphic(Paths.image('battle/bgs/mooStageFrontGround', 'shared'));
				g.antialiasing = true;
				g.scrollFactor.set(1, 1);
				g.active = false;
				add(g);
			}
			case 'all-around-you':
			{
				defaultCamZoom = 0.5;
				curStage = 'aay';
				var bg:FlxSprite = new FlxSprite(8, -3288).loadGraphic(Paths.image('aay/bg', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			}
			case 'alan' | 'sticks-n-stones' | 'branching-out' | 'logging-in':
			{
				defaultCamZoom = 0.9;
				curStage = 'stick';
				var bg:FlxSprite = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.WHITE);
				add(bg);
			}
			case 'stickletta' | 'hot-pink' | 'friends':
				defaultCamZoom = 0.9;
				curStage = 'lime';
				var bg:FlxSprite = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.LIME);
				add(bg);
			case 'duplication' | 'darkness':
				defaultCamZoom = 0.9;
				curStage = 'red';
				redR = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.RED);
				add(redR);
				cyan = new FlxSprite(-600, -200).makeGraphic(3000, 3000, 0xFF3399FF);
			case 'enemy':
				defaultCamZoom = 0.9;
				curStage = 'stick2';
				var bg:FlxSprite = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.WHITE);
				add(bg);
			case 'trust' | 'team-up':
				defaultCamZoom = 0.9;
				curStage = 'stick3';
				var bg:FlxSprite = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.WHITE);
				add(bg);
			case 'infecto' | 'recovery':
				defaultCamZoom = 0.9;
				curStage = 'wellow';
				redR = new FlxSprite(-600, -200).loadGraphic(Paths.image('infecto bg', 'shared'));
				redR.antialiasing = true;
				redR.scrollFactor.set(1, 1);
				redR.active = false;
				add(redR);
			case 'striker':
				defaultCamZoom = 0.9;
				curStage = 'wellow2'; // curSong in the shitty layering won't work so gotta do this
				redR = new FlxSprite(-600, -200).loadGraphic(Paths.image('infecto bg', 'shared'));
				redR.antialiasing = true;
				redR.scrollFactor.set(1, 1);
				redR.active = false;
				add(redR);
			case 'yellow' | 'teleportation' | 'ffff00':
				defaultCamZoom = 0.9;
				curStage = 'blue';
				cyan = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.BLUE);
				add(cyan);
				redR = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.YELLOW);
			case 'ff0000' | 'laser' | '00ffff':
			{
				defaultCamZoom = 0.9;
				curStage = 'cyan';
				cyan = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.CYAN);
				add(cyan);
				redR = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.RED);
			}
			case 'fury' | 'rage' | 'fiery-madness':
			{
				defaultCamZoom = 0.9;
				curStage = 'sburn';
				var bg:FlxSprite = new FlxSprite(-600, -200).makeGraphic(3000, 3000, 0xFF7F0000);
				add(bg);

				var holes:FlxSprite = new FlxSprite(120, 420).loadGraphic(Paths.image('holes', 'shared'));
				holes.updateHitbox();
				holes.antialiasing = true;
				holes.scrollFactor.set(1, 1);
				holes.active = false;
				add(holes);

				var platform:FlxSprite = new FlxSprite(541, 832).loadGraphic(Paths.image('platform', 'shared'));
				platform.updateHitbox();
				platform.antialiasing = true;
				platform.scrollFactor.set(1, 1);
				platform.active = false;
				add(platform);
			}
			case 'crock':
			{
				defaultCamZoom = 0.6;
				curStage = 'green';
				cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFF107500);
				add(cyan);
			}
			case 'switch' | 'bite':
			{
				defaultCamZoom = 0.6;
				curStage = 'green2';
				cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFF107500);
				add(cyan);
			}
			case 'crocker':
			{
				defaultCamZoom = 0.6;
				curStage = 'green3';
				cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFFA000BA); // Not even green lol
				add(cyan);
			}
			case 'sticklettabreaker':
			{
				defaultCamZoom = 0.9;
				curStage = 'stickbreaker';
				cyan = new FlxSprite(-600, -200).makeGraphic(3000, 3000, FlxColor.WHITE);
				cyan.scrollFactor.set(0, 0);
				add(cyan);
			}
			case 'hit-and-miss':
			{
				defaultCamZoom = 0.6;
				curStage = 'ham';
				var bg:FlxSprite = new FlxSprite(303.25, -250.2).loadGraphic(Paths.image('ham bg', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var platform:FlxSprite = new FlxSprite(1097.95, 779.6).loadGraphic(Paths.image('platform', 'shared'));
				platform.updateHitbox();
				platform.antialiasing = true;
				platform.scrollFactor.set(1, 1);
				platform.active = false;
				add(platform);

				var platform2:FlxSprite = new FlxSprite(1831.65, 794.35).loadGraphic(Paths.image('platform', 'shared'));
				platform2.updateHitbox();
				platform2.antialiasing = true;
				platform2.scrollFactor.set(1, 1);
				platform2.active = false;
				add(platform2);

				var platform3:FlxSprite = new FlxSprite(2181, 246.35).loadGraphic(Paths.image('platform', 'shared'));
				platform3.updateHitbox();
				platform3.antialiasing = true;
				platform3.scrollFactor.set(1, 1);
				platform3.active = false;
				add(platform3);
			}
			case 'portal' | 'ralph' | 'amethyst':
			{
				defaultCamZoom = 0.5;
				curStage = 'ralph and i will be there';
				cyan = new FlxSprite(-800, -600).makeGraphic(3000, 3000, 0xFF00CCFF);
				cyan.scrollFactor.set(0, 0);
				add(cyan);

				var stageFront:FlxSprite = new FlxSprite(-226.55, 424.6).loadGraphic(Paths.image('part3/rStage/base', 'shared'));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				add(stageFront);
			}
			case 'bite-wave':
			{
				defaultCamZoom = 0.8;
				curStage = 'ralph and i will be there2';
				cyan = new FlxSprite(-800, -600).makeGraphic(3000, 3000, 0xFF000033);
				cyan.scrollFactor.set(0, 0);
				add(cyan);

				var stars:FlxSprite = new FlxSprite(-2317.85, -1598.75).loadGraphic(Paths.image('part3/rStage/stars', 'shared'));
				stars.updateHitbox();
				stars.antialiasing = true;
				stars.scrollFactor.set(0.1, 0.1);
				stars.active = false;
				add(stars);

				var stageFront:FlxSprite = new FlxSprite(-226.55, 424.6).loadGraphic(Paths.image('part3/rStage/base', 'shared'));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				add(stageFront);
			}
			case 'dark-purple':
			{
				defaultCamZoom = 0.8;
				curStage = 'dp';
				redR = new FlxSprite(-600, -200).loadGraphic(Paths.image('dp bg', 'shared'));
				redR.antialiasing = true;
				redR.scrollFactor.set(1, 1);
				redR.active = false;
				add(redR);

				leCoolBl = new FlxSprite().loadGraphic(Paths.image('leCool/black'));
				leCoolBl.antialiasing = true;
				leCoolBl.alpha = 0;
				leCoolBl.scrollFactor.set(0, 0);
				leCoolBl.active = false;
				leCoolBl.cameras = [camTOP];
				leCoolBl.screenCenter();
				add(leCoolBl);
			}
			case 'dual-dimensions':
			{
				defaultCamZoom = 0.7;
				curStage = 'dd';
				var bg:FlxSprite = new FlxSprite(-798.1, -384.45).loadGraphic(Paths.image('dd bg', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);

				leCoolBl = new FlxSprite(-600, -200).loadGraphic(Paths.image('leCool/black'));
				leCoolBl.antialiasing = true;
				leCoolBl.alpha = 0;
				leCoolBl.scrollFactor.set(1, 1);
				leCoolBl.active = false;
				leCoolBl.visible = false;
				add(leCoolBl);
			}
		}

		var gfVersion:String = 'gf';
		var gfSX:Float = 1;
		var gfSY:Float = 1;

		switch (curStage)
		{
			case 'airship':
				gfVersion = 'gf-airship';
			case 'ralph and i will be there' | 'ralph and i will be there2':
				gfVersion = 'grilfen';
			case 'red' | 'cyan':
				gfVersion = 'stickletta-gf';
				gfSpeed = 2;
				gfSX = 0.97;
				gfSY = 1;
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(gfSX, gfSY);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'bf-opponent':
				dad.y += 330;
			case 'bf-flipped':
				dad.y += 330;
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "james":
				if (curStage != 'aay')
				{
					dad.y += 300;
				}
				else
				{
					dad.x = 1369;
					dad.y = 1246;
				}
			case 'slime':
				camPos.x += 400;
				if (curStage != 'aay')
				{
					dad.y += 200;
				}
				else
				{
					dad.x = 1283;
					dad.y = 1327;
				}
			case 'fire' | 'lemony' | 'icy' | 'slimy':
				dad.x += 250;
				dad.y += 600;
			case 'fire-battle':
				dad.x = 524;
				dad.y = 159;
			case 'ghost':
				camPos.x += 600;
				dad.y += 300;
			case 'madcloud':
				dad.x = 389;
				dad.y = 856;
			case 'sheary':
				if (curStage != 'plane')
					dad.y = 567;
					dad.x = 531;
			case 'cluckington':
				dad.x = 1180;
				dad.y = 885;
			case 'clooshie':
				dad.x = 962;
				dad.y = 842;
			case 'trooper':
				dad.x = 805;
				dad.y = 972;
			case 'gooey':
				dad.x = 1376;
				dad.y = 117;
			case 'gooey-squished':
				dad.x = 1428;
				dad.y = 1094;
			case 'gooey-battle':
				dad.x = 1854;
				dad.y = 893;
			case 'mooshie':
				dad.x += 200;
				dad.y += 220;
			case 'supermooshie':
				dad.x += 200;
				dad.y += 270;
			case 'supermooshie-mad':
				if (curStage != 'plane')
				{
					if (curStage == 'plane-air-battle')
					{
						dad.x = 1408;
						dad.y = 1455;
					}
					else if (curStage == 'ham')
					{
						dad.x = 774.25;
						dad.y = -22.15;
					}
					else
					{
						dad.x += -250;
						dad.y += 270;
					}
				}
				else
				{
					dad.x = 1214;
					dad.y = 622;
				}
			case 'supermooshie-battle':
				dad.x = 1837;
				dad.y = 830;
			case 'sticko':
				dad.y += 300;
			case 'stickletta':
				dad.y += 300;
			case 'clonerman':
				dad.y += 300;
			case 'sticklettabow':
				dad.x = 294.9;
				dad.y = 248.15;
			case 'stickletto-i':
				dad.y += 350;
				dad.flipX = false;
				var oldRight = dad.animation.getByName('singRIGHT').frames;
				dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
				dad.animation.getByName('singLEFT').frames = oldRight;
			case 'striker':
				dad.x -= 30;
				dad.y += 169;
			case 'yellow':
				dad.y += 300;
			case 'red':
				dad.y += 200;
			case 'stiburn':
				dad.x = 1066;
				dad.y = 442;
			case 'ralph':
				dad.x = 903.2;
				dad.y = 526.75;
			case 'maroon':
				dad.y += 300;
			case 'blue':
				dad.y += 300;
			case 'stickletto-dd':
				dad.x = 27.15;
				dad.y = -196.35;
		}
		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'sky':
				boyfriend.x = 2103;
				boyfriend.y = 539;
				gf.x = 1138;
				gf.y = 310;
			case 'skymad':
				boyfriend.x = 2103;
				boyfriend.y = 539;
				gf.x = 1138;
				gf.y = 310;
			case 'cluck' | 'cluckEvil':
				boyfriend.x = 2513;
				boyfriend.y = 828;
				gf.x = 2050;
				gf.y = 524;
			case 'sky2':
				boyfriend.x = 2127;
				boyfriend.y = 960;
				gf.x = 2046;
				gf.y = 638;
			case 'airship':
				boyfriend.x = 1832;
				boyfriend.y = 815;
				gf.x = 829;
				gf.y = 433;
			case 'mooStage':
				boyfriend.x += 650;
				boyfriend.y += 46;
				gf.x += 296;
				gf.y += -20;
			case 'mooStageEvil':
				boyfriend.x += 550;
				boyfriend.y += 46;
				gf.x += 296;
				gf.y += -20;
			case 'mooStageInsane':
				var mooTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				add(mooTrail);

				boyfriend.x += 420;
				boyfriend.y += 55;
				gf.x += -196;
				gf.y += -20;
			case 'plane':
				boyfriend.x = 2604;
				boyfriend.y = 576;
				gf.x = 1726;
				gf.y = 283;
			case 'plane-air-battle':
				boyfriend.x = 2503;
				boyfriend.y = 1094;
				gf.x = 1726;
				gf.y = 5000;
			case 'airship-front':
				boyfriend.x = 1769;
				boyfriend.y = 1173;
				gf.x = -5000;
				gf.y = -5000;
			case 'void':
				boyfriend.x = 489;
				boyfriend.y = 452;
				gf.x = -5000;
				gf.y = -5000;
			case 'mooStageFront':
				boyfriend.x = 1769;
				boyfriend.y = 1162;
				gf.x = -5000;
				gf.y = -5000;
			case 'aay':
				boyfriend.x = 1664;
				boyfriend.y = 1432;
				gf.x = -5000;
				gf.y = -5000;
			case 'stick' | 'lime' | 'wellow' | 'wellow2' | 'blue' | 'stickbreaker' | 'dp':
				gf.x = -5000;
				gf.y = -5000;
			case 'stick2':
				boyfriend.x = 839;
				boyfriend.y = 235.65;
				gf.x = -5000;
				gf.y = -5000;
			case 'stick3':
				boyfriend.x = 639;
				boyfriend.y = 235.65;
				gf.x = -5000;
				gf.y = -5000;
			case 'red' | 'cyan':
				gf.x = boyfriend.x + boyfriend.width / 4;
				gf.y += 225;
				gf.flipX = true;
			case 'sburn':
				boyfriend.x = 667;
				boyfriend.y = 442;
				gf.x = -5000;
				gf.y = -5000;
			case 'green' | 'green2' | 'green3':
				boyfriend.x = dad.x - boyfriend.width;
				boyfriend.y = dad.y + dad.height - boyfriend.height / 2;
				gf.x = -5000;
				gf.y = -5000;
			case 'ham':
				boyfriend.x = 2147.3;
				boyfriend.y = -95.75;
				gf.x = -5000;
				gf.y = -5000;
			case 'ralph and i will be there' | 'ralph and i will be there2':
				boyfriend.x = 2045.85;
				boyfriend.y = 610.45;
				gf.x = 1290.6;
				gf.y = -241.65;
			case 'dd':
				boyfriend.x = 1172.25;
				boyfriend.y = 713.85;
				gf.x = -5000;
				gf.y = -5000;
		}

		if (curStage != 'airship' && curStage != 'airship-front')
			add(gf);
		cloosh = new Character(962, 842, 'clooshie');
		sheary = new Character(1428, 622, 'sheary');

		stickannon = new Character(1165, 598, 'stickannon');
		stibow = new Character(245, 427, 'stibow');
		stlaw = new Character(927, 616, 'stlaw');

		swordletto = new Character(968.7, 196.2, 'swordletto');

		sticko = new Character(1152.45, 375.9, 'sticko');
		stickletto = new Character(1835.65, 400, 'stickletto');
		
		clone1 = new Character(dad.x - dad.width * 1.25, dad.y + 50, 'clonerman');
		clone2 = new Character(dad.x + dad.width * 1.25, dad.y - 50, 'clonerman');
		clone1.alpha = 0;
		clone2.alpha = 0;

		striker = new Character(dad.x - 70, dad.y - 181, 'striker');

		// Shitty layering but whatev it works LOL
		if (curStage != 'mooStageInsane')
		{
			if (curStage == 'plane')
				add(sheary);
			else if (curStage == 'plane-air-battle')
			{
				sheary = new Character(1844, 1134, 'sheary');
				add(sheary);
			}
			else if (curStage == 'cluck' || curStage == 'cluckEvil')
			{
				add(cloosh);
			}
			add(dad);
			add(boyfriend);
			if (curStage == 'cluckEvil')
			{
				shading = new FlxSprite(-5, -16).loadGraphic(Paths.image('cluck/shading', 'week5'));
				shading.antialiasing = true;
				shading.scrollFactor.set(0.9, 0.9);
				shading.active = false;
				add(shading);
			}
			if (curStage == 'airship')
			{
				var b_g:FlxSprite = new FlxSprite(697, 687).loadGraphic(Paths.image('airship/base-gooey', 'shared'));
				b_g.updateHitbox();
				b_g.antialiasing = true;
				b_g.scrollFactor.set(1, 1);
				b_g.active = false;
				b_g.alpha = 0.5;
				add(b_g);

				var b_bf:FlxSprite = new FlxSprite(1936, 872).loadGraphic(Paths.image('airship/base-bf', 'shared'));
				b_bf.updateHitbox();
				b_bf.antialiasing = true;
				b_bf.scrollFactor.set(1, 1);
				b_bf.active = false;
				add(b_bf);

				add(gf);
			}
			if (curStage == 'airship-front')
			{
				var b_g:FlxSprite = new FlxSprite(1619, 641).loadGraphic(Paths.image('battle/bgs/base_gooey', 'shared'));
				b_g.updateHitbox();
				b_g.antialiasing = true;
				b_g.scrollFactor.set(1, 1);
				b_g.active = false;
				add(b_g);

				var b_bf:FlxSprite = new FlxSprite(1608, 1238).loadGraphic(Paths.image('battle/bgs/base_bf', 'shared'));
				b_bf.updateHitbox();
				b_bf.antialiasing = true;
				b_bf.scrollFactor.set(1, 1);
				b_bf.active = false;
				add(b_bf);

				add(gf);
			}
			if (curStage == 'aay')
			{
				james = new Character(1369, 1246, 'james');
				ghost = new Character(1757, 1215, 'ghost-front');
				sheary = new Character(2007, 1308, 'sheary-diagonal');
				cluck = new Character(2225, 1540, 'cluckington-f');
				cloosh = new Character(2062, 1695, 'clooshie-diagonal');
				trooper = new Character(1747, 1683, 'trooper-back');
				gooey = new Character(1616, 1855, 'gooey-back');
				supermooshie = new Character(1263, 1540, 'supermooshie-diagonal');

				supermooshie.alpha = 0;

				l = new FlxSprite(1448, -203).loadGraphic(Paths.image('aay/line', 'shared'));
				l.antialiasing = true;
				l.scrollFactor.set(1, 1);
				l.active = false;
				l.alpha = 0;

				remove(dad);
				remove(boyfriend);

				add(ghost);
				add(sheary);
				add(james);
				add(dad);
				add(cluck);
				add(boyfriend);
				add(cloosh);
				add(supermooshie);
				add(gooey);
				add(trooper);

				add(l);
			}
			if (curStage == 'red')
			{
				add(clone1);
				add(clone2);
			}
			if (curStage == 'stick2' || curStage == 'stick3')
			{
				add(swordletto);
			}
			if (curStage == 'sburn')
			{
				add(stlaw);
				add(stibow);
				add(stickannon);
			}
			if (curStage == 'ham')
			{
				stickletto.flipX = false;
				add(sticko);
				add(stickletto);
			}
			if (curStage == 'wellow')
			{
				add(striker);
			}
			if (curStage == 'wellow2')
			{
				stickletto = new Character(boyfriend.x + boyfriend.width + 50, boyfriend.y + 40, 'stickletto');
				add(stickletto);
				stickletto.flipX = false;
			}
			if (curStage == 'green')
			{
				stickletta = new Character(boyfriend.x - boyfriend.width * 1.5, boyfriend.y, 'stickletta-b');
				add(stickletta);
			}
			if (curStage == 'green2' || curStage == 'green3')
			{
				stickletta = new Character(boyfriend.x - boyfriend.width * 1.5, boyfriend.y, 'stickletta-b');
				add(stickletta);
				sticklettabow = new Character(dad.x + boyfriend.width * 2, boyfriend.y, 'sticklettabow-b');
				add(sticklettabow);
				swordletto = new Character(dad.x + boyfriend.width * 2 + sticklettabow.width + 20, boyfriend.y, 'swordletto-b');
				add(swordletto);
			}
			if (curStage == 'ralph and i will be there' || curStage == 'ralph and i will be there2')
			{
				remove(biteWave);
				biteWave = new FlxSprite(dad.x + dad.width, dad.getMidpoint().y - 62).loadGraphic(Paths.image('battle/bite wave', 'shared'));
				biteWave.antialiasing = true;
				biteWave.scrollFactor.set(1, 1);
				biteWave.visible = false;
				add(biteWave);

				remove(dad);
				remove(boyfriend);
				add(dad);
				add(boyfriend);

				moo = new FlxSprite(-563.8, 332.65).loadGraphic(Paths.image('part3/rStage/foreground', 'shared'));
				moo.updateHitbox();
				moo.antialiasing = true;
				moo.scrollFactor.set(1, 1);
				moo.active = false;
				add(moo);
			}
			if (curStage == 'dp')
			{
				// Blue but I'm too lazy
				remove(sticko);
				remove(dad);
				sticko = new Character(dad.x + dad.width + 20, dad.y - 20, 'blue');
				add(sticko);

				add(dad);

				boyfriend.x += 20;
				boyfriend.y -= 30;
			}
		}
		else
		{
			add(boyfriend);
			add(dad);
		}
		if (boyfriend.curCharacter == 'bf-gf')
			fire = new FlxSprite(boyfriend.x - 200, boyfriend.y + 340).loadGraphic(Paths.image('fireBall'));
		else
			fire = new FlxSprite(boyfriend.x - 200, boyfriend.y).loadGraphic(Paths.image('fireBall'));
		fire.updateHitbox();
		fire.antialiasing = true;
		fire.scrollFactor.set(1, 1);
		fire.active = false;
		fire.visible = false;
		add(fire);

		doof = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		doof2 = new DialogueBox(false, diaEnd); // end of week dialogue
		doof2.scrollFactor.set(); //               ^^^^^^^^^^^^^^^^^^^^
		doof2.finishThing = shittyShit; //         ^^^^^^^^^^^^^^^^^^^^

		Conductor.songPosition = -5000;


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor)); // for healthbar colors for multiple characters
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		// battle mechanic
		// Checkmark
		checkmark = new FlxSprite(0, 20).loadGraphic(Paths.image('battle/checkmark', 'shared'));
		checkmark.updateHitbox();
		checkmark.antialiasing = true;
		checkmark.scrollFactor.set(1, 1);
		checkmark.active = false;
		checkmark.cameras = [camHUD];
		checkmark.screenCenter(X);
		checkmark.visible = false;
		add(checkmark);

		// Attack
		attackSprite = new FlxSprite(1622, 731).loadGraphic(Paths.image('battle/attack', 'shared'));
		attackSprite.updateHitbox();
		attackSprite.antialiasing = true;
		attackSprite.scrollFactor.set(1, 1);
		attackSprite.active = false;
		attackSprite.cameras = [camHUD];
		attackSprite.screenCenter();
		attackSprite.visible = false;
		add(attackSprite);

		// Normal dodge
		dodgeSprite = new FlxSprite().loadGraphic(Paths.image('battle/dodge', 'shared'));
		dodgeSprite.updateHitbox();
		dodgeSprite.antialiasing = true;
		dodgeSprite.scrollFactor.set(1, 1);
		dodgeSprite.active = false;
		dodgeSprite.cameras = [camHUD];
		dodgeSprite.screenCenter();
		dodgeSprite.visible = false;
		add(dodgeSprite);

		// Left dodge
		dodgeSprite2 = new FlxSprite().loadGraphic(Paths.image('battle/dodge left', 'shared'));
		dodgeSprite2.updateHitbox();
		dodgeSprite2.antialiasing = true;
		dodgeSprite2.scrollFactor.set(1, 1);
		dodgeSprite2.active = false;
		dodgeSprite2.cameras = [camHUD];
		dodgeSprite2.screenCenter();
		dodgeSprite2.x -= 100;
		dodgeSprite2.visible = false;
		add(dodgeSprite2);

		// Right dodge
		dodgeSprite3 = new FlxSprite().loadGraphic(Paths.image('battle/dodge right', 'shared'));
		dodgeSprite3.updateHitbox();
		dodgeSprite3.antialiasing = true;
		dodgeSprite3.scrollFactor.set(1, 1);
		dodgeSprite3.active = false;
		dodgeSprite3.cameras = [camHUD];
		dodgeSprite3.screenCenter();
		dodgeSprite3.x += 100;
		dodgeSprite3.visible = false;
		add(dodgeSprite3);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD]; // end of week dialogue
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		startingSong = true;
		
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'icy' | 'fire' | 'slime-attack':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'tutorial':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'boo':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'cloud' | 'sheary' | 'monster-cloud':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'cluck' | 'clooshie' | 'fight-for-life':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'trooper' | 'shell' | 'attack':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'gooey' | 'sacrifice':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'moo' | 'mooshie' | 'showdown':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'red' | 'light-speed' | 'moo-storm' | 'moosanity' | 'moovenge' | '7391203':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'interview' | 'drive-thru':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'plane' | 'air-battle' | 'thunder-storm':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'lemons' | 'freezing' | 'burning' | 'slimy' | 'slime-rematch':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'all-around-you':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'sticks-n-stones' | 'branching-out' | 'logging-in':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'gooey-battle' | 'fire-battle' | 'moo-battle' | 'hit-and-miss':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'stickletta' | 'hot-pink' | 'friends':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'duplication' | 'darkness':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'trust' | 'team-up':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'recovery' | 'striker':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'yellow' | 'teleportation' | 'ffff00':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'ff0000' | 'laser' | '00ffff':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'fury' | 'rage' | 'fiery-madness':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'bite-wave':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				case 'dark-purple':
					if (FlxG.save.data.dialogue)
						schoolIntro(doof);
					else
						startCountdown();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function endDia(?dialogueBox:DialogueBox):Void // end of week dialogue
		{
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				if (dialogueBox != null)
				{
					vocals.stop();
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('menu drums'));
					inCutscene = true;
					add(dialogueBox);
				}
				else
					endSong();
			});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		// ice note
		freezeOverlay = new FlxSprite(-100, -100).makeGraphic(3840, 2160, 0xFF00D0FF);
		freezeOverlay.antialiasing = true;
		freezeOverlay.alpha = 0;
		freezeOverlay.scrollFactor.set(0, 0);
		freezeOverlay.active = false;
		add(freezeOverlay);

		if (executeModchart) // dude I hate lua (jkjkjkjk)
			{
				trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file
	
				if (result != 0)
					trace('COMPILE ERROR\n' + getLuaErrorMessage(lua));

				// get some fukin globals up in here bois
	
				setVar("bpm", Conductor.bpm);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);

				setVar("curStep", 0);
				setVar("curBeat", 0);
	
				setVar("hudZoom", camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", camHUD.angle);
	
				setVar("followXOffset",0);
				setVar("followYOffset",0);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("hudWidth", camHUD.width);
				setVar("hudHeight", camHUD.height);
	
				// callbacks
	
				// sprites
	
				trace(Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite));
	
				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					remove(sprite);
					return true;
				});
	
				// hud/camera
	
				trace(Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					camHUD.x = x;
					camHUD.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudX", function () {
					return camHUD.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudY", function () {
					return camHUD.y;
				}));
				
				trace(Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Int) {
					FlxG.camera.zoom = zoomAmount;
				}));
	
				trace(Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Int) {
					camHUD.zoom = zoomAmount;
				}));
	
				// actors
				
				trace(Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return notes.length;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return notes.members[id].x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return notes.members[id].y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return notes.members[id].scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleY", function(id:Int) {
					return notes.members[id].scale.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteAlpha", function(id:Int) {
					return notes.members[id].alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Int,y:Int, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].x = x;
					notes.members[id].y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].setGraphicSize(Std.int(notes.members[id].width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleX", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleY", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String) {
					getActorByName(id).x = x;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Int,id:String) {
					getActorByName(id).alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String) {
					getActorByName(id).y = y;
				}));
							
				trace(Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String) {
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleX", function(scale:Float,id:String) {
					getActorByName(id).scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleY", function(scale:Float,id:String) {
					getActorByName(id).scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorX", function (id:String) {
					return getActorByName(id).x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorY", function (id:String) {
					return getActorByName(id).y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleX", function (id:String) {
					return getActorByName(id).scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleY", function (id:String) {
					return getActorByName(id).scale.y;
				}));
	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				for (i in 0...strumLineNotes.length) {
					var member = strumLineNotes.members[i];
					trace(strumLineNotes.members[i].x + " " + strumLineNotes.members[i].y + " " + strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					trace("Adding strum" + i);
				}
	
				trace('calling start function');
	
				trace('return: ' + Lua.tostring(lua,callLua('start', [PlayState.SONG.song])));
			}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (dad.curCharacter != 'yellow' && dad.curCharacter != 'yellow-f')
				dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					if (curSong == 'amethyst')
					{
						var ralphIntro:FlxSound;
						ralphIntro = new FlxSound().loadEmbedded(Paths.sound('RalphIntro', 'shared'));
						ralphIntro.play();
						dad.playAnim('singUP', true);
					}
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					if (curSong == 'amethyst')
						dad.playAnim('singUP', true);
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);

					if (curSong == 'amethyst')
					{
						new FlxTimer().start(0.1, function(t:FlxTimer)
						{
							dad.playAnim('singUP', true);
						}, 1);
					}
				case 2:
					if (curSong == 'amethyst')
						dad.playAnim('singUP', true);
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					if (curSong == 'amethyst')
						dad.playAnim('singUP', true);
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);

					if (curSong == 'amethyst')
					{
						new FlxTimer().start(0.1, function(t:FlxTimer)
						{
							dad.playAnim('singUP', true);
						}, 1);
					}
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		freezeCount = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			if (storyDifficulty == 3)
				vocals = new FlxSound().loadEmbedded(Paths.voicesDUET(PlayState.SONG.song));
			else
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if desktop
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];

				swagNote.scrollFactor.set(0, 0);	

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (misses == 0) // Regular FC
			ranking = "(FC)";
		else if (misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy == 100, // God
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy >= 30, // D
			accuracy >= 20, // Nub
			accuracy >= 0.1, // Ur bad lol
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						ranking += " God";
					case 1:
						ranking += " AAAAA";
					case 2:
						ranking += " AAAA:";
					case 3:
						ranking += " AAAA.";
					case 4:
						ranking += " AAAA";
					case 5:
						ranking += " AAA:";
					case 6:
						ranking += " AAA.";
					case 7:
						ranking += " AAA";
					case 8:
						ranking += " AA:";
					case 9:
						ranking += " AA.";
					case 10:
						ranking += " AA";
					case 11:
						ranking += " A:";
					case 12:
						ranking += " A.";
					case 13:
						ranking += " A";
					case 14:
						ranking += " B";
					case 15:
						ranking += " C";
					case 16:
						ranking += " D";
					case 17:
						ranking += " Nub";
					case 18:
						ranking += " Ur bad lol";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	// Dark-Purple stuff
	var dpBLStarted:Bool = false;

	override public function update(elapsed:Float)
	{
		FlxG.mouse.visible = false;
		ralphBattle();

		// Ralph battle mechanic
		if (curSong == 'bite-wave')
		{
			boyfriend.maxVelocity.y = 3000;
			FlxG.collide(redR, boyfriend);

			if (isJumping && !controls.BATTLE_TWO)
				isJumping = false;

			if (boyfriend.y >= 610.45 && !isJumping)
			{
				jumpTimer = 0;
				boyfriend.y = 610.45;
				boyfriend.acceleration.y = 0;
				boyfriend.velocity.y = 0;
			}

			if (jumpTimer >= 0 && controls.BATTLE_TWO)
			{
				isJumping = true;
				jumpTimer += elapsed;
				boyfriend.acceleration.y = 7000;
			}
			else
				jumpTimer = -1;

			if (jumpTimer > 0 && jumpTimer < 0.15)
				boyfriend.velocity.y = -3000;
		}

		// Dark-Purple stuff
		if (dpIsBLing && !dpBLStarted)
		{
			dpBLStarted = true;

			dpTimerTxt = new FlxText(150, 50, 980, "3", 128);
			dpTimerTxt.setFormat(Paths.font("vcr.ttf"), 128, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			dpTimerTxt.scrollFactor.set();
			dpTimerTxt.cameras = [camTOP];
			dpTimerTxt.borderSize = 2.4;

			resetSpaceCounter();
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			spaceCounter += 1;
			// Dark-Purple stuff
			if (curSong == 'dark-purple' && dpIsBLing)
			{
				if (dpCancels > 0)
				{
					remove(dpTimerTxt);
					dpCancels -= 1;
					dpAlphaCancel();
				}
			}
		}

		// Dark-Purple stuff
		if (curSong == "dark-purple" && dpIsBLing)
		{

			if (leCoolBl.alpha == 1 && !dpTimerStarted)
			{
				dpTimerTxt.text = "3";
				add(dpTimerTxt);

				dpTimerStarted = true;

				new FlxTimer().start(1, function(t:FlxTimer)
				{
					if (leCoolBl.alpha < 1)
					{
						remove(dpTimerTxt);
						dpTimerStarted = false;
						return;
					}

					dpTimerTxt.text = "2";

					new FlxTimer().start(1, function(t:FlxTimer)
					{
						if (leCoolBl.alpha < 1)
						{
							remove(dpTimerTxt);
							dpTimerStarted = false;
							return;
						}

						dpTimerTxt.text = "1";

						new FlxTimer().start(1, function(t:FlxTimer)
						{
							if (leCoolBl.alpha < 1)
							{
								remove(dpTimerTxt);
								dpTimerStarted = false;
								return;
							}

							if (spaceCounter < 1)
							{
								boyfriend.stunned = true;

								persistentUpdate = false;
								persistentDraw = false;
								paused = true;

								vocals.stop();
								FlxG.sound.music.stop();
								
								openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

								#if windows
								// Game Over doesn't get his own variable because it's only used here
								DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
								#end
							}
						}, 1);
					}, 1);
				}, 1);
			}
		}

		// item mechanic
		if (FlxG.save.data.itemBlock)
			hitBlock();

		// ice note
		if (frozen)
		{
			boyfriend.playAnim('frozen', true);
		}

		if (!dodged)
		{
			switch (dad.curCharacter)
			{
				case 'fire-battle':
					if (dad.animation.curAnim.name == 'attack' && dad.animation.curAnim.curFrame == 5)
					{
						boyfriend.playAnim('hit', true);
						health -= 0.1;
					}
				case 'gooey-battle':
					if (dad.animation.curAnim.name == 'attackMISS' && dad.animation.curAnim.curFrame == 12)
					{
						dad.playAnim('attackHIT', true);
						boyfriend.playAnim('hit', true);
						health -= 0.5;
					}
				case 'supermooshie-battle':
					if (dad.animation.curAnim.name == 'attack' && dad.animation.curAnim.curFrame == 4)
					{
						boyfriend.playAnim('hit', true);
						health -= 2;
					}
				case 'stiburn':
					if (stibow.animation.curAnim.name == 'attack' && stibow.animation.curAnim.curFrame == 13)
					{
						health -= 0.1;
					}
					if (stlaw.animation.curAnim.name == 'attack' && stlaw.animation.curAnim.curFrame == 13)
					{
						health -= 0.2;
					}
					if (stickannon.animation.curAnim.name == 'attack' && stickannon.animation.curAnim.curFrame == 15)
					{
						health -= 0.3;
					}
			}
		}
		if (boyfriend.animation.curAnim.name == 'attack')
		{
			if (!boyfriend.animation.curAnim.finished)
				attacking = true;
			else
				attacking = false;
		}
		if (boyfriend.animation.curAnim.name == 'dodge')
		{
			if (!boyfriend.animation.curAnim.finished)
				dodging = true;
			else
				dodging = false;
		}

		if (attacked)
		{
			if (boyfriend.animation.curAnim.name == 'attack' && boyfriend.animation.curAnim.curFrame == 5)
			{
				dad.playAnim('hit', true);
				health += 0.5;
			}
		}

		floatShit += 0.1;
		#if !debug
		perfectMode = false;
		#end
		// health drain
		if (SONG.song.toLowerCase() == 'fight-for-life' && FlxG.sound.music.playing && !inCutscene)
			health -= drainAmount * (elapsed / (1/60));

		// item mechanic / health drain
		if (hasDrainEffect && FlxG.sound.music.playing && !inCutscene)
			health -= drainAmount * (elapsed / (1/60));

		if (usedTotem && !totemEnded)
			health += 0.0084 * (elapsed / (1/60));

		if (executeModchart && lua != null && songStarted)
		{
			setVar('songPos',Conductor.songPosition);
			setVar('hudZoom', camHUD.zoom);
			setVar('cameraZoom',FlxG.camera.zoom);
			callLua('update', [elapsed]);

			FlxG.camera.angle = getVar('cameraAngle', 'float');
			camHUD.angle = getVar('camHudAngle','float');

			if (getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = getVar("strumLine1Visible",'bool');
			var p2 = getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (!isSheary && isDad && dad.curCharacter == 'supermooshie-mad')
		{
			switch(curSong)
			{
				case 'plane' | 'air-battle' | 'thunder-storm':
				{
					iconP2.animation.play('mooshep-sm');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		else if (isSheary && !isDad)
		{
			switch(curSong)
			{
				case 'plane' | 'air-battle' | 'thunder-storm':
				{
					iconP2.animation.play('mooshep-sh');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		else if (isSheary && isDad && dad.curCharacter == 'supermooshie-mad')
		{
			switch(curSong)
			{
				case 'plane' | 'air-battle' | 'thunder-storm':
				{
					iconP2.animation.play('mooshep-both');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		if (!isCloosh && isDad && dad.curCharacter == 'cluckington')
		{
			switch(curSong)
			{
				case 'cluck' | 'clooshie' | 'fight-for-life':
				{
					iconP2.animation.play('cluck-clu');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		else if (isCloosh && !isDad)
		{
			switch(curSong)
			{
				case 'cluck' | 'clooshie' | 'fight-for-life':
				{
					iconP2.animation.play('cluck-clo');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		else if (isCloosh && isDad && dad.curCharacter == 'cluckington')
		{
			switch(curSong)
			{
				case 'cluck' | 'clooshie' | 'fight-for-life':
				{
					iconP2.animation.play('cluck-both');
				}
				default:
				{
					iconP2.animation.play(SONG.player2);
				}
			}
		}
		if (curSong == 'all-around-you')
		{
			if (isDad)
				iconP2.animation.play('slime');
			else if (isJames)
				iconP2.animation.play('james');
			else if (isGhost)
				iconP2.animation.play('ghost');
			else if (isSheary)
				iconP2.animation.play('sheary');
			else if (isCluck)
				iconP2.animation.play('cluckington');
			else if (isCloosh)
				iconP2.animation.play('clooshie');
			else if (isTrooper)
				iconP2.animation.play('trooper');
			else if (isGooey)
				iconP2.animation.play('gooey');
			else if (isSupermooshie)
				iconP2.animation.play('supermooshie-mad');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore) + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if ((dad.curCharacter == "supermooshie-mad" && curSong != 'plane') || dad.curCharacter == 'trooper' || dad.curCharacter == 'supermooshie-battle' || dad.curCharacter == 'red' || dad.curCharacter == 'red-f')
		{
			dad.y += Math.sin(floatShit);
		}
		if (clone1.curCharacter == 'red-f')
		{
			clone1.y += Math.sin(floatShit);
		}
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/*if (healthBar.percent <= 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 2;

		if (healthBar.percent > 20 && healthbar.percent < 80)
			iconP2.animation.curAnim.curFrame = 0;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (healthBar.percent >= 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 2;*/

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						
					}
				}
			}
			
			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150 + (lua != null ? getVar("followXOffset", "float") : 0), dad.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));

				switch (dad.curCharacter)
				{
					case 'trooper':
						camFollow.y = dad.getMidpoint().y;
					case 'supermooshie-mad':
						camFollow.x = dad.getMidpoint().x - 200;
						if (curStage == 'plane-air-battle')
						{
							camFollow.y = dad.getMidpoint().y - 150;
						}
						if (curStage == 'ham')
						{
							camFollow.x = dad.getMidpoint().x;
							camFollow.y = dad.getMidpoint().y + 150;
						}
					case 'sheary':
						camFollow.x = gf.getMidpoint().x;
					case 'madcloud':
						camFollow.x = gf.getMidpoint().x;
					case 'gooey-battle' | 'fire-battle' | 'supermooshie-battle' | 'sticko' | 'stiburn':
						camFollow.x = dad.getMidpoint().x - 200;
					case 'slime':
						if (curStage == 'aay')
						{
							if (curBeat <= 656 || curBeat >= 707)
							{
								camFollow.x = boyfriend.getMidpoint().x;
								camFollow.y = boyfriend.getMidpoint().y - 300;
							}
							else
							{
								camFollow.x = boyfriend.getMidpoint().x - 100;
								camFollow.y = boyfriend.getMidpoint().y + 50;
							}
						}
					case 'stickletta':
						camFollow.y = dad.getMidpoint().y + 20;
					case 'yellow':
						camFollow.x = dad.getMidpoint().x + 300;
					case 'stickletto-i' | 'stickletto-i-w':
						camFollow.x = boyfriend.getMidpoint().x - 500;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					case 'stickletto-i-w-f':
						camFollow.x = dad.getMidpoint().x - 400;
						camFollow.y = dad.getMidpoint().y - 100;
					case 'crocker':
						camFollow.x = dad.getMidpoint().x - 150;
					case 'striker-fr' | 'stiburn-fr':
						camFollow.x = dad.getMidpoint().x;
						camFollow.y = dad.getMidpoint().y + 50;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
				if (curSong == 'crock' || curSong == 'switch' || curSong == 'bite' || curSong == 'crocker')
				{
					defaultCamZoom = 0.6;
				}

				if (curSong == 'enemy' || curSong == 'trust' || curSong == 'team-up')
				{
					if (isSwordletto && !isDad)
						camFollow.x = swordletto.getMidpoint().x - 100;
					else if (isDad && !isSwordletto)
						camFollow.x = dad.getMidpoint().x + 150;
					else if (isSwordletto && isDad)
						camFollow.x = boyfriend.getMidpoint().x - 400;
				}
				if (curSong == 'switch' || curSong == 'bite')
				{
					if (isBf)
						camFollow.x = boyfriend.getMidpoint().x - 50;
					else if (isSwordletto)
						camFollow.x = swordletto.getMidpoint().x - 200;
				}
				if (curSong == 'sticklettabreaker')
				{
					if (isClone1)
					{
						camFollow.x = clone1.getMidpoint().x - 120;
						camFollow.y = clone1.getMidpoint().y + 30;
					}
					else if (isDad && curStep >= 5760 && curStep < 6528)
						camFollow.x = dad.getMidpoint().x + 150;
					else if (isSwordletto && curStep >= 5760 && curStep < 6528)
						camFollow.x = swordletto.getMidpoint().x - 100;

					if (curStep >= 6528 && curStep < 8960 || curStep >= 9248)
						defaultCamZoom = 0.6;
					// else
					// 	defaultCamZoom = 0.9;
				}
				if (curSong == 'portal')
				{
					if (curBeat < 160 || curBeat >= 192)
					{
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == "ralph")
				{
					if (curBeat < 64 || curBeat >= 192 && curBeat < 256)
					{
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 320)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == 'amethyst')
				{
					if (curBeat < 128 || curBeat >= 224 && curBeat < 352 || curBeat >= 448)
					{
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 128 && curBeat < 160 || curBeat >= 352 && curBeat < 384)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == "bite-wave")
				{
					if (curBeat >= 64 && curBeat < 128 || curBeat >= 256 && curBeat < 320 || curBeat >= 328 && curBeat < 366 || curBeat >= 368 && curBeat < 384)
					{
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 192 && curBeat < 256 || curBeat >= 384)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + (lua != null ? getVar("followXOffset", "float") : 0), boyfriend.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));

				switch (curStage)
				{
					case 'sky':
						camFollow.x = gf.getMidpoint().x;
					case 'skymad':
						camFollow.x = gf.getMidpoint().x;
					case 'plane-air-battle':
						camFollow.x = boyfriend.getMidpoint().x - 125;
						camFollow.y = boyfriend.getMidpoint().y + 130;
					case 'airship-front' | 'void' | 'mooStageFront':
						camFollow.x = boyfriend.getMidpoint().x;
					case 'aay':
						if (curBeat <= 656 || curBeat >= 707)
						{
							camFollow.x = boyfriend.getMidpoint().x;
							camFollow.y = boyfriend.getMidpoint().y - 300;
						}
						else
						{
							camFollow.x = boyfriend.getMidpoint().x - 100;
							camFollow.y = boyfriend.getMidpoint().y + 50;
						}
					case 'stick' | 'sburn':
						camFollow.x = boyfriend.getMidpoint().x - 500;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					case 'stick2':
						camFollow.x = boyfriend.getMidpoint().x;
					case 'lime' | 'stick3' | 'cyan' | 'red' | 'blue':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					case 'ham':
					{
						camFollow.x = dad.getMidpoint().x;
						camFollow.y = dad.getMidpoint().y + 150;
					}
					case 'green' | 'green2' | 'green3':
						if (p1Char == 'bf' || p1Char == 'stickletta' || p1Char == 'stSa')
							camFollow.x = boyfriend.getMidpoint().x - 50;
						else if (p1Char == 'sticklettabow' || p1Char == 'swordletto' || p1Char == 'sbSw')
							camFollow.x = swordletto.getMidpoint().x - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
				if (curSong == 'crock' || curSong == 'switch' || curSong == 'bite' || curSong == 'crocker')
				{
					defaultCamZoom = 0.9;
				}
				if (curSong == 'sticklettabreaker')
				{
					if (curStep < 2496 || curStep >= 3200 && curStep < 3328 || curStep >= 8960 && curStep < 9056 || curStep >= 9152 && curStep < 9184) // Everything before and Stickletta part
					{
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					}
					else if (curStep >= 2496 && curStep < 3200 || curStep >= 9184 && curStep < 9216) // Red dude part
					{
						camFollow.x = boyfriend.getMidpoint().x - 150;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					}
					else if (curStep >= 3328 && curStep < 3840) // Sticko Stickletta part
					{
						camFollow.x = boyfriend.getMidpoint().x - 150;
						camFollow.y = boyfriend.getMidpoint().y + 20;
					}
					else if (curStep >= 3840 && curStep < 4352 || curStep >= 5632 && curStep < 5760 || curStep >= 9088 && curStep < 9120) // Infecto part
					{
						camFollow.x = boyfriend.getMidpoint().x + 80;
						camFollow.y = boyfriend.getMidpoint().y + 20;
					}
					else if (curStep >= 4352 && curStep < 5760 || curStep >= 9120 && curStep < 9152 || curStep >= 9216 && curStep < 9248) // Striker part and Stiburn part
					{
						camFollow.x = dad.getMidpoint().x;
						camFollow.y = dad.getMidpoint().y + 250;
					}
					else if (curStep >= 5760 && curStep < 6528 || curStep >= 9056 && curStep < 9088) // Sticklettabow and Swordletto part
					{
						camFollow.x = boyfriend.getMidpoint().x - 300;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					}
					else if (curStep >= 6528 && curStep < 8960 || curStep >= 9248) // Crocker part
					{
						var ghjkl:Int = 0;
						if (curStep < 9248)
							ghjkl = 0;
						else
							ghjkl = 1;
						if (ghjkl == 0)
						{
							defaultCamZoom = 0.9;
							if (p1Char == 'bf' || p1Char == 'stickletta' || p1Char == 'stSa')
								camFollow.x = boyfriend.getMidpoint().x - 50;
							else if (p1Char == 'sticklettabow' || p1Char == 'swordletto' || p1Char == 'sbSw')
								camFollow.x = swordletto.getMidpoint().x - 200;
						}
						else
						{
							defaultCamZoom = 0.65;
							camFollow.x = dad.getMidpoint().x - 150;
							camFollow.y = dad.getMidpoint().y + 20;
						}
					}
				}
				if (curSong == 'portal')
				{
					if (curBeat < 160 || curBeat >= 192)
					{
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == "ralph")
				{
					if (curBeat < 64 || curBeat >= 192 && curBeat < 256)
					{
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 320)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == 'amethyst')
				{
					if (curBeat < 128 || curBeat >= 224 && curBeat < 352 || curBeat >= 448)
					{
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 128 && curBeat < 160 || curBeat >= 352 && curBeat < 384)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
				if (curSong == "bite-wave")
				{
					if (curBeat >= 64 && curBeat < 128 || curBeat >= 256 && curBeat < 320 || curBeat >= 328 && curBeat < 366 || curBeat >= 368 && curBeat < 384)
					{
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
					}
					if (curBeat >= 192 && curBeat < 256 || curBeat >= 384)
					{
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					}
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
				// FlxG.watch.addQuick('Queued',inputsQueued);
			}

		if (health <= 0 || (curSong == 'hit-and-miss' && (health >= 2 || misses > 30)))
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						var dadsDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

						// 2v1
						if (isJames)
						{
							james.playAnim('sing' + dadsDir[daNote.noteData], true);
							james.holdTimer = 0;
						}
						if (isGhost)
						{
							ghost.playAnim('sing' + dadsDir[daNote.noteData], true);
							ghost.holdTimer = 0;
						}
						if (isSheary)
						{
							sheary.playAnim('sing' + dadsDir[daNote.noteData], true);
							sheary.holdTimer = 0;
						}
						if (isCluck)
						{
							cluck.playAnim('sing' + dadsDir[daNote.noteData], true);
							cluck.holdTimer = 0;
						}
						if (isCloosh)
						{
							cloosh.playAnim('sing' + dadsDir[daNote.noteData], true);
							cloosh.holdTimer = 0;
						}
						if (isTrooper)
						{
							trooper.playAnim('sing' + dadsDir[daNote.noteData], true);
							trooper.holdTimer = 0;
						}
						if (isGooey)
						{
							gooey.playAnim('sing' + dadsDir[daNote.noteData], true);
							gooey.holdTimer = 0;
						}
						if (isSupermooshie)
						{
							supermooshie.playAnim('sing' + dadsDir[daNote.noteData], true);
							supermooshie.holdTimer = 0;
						}
						if (isSticklettabow)
						{
							sticklettabow.playAnim('sing' + dadsDir[daNote.noteData], true);
							sticklettabow.holdTimer = 0;
						}
						if (isSwordletto)
						{
							swordletto.playAnim('sing' + dadsDir[daNote.noteData], true);
							swordletto.holdTimer = 0;
						}
						if (isBf)
						{
							boyfriend.playAnim('sing' + dadsDir[daNote.noteData], true);
							boyfriend.holdTimer = 0;
						}
						if (isSticko)
						{
							sticko.playAnim('sing' + dadsDir[daNote.noteData], true);
							sticko.holdTimer = 0;
						}
						if (isClone1)
						{
							clone1.playAnim('sing' + dadsDir[daNote.noteData], true);
							clone1.holdTimer = 0;
						}
						if (isStickletta)
						{
							stickletta.playAnim('sing' + dadsDir[daNote.noteData], true);
							stickletta.holdTimer = 0;
						}
						if (isDad)
						{
							if (dad.animation.curAnim.name == 'attackHIT' || dad.animation.curAnim.name == 'attackMISS' || dad.animation.curAnim.name == 'attack' || dad.animation.curAnim.name == 'dodge' || dad.animation.curAnim.name == 'hit' || dad.animation.curAnim.name == 'appear')
							{
								if (dad.animation.curAnim.finished)
									dad.playAnim('sing' + dadsDir[daNote.noteData] + altAnim, true);
							}
							else
								dad.playAnim('sing' + dadsDir[daNote.noteData] + altAnim, true);
							dad.holdTimer = 0;
						}

						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();

						// for moovenge health drain
						if (dad.curCharacter == 'supermooshie-mad' && curSong == 'Moovenge' && health > 0.1)
						{
							health -= 0.04; // 25 notes to lose half health
						}
					}

					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					
					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							if (daNote.noteType == 2) // lava note
							{
								if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
									health -= 0;
								else
								{
									switch(daNote.noteData)
									{
										case 0:
											if (!leftBlocked)
												health -= 2;
											else
												health -= 0;
										case 1:
											if (!downBlocked)
												health -= 2;
											else
												health -= 0;
										case 2:
											if (!upBlocked)
												health -= 2;
											else
												health -= 0;
										case 3:
											if (!rightBlocked)
												health -= 2;
											else
												health -= 0;
									}
								}
							}
							if (daNote.noteType == 3) // heal note
							{
								health -= 0;
							}
							if (daNote.noteType == 4) // lightning note
							{
								if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
									health -= 0;
								else
								{
									switch(daNote.noteData)
									{
										case 0:
											if (!leftBlocked)
											{
												health -= 1.5;
												boyfriend.playAnim('hit');
											}
											else
												health -= 0;
										case 1:
											if (!downBlocked)
											{
												health -= 1.5;
												boyfriend.playAnim('hit');
											}
											else
												health -= 0;
										case 2:
											if (!upBlocked)
											{
												health -= 1.5;
												boyfriend.playAnim('hit');
											}
											else
												health -= 0;
										case 3:
											if (!rightBlocked)
											{
												health -= 1.5;
												boyfriend.playAnim('hit');
											}
											else
												health -= 0;
									}
								}
							}
							if (daNote.noteType == 5) // fuckyou note
							{
								if (curSong != 'hit-and-miss')
									health -= 0;
								else
									health += 0.2;
							}
							if (daNote.noteType == 6) // shell note
							{
								if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
									health -= 0;
								else
								{
									switch(daNote.noteData)
									{
										case 0:
											if (!leftBlocked)
											{
												health -= 0.5;
												boyfriend.playAnim('hit');
												dad.playAnim('attack', true);
											}
											else
												health -= 0;
										case 1:
											if (!downBlocked)
											{
												health -= 0.5;
												boyfriend.playAnim('hit');
												dad.playAnim('attack', true);
											}
											else
												health -= 0;
										case 2:
											if (!upBlocked)
											{
												health -= 0.5;
												boyfriend.playAnim('hit');
												dad.playAnim('attack', true);
											}
											else
												health -= 0;
										case 3:
											if (!rightBlocked)
											{
												health -= 0.5;
												boyfriend.playAnim('hit');
												dad.playAnim('attack', true);
											}
											else
												health -= 0;
									}
								}
							}
							if (daNote.noteType == 7) // ice note
							{
								health -= 0;
							}
							if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
									health -= 0;
								else
								{
									switch(daNote.noteData)
									{
										case 0:
											if (!leftBlocked)
											{
												if (curSong != 'hit-and-miss')
													health -= 0.075;
												else
													health -= 0;
												if (theFunne)
													noteMiss(daNote.noteData, daNote);
											}
											else
												health -= 0;
										case 1:
											if (!downBlocked)
											{
												if (curSong != 'hit-and-miss')
													health -= 0.075;
												else
													health -= 0;
												if (theFunne)
													noteMiss(daNote.noteData, daNote);
											}
											else
												health -= 0;
										case 2:
											if (!upBlocked)
											{
												if (curSong != 'hit-and-miss')
													health -= 0.075;
												else
													health -= 0;
												if (theFunne)
													noteMiss(daNote.noteData, daNote);
											}
											else
												health -= 0;
										case 3:
											if (!rightBlocked)
											{
												if (curSong != 'hit-and-miss')
													health -= 0.075;
												else
													health -= 0;
												if (theFunne)
													noteMiss(daNote.noteData, daNote);
											}
											else
												health -= 0;
									}
									vocals.volume = 0;
								}
							}
							if (hasDrainEffect) // item mechanic
							{
								drainAmount += 0.001;
							}
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}

		if (!inCutscene && !frozen)
			keyShit();

		// DONT use this on the last song of any week
		// and DONT use this before skipping dialogue on the last song, shit will get broken and i'm too lazy to fix it
		// also don't use it in Moosanity, the game is weird
		// #if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		// #end
	}

	// my end dialogue code is absolute shit
	function shittyShit():Void // end of week dialogue
	{
		// FlxG.sound.playMusic(Paths.music('freakyMenu'));
		// FlxG.sound.playMusic(Paths.music('menu drums'));
		FlxG.sound.music.stop();
		FlxG.switchState(new FNMStoryMenuState());
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		if (executeModchart)
		{
			Lua.close(lua);
			lua = null;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		// "Secret" achievement
		if (curSong == '7391203')
		{
			GameJoltAPI.getTrophy(153766);
		}
		// "Secret 2" achievement
		if (curSong == 'boyfriend')
		{
			GameJoltAPI.getTrophy(154198);
		}
		// "Freezeless run" achievement
		if (freezeCount == 0 && (curSong == 'freezing' || curSong == 'slime-rematch'))
		{
			GameJoltAPI.getTrophy(154893);
		}
		// "Battle master" achievement
		if (curSong == 'gooey-battle')
		{
			FlxG.save.data.beatGooey = true;
			if (FlxG.save.data.beatGooey && FlxG.save.data.beatFire && FlxG.save.data.beatSupermooshie)
			{
				GameJoltAPI.getTrophy(158165);
			}
		}
		if (curSong == 'fire-battle')
		{
			FlxG.save.data.beatFire = true;
			if (FlxG.save.data.beatGooey && FlxG.save.data.beatFire && FlxG.save.data.beatSupermooshie)
			{
				GameJoltAPI.getTrophy(158165);
			}
		}
		if (curSong == 'moo-battle')
		{
			FlxG.save.data.beatSupermooshie = true;
			if (FlxG.save.data.beatGooey && FlxG.save.data.beatFire && FlxG.save.data.beatSupermooshie)
			{
				GameJoltAPI.getTrophy(158165);
			}
		}
		// "Keeping it 100" achievement
		if (misses == 0 && bads == 0 && shits == 0 && goods == 0 && curSong != 'Tutorial')
		{
			GameJoltAPI.getTrophy(153767);
		}
		// "Hit or Miss" achievement
		if (curSong == 'hit-and-miss')
		{
			GameJoltAPI.getTrophy(189082);
		}

		if (offsetTesting)
		{
			// FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.sound.playMusic(Paths.music('menu drums'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					// end of week dialogue and cutscenes
					switch(SONG.song.toLowerCase())
					{
						case 'slime-attack':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'drive-thru':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'haunted':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'monster-cloud':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'fight-for-life':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'showdown':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'attack':
							if (FlxG.save.data.cutscenes)
							{
								// FlxG.sound.music.stop();
								playEndCutscene('bfGetsKidnappedLol');
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'squash':
							if (FlxG.save.data.cutscenes)
							{
								// FlxG.sound.music.stop();
								playEndCutscene('theyJump');
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'moovenge':
							if (FlxG.save.data.cutscenes)
							{
								// FlxG.sound.music.stop();
								playEndCutscene('week9ending');
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'thunder-storm':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'slime-rematch':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'logging-in':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'friends':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'darkness':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'striker':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'ffff00':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case '00ffff':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'fiery-madness':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'crocker':
							if (FlxG.save.data.cutscenes)
							{
								playEndCutscene('crocker dies');
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'sticklettabreaker':
							if (FlxG.save.data.dialogue)
								endDia(doof2);
							else
								FlxG.switchState(new FNMStoryMenuState());
						case 'bite-wave':
							if (FlxG.save.data.cutscenes)
							{
								// FlxG.sound.music.stop();
								playEndCutscene('jeffery flys');
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								FlxG.switchState(new FNMStoryMenuState());
						default:
							FlxG.sound.playMusic(Paths.music('menu drums'));
							FlxG.switchState(new FNMStoryMenuState());
					}

					if (storyWeek == 7 && storyDifficulty == 2)  // 1-7
						FlxG.save.data.beatGooeyWeek = true;
					if (storyWeek == 9 && storyDifficulty == 2)  // 1-9
						FlxG.save.data.beatMooWeek = true;
					if (storyWeek == 11 && storyDifficulty == 2) // 1-11
						FlxG.save.data.beatSlimeWeek = true;
					if (storyWeek == 13 && storyDifficulty == 2) // 2-1
						FlxG.save.data.beatStickoWeek = true;
					if (storyWeek == 14 && storyDifficulty == 2) // 2-2
						FlxG.save.data.beatSaWeek = true;
					if (storyWeek == 23 && storyDifficulty == 2) // 3-1
						FlxG.save.data.beatRalphWeek = true;

					if (lua != null)
					{
						Lua.close(lua);
						lua = null;
					}

					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					if (storyDifficulty == 3)
						difficulty = '-duet';

					if (storyDifficulty == 4)
						difficulty = '-fuckyou';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					var video:VideoHandlerMP4 = new VideoHandlerMP4();
					switch (SONG.song.toLowerCase())
					{
						case 'monster-cloud':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('shearyFuckingDies'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'fight-for-life':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('pacman'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'squash':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('squishLol'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'moosanity':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('moosanity'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'air-battle':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('theyFall'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'switch':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('theyJoin'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						case 'bite-wave':
							if (FlxG.save.data.cutscenes)
							{
								video.playMP4(Paths.video('ralph does commands'), new PlayState());
								#if windows
								DiscordClient.changePresence("In cutscene", null, null, true);
								#end
							}
							else
								LoadingState.loadAndSwitchState(new PlayState());
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					};
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					if (daNote.noteType == 2)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 1;
					}
					if (daNote.noteType == 3)
					{
						if (hasX2Effect)
							health += 0.04;
						else
							health += 0.02;
					}
					if (daNote.noteType == 4)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 1;
					}
					if (daNote.noteType == 5)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
						{
							if (curSong != 'hit-and-miss')
								health -= 2;
							else
								health -= 0.5;
						}
					}
					if (daNote.noteType == 6)
					{
						health -= 0;
					}
					if (daNote.noteType == 7)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.2;
						frozen = true;
						freeze();
					}
					if (daNote.noteType == 1 || daNote.noteType == 0)
					{
						score = -300;
						combo = 0;
						misses++;
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					}
				case 'bad':
					if (daNote.noteType == 2)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.5;
					}
					if (daNote.noteType == 3)
					{
						if (hasX2Effect)
							health += 0.1;
						else
							health += 0.05;
					}
					if (daNote.noteType == 4)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.5;
					}
					if (daNote.noteType == 5)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
						{
							if (curSong != 'hit-and-miss')
								health -= 2;
							else
								health -= 0.5;
						}
					}
					if (daNote.noteType == 6)
					{
						health -= 0;
					}
					if (daNote.noteType == 7)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.06;
						frozen = true;
						freeze();
					}
					if (daNote.noteType == 1 || daNote.noteType == 0)
					{
						daRating = 'bad';
						score = 0;
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.06;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
				case 'good':
					if (daNote.noteType == 2)
					{
						if (hasX2Effect)
							health += 0.06;
						else
							health += 0.03;
					}
					if (daNote.noteType == 3)
					{
						if (hasX2Effect)
							health += 1;
						else
							health += 0.5;
					}
					if (daNote.noteType == 4)
					{
						health += 0;
					}
					if (daNote.noteType == 5)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
						{
							if (curSong != 'hit-and-miss')
								health -= 2;
							else
								health -= 0.5;
						}
					}
					if (daNote.noteType == 6)
					{
						health -= 0;
					}
					if (daNote.noteType == 7)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.06;
						frozen = true;
						freeze();
					}
					if (daNote.noteType == 1 || daNote.noteType == 0)
					{
						daRating = 'good';
						if (hasX2Effect)
							score = 400;
						else
							score = 200;
						ss = false;
						goods++;
						if (health < 2)
							if (hasX2Effect)
								health += 0.06;
							else
								health += 0.03;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
				case 'sick':
					if (daNote.noteType == 2)
					{
						if (hasX2Effect)
							health += 0.12;
						else
							health += 0.06;
					}
					if (daNote.noteType == 3)
					{
						if (hasX2Effect)
							health += 2;
						else
							health += 1;
					}
					if (daNote.noteType == 4)
					{
						health += 0;
					}
					if (daNote.noteType == 5)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
						{
							if (curSong != 'hit-and-miss')
								health -= 2;
							else
								health -= 0.5;
						}
					}
					if (daNote.noteType == 6)
					{
						health -= 0;
					}
					if (daNote.noteType == 7)
					{
						if (hasWallEffect && iconP1.x >= wall.x - 150) // item mechanic
							health -= 0;
						else
							health -= 0.06;
						frozen = true;
						freeze();
					}
					if (daNote.noteType == 1 || daNote.noteType == 0)
					{
						if (health < 2)
							if (hasX2Effect)
								health += 0.12;
							else
								health += 0.06;
						if (hasX2Effect)
							score = 700;
						else
							score = 350;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
					}
			}

			if (daRating != 'shit' || daRating != 'bad')
			{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			
			var msTiming = truncateFloat(noteDiff, 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);
			


			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	// item mechanic
	function itemBlock():Void
	{
		trace('time for block to appear: ' + timeToAppear);

		item = FlxG.random.int(1,13);
		//item = 13; // testing testing...

		block = new FlxSprite(boyfriend.x + 100, boyfriend.y - 200);
		block.frames = Paths.getSparrowAtlas('item_block');
		block.animation.addByPrefix('idle', 'idle', 24, true);
		block.animation.addByPrefix('hit', 'hit', 24, false);
		block.animation.addByPrefix('roll', 'random', 24, true);

		// good
		block.animation.addByPrefix('r1', 'hesl', 24, true);
		block.animation.addByPrefix('r2', 'x2', 24, true);
		block.animation.addByPrefix('r3', 'wall', 24, true);
		block.animation.addByPrefix('r4', 'totem', 24, true);
		block.animation.addByPrefix('r5', 'star', 24, true);
		block.animation.addByPrefix('r6', 'fire', 24, true);

		// bad
		//block.animation.addByPrefix('r7', 'code', 24, true);
		block.animation.addByPrefix('r8', 'death', 24, true);
		block.animation.addByPrefix('r9', 'drain', 24, true);
		block.animation.addByPrefix('r10', 'freeze', 24, true);
		block.animation.addByPrefix('r11', 'notes', 24, true);
		block.animation.addByPrefix('r12', 'pause', 24, true);
		block.animation.addByPrefix('r13', 'boss fight', 24, true);

		block.animation.play('idle', true);
		add(block);

		block.visible = false;
		new FlxTimer().start(timeToAppear, function(tmr:FlxTimer)
		{
			block.visible = true;

			trace('block has appeared');
			hitBlock();

			timerUgh = new FlxTimer().start(itemTime, function(tmr:FlxTimer)
			{
				timeOver = true;
				block.visible = false;
				trace('bye block');
			}, 1);
		}, 1);
	}

	// item mechanic
	function hitBlock():Void
	{
		if (FlxG.keys.justPressed.SPACE && block.visible == true)
		{
			timerUgh.cancel();

			trace('block has been hit');
			block.y -= 50;
			block.animation.play('hit', true);

			trace('rolling...');
			block.y += 50;
			block.animation.play('roll', true);
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				trace(item + '!');
				block.animation.play('r' + item, true);
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					itemEffects();
					block.visible = false;
					trace('bye block (why am I using trace so much?)');
				}, 1);
			}, 1);
		}
	}

	function itemEffects():Void
	{
		switch (item)
		{
			case 1:
				health = 2;
			case 2:
				hasX2Effect = true;
				new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					hasX2Effect = false;
				}, 1);
			case 3:
				wall = new FlxSprite(iconP1.x + 150, iconP1.y - 10).makeGraphic(50, 170, FlxColor.GRAY);
				add(wall);
				hasWallEffect = true;
				new FlxTimer().start(15, function(tmr:FlxTimer)
				{
					remove(wall);
					hasWallEffect = false;
				}, 1);
			case 4:
				if (health >= 0.1 && !usedTotem)
				{
					usedTotem = true;
					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						totemEnded = true;
					}, 1);
				}
			case 5:
				hasStar = true;
				new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					hasStar = false;
				}, 1);
			case 6:
				fire.visible = true;
				FlxTween.tween(fire, { x: dad.x }, 0.3, { onComplete: removeFire });
			//case 7:
				//openSubState(new CodeSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			case 8:
				health = 0;
			case 9:
				hasDrainEffect = true;
			case 10:
				freeze();
			case 11:
				moveNotes();
			case 12:
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			case 13:
				var boss = FlxG.random.int(1,3);
				switch(boss)
				{
					case 1:
						isStoryMode = true;
						storyDifficulty = 2;
						SONG = Song.loadFromJson('gooey-battle-hard', 'gooey-battle');
						LoadingState.loadAndSwitchState(new PlayState(), true);
					case 2:
						isStoryMode = true;
						storyDifficulty = 2;
						SONG = Song.loadFromJson('fire-battle-hard', 'fire-battle');
						LoadingState.loadAndSwitchState(new PlayState(), true);
					case 3:
						isStoryMode = true;
						storyDifficulty = 2;
						SONG = Song.loadFromJson('moo-battle-hard', 'moo-battle');
						LoadingState.loadAndSwitchState(new PlayState(), true);
				}
		}
	}

	// item mechanic
	function removeFire(tween:FlxTween):Void
	{
		if (dad.curCharacter == 'supermooshie' || dad.curCharacter == 'supermooshie-mad')
		{
			fire.flipX = true;
			FlxTween.tween(fire, { x: boyfriend.x + 200 }, 0.3, { onComplete: removeFire2 });
		}
		else
		{
			fire.visible = false;
			health += 0.5;
		}
	}

	function removeFire2(tween:FlxTween):Void
	{
		fire.visible = false;
		health -= 0.5;
	}

	// ice note
	function freeze():Void
	{
		freezeTime = FlxG.random.int(1,3);

		frozen = true;
		freezeCount += 1;
		FlxG.camera.flash(0xFF00D0FF, 0.5);
		FlxTween.tween(freezeOverlay, {alpha: 0.5}, 0.5, {ease: FlxEase.smoothStepOut});

		new FlxTimer().start(freezeTime, unfreeze, 1);

		trace('Frozen for ' + freezeTime + ' seconds');
	}

	// ice note
	function unfreeze(timer:FlxTimer):Void
	{
		FlxTween.tween(freezeOverlay, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
		frozen = false;

		// "Is it cold in here? Or is it just me?" achievement
		if (freezeTime == 3 && !frozen && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && health > 0)
		{
			trace("Must have been cold");
			GameJoltAPI.getTrophy(154894);
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep) // replay code
		{
			// disable input
			up = false;
			down = false;
			right = false;
			left = false;

			// new input

			//if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			//timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			//timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "left";	

				upR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition  && rep.replay.keyReleases[repReleases].key == "right";
				downR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}

		// battle mechanic
		if (controls.BATTLE_ONE && canAttack)
		{
			boyfriend.playAnim('attack');
			attackCounter += 1;
			checkmark.visible = true;
		}
		if (controls.BATTLE_TWO && canDodge)
		{
			boyfriend.playAnim('dodge');
			dodgeCounter += 1;
			checkmark.visible = true;
		}
		if (controls.BATTLE_TWOL && canDodgeL)
		{
			boyfriend.playAnim('dodge');
			dodgeLCounter += 1;
			checkmark.visible = true;
		}
		if (controls.BATTLE_TWOR && canDodgeR)
		{
			boyfriend.playAnim('dodge');
			dodgeRCounter += 1;
			checkmark.visible = true;
		}

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
											trace('force note hit');
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							noteCheck(controlArray, daNote);
					}

					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						if (daNote.noteType == 6)
						{
							boyfriend.playAnim('dodge', true);
							dad.playAnim('attack', true);
						}
					}
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && !dodging && !attacking)
				{
					if (boyfriend.animation.curAnim.name == 'pushed')
					{
						if (boyfriend.animation.curAnim.finished)
						{
							boyfriend.playAnim('idle');
						}
					}
					else
					{
						boyfriend.playAnim('idle');
					}
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (loadRep)
							{

							}
							else
							{
								if (upP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
								}
								if (upR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 3:
							if (loadRep)
								{

								}
							else
							{
								if (rightP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (rightR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}	
						case 1:
							if (loadRep)
								{

								}
							else
							{
								if (downP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (downR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 0:
							if (loadRep)
								{

								}
							else
							{
								if (leftP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (leftR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
					}
					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (curSong != 'hit-and-miss')
				health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				note.rating = "shit";
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";

			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) && mashViolations < 2)
					{
						mashViolations++;
						
						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else
					{
						// this is bad but fuck you
						playerStrums.members[0].animation.play('static');
						playerStrums.members[1].animation.play('static');
						playerStrums.members[2].animation.play('static');
						playerStrums.members[3].animation.play('static');
						health -= 0.2;
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{
				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;

					/*if (!attacking && !dodging)
					{
						switch (note.noteData)
						{
							case 2:
								boyfriend.playAnim('singUP', true);
							case 3:
								boyfriend.playAnim('singRIGHT', true);
							case 1:
								boyfriend.playAnim('singDOWN', true);
							case 0:
								boyfriend.playAnim('singLEFT', true);
						}
					}*/

					var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

					// 2v1
					if (p1Char == 'bf')
					{
						if (!attacking && !dodging)
						{
							boyfriend.playAnim('sing' + sDir[note.noteData], true);
							boyfriend.holdTimer = 0;
						}
					}
					if (p1Char == 'stickletto')
					{
						stickletto.playAnim('sing' + sDir[note.noteData], true);
						stickletto.holdTimer = 0;
					}
					if (p1Char == 'stickletta')
					{
						stickletta.playAnim('sing' + sDir[note.noteData], true);
						stickletta.holdTimer = 0;
					}
					if (p1Char == 'bfSt')
					{
						if (!attacking && !dodging)
						{
							boyfriend.playAnim('sing' + sDir[note.noteData], true);
							boyfriend.holdTimer = 0;
						}
						stickletto.playAnim('sing' + sDir[note.noteData], true);
						stickletto.holdTimer = 0;
					}
					if (p1Char == 'sticklettabow')
					{
						sticklettabow.playAnim('sing' + sDir[note.noteData], true);
						sticklettabow.holdTimer = 0;
					}
					if (p1Char == 'swordletto')
					{
						swordletto.playAnim('sing' + sDir[note.noteData], true);
						swordletto.holdTimer = 0;
					}
					if (p1Char == 'stSa')
					{
						boyfriend.playAnim('sing' + sDir[note.noteData], true);
						boyfriend.holdTimer = 0;
						stickletta.playAnim('sing' + sDir[note.noteData], true);
						stickletta.holdTimer = 0;
					}
					if (p1Char == 'stSaSb')
					{
						boyfriend.playAnim('sing' + sDir[note.noteData], true);
						boyfriend.holdTimer = 0;
						stickletta.playAnim('sing' + sDir[note.noteData], true);
						stickletta.holdTimer = 0;
						sticklettabow.playAnim('sing' + sDir[note.noteData], true);
						sticklettabow.holdTimer = 0;
					}
					if (p1Char == 'stSaSbSw')
					{
						boyfriend.playAnim('sing' + sDir[note.noteData], true);
						boyfriend.holdTimer = 0;
						stickletta.playAnim('sing' + sDir[note.noteData], true);
						stickletta.holdTimer = 0;
						sticklettabow.playAnim('sing' + sDir[note.noteData], true);
						sticklettabow.holdTimer = 0;
						swordletto.playAnim('sing' + sDir[note.noteData], true);
						swordletto.holdTimer = 0;
					}
					if (p1Char == 'sbSw')
					{
						sticklettabow.playAnim('sing' + sDir[note.noteData], true);
						sticklettabow.holdTimer = 0;
						swordletto.playAnim('sing' + sDir[note.noteData], true);
						swordletto.holdTimer = 0;
					}

					// note blocking mechanic
					switch (note.noteData)
					{
						case 0:
							if (leftBlocked)
							{
								health -= 0.5;
								boyfriend.playAnim('hit', true);
							}
						case 1:
							if (downBlocked)
							{
								health -= 0.5;
								boyfriend.playAnim('hit', true);
							}
						case 2:
							if (upBlocked)
							{
								health -= 0.5;
								boyfriend.playAnim('hit', true);
							}
						case 3:
							if (rightBlocked)
							{
								health -= 0.5;
								boyfriend.playAnim('hit', true);
							}
					}

					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	// 2v1
	function resetChars():Void
	{
		isBf = false;
		isDad = false;
		isJames = false;
		isGhost = false;
		isSheary = false;
		isCluck = false;
		isCloosh = false;
		isTrooper = false;
		isGooey = false;
		isSupermooshie = false;
		isSticko = false;
		isStickletta = false;
		isCloneerman = false;
		isClone1 = false;
		isSwordletto = false;
		isSticklettabow = false;
	}

	// 2v1
	function switchChars(characters:String):Void
	{
		switch(characters)
		{
			case 'bf' | 'stickletto' | 'stickletto-i' | 'stickletto-f':
				isBf = true;
			case 'dad':
				isDad = true;
			case 'james':
				isJames = true;
			case 'ghost' | 'ghost-front':
				isGhost = true;
			case 'sheary' | 'sheary-diagonal':
				isSheary = true;
			case 'cluckington' | 'cluckington-f':
				isCluck = true;
			case 'clooshie' | 'clooshie-diagonal':
				isCloosh = true;
			case 'trooper' | 'trooper-back':
				isTrooper = true;
			case 'gooey' | 'gooey-back' | 'gooey-squished' | 'gooey-battle':
				isGooey = true;
			case 'supermooshie' | 'supermooshie-mad' | 'supermooshie-battle' | 'supermooshie-diagonal':
				isSupermooshie = true;
			case 'sticko':
				isSticko = true;
			case 'clonerman':
				isCloneerman = true;
			case 'clone':
				isClone1 = true;
			case 'sticklettabow' | 'sb':
				isSticklettabow = true;
			case 'swordletto' | 'sw':
				isSwordletto = true;
			case 'stickletta' | 'sa':
				isStickletta = true;
		}
	}

	// 2v1
	function resetP1():Void
	{
		p1Char = '';
	}

	// 2v1
	function switchP1(bfChar:String):Void
	{
		switch(bfChar)
		{
			case 'bf' | 'boyfriend':
				p1Char = 'bf';
			case 'stickletto' | 'st':
				p1Char = 'stickletto';
			case 'stickletta' | 'sa':
				p1Char = 'stickletta';
			case 'sticklettabow' | 'sb':
				p1Char = 'sticklettabow';
			case 'swordletto' | 'sw':
				p1Char = 'swordletto';
			case 'bfSt':
				p1Char = 'bfSt'; // "Boyfriend" and Stickletto
			case 'stSa' | 'bfSa':
				p1Char = 'stSa'; // "Boyfriend" and Stickletta
			case 'sbSw':
				p1Char = 'sbSw';
			case 'stSaSb' | 'bfSaSb': // "Boyfriend", Stickletta, and Sticklettabow
				p1Char = 'stSaSb';
			case 'stSaSbSw' | 'bfSaSbSw':
				p1Char = 'stSaSbSw'; // "Boyfriend", Stickletta, Sticklettabow, and Swordletto
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (curSong == 'plane')
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
					sheary.playAnim('idle', true);
				case 256:
					resetChars();
					switchChars('sheary');
				case 512:
					resetChars();
					switchChars('dad');
				case 640:
					resetChars();
					switchChars('sheary');
				case 768:
					switchChars('dad');
				case 832:
					resetChars();
					switchChars('dad');
				case 1343:
					switchChars('sheary');
				case 1599:
					resetChars();
					switchChars('dad');
				case 1679:
					resetChars();
					switchChars('sheary');
				case 1711:
					resetChars();
					switchChars('dad');
				case 2160:
					switchChars('sheary');
			}
		}
		if (curSong == 'air-battle')
		{
			switch(curStep)
			{
				case 1:
					sheary.playAnim('idle', true);
				case 32:
					resetChars();
					switchChars('sheary');
				case 159:
					resetChars();
					switchChars('dad');
				case 288:
					resetChars();
					switchChars('sheary');
				case 543:
					resetChars();
					switchChars('dad');
				case 799:
					switchChars('sheary');
				case 1984:
					resetChars();
					switchChars('dad');
				case 2848:
					switchChars('sheary');
			}
		}
		if (curSong == 'thunder-storm')
		{
			switch(curStep)
			{
				case 1:
					sheary.playAnim('idle', true);
				case 112:
					resetChars();
					switchChars('dad');
				case 456:
					resetChars();
					switchChars('sheary');
				case 1344:
					resetChars();
					switchChars('dad');
					switchChars('sheary');
			}
		}
		if (curSong == 'clooshie')
		{
			switch(curStep)
			{
				case 2 | 213 | 217 | 221 |                                             624 | 864 |       1184 |                   1478 | 1486 | 1510:
					resetChars();
					switchChars('clooshie');
				case 64 | 197 | 201 | 205 |              262 | 270 | 390 | 398 |       608 | 832 | 960 | 1120 |     1446 | 1454 |               1504:
					resetChars();
					switchChars('dad');
				case 128 | 198 | 204 | 208 | 214 | 220 | 256 | 264 | 272 | 392 | 400 | 736 | 1024 |      1376 |     1448 | 1456 | 1480 | 1488:
					resetChars();
					switchChars('dad');
					switchChars('clooshie');
			}
		}
		if (curSong == 'cluck')
		{
			switch(curStep)
			{
				case 1 | 128 | 256 | 384 | 640:
					resetChars();
					switchChars('dad');
				case 64 | 192 | 320 | 416 | 800:
					resetChars();
					switchChars('clooshie');
			}
		}
		if (curSong == 'fight-for-life')
		{
			// Character switch
			switch(curStep)
			{
				case 192 | 224 | 258 | 290 | 832 | 1216 | 1376 | 1410 | 1442:
					resetChars();
					switchChars('dad');
				case 216 | 248 | 280 | 1368 | 1400 | 1432 | 1472:
					resetChars();
					switchChars('dad');
					switchChars('clooshie');
				case 448 | 1088:
					resetChars();
					switchChars('clooshie');
			}
			// drainAmount
			switch(curStep)
			{
				case 1:
					drainAmount = 0.001;
				case 576:
					drainAmount = 0.002;
				case 832:
					drainAmount = 0.0025;
				case 1120:
					drainAmount = 0.001;
				case 1215:
					drainAmount = 0.002;
				case 1216 | 1248 | 1280 | 1312:
					drainAmount += 0.0005;
				case 1616:
					drainAmount = 0.002;
			}
		}
		if (curSong == 'all-around-you')
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
					for (i in 0...4)
					{
						FlxTween.tween(strumLineNotes.members[i], {alpha: 0}, 0.2, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							strumLineNotes.members[i].visible = false;
						}});
					}
				case 224:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 560:
					resetChars();
					switchChars('james');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 784:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 944:
					resetChars();
					switchChars('dad');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf');
					add(boyfriend);
				case 1024:
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 1124:
					resetChars();
					switchChars('sheary-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal-f');
					add(boyfriend);
				case 1508:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 1572:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 1752:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 1756:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 1760:
					resetChars();
					switchChars('cluckington-f');
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 1892:
					resetChars();
					switchChars('trooper-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-front');
					add(boyfriend);
				case 2084:
					resetChars();
					switchChars('dad');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf');
					add(boyfriend);
				case 2096:
					resetChars();
					switchChars('james');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 2108:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 2128:
					resetChars();
					switchChars('sheary-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal-f');
					add(boyfriend);
				case 2144:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 2160:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 2176:
					resetChars();
					switchChars('trooper-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-front');
					add(boyfriend);
				case 2308:
					resetChars();
					switchChars('gooey-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal-f');
					add(boyfriend);
				case 2628:
					resetChars();
					switchChars('supermooshie-diagonal');
				case 2828:
					resetChars();
					switchChars('dad');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf');
					add(boyfriend);
				case 2832:
					resetChars();
					switchChars('james');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 2836:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 2840:
					resetChars();
					switchChars('sheary-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal-f');
					add(boyfriend);
				case 2844:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 2848:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 2852:
					resetChars();
					switchChars('trooper-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-front');
					add(boyfriend);
				case 2856:
					resetChars();
					switchChars('gooey-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal-f');
					add(boyfriend);
				case 2860:
					resetChars();
					switchChars('supermooshie-diagonal');
				case 2868:
					resetChars();
					switchChars('dad');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf');
					add(boyfriend);
				case 2876:
					resetChars();
					switchChars('james');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 2884:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 2892:
					resetChars();
					switchChars('sheary-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal-f');
					add(boyfriend);
				case 2900:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 2908:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 2916:
					resetChars();
					switchChars('trooper-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-front');
					add(boyfriend);
				case 2924:
					resetChars();
					switchChars('gooey-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal-f');
					add(boyfriend);
				case 2932:
					resetChars();
					switchChars('supermooshie-diagonal');
				case 2940:
					resetChars();
					switchChars('dad');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf');
					add(boyfriend);
				case 2942:
					resetChars();
					switchChars('james');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal');
					add(boyfriend);
				case 2944:
					resetChars();
					switchChars('ghost-front');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-battle');
					add(boyfriend);
				case 2946:
					resetChars();
					switchChars('sheary-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-bDiagonal-f');
					add(boyfriend);
				case 2948:
					resetChars();
					switchChars('cluckington-f');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-flipped');
					add(boyfriend);
				case 2950:
					resetChars();
					switchChars('clooshie-diagonal');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal');
					add(boyfriend);
				case 2952:
					resetChars();
					switchChars('trooper-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-front');
					add(boyfriend);
				case 2954:
					resetChars();
					switchChars('gooey-back');
					remove(boyfriend);
					boyfriend = new Boyfriend(1664, 1432, 'bf-frDiagonal-f');
					add(boyfriend);
				case 2956:
					resetChars();
					switchChars('supermooshie-diagonal');
			}
			if (isDad && !isGhost)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isJames || isSupermooshie)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 200}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 200}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 200}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 200}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if ((isGhost && !isDad) || isTrooper) // middle
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isSheary || (isCloosh && !isCluck))
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isCluck && !isCloosh)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isGooey)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 300}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 300}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 300}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 300}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isDad && isGhost)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 100}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 380}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
			else if (isCluck && isCloosh)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 580}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 680}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
		}
		if (curSong == 'fury')
		{
			switch (curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
				case 1408:
					resetChars();
					switchChars('stickletto-i');
				case 1656:
					resetChars();
					switchChars('dad');
			}
		}
		if (curSong == 'rage')
		{
			switch (curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
				case 1792:
					resetChars();
					switchChars('stickletto-i');
				case 2048:
					resetChars();
					switchChars('dad');
			}
		}
		if (curSong == 'fiery-madness')
		{
			switch (curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
				case 2176:
					resetChars();
					switchChars('stickletto-i');
				case 2432:
					resetChars();
					switchChars('dad');
			}
		}
		if (curSong == 'enemy')
		{
			switch(curStep)
			{
				case 1 | 1216:
					resetChars();
					switchChars('dad');
				case 648:
					resetChars();
					switchChars('swordletto');
					boyfriend.playAnim('pushed', true);
				case 656 | 1344:
					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto-unc-f');
					add(boyfriend);
				case 1216 | 1472:
					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto-unc');
					add(boyfriend);
			}
			switch(curStep)
			{
				case 1088 | 1120 | 1152 | 1184 | 1216 | 1280 | 1312 | 1344 | 1376 | 1408 | 1440 | 1472 | 1536 | 1568:
					defaultCamZoom = 0.6;
					FlxG.camera.flash(FlxColor.WHITE, 0.5);
					camHUD.flash(FlxColor.BLACK, 0.5);
				case 1092 | 1124 | 1156 | 1188 | 1200:
					defaultCamZoom = 1.1;
				case 1224 | 1480:
					defaultCamZoom = 0.7;
				case 1232 | 1308 | 1488 | 1564:
					defaultCamZoom = 0.8;
				case 1240 | 1256 | 1264 | 1496 | 1512 | 1520:
					defaultCamZoom = 0.9;
				case 1244 | 1252 | 1260 | 1268 | 1304 | 1500 | 1508 | 1516 | 1524 | 1560:
					defaultCamZoom = 1.0;
				case 1248 | 1272 | 1328 | 1360 | 1392 | 1424 | 1456 | 1504 | 1528 | 1584:
					defaultCamZoom = 1.1;
			}
		}
		if (curSong == 'trust')
		{
			switch(curStep)
			{
				case 1 | 976 | 1040 | 1136 | 1312 | 1408:
					resetChars();
					switchChars('dad');

					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto');
					add(boyfriend);
				case 632 | 1024 | 1088 | 1152 | 1344 | 1472:
					resetChars();
					switchChars('swordletto');

					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto-f');
					add(boyfriend);
				case 1536:
					resetChars();
					switchChars('dad');
					switchChars('swordletto');
			}
			switch(curStep)
			{
				case 896:
					defaultCamZoom = 1.1;
				case 1344 | 1408 | 1440 | 1472 | 1504 | 1536 | 1600 | 1664 | 1696 | 1738 | 1760 | 1792:
					defaultCamZoom = 0.6;
					FlxG.camera.flash(FlxColor.WHITE, 0.5);
					camHUD.flash(FlxColor.BLACK, 0.5);
				case 1360 | 1424 | 1456 | 1488 | 1520 | 1616 | 1680 | 1712 | 1744 | 1776:
					defaultCamZoom = 1.1;
				case 1376 | 1632:
					defaultCamZoom = 1.0;
				case 1380 | 1537 | 1636 | 1793:
					defaultCamZoom = 0.9;
				case 1384 | 1640:
					defaultCamZoom = 0.8;
				case 1388 | 1644:
					defaultCamZoom = 0.7;
			}
		}
		if (curSong == 'team-up')
		{
			switch(curStep)
			{
				case 1 | 560 | 768:
					resetChars();
					switchChars('dad');

					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto');
					add(boyfriend);
				case 272 | 705:
					resetChars();
					switchChars('swordletto');

					remove(boyfriend);
					boyfriend = new Boyfriend(692.4, 236.05, 'stickletto-f');
					add(boyfriend);
			}

			if (curStep >= 704 && curStep < 960 && curStep % 16 == 0)
			{
				FlxG.camera.flash(FlxColor.WHITE, 0.5);
				camHUD.flash(FlxColor.BLACK, 0.5);
			}
		}
		if (curSong == 'hit-and-miss')
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
					resetP1();
					switchP1('bf');
				case 128 | 448:
					resetChars();
					switchChars('sticko');
				case 136 | 512:
					resetP1();
					switchP1('stickletto');
				case 320 | 944:
					resetChars();
					switchChars('dad');
				case 384 | 960 | 1408:
					resetP1();
					switchP1('bf');
				case 640:
					resetChars();
					switchChars('dad');
					resetP1();
					switchP1('bf');
				case 768:
					resetChars();
					switchChars('sticko');
					resetP1();
					switchP1('stickletto');
				case 1088:
					resetP1();
					switchP1('bfSt'); // bf and stickletto
				case 1344:
					resetChars();
					switchChars('dad');
					switchChars('sticko');
			}
		}
		if (curSong == 'duplication')
		{
			switch(curStep)
			{
				case 1 | 584 | 1160:
					clone1.alpha = 0;
					resetChars();
					switchChars('dad');
				case 544 | 1120:
					clone1.alpha = 1;
					resetChars();
					switchChars('dad');
					switchChars('clone');
			}
			switch(curStep)
			{
				case 544 | 584 | 1120 | 1160:
					camHUD.flash(FlxColor.BLACK, 0.5);
			}
			switch(curStep)
			{
				case 512 | 640 | 1024:
					remove(cyan);
					FlxTween.tween(redR, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
				case 576 | 704 | 1152:
					FlxTween.tween(redR, {color: FlxColor.CYAN}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
					{
						remove(dad);
						remove(boyfriend);
						remove(clone1);
						add(cyan);
						add(dad);
						add(boyfriend);
						add(clone1);
					}});
				case 768 | 1280:
					remove(cyan);
					FlxTween.tween(redR, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut});
			}
		}
		if (curSong == 'darkness')
		{
			switch(curStep)
			{
				case 1 | 328 | 968:
					clone1.alpha = 0;
					resetChars();
					switchChars('dad');
				case 256 | 896:
					clone1.alpha = 1;
					resetChars();
					switchChars('dad');
					switchChars('clone');
				case 512:
					clone2.alpha = 1;
				case 969:
					clone2.alpha = 0;
			}
			switch(curStep)
			{

				case 512 | 518 | 525 | 528 | 532 | 537 | 541 | 552 | 570:
					clone2.playAnim('singRIGHT', true);
				case 513 | 520 | 523 | 526 | 530 | 534 | 536 | 538 | 540 | 542 | 546 | 550 | 554 | 560 | 564 | 568:
					clone2.playAnim('singUP', true);
				case 514 | 516 | 521 | 527 | 529 | 531 | 544 | 548 | 556 | 557 | 558 | 559 | 562 | 566 | 572 | 573 | 574 | 575:
					clone2.playAnim('singDOWN', true);
				case 515 | 517 | 519 | 522 | 524 | 533 | 535 | 539 | 543:
					clone2.playAnim('singLEFT', true);

				case 578 | 672 | 704 | 784 | 820 | 960:
					clone2.playAnim('idle', true);

				case 656 | 664 | 688 | 696:
					clone2.playAnim('singUP', true);
				case 658 | 665 | 692 | 698:
					clone2.playAnim('singDOWN', true);
				case 660 | 668:
					clone2.playAnim('singRIGHT', true);
				case 694 | 700:
					clone2.playAnim('singLEFT', true);

				case 768 | 776 | 800 | 808:
					clone2.playAnim('singRIGHT', true);
				case 770 | 774 | 778 | 782 | 811 | 815:
					clone2.playAnim('singLEFT', true);
				case 772 | 780 | 813:
					clone2.playAnim('singUP', true);
				case 802 | 804 | 806 | 810 | 812 | 814:
					clone2.playAnim('singDOWN', true);

				case 896 | 904 | 916 | 928 | 936:
					clone2.playAnim('singUP', true);
				case 900 | 908 | 918 | 932 | 940 | 952:
					clone2.playAnim('singDOWN', true);
				case 912 | 944:
					clone2.playAnim('singRIGHT', true);
			}
			switch(curStep)
			{
				case 256 | 328 | 512 | 896 | 968:
					camHUD.flash(FlxColor.BLACK, 0.5);
			}
			switch(curStep)
			{
				case 512 | 640 | 1024 | 1152:
					remove(cyan);
					FlxTween.tween(redR, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
				case 576 | 704 | 1088 | 1216:
					FlxTween.tween(redR, {color: FlxColor.CYAN}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
					{
						remove(dad);
						remove(boyfriend);
						remove(clone1);
						add(cyan);
						add(dad);
						add(boyfriend);
						add(clone1);
					}});
				case 768 | 1280:
					remove(cyan);
					FlxTween.tween(redR, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut});
			}
		}
		if (curSong == 'striker')
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
					resetP1();
					switchP1('bf');
				case 640 | 1152 | 1408:
					resetP1();
					switchP1('st');
				case 1024 | 1280:
					resetP1();
					switchP1('bf');
				case 1664:
					resetP1();
					switchP1('bfSt');
			}
			switch(curStep)
			{
				case 1008:
					defaultCamZoom = 1.3;
				case 1024:
					defaultCamZoom = 1.1;
					camHUD.flash(FlxColor.BLACK, 0.5);
				case 1536:
					defaultCamZoom = 1.4;
					camHUD.flash(FlxColor.BLACK, 1.5);
				case 1664:
					defaultCamZoom = 1.0;
			}
		}
		else
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad');
			}
		}

		if (curSong == 'slimy')
		{
			switch(curStep)
			{
				case 1178 | 1210 | 1306 | 1338:
					FlxTween.tween(leCoolBl, {alpha: 0.5}, 0.01, {ease: FlxEase.smoothStepOut});
				case 1180 | 1212 | 1308 | 1340:
					FlxTween.tween(leCoolBl, {alpha: 1}, 0.01, {ease: FlxEase.smoothStepOut});
				case 1184 | 1216 | 1312 | 1344:
					FlxTween.tween(leCoolBl, {alpha: 0}, 0.01, {ease: FlxEase.smoothStepOut});
			}
		}

		// I could've just done a tween but I didn't feel like it for some reason
		if (curSong == 'slime-rematch')
		{
			switch (curStep)
			{
				case 960:
					leCoolBl.alpha = 0.00819672131;
				case 961 | 962 | 963 | 964 | 965 | 966 | 967 | 968 | 969 | 970 | 971 | 972 | 973 | 974 | 975 | 976:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 977 | 978 | 979 | 980 | 981 | 982 | 983 | 984 | 985 | 986 | 987 | 988 | 989 | 990 | 991 | 992:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 993 | 994 | 995 | 996 | 997 | 998 | 999 | 1000 | 1001 | 1002 | 1004 | 1006 | 1008:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 1009 | 1010 | 1011 | 1012 | 1013 | 1014 | 1015 | 1016 | 1017 | 1018 | 1019 | 1020 | 1021 | 1022 | 1023:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131; // by now it's at 0.5 alpha
				case 1024 | 1025 | 1026 | 1027 | 1028 | 1029 | 1030 | 1031 | 1032 | 1033 | 1034 | 1035 | 1036 | 1037 | 1038 | 1039:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 1040 | 1041 | 1042 | 1043 | 1044 | 1045 | 1046 | 1047 | 1048 | 1049 | 1050 | 1051 | 1052 | 1053 | 1054 | 1055:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 1056 | 1057 | 1058 | 1059 | 1060 | 1061 | 1062 | 1063 | 1064 | 1065 | 1066 | 1068 | 1070:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131;
				case 1072 | 1073 | 1074 | 1075 | 1076 | 1077 | 1078 | 1079 | 1080 | 1081 | 1082 | 1083 | 1084 | 1085 | 1086 | 1087:
					leCoolBl.alpha = leCoolBl.alpha + 0.00819672131; // by now it's fully visible
			}
		}

		if (curSong == 'switch')
		{
			switch(curStep)
			{
				case 256 | 1216 | 1824:
					resetP1();
					switchP1('sa'); // Stickletta
				case 512 | 1280 | 1856:
					resetP1();
					switchP1('sb'); // Sticklettabow
				case 768 | 1344 | 1888:
					resetP1();
					switchP1('sw'); // Swordletto
				case 1024 | 1792:
					resetP1();
					switchP1('bf'); // Stickletto
				case 1536:
					resetP1();
					switchP1('sa'); // Stickletta
					resetChars();
					switchChars('bf'); // Stickletto
				case 1600:
					resetP1();
					switchP1('sb'); // Sticklettabow
					resetChars();
					switchChars('swordletto');
				case 1664:
					resetChars();
					switchChars('dad'); // Crocker
			}
		}

		if (curSong == 'bite')
		{
			switch(curStep)
			{
				case 255 | 1792:
					resetChars();
					switchChars('dad'); // Crocker
				case 383 | 1664 | 2176:
					resetP1();
					switchP1('bf'); // Stickletto
				case 640 | 2208:
					resetP1();
					switchP1('sb'); // Sticklettabow
				case 768 | 1696 | 2240:
					resetP1();
					switchP1('sa'); // Stickletta
				case 1024 | 2016 | 2272:
					resetP1();
					switchP1('sw'); // Swordletto
				case 1728:
					resetP1();
					switchP1('sa'); // Stickletta
					resetChars();
					switchChars('bf'); // Stickletto
				case 1920:
					resetP1();
					switchP1('sw'); // Swordletto
					resetChars();
					switchChars('sb'); // Sticklettabow
				case 1984:
					resetChars();
					switchChars('dad'); // Crocker
					resetP1();
					switchP1('sb'); // Sticklettabow
			}
			switch(curStep)
			{
				case 1280:
					playMidCutscene('crocker bites');
				case 1408:
					remove(cyan);
					cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFFEF8AFF);
					add(cyan);
					camHUD.flash(FlxColor.RED, 1.09);
					health -= 1.5;
				case 1792:
					remove(cyan);
					cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFFE331FF);
					add(cyan);
					camHUD.flash(FlxColor.RED, 1.09);
				case 2048:
					remove(cyan);
					cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFFA000BA);
					add(cyan);
					camHUD.flash(FlxColor.RED, 1.09);
			}
			if (curStep % 16 == 0)
			{
				if (!inCutscene)
				{
					if (curStep >= 1408)
						camHUD.flash(0xAAFF0000, 0.545);
					if (curStep >= 1408 && curStep < 1792)
						health -= 0.02;
					else if (curStep >= 1792 && curStep < 2048)
						health -= 0.05;
					else if (curStep >= 2048)
						health -= 0.1;
				}
			}
		}

		if (curSong == 'crocker')
		{
			switch(curStep)
			{
				case 1:
					resetChars();
					switchChars('dad'); // Crocker
					resetP1();
					switchP1('sa'); // Stickletta
				case 512 | 1536:
					resetP1();
					switchP1('sb'); // Sticklettabow
				case 640:
					resetP1();
					switchP1('bf'); // Stickletto
				case 1280:
					resetP1();
					switchP1('sa'); // Stickletta
				case 1664:
					resetP1();
					switchP1('sw'); // Swordletto
				case 2304:
					resetP1();
					switchP1('stSa'); // Stickletto and Stickletta
				case 2560:
					resetP1();
					switchP1('sbSw'); // Swordletto and Swordletto
			}
			switch(curStep)
			{
				case 896 | 2432:
					remove(cyan);
					cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFF79008D);
					add(cyan);
					camHUD.flash(FlxColor.RED, 0.96);
				case 1664:
					remove(cyan);
					cyan = new FlxSprite(-1200, -200).makeGraphic(3000, 3000, 0xFFA000BA);
					add(cyan);
					camHUD.flash(FlxColor.RED, 0.96);
			}
			if (curStep % 16 == 0)
			{
				if (!inCutscene)
				{
					camHUD.flash(0xAAFF0000, 0.48);
					if ((curStep < 896) || (curStep >= 1664 && curStep < 2432))
						health -= 0.1;
					else if ((curStep >= 896 && curStep < 1664) || (curStep >= 2432))
						health -= 0.2;
				}
			}
		}

		if (curSong == 'sticklettabreaker')
		{
			final zxcv:Float = 100;
			final bnm:Float  = 400;
			final rewq:Float = 770;
			final poiu:Float = 450;
			// Most things
			switch(curStep)
			{
				case 1136:
					dodgeCheck(0,0); // Normal dodge, but you can't dodge
				case 1144: // add sound effects here here here here here here here hre here hre rehre her e
					remove(dad);
					FlxTween.tween(cyan, {color: FlxColor.RED}, 0.57, {ease: FlxEase.smoothStepOut});
				case 1148 | 1149 | 1150 | 1151:
					health -= 0.2;
				case 1152:
					camHUD.flash(FlxColor.CYAN, 0.57);
					remove(dad);
					remove(clone2);
					dad = new Character(zxcv, bnm, 'clonerman');
					add(dad);
				case 1408:
					camHUD.flash(FlxColor.BLACK, 0.5);
					clone2 = new Character(dad.x + dad.width * 1.25, dad.y - 50, 'clonerman');
					add(clone2);
				case 1544:
					camHUD.flash(FlxColor.BLACK, 0.5);
					remove(clone2);
				case 1912:
					var tp:FlxSprite = new FlxSprite(boyfriend.x + 1000, boyfriend.y + boyfriend.height / 4).loadGraphic(Paths.image('tp thing'));
					tp.antialiasing = true;
					add(tp);
					FlxTween.tween(tp, {x: dad.x * 2}, 0.57, {onComplete: function(t:FlxTween)
					{
						remove(tp);
						clone2 = new Character(dad.x * 2, dad.y, 'yellow');
						add(clone2);
						remove(dad);
						FlxTween.tween(cyan, {color: FlxColor.BLUE}, 0.57, {onComplete: function(t:FlxTween)
						{
							camHUD.flash(FlxColor.YELLOW, 0.57);
							remove(clone2);
							dad = new Character(zxcv, bnm, 'yellow');
							add(dad);
						}});
					}});
				case 2464 | 9152:
					clone1 = new Character(1600, boyfriend.y - 1000, 'red-f');
					add(clone1);

					FlxTween.tween(clone1, {y: 300}, 1.14, {ease: FlxEase.sineOut, onComplete: function(t:FlxTween)
					{
						resetChars();
						switchChars('clone');
					}});
				case 2488 | 9176:
					remove(dad);
					FlxTween.tween(cyan, {color: FlxColor.CYAN}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.RED, 0.57);
						remove(boyfriend);
						boyfriend = new Boyfriend(rewq, poiu, 'stickletto-f');
						add(boyfriend);
					}});
				case 3196:
					remove(clone1);
					FlxTween.tween(cyan, {color: FlxColor.LIME}, 0.285, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.MAGENTA, 0.57);
						resetChars();
						switchChars('dad');

						dad = new Character(zxcv, bnm, 'stickletta');
						add(dad);

						new FlxTimer().start(0.285, function(t:FlxTimer)
						{
							remove(boyfriend);
							boyfriend = new Boyfriend(rewq, poiu, 'stickletto');
							add(boyfriend);
						}, 1);
					}});
				case 3320:
					remove(boyfriend);
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);

						remove(dad);
						dad = new Character(zxcv - 700, bnm, 'sticko');
						add(dad);

						boyfriend = new Boyfriend(zxcv, bnm, 'stickletta-f');
						add(boyfriend);
					}});
				case 3832:
					remove(dad);
					FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.WHITE, 0.57);

						dad = new Character(rewq, bnm, 'stickletto-i-w-f');
						add(dad);

						remove(boyfriend);
						boyfriend = new Boyfriend(zxcv, bnm, 'stickletta-c-f');
						add(boyfriend);
						var oldRight = boyfriend.animation.getByName('singRIGHT').frames;
						boyfriend.animation.getByName('singRIGHT').frames = boyfriend.animation.getByName('singLEFT').frames;
						boyfriend.animation.getByName('singLEFT').frames = oldRight;
					}});
				case 3968:
					FlxTween.tween(cyan, {color: 0xFF333333}, 0.285);
				case 4096:
					FlxTween.tween(cyan, {color: 0xFF444444}, 0.285);
				case 4224:
					FlxTween.tween(cyan, {color: 0xFF808080}, 0.285);
				case 4288:
					FlxTween.tween(cyan, {color: 0xFF989898}, 0.285);
				case 4320:
					FlxTween.tween(cyan, {color: 0xFFA9A9A9}, 0.285);
				case 4336:
					FlxG.camera.flash(FlxColor.WHITE, 0.57);
					remove(dad);
					dad = new Character(rewq, poiu, 'stickletto');
					dad.flipX = false;
					add(dad);
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.285);
				case 4345:
					clone1 = new Character(435, 100, 'striker-fr');
					add(clone1);
					clone1.playAnim('appear', true);
				case 4352:
					remove(boyfriend);
					boyfriend = new Boyfriend(rewq, poiu, 'stickletto-b');
					add(boyfriend);
					remove(clone1);
					remove(dad);
					dad = new Character(435, 100, 'striker-fr');
					add(dad);
					remove(stickletta);
					stickletta = new Character(zxcv, poiu, 'stickletta-b');
					add(stickletta);

					resetP1();
					switchP1('sa'); // stickletta
				case 4992 | 5248:
					resetP1();
					switchP1('bf'); // stickletto
				case 5120:
					resetP1();
					switchP1('sa'); // stickletta
				case 5368:
					remove(dad);
					dad = new Character(435, 100, 'stiburn-fr');
					add(dad);
					dad.playAnim('appear', true);
					FlxTween.tween(cyan, {color: 0xFF7F0000}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);
					}});
				case 5504:
					resetChars();
					switchChars('sa'); // stickletta
				case 5628:
					dad.playAnim('attack', true);
				case 5632:
					resetChars();
					switchChars('dad'); // opponent
					camHUD.flash(FlxColor.WHITE, 0.57);

					remove(stickletta);
					remove(dad);
					dad = new Character(rewq, bnm, 'stickletto-i-w-f');
					add(dad);

					remove(boyfriend);
					boyfriend = new Boyfriend(zxcv, bnm, 'stickletta-c-f');
					add(boyfriend);
					var oldRight = boyfriend.animation.getByName('singRIGHT').frames;
					boyfriend.animation.getByName('singRIGHT').frames = boyfriend.animation.getByName('singLEFT').frames;
					boyfriend.animation.getByName('singLEFT').frames = oldRight;
				case 5752:
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);

						remove(dad);
						remove(boyfriend);
						remove(stickletta);
						remove(swordletto);
						dad = new Character(zxcv, poiu, 'sticklettabow');
						boyfriend = new Boyfriend(zxcv + dad.width * 1.25, poiu, 'stickletto-f');
						stickletta = new Character(rewq, poiu, 'stickletta');
						swordletto = new Character(stickletta.x + stickletta.width * 1.25, bnm, 'swordletto');
						add(dad);
						add(boyfriend);
						add(stickletta);
						add(swordletto);
					}});
				case 5760:
					resetChars();
					switchChars('sw'); // swordletto
					resetP1();
					switchP1('bf'); // stickletto
				case 5888 | 6272:
					resetChars();
					switchChars('dad'); // sticklettabow
				case 6016:
					remove(boyfriend);
					boyfriend = new Boyfriend(zxcv + dad.width * 1.25, poiu, 'stickletto');
					add(boyfriend);
				case 6144:
					resetChars();
					switchChars('sw'); // swordletto
					resetP1();
					switchP1('sa'); // stickletta
				case 6520 | 9240:
					FlxTween.tween(cyan, {color: 0xFF107500}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.LIME, 0.57);
						resetP1();
						resetChars();
						switchP1('bf');
						switchChars('dad');

						remove(dad);
						remove(boyfriend);
						remove(stickletta);
						remove(swordletto);
						remove(sticklettabow);
						dad = new Character(zxcv, 100, 'crocker');
						boyfriend = new Boyfriend(zxcv, dad.y + dad.height - boyfriend.height / 2, 'stickletto-b');
						boyfriend.x = dad.x - boyfriend.width;
						stickletta = new Character(boyfriend.x - boyfriend.width * 1.5, boyfriend.y, 'stickletta-b');
						sticklettabow = new Character(dad.x + boyfriend.width * 2, boyfriend.y, 'sticklettabow-b');
						swordletto = new Character(dad.x + boyfriend.width * 2 + sticklettabow.width + 20, boyfriend.y, 'swordletto-b');
						add(dad);
						add(boyfriend);
						add(stickletta);
						add(swordletto);
						add(sticklettabow);
					}});
				case 7360 | 7680 | 8640:
					resetP1();
					switchP1('sa'); // stickletta
				case 7424 | 8576 | 8960:
					resetP1();
					switchP1('bf'); // stickletto
				case 7936 | 8832:
					resetP1();
					switchP1('sb'); // sticklettabow
				case 8192 | 8896:
					resetP1();
					switchP1('sw'); // swordletto
				case 8952:
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);
						resetP1();
						resetChars();
						switchP1('bf');
						switchChars('dad');

						remove(dad);
						remove(boyfriend);
						remove(stickletta);
						remove(swordletto);
						remove(sticklettabow);
						dad = new Character(zxcv, bnm, 'sticko');
						boyfriend = new Boyfriend(rewq, poiu, 'stickletto');
						add(dad);
						add(boyfriend);
					}});
				case 8984:
					FlxTween.tween(cyan, {color: FlxColor.LIME}, 0.285, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.MAGENTA, 0.57);

						remove(dad);
						dad = new Character(zxcv, bnm, 'stickletta');
						add(dad);
						remove(boyfriend);
						boyfriend = new Boyfriend(rewq, poiu, 'stickletto');
						add(boyfriend);
					}});
				case 9016:
					FlxTween.tween(cyan, {color: FlxColor.RED}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.CYAN, 0.57);

						remove(dad);
						remove(boyfriend);
						dad = new Character(zxcv, bnm, 'clonerman');
						add(dad);
						boyfriend = new Boyfriend(rewq, poiu, 'stickletto');
						add(boyfriend);
					}});
				case 9048:
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);

						resetChars();
						switchChars('sw');
						remove(dad);
						remove(boyfriend);
						remove(stickletta);
						remove(swordletto);
						dad = new Character(zxcv, poiu, 'sticklettabow');
						boyfriend = new Boyfriend(zxcv + dad.width * 1.25, poiu, 'stickletto-f');
						stickletta = new Character(rewq, poiu, 'stickletta');
						swordletto = new Character(stickletta.x + stickletta.width * 1.25, bnm, 'swordletto');
						add(dad);
						add(boyfriend);
						add(stickletta);
						add(swordletto);
						new FlxTimer().start(0.57, function(t:FlxTimer)
						{
							resetChars();
							switchChars('dad');
						}, 1);
					}});
				case 9080:
					remove(dad);
					remove(boyfriend);
					remove(stickletta);
					remove(swordletto);
					FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.WHITE, 0.57);

						dad = new Character(rewq, bnm, 'stickletto-i-w-f');
						add(dad);

						boyfriend = new Boyfriend(zxcv, bnm, 'stickletta-c-f');
						add(boyfriend);
						var oldRight = boyfriend.animation.getByName('singRIGHT').frames;
						boyfriend.animation.getByName('singRIGHT').frames = boyfriend.animation.getByName('singLEFT').frames;
						boyfriend.animation.getByName('singLEFT').frames = oldRight;
					}});
				case 9112:
					FlxTween.tween(cyan, {color: FlxColor.WHITE}, 0.57);
					remove(clone1);
					clone1 = new Character(435, 100, 'striker-fr');
					add(clone1);
					clone1.playAnim('appear', true);
				case 9120:
					camHUD.flash(FlxColor.BLACK, 0.57);

					remove(boyfriend);
					boyfriend = new Boyfriend(rewq, poiu, 'stickletto-b');
					add(boyfriend);
					remove(clone1);
					remove(dad);
					dad = new Character(435, 100, 'striker-fr');
					add(dad);
					remove(stickletta);
					stickletta = new Character(zxcv, poiu, 'stickletta-b');
					add(stickletta);

					resetP1();
					switchP1('sa'); // stickletta
				case 9136:
					var tp:FlxSprite = new FlxSprite(boyfriend.x + 1000, boyfriend.y + boyfriend.height / 4).loadGraphic(Paths.image('tp thing'));
					tp.antialiasing = true;
					add(tp);
					FlxTween.tween(tp, {x: dad.x * 2}, 0.57, {onComplete: function(t:FlxTween)
					{
						remove(tp);
						clone2 = new Character(dad.x * 2, dad.y, 'yellow');
						add(clone2);
						remove(dad);
						FlxTween.tween(cyan, {color: FlxColor.BLUE}, 0.57, {onComplete: function(t:FlxTween)
						{
							camHUD.flash(FlxColor.YELLOW, 0.57);
							resetP1();
							switchP1('bf'); // stickletto

							remove(stickletta);
							remove(clone2);
							dad = new Character(zxcv, bnm, 'yellow');
							add(dad);
							remove(boyfriend);
							boyfriend = new Boyfriend(rewq, poiu, 'stickletto');
							add(boyfriend);
						}});
					}});
				case 9208:
					FlxTween.tween(cyan, {color: 0xFF7F0000}, 0.57, {onComplete: function(t:FlxTween)
					{
						camHUD.flash(FlxColor.BLACK, 0.57);
						resetChars();
						switchChars('dad');

						remove(clone1);
						remove(dad);
						dad = new Character(435, 100, 'stiburn-fr');
						add(dad);
						remove(boyfriend);
						boyfriend = new Boyfriend(rewq, poiu, 'stickletto-b');
						add(boyfriend);
						remove(stickletta);
						stickletta = new Character(zxcv, poiu, 'stickletta-b');
						add(stickletta);
					}});
				case 9232:
					resetChars();
					switchChars('sa');
				case 9280:
					resetP1();
					switchP1('bf');
				case 9288:
					resetP1();
					switchP1('stSa');
				case 9296:
					resetP1();
					switchP1('stSaSb');
				case 9304:
					resetP1();
					switchP1('stSaSbSw');
			}
			// Clone movements
			switch(curStep)
			{
				case 1408 | 1412 | 1428 | 1440 | 1444 | 1472 | 1492 | 1504:
					clone2.playAnim('singRIGHT', true);
				case 1416 | 1420 | 1432 | 1436 | 1448 | 1452 | 1464 | 1468 | 1480 | 1484 | 1496 | 1500 | 1512 | 1528 | 1532:
					clone2.playAnim('singLEFT', true);
				case 1424 | 1460 | 1476 | 1488 | 1508 | 1516 | 1524:
					clone2.playAnim('singDOWN', true);
				case 1430 | 1456 | 1494 | 1520:
					clone2.playAnim('singUP', true);
			}
			// Dodge appear
			switch(curStep)
			{
				case 1920 | 1936 | 2240 | 2256 | 2360 | 2364:
					preBattle(0); // Normal dodge
					resetBattleCounter();
				case 1952 | 1968 | 2272 | 2304 | 2344:
					preBattle(1); // Left dodge
					resetBattleCounter();
				case 1960 | 1976 | 2288 | 2312 | 2336 | 9136:
					preBattle(2); // Right dodge
					resetBattleCounter();
			}
			// Dodge check
			switch(curStep)
			{
				case 1928 | 1944 | 2248 | 2264 | 2362 | 2366:
					dodgeCheck(0,0); // Normal dodge
				case 1956 | 1972 | 2280 | 2308 | 2348:
					dodgeCheck(0,1); // Left dodge
				case 1964 | 1980 | 2296 | 2316 | 2340 | 9152:
					dodgeCheck(0,2); // Right dodge
			}
			// Strumline shit
			switch(curStep)
			{
				case 1:
					// Makes opponent strums invisible
					for (i in 0...4)
					{
						FlxTween.tween(strumLineNotes.members[i], {alpha: 0}, 0.285, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							strumLineNotes.members[i].visible = false;
						}});
					}
				// Left side in  2 beats
				case 2488 | 3832 | 5624 | 9080 | 9176:
					// Player, left, middle, right, time
					moveStrums(true, true, false, false, 0.57);
				// Right side in 2 beats
				case 3192 | 9144:
					moveStrums(true, false, false, true, 0.57);
				// Makes player strums invisible in 1 beat
				case 4352:
					for (i in 0...4)
					{
						FlxTween.tween(playerStrums.members[i], {alpha: 0}, 0.285, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							playerStrums.members[i].visible = false;
						}});
					}
				// Makes player strums invisible in 1 beat
				case 4592:
					for (i in 0...4)
					{
						playerStrums.members[i].visible = true;
						playerStrums.members[i].alpha = 0;
						FlxTween.tween(playerStrums.members[i], {alpha: 1}, 1.04, {ease: FlxEase.smoothStepOut});
					}
				// Right side in 1 beat
				case 4992 | 5248 | 8192 | 8896:
					moveStrums(true, false, false, true, 0.285);
				// Left side in  1 beat
				case 5120 | 7296 | 7680 | 8640:
					moveStrums(true, true, false, false, 0.285);
				// Middle in 4 beats
				case 5488:
					moveStrums(true, false, true, false, 1.04);
				// Middle in 2 beats
				case 5752 | 9048 | 9208:
					moveStrums(true, false, true, false, 0.57);
				// Makes player strums invisible in 1 beat
				case 6524:
					for (i in 0...4)
					{
						FlxTween.tween(playerStrums.members[i], {alpha: 0}, 0.285, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							playerStrums.members[i].visible = false;
						}});
					}
				case 6752 | 7424 | 8448:
					FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 200}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 200}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 200}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 200}, 0.285, {ease: FlxEase.smoothStepInOut});
				// Makes player strums visible in 4 beats
				case 6768:
					for (i in 0...4)
					{
						playerStrums.members[i].visible = true;
						playerStrums.members[i].alpha = 0;
						FlxTween.tween(playerStrums.members[i], {alpha: 1}, 1.04, {ease: FlxEase.smoothStepOut});
					}
				case 7936 | 8704:
					FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 500}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 500}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 500}, 0.285, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 500}, 0.285, {ease: FlxEase.smoothStepInOut});
				case 9240:
					FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 200}, 0.57, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 200}, 0.57, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 200}, 0.57, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 200}, 0.57, {ease: FlxEase.smoothStepInOut});
				case 9288:
					FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 100}, 0.57, {ease: FlxEase.smoothStepInOut});
				case 9296:
					FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 500}, 0.57, {ease: FlxEase.smoothStepInOut});
				case 9304:
					FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 600}, 0.57, {ease: FlxEase.smoothStepInOut});
			}
			// Zooms and some flashes
			switch(curStep)
			{
				case 384:
					defaultCamZoom = 1.2;
				case 640 | 3328 | 4864 | 6464 | 6496:
					defaultCamZoom = 0.8;
				case 896 | 3584 | 5696:
					defaultCamZoom = 1.0;
				case 1136:
					defaultCamZoom = 1.2;
				case 1144 | 4352 | 5752 | 6524:
					defaultCamZoom = 1.4;
				case 1152 | 3840 | 4336 | 5120 | 5504 | 5760 | 6472 | 6504:
					defaultCamZoom = 0.9;
				case 1408 | 4224 | 5376 | 6480 | 6512:
					defaultCamZoom = 1.0;
				case 1664:
					defaultCamZoom = 0.9;
				case 1920 | 4608 | 6488:
					defaultCamZoom = 1.2;
				case 2048 | 4288 | 5728 | 6492:
					defaultCamZoom = 1.1;
				case 2112 | 2432:
					defaultCamZoom = 1.0;
				case 2176 | 4736:
					defaultCamZoom = 0.9;
				case 2368:
					camHUD.flash(FlxColor.BLACK, 0.57);
					defaultCamZoom = 1.0;
				case 2376 | 2440 | 2752 | 3168:
					defaultCamZoom = 1.1;
				case 2384 | 2448 | 3008 | 3200 | 5744 | 6400 | 6440 | 6456:
					defaultCamZoom = 1.2;
				case 2400 | 2464 | 3136 | 3296 | 6408 | 6436 | 6444 | 6452:
					defaultCamZoom = 1.1;
				case 2408 | 2472 | 3144 | 3264 | 6416 | 6432 | 6448:
					defaultCamZoom = 1.0;
				case 2416 | 2480 | 3152 | 3232 | 6424:
					defaultCamZoom = 0.9;
				case 6144 | 6176 | 6208 | 6240 | 6272 | 6304 | 6336 | 6368 | 6528:
					defaultCamZoom = 0.6;
				case 6148 | 6180 | 6212 | 6244 | 6276 | 6308 | 6340 | 6372:
					defaultCamZoom = 1.1;
				case 6160 | 6192 | 6224 | 6256 | 6288 | 6320 | 6352 | 6384:
					defaultCamZoom = 0.9;
			}
		}

		if (curSong == 'dark-purple')
		{
			switch(curStep)
			{
				case 1 | 240 | 528 | 752:
					resetChars();
					switchChars('dad');
				case 128 | 384 | 560 | 960:
					resetChars();
					switchChars('sticko'); // Blue
				case 512 | 544 | 1024:
					resetChars();
					switchChars('dad');
					switchChars('sticko'); // Blue
			}
			switch(curStep)
			{
				case 296:
					bfSwitch(boyfriend.x, boyfriend.y, "stickletta-c-f");
				case 544:
					bfSwitch(boyfriend.x, boyfriend.y, "stickletta-m");
			}
			switch(curStep)
			{
				case 256:
					for (i in 0...4)
					{
						FlxTween.tween(strumLineNotes.members[i], {alpha: 0}, 0.285, {ease: FlxEase.smoothStepOut, onComplete: function(tween:FlxTween)
						{
							strumLineNotes.members[i].visible = false;
						}});
					}
					dpIsBLing = true;
					dpATtime = 2.5;
					dpArrowTween();
					dpAlphaTween();
				case 512:
					dpATtime = 2;
				case 768:
					dpATtime = 1.5;
					dpBLtime = 7.5;
				case 832:
					dpATtime = 1;
				case 1024:
					dpATtime = 0.75;
					dpBLtime = 5;
			}
		}

		// item mechanic
		switch (curStep)
		{
			case 1:
				if (FlxG.save.data.itemBlock)
					itemBlock();
		}

		if (executeModchart && lua != null)
		{
			setVar('curStep',curStep);
			callLua('stepHit',[curStep]);
		}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	function killTimer(timer:FlxTimer):Void // for the /kill text in moovenge
	{
		if (spaceCounter >= 1)
		{
			health -= 0;
		}
		else
		{
			health = 0;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (executeModchart && lua != null)
		{
			setVar('curBeat',curBeat);
			callLua('beatHit',[curBeat]);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				if (dad.curCharacter != 'yellow' && dad.curCharacter != 'yellow-f')
				{
					if (dad.animation.curAnim.name == 'attackHIT' || dad.animation.curAnim.name == 'attackMISS' || dad.animation.curAnim.name == 'attack' || dad.animation.curAnim.name == 'dodge' || dad.animation.curAnim.name == 'hit')
					{
						if (dad.animation.curAnim.finished)
							dad.dance();
					}
					else
						dad.dance();
				}
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == '7391203' && curBeat >= 98 && curBeat < 128 && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 2)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == '7391203' && curBeat >= 128 && curBeat < 140 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'burning' && curBeat >= 240 && curBeat < 304 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'lemons' && curBeat >= 224 && curBeat < 256 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'freezing' && curBeat >= 256 && curBeat < 320 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'slimy' && curBeat >= 256 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'slime-rematch' && curBeat >= 240 && curBeat < 272 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}

		// 2v1
		if (curSong == 'plane' || curSong == 'air-battle' || curSong == 'thunder-storm' && curBeat % 2 == 1)
		{
			sheary.playAnim('idle');
		}

		if (curSong == 'cluck' || curSong == 'clooshie' || curSong == 'fight-for-life' && curBeat % 2 == 1)
		{
			cloosh.playAnim('idle');
		}

		if (curSong == 'all-around-you' && curBeat % 2 == 1)
		{
			james.playAnim('idle');
			ghost.playAnim('idle');
			sheary.playAnim('idle');
			cluck.playAnim('idle');
			cloosh.playAnim('idle');
			trooper.playAnim('idle');
			gooey.playAnim('idle');
			supermooshie.playAnim('idle');
		}

		if ((curSong == 'fury' || curSong == 'rage' || curSong == 'fiery-madness') && curBeat % 2 == 0)
		{
			if (stlaw.animation.curAnim.name == 'attack')
			{
				if (stlaw.animation.curAnim.finished)
				{
					stlaw.animation.play('idle', true);
					stlaw.offset.set(0, 0);
				}
			}
			else
				stlaw.animation.play('idle', true);
			if (stibow.animation.curAnim.name == 'attack')
			{
				if (stibow.animation.curAnim.finished)
				{
					stibow.animation.play('idle', true);
					stibow.offset.set(0, 0);
				}
			}
			else
				stibow.animation.play('idle', true);
			if (stickannon.animation.curAnim.name == 'attack')
			{
				if (stickannon.animation.curAnim.finished)
				{
					stickannon.animation.play('idle', true);
					stickannon.offset.set(0, 0);
				}
			}
			else
				stickannon.animation.play('idle', true);
		}

		if ((curSong == 'infecto' || curSong == 'recovery') && curBeat % 2 == 0)
		{
			if (striker.animation.curAnim.name == 'attack')
			{
				if (striker.animation.curAnim.finished)
				{
					striker.animation.play('idle2', true);
					striker.offset.set(0, 0);
				}
			}
			else
				striker.animation.play('idle2', true);
		}

		if ((curSong == 'enemy' || curSong == 'trust' || curSong == 'team-up') && curBeat % 2 == 0)
		{
			swordletto.playAnim('idle', true);
		}

		if (curSong == 'hit-and-miss' && curBeat % 2 == 0)
		{
			sticko.playAnim('idle', true);
			stickletto.playAnim('idle', true);
		}

		if (curSong == 'dark-purple' && curBeat % 2 == 0)
		{
			sticko.playAnim('idle', true);
			dad.playAnim('idle');
		}

		if (curSong == 'striker' && curBeat % 2 == 0)
		{
			stickletto.playAnim('idle', true);
		}

		if (curSong == 'crock' && curBeat % 2 == 0)
		{
			stickletta.playAnim('idle', true);
		}

		if ((curSong == 'switch' || curSong == 'bite' || curSong == 'crocker') && curBeat % 2 == 0)
		{
			stickletta.playAnim('idle', true);
			sticklettabow.playAnim('idle', true);
			swordletto.playAnim('idle', true);
		}

		if (curSong == 'sticklettabreaker' && curBeat % 4 == 0)
		{
			if (clone1.animation.curAnim.name != 'appear')
				clone1.dance();
			if (curBeat >= 1089)
				stickletta.dance();
			if (curBeat >= 1441)
				swordletto.dance();
			if (curBeat >= 1633)
				sticklettabow.dance();
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}
		if (dad.curCharacter == 'yellow' && curBeat % 2 == 0)
			dad.dance();
		if (dad.curCharacter == 'yellow-f' && curBeat % 2 == 0)
			dad.dance();

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && !dodging && !attacking)
		{
			if (boyfriend.animation.curAnim.name == 'pushed')
			{
				if (boyfriend.animation.curAnim.finished)
				{
					boyfriend.playAnim('idle');
				}
			}
			else
			{
				boyfriend.playAnim('idle');
			}
		}

		if (curSong == 'icy')
			{
				switch (curBeat)
				{
					case 16 | 24 | 40 | 48 | 56 | 64 | 72 | 79 | 88 | 95 | 112 | 144 | 152 | 160:
					  boyfriend.playAnim('hey', true);
					case 120:
					  boyfriend.playAnim('scared', true);
				 }
			}

		if (curSong == 'slime-attack')
			{
				switch (curBeat)
				{
					case 1 | 92 | 124 | 238:
						remove(boyfriend);
						boyfriend = new Boyfriend(775, 450, 'bf-neon');
						add(boyfriend);
						iconP1.animation.play('bf-neon');
					case 8 | 96 | 160 | 272:
						remove(boyfriend);
						boyfriend = new Boyfriend(775, 450, 'bf');
						add(boyfriend);
						iconP1.animation.play('bf');
				 }
			}

		if (curSong == 'light-speed')
			{
				switch (curBeat)
				{
					case 1:
						FlxTween.tween(SONG,{speed:4},130);
				}
			}

		if (curSong == 'moo-storm')
			{
				switch (curBeat)
				{
					case 66:
						defaultCamZoom = 0.75;
					case 68:
						defaultCamZoom = 0.8;
					case 69: // nice
						defaultCamZoom = 0.85;
					case 70:
						defaultCamZoom = 0.9;
					case 72:
						defaultCamZoom = 0.7;
					case 74:
						defaultCamZoom = 0.75;
					case 76:
						defaultCamZoom = 0.8;
					case 77:
						defaultCamZoom = 0.85;
					case 78:
						defaultCamZoom = 0.9;
					case 79:
						defaultCamZoom = 0.95;
					case 80:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						defaultCamZoom = 0.7;
					case 168:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(dad);
						dad = new Character(200, 270, 'supermooshie-mad');
						add(dad);
						iconP2.animation.play('supermooshie-mad');
					case 264:
						FlxG.camera.flash(FlxColor.WHITE, 0.3);
					case 328:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong == 'moosanity-old')
			{
				switch (curBeat)
				{
					case 1:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
						add(boyfriend);
					case 3:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf');
						add(boyfriend);
					case 88:
						health = 0.5;
					case 144:
						health = 1.0;
					case 248:
						health = 0.01;
					case 448:
						health = 2.0;
					case 452:
						health = 1.0;
					case 456:
						health = 0.75;
					case 460:
						health = 0.5;
					case 464:
						health = 0.25;
					case 468:
						health = 0.1;
					case 472:
						health = 0.05;
					case 476:
						health = 0.2;
					case 480:
						health = 2.0;
				}
			}

			if (curSong == 'moosanity-old')
			{
				switch (curStep)
				{
					case 344 | 504 | 984 | 1336 | 1784:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
						add(boyfriend);
					case 352 | 512 | 992 | 1344 | 1792:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf');
						add(boyfriend);
				}
			}

			if (curSong == 'moosanity')
				{
					switch (curBeat)
					{
						case 1:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 3:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
						case 120:
							health = 0.5;
						case 176:
							health = 1.0;
						case 280:
							health = 0.01;
						case 480:
							health = 2.0;
						case 484:
							health = 1.0;
						case 488:
							health = 0.75;
						case 492:
							health = 0.5;
						case 496:
							health = 0.25;
						case 500:
							health = 0.1;
						case 504:
							health = 0.05;
						case 508:
							health = 0.2;
						case 512:
							health = 2.0;
					}
				}
	
			if (curSong == 'moosanity')
			{
				switch (curStep)
				{
					case 472 | 632 | 1112 | 1464 | 1912:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
						add(boyfriend);
					case 480 | 640 | 1120 | 1472 | 1920:
						remove(boyfriend);
						boyfriend = new Boyfriend(1190, 500, 'bf');
						add(boyfriend);
				}
			}

			if (curSong == 'Moovenge')
				{
					switch (curBeat)
					{
						case 1:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 3:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
						case 8:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 12:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
							iconP1.animation.play('bf');
						case 56:
							defaultCamZoom = 1.2;
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 64: // haha minecraft stack
							defaultCamZoom = 0.6;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);

							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							resetSpaceCounter();

							qwerty = new FlxText(30, 100, 0);
							qwerty.text = "/kill boyfriend";
							qwerty.setFormat("vcr.ttf", 100, FlxColor.WHITE, CENTER);
							qwerty.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
							qwerty.visible = true;
							add(qwerty);
						case 68: // almost nice :(
							qwerty.visible = false;
						case 76:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 96:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);

							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 100:
							qwerty.visible = false;
						case 152:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
						case 176:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);

							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 180:
							qwerty.visible = false;
						case 184:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);

							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 188:
							qwerty.visible = false;
						case 192:
							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 196:
							qwerty.visible = false;
						case 248:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');

							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 252:
							qwerty.visible = false;
						case 256:
							gf.playAnim('space');

							new FlxTimer().start(1.2, killTimer, 1);
							qwerty.visible = true;
							resetSpaceCounter();
						case 260:
							qwerty.visible = false;
						case 280:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
							iconP1.animation.play('bf');
						case 312:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 336:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
						case 408:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 412:
							health = 0.01;
						case 416:
							health = 0.01;
						case 424:
							health = 0.01;
						case 436:
							health = 0.01;
						case 444:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
							iconP1.animation.play('bf');
						case 452:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
						case 476:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 520:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
							iconP1.animation.play('bf');
						case 524:
							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 540:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-dodge');
							add(boyfriend);
							iconP1.animation.play('bf');
						case 572:
							health = 0.01;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 604:
							health = 2;

							remove(boyfriend);
							boyfriend = new Boyfriend(1190, 500, 'bf');
							add(boyfriend);
							iconP1.animation.play('bf');
					}
				}

			if (curSong == '7391203')
				{
					switch(curBeat)
					{
						case 96:
							defaultCamZoom = 1;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
						case 125:
							defaultCamZoom = 0.9;
						case 126:
							defaultCamZoom = 0.8;
						case 127:
							defaultCamZoom = 0.7;
						case 128:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							leCoolBl.visible = true;
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						case 129:
							leCoolBl.visible = false;
							leCoolB.visible = true;
						case 130 | 135 | 140 | 145 | 150 | 155:
							leCoolB.visible = false;
							leCoolG.visible = true;
						case 131 | 136 | 141 | 146 | 151 | 156:
							leCoolG.visible = false;
							leCoolP.visible = true;
						case 132 | 137 | 142 | 147 | 152 | 157:
							leCoolP.visible = false;
							leCoolR.visible = true;
						case 133 | 138 | 143 | 148 | 153 | 158:
							leCoolR.visible = false;
							leCoolO.visible = true;
						case 134 | 139 | 144 | 149 | 154 | 159:
							leCoolO.visible = false;
							leCoolB.visible = true;
						case 160:
							FlxTween.tween(leCoolB, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
					}
				}

			if (curSong == 'burning')
				{
					switch (curBeat)
					{
						case 240:
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							defaultCamZoom = 1.2;

							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
					}
				}

			if (curSong == 'lemons')
				{
					switch (curBeat)
					{
						case 1 | 152 | 184 | 216:
							leCoolBl.visible = true;
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						case 32 | 160 | 192:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
						case 224:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});

							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							defaultCamZoom = 1.2;

							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
					}
				}

			if (curSong == 'freezing')
				{
					switch (curBeat)
					{
						case 1 | 60 | 92 | 120 | 192 | 284:
							leCoolBl.visible = true;
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						case 32 | 64 | 96 | 128:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
						case 256:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});

							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							defaultCamZoom = 1.2;

							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 288:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
					}
				}

			if (curSong == 'slimy')
				{
					switch (curBeat)
					{
						case 1 | 120 | 160 | 248:
							leCoolBl.visible = true;
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						case 32 | 128 | 224:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
						case 54 | 62 | 86 | 94:
							defaultCamZoom = 1.2;
						case 56 | 64 | 88 | 96:
							defaultCamZoom = 0.9;
						case 256:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});

							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							defaultCamZoom = 1.2;

							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 352:
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
					}
				}

			if (curSong == 'slime-rematch')
				{
					switch (curBeat)
					{
						case 1 | 96 | 160:
							leCoolBl.visible = true;
							FlxTween.tween(leCoolBl, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						case 32 | 128 | 192:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
						case 240:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});

							FlxG.camera.flash(FlxColor.WHITE, 0.5);
							defaultCamZoom = 1.2;

							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 304:
							FlxTween.tween(leCoolBl, {alpha: 0}, 0.5, {ease: FlxEase.smoothStepOut});
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
					}

					switch (curBeat)
					{
						case 1 | 92 | 124:
							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf-neon');
							add(boyfriend);
							iconP1.animation.play('bf-neon');
						case 4 | 96 | 160:
							remove(boyfriend);
							boyfriend = new Boyfriend(775, 450, 'bf');
							add(boyfriend);
							iconP1.animation.play('bf');
					}
				}

			if (curSong == 'gooey-battle')
				{
					switch (curBeat)
					{
						case 4 | 72 | 76 | 80 | 84 | 136 | 200 | 216 | 232 | 240 | 248 | 252 | 256:
							dodged = false;
							canDodge = true;
							dodgeSprite.visible = true;
							dodging = false;
							resetBattleCounter();
						case 5 | 73 | 77 | 81 | 85 | 137 | 201 | 217 | 233 | 241 | 249 | 253 | 257:
							dodgeCheck(0,0);
					}
					switch (curBeat)
					{
						case 134 | 262 | 367:
							attacked = false;
							canAttack = true;
							attackSprite.visible = true;
							resetBattleCounter();
						case 135 | 263 | 368:
							attackCheck();
					}
				}

			if (curSong.toLowerCase() == 'gooey-battle' && curBeat >= 272 && curBeat < 336 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.025;
				camHUD.zoom += 0.03;
			}

			if (curSong.toLowerCase() == 'gooey-battle' && curBeat >= 272 && curBeat < 288 && curBeat % 4 == 0)
			{
				dodged = false;
				canDodge = true;
				dodgeSprite.visible = true;
				resetBattleCounter();
			}

			if (curSong.toLowerCase() == 'gooey-battle' && curBeat >= 304 && curBeat < 336 && curBeat % 4 == 0)
			{
				dodged = false;
				canDodge = true;
				dodgeSprite.visible = true;
				resetBattleCounter();
			}

			if (curSong.toLowerCase() == 'gooey-battle' && curBeat >= 272 && curBeat < 288 && curBeat % 4 == 1)
			{
				dodgeCheck(0,0);
			}

			if (curSong.toLowerCase() == 'gooey-battle' && curBeat >= 304 && curBeat < 336 && curBeat % 4 == 1)
			{
				dodgeCheck(0,0);
			}

			if (curSong == 'fire-battle')
			{
				switch (curBeat)
				{
					case 12 | 44 | 80 | 84 | 88 | 92 | 96 | 100 | 104 | 110 | 224 | 232 | 276 | 278 | 280 | 300 | 302:
						dodged = false;
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 16 | 45 | 83 | 87 | 91 | 95 | 99 | 103 | 107 | 111 | 226 | 234 | 277 | 279 | 281 | 301 | 303:
						dodgeCheck(0,0);
				}
				switch (curBeat)
				{
					case 268 | 364:
						attacked = false;
						canAttack = true;
						attackSprite.visible = true;
						resetBattleCounter();
					case 272 | 368:
						attackCheck();
				}
			}

			if (curSong == 'moo-battle')
			{
				switch (curBeat)
				{
					case 64 | 68 | 72 | 76 | 80 | 84 | 88 | 92 | 128 | 144 | 146 | 148 | 150 | 152 | 154 | 156 | 158 | 160 | 168 | 176 | 184 | 288 | 292 | 296 | 300 | 324 | 332 | 384 | 392 | 400 | 408 | 448 | 456 | 464 | 472 | 528 | 532 | 536 | 540:
						dodged = false;
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 66 | 70 | 74 | 78 | 82 | 86 | 90 | 94 | 130 | 145 | 147 | 149 | 151 | 153 | 155 | 157 | 159 | 164 | 172 | 180 | 188 | 290 | 294 | 298 | 302 | 326 | 334 | 308 | 396 | 404 | 412 | 452 | 460 | 468 | 476 | 530 | 534 | 538 | 542:
						dodgeCheck(0,0);
				}
				switch (curBeat)
				{
					case 316 | 348 | 543:
						attacked = false;
						canAttack = true;
						attackSprite.visible = true;
						resetBattleCounter();
					case 320 | 350 | 544:
						attackCheck();
				}
			}

			if (curSong == 'all-around-you')
			{
				switch (curBeat)
				{
					case 653:
						FlxG.camera.flash(FlxColor.RED, 0.5);
						dad.visible = false;
						james.visible = false;
						ghost.visible = false;
						sheary.visible = false;
						cluck.visible = false;
						cloosh.visible = false;
						trooper.visible = false;
						gooey.visible = false;

						FlxTween.tween(supermooshie, {alpha: 1}, 1, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1;
					case 656:
						// FlxTween.tween(l, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 0.8;
					case 707:
						FlxG.camera.flash(FlxColor.RED, 0.5);
						dad.visible = true;
						james.visible = true;
						ghost.visible = true;
						sheary.visible = true;
						cluck.visible = true;
						cloosh.visible = true;
						trooper.visible = true;
						gooey.visible = true;
						// l.alpha = 0;

						defaultCamZoom = 0.5;
				}
			}

			if (curSong == 'logging-in')
			{
				switch (curBeat)
				{
					case 108 | 124 | 150 | 158 | 166 | 174 | 182 | 192 | 246 | 254 | 260 | 276 | 320 | 324 | 328 | 332 | 334 | 336 | 340 | 344 | 348 | 350:
						dodged = false;
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 112 | 128 | 152 | 160 | 168 | 176 | 184 | 194 | 248 | 256 | 262 | 278 | 323 | 327 | 331 | 333 | 335 | 339 | 343 | 347 | 349 | 351:
						dodgeCheck(0,0);
				}
			}

			if (curSong == 'fury')
			{
				switch (curBeat)
				{
					case 351:
						dad.playAnim('infect', true);
					case 352:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-i');
						add(boyfriend);
						dad.playAnim('idle', true);
					case 414:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-f');
						add(boyfriend);
				}
			}

			if (curSong == 'rage')
			{
				switch (curBeat)
				{
					case 447:
						dad.playAnim('infect', true);
					case 448:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-i');
						add(boyfriend);
						dad.playAnim('idle', true);
					case 512:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-f');
						add(boyfriend);
				}
			}

			if (curSong == 'fiery-madness')
			{
				switch (curBeat)
				{
					case 543:
						dad.playAnim('infect', true);
					case 544:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-i');
						add(boyfriend);
						dad.playAnim('idle', true);
					case 608:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						remove(boyfriend);
						boyfriend = new Boyfriend(667, 442, 'stickletto-f');
						add(boyfriend);
				}
				switch (curBeat)
				{
					case 128 | 144 | 152 | 192 | 200 | 208 | 216 | 512 | 516 | 520 | 524 | 608 | 616 | 624 | 632 | 640 | 644 | 648 | 652 | 656 | 660 | 664 | 668 | 672:
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 132 | 196 | 204:
						dodged = false;
						dodgeCheck(2);
					case 148 | 212 | 514 | 518:
						dodged = false;
						dodgeCheck(1);
					case 156 | 220 | 522 | 526 | 612 | 620 | 628 | 636 | 642 | 646 | 650 | 654 | 658 | 662 | 666 | 670 | 676:
						dodged = false;
						dodgeCheck(3);
				}
			}

			if (curSong == 'ff0000')
			{
				switch (curBeat)
				{
					case 128 | 160 | 256:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1.1;
					case 144 | 176 | 352:
						FlxTween.tween(cyan, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
						{
							remove(dad);
							remove(boyfriend);
							add(redR);
							add(dad);
							add(boyfriend);
						}});
						defaultCamZoom = 1.1;
					case 192 | 448:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.CYAN}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 0.9;
					case 224:
						camHUD.flash(FlxColor.BLACK, 0.5);
				}

				if (curBeat % 4 == 0 && SONG.song == 'ff0000' && curBeat >= 256 && curBeat < 449)
					camHUD.flash(FlxColor.BLACK, 0.5);
			}

			if (curSong == 'laser')
			{
				switch (curBeat)
				{
					case 64 | 72:
						camHUD.flash(FlxColor.BLACK, 0.5);
					case 128 | 160 | 288:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1.1;
					case 144 | 176 | 352:
						FlxTween.tween(cyan, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
						{
							remove(dad);
							remove(boyfriend);
							add(redR);
							add(dad);
							add(boyfriend);
						}});
						defaultCamZoom = 1.1;
					case 192 | 416:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.CYAN}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 0.9;
				}

				if (curBeat % 4 == 0 && SONG.song == 'laser' && curBeat >= 288 && curBeat < 417)
					camHUD.flash(FlxColor.BLACK, 0.5);
			}

			if (curSong == '00ffff')
			{
				switch (curBeat)
				{
					case 32 | 176 | 208 | 480:
						FlxTween.tween(cyan, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
						{
							remove(dad);
							remove(boyfriend);
							add(redR);
							add(dad);
							add(boyfriend);
						}});
						defaultCamZoom = 1.1;
					case 96 | 192 | 416:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1.1;
					case 224 | 544:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.CYAN}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 0.9;
					case 256 | 264 | 272 | 280 | 352:
						camHUD.flash(FlxColor.BLACK, 0.5);
				}

				if (curBeat % 8 == 0 && SONG.song == '00ffff' && ((curBeat >= 32 && curBeat < 161) || (curBeat >= 416 && curBeat < 544)))
					camHUD.flash(FlxColor.BLACK, 0.5);
			}

			if (curSong == 'yellow')
			{
				switch (curBeat)
				{
					case 112 | 240:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1.0;
					case 128 | 256: // This is yellow, just didn't wanna make a new var for the same purpose as redR
						FlxTween.tween(cyan, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
						{
							remove(dad);
							remove(boyfriend);
							add(redR);
							add(dad);
							add(boyfriend);
						}});
					case 144 | 272:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLUE}, 0.5, {ease: FlxEase.smoothStepOut});
				}
				switch (curBeat)
				{
					case 114 | 121 | 137 | 252 | 264:
						defaultCamZoom = 1.1;
					case 116 | 254:
						defaultCamZoom = 1.2;
					case 123 | 139 | 268 | 280 | 296:
						defaultCamZoom = 1.0;
					case 125 | 141 | 270 | 288:
						defaultCamZoom = 0.9;
					case 274 | 290:
						defaultCamZoom = 0.8;
					case 276 | 292:
						defaultCamZoom = 0.7;
				}
				switch (curBeat)
				{
					case 113 | 115 | 117 | 120 | 122 | 124 | 129 | 131 | 133 | 136 | 138 | 140 | 248 | 252 | 254 | 256 | 264 | 268 | 270 | 280 | 296:
						camHUD.flash(FlxColor.BLACK, 0.5);
				}
			}

			if (curSong == 'teleportation')
			{
				switch (curBeat)
				{
					case 304 | 312 | 320 | 328 | 336 | 344 | 352 | 360:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLACK}, 0.5, {ease: FlxEase.smoothStepOut});
						defaultCamZoom = 1.0;
					case 308 | 316 | 324 | 332 | 340 | 348 | 356 | 364: // This is yellow, just didn't wanna make a new var for the same purpose as redR
						FlxTween.tween(cyan, {color: FlxColor.RED}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween)
						{
							remove(dad);
							remove(boyfriend);
							add(redR);
							add(dad);
							add(boyfriend);
						}});
					case 368:
						remove(redR);
						FlxTween.tween(cyan, {color: FlxColor.BLUE}, 0.5, {ease: FlxEase.smoothStepOut});
				}
				switch (curBeat)
				{
					case 96 | 176:
						defaultCamZoom = 1.2;
					case 112 | 192:
						defaultCamZoom = 1.1;
					case 128 | 208:
						defaultCamZoom = 1.0;
					case 144 | 224:
						defaultCamZoom = 0.9;
				}
				switch (curBeat)
				{
					case 96 | 176 | 240 | 256:
						camHUD.flash(FlxColor.BLACK, 0.5);
					case 304 | 312 | 320 | 328 | 336 | 344 | 352 | 360:
						camHUD.flash(FlxColor.BLACK, 0.5);
					case 308 | 316 | 324 | 332 | 340 | 348 | 356 | 364:
						camHUD.flash(FlxColor.YELLOW, 0.5);
					case 368:
						camHUD.flash(FlxColor.BLUE, 0.5);
				}
				switch (curBeat)
				{
					case 96 | 240:
						remove(dad);
						dad = new Character(boyfriend.x + 250, dad.y, 'yellow-f');
						add(dad);
					case 97 | 241:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletto-f');
						add(boyfriend);
					case 176 | 256:
						remove(dad);
						dad = new Character(boyfriend.x - 450, dad.y, 'yellow');
						add(dad);
					case 177 | 257:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletto');
						add(boyfriend);
				}
				switch (curBeat)
				{
					case 80 | 88 | 248 | 250 | 266 | 270 | 296 | 302: // Normal dodge
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 84 | 160 | 170 | 252 | 268 | 280 | 286 | 298: // Left dodge
						canDodgeL = true;
						dodgeSprite2.visible = true;
						dodging = false;
						resetBattleCounter();
					case 92 | 162 | 168 | 254 | 264 | 282 | 284 | 300: // Right dodge
						canDodgeR = true;
						dodgeSprite3.visible = true;
						dodging = false;
						resetBattleCounter();
					case 82 | 90 | 259 | 251 | 267 | 271 | 297 | 303: // Normal dodge
						dodged = false;
						dodgeCheck(0,0);
					case 87 | 161 | 171 | 253 | 269 | 281 | 287 | 299: // Left dodge
						dodgedL = false;
						dodgeCheck(0,1);
					case 95 | 163 | 169 | 255 | 265 | 283 | 285 | 301: // Right dodge
						dodgedR = false;
						dodgeCheck(0,2);
				}
			}

			if (curSong == 'ffff00')
			{
				switch (curBeat) // Zoomy Zooms
				{
					case 336 | 368 | 390:
						defaultCamZoom = 1.0;
					case 340 | 372 | 388 | 391 | 395:
						defaultCamZoom = 1.1;
					case 344 | 376 | 384 | 392 | 396:
						defaultCamZoom = 1.2;
					case 348 | 380:
						defaultCamZoom = 1.3;
					case 352 | 386 | 394 | 400:
						defaultCamZoom = 0.9;
				}
				switch (curBeat) // Flashy Flashy
				{
					case 176 | 256 | 288 | 296 | 304 | 312 | 320 | 388:
						camHUD.flash(FlxColor.BLACK, 0.5);
					case 264 | 272 | 280:
						camHUD.flash(FlxColor.YELLOW, 0.5);
				}
				switch (curBeat) // Teleportation
				{
					case 176 | 320:
						remove(dad);
						dad = new Character(boyfriend.x + 250, dad.y, 'yellow-f');
						add(dad);
					case 177 | 321:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletto-f');
						add(boyfriend);
					case 256 | 388:
						remove(dad);
						dad = new Character(boyfriend.x - 500, dad.y, 'yellow');
						add(dad);
					case 257 | 389:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletto');
						add(boyfriend);
				}
				switch (curBeat) // Battle
				{
					case 144 | 154 | 158 | 170 | 174 | 252 | 262 | 284 | 302 | 317 | 319: // Normal dodge
						canDodge = true;
						dodgeSprite.visible = true;
						dodging = false;
						resetBattleCounter();
					case 148 | 152 | 160 | 168 | 172 | 248 | 268 | 286 | 308 | 310: // Left dodge
						canDodgeL = true;
						dodgeSprite2.visible = true;
						dodging = false;
						resetBattleCounter();
					case 150 | 156 | 164 | 166 | 240 | 244 | 276 | 278 | 293 | 295: // Right dodge
						canDodgeR = true;
						dodgeSprite3.visible = true;
						dodging = false;
						resetBattleCounter();
					case 146 | 155 | 159 | 171 | 175 | 253 | 263 | 285 | 303 | 318 | 320: // Normal dodge
						dodged = false;
						dodgeCheck(0,0);
					case 149 | 153 | 162 | 169 | 173 | 249 | 270 | 287 | 309 | 311: // Left dodge
						dodgedL = false;
						dodgeCheck(0,1);
					case 151 | 157 | 165 | 167 | 241 | 245 | 277 | 279 | 294 | 296: // Right dodge
						dodgedR = false;
						dodgeCheck(0,2);
				}
			}

			if (curSong == 'infecto')
			{
				switch(curBeat)
				{
					case 12 | 80:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						defaultCamZoom = 1.2;
					case 16 | 96:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						defaultCamZoom = 0.9;
					case 126:
						defaultCamZoom = 1.0;
					case 127:
						defaultCamZoom = 1.1;
						striker.playAnim('attack', true);
					case 128 | 196 | 204:
						camHUD.flash(FlxColor.WHITE, 0.5);
						redR.visible = false;
						defaultCamZoom = 0.9;
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-i-w');
						add(dad);
						dad.flipX = false;
					case 192 | 200 | 208:
						camHUD.flash(FlxColor.BLACK, 0.5);
						redR.visible = true;
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-i');
						add(dad);
						dad.flipX = false;
						var oldRight = dad.animation.getByName('singRIGHT').frames;
						dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
						dad.animation.getByName('singLEFT').frames = oldRight;
				}
				switch(curBeat)
				{
					case 128:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletta-c-f');
						add(boyfriend);
				}
			}

			if (curSong == 'recovery')
			{
				switch(curBeat)
				{
					case 128:
						defaultCamZoom = 0.9;
					case 132:
						defaultCamZoom = 1.0;
					case 136:
						defaultCamZoom = 1.1;
					case 140:
						defaultCamZoom = 1.2;
					case 142:
						defaultCamZoom = 1.3;
						striker.playAnim('attack', true);
					case 143:
						defaultCamZoom = 1.4;
					case 144:
						camHUD.flash(FlxColor.RED, 0.5);
						redR.visible = false;
						defaultCamZoom = 0.9;
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-i-w');
						add(dad);
						dad.flipX = false;
					case 240:
						camHUD.flash(FlxColor.RED, 0.5);
						redR.visible = true;
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-i');
						add(dad);
						dad.flipX = false;
						var oldRight = dad.animation.getByName('singRIGHT').frames;
						dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
						dad.animation.getByName('singLEFT').frames = oldRight;
					case 271:
						camHUD.flash(FlxColor.BLACK, 0.5);
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-f');
						add(dad);
						dad.flipX = true;
						var oldRight = dad.animation.getByName('singRIGHT').frames;
						dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
						dad.animation.getByName('singLEFT').frames = oldRight;
					case 276:
						remove(boyfriend);
						boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'stickletta-f');
						add(boyfriend);
					case 280:
						camHUD.flash(FlxColor.RED, 0.5);
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-i');
						add(dad);
						dad.flipX = false;
						var oldRight = dad.animation.getByName('singRIGHT').frames;
						dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
						dad.animation.getByName('singLEFT').frames = oldRight;
					case 282:
						camHUD.flash(FlxColor.BLACK, 0.5);
						remove(dad);
						dad = new Character(dad.x, dad.y, 'stickletto-f');
						add(dad);
						dad.flipX = true;
						var oldRight = dad.animation.getByName('singRIGHT').frames;
						dad.animation.getByName('singRIGHT').frames = dad.animation.getByName('singLEFT').frames;
						dad.animation.getByName('singLEFT').frames = oldRight;
				}
			}

			if (curSong == 'crock')
			{
				switch (curBeat)
				{
					case 96 | 256:
						resetP1();
						switchP1('sa'); // stickletta
					case 160:
						resetP1();
						switchP1('bf'); // stickletto
				}
			}

			if (curSong == 'portal')
			{
				switch (curBeat)
				{
					case 160:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.9;
					case 192:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
				}
			}

			if (curSong == 'ralph')
			{
				switch (curBeat)
				{
					case 64 | 256:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.9;
					case 128 | 288:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.8;
					case 192 | 320:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
				}
			}

			if (curSong == 'amethyst')
			{
				switch(curBeat)
				{
					case 160 | 192 | 384 | 416:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.9;
					case 188 | 220 | 412 | 444:
						defaultCamZoom = 1.1;
					case 224 | 448:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
				}
			}

			if (curSong == "bite-wave")
			{
				switch(curBeat)
				{
					case 64:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					case 128:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.9;
					case 192 | 448:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x;
						camFollow.y = gf.getMidpoint().y + 240;
					case 320:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.8;
					case 328:
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x - 100;
						camFollow.y = gf.getMidpoint().y + 240;
					case 366:
						defaultCamZoom = 0.8;
					case 368:
						FlxG.cameras.flash(FlxColor.MAGENTA, 0.5);
						defaultCamZoom = 0.5;
						camFollow.x = gf.getMidpoint().x + 100;
						camFollow.y = gf.getMidpoint().y + 240;
					case 416 | 480:
						defaultCamZoom = 0.6;
				}
				// Ralph battle mechanic
				switch(curBeat)
				{
					case 126 | 188 | 254 | 278 | 288 | 302 | 330 | 334 | 366 | 380 | 446 | 454 | 462 | 470 | 486 | 494 | 502 | 511:
						ralphCanAttack = true;
						playedAnim = false;
				}
			}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function resetSpaceCounter():Void
	{
		spaceCounter = 0;
	}

	function preBattle(dir:Int = 0):Void
	{
		dodging = false;
		switch(dir)
		{
			case 0:
				canDodge = true;
				dodgeSprite.visible = true;  // Normal dodge
			case 1:
				canDodgeL = true;
				dodgeSprite2.visible = true; // Left dodge
			case 2:
				canDodgeR = true;
				dodgeSprite3.visible = true; // Right dodge
		}
	}

	// battle mechanic
	function resetBattleCounter():Void
	{
		dodgeCounter = 0;
		dodgeLCounter = 0;
		dodgeRCounter = 0;
		attackCounter = 0;
	}

	// Ralph battle mechanic
	function ralphBattle():Void
	{
		if (ralphCanAttack)
		{
			if (dad.animation.curAnim.name != 'attack' && !playedAnim)
			{
				biteWave.x = dad.x + dad.width;
				biteWave.velocity.x = 0;
				biteWave.visible = false;
				dad.playAnim('attack', true);
				playedAnim = true;
			}

			if (dad.animation.curAnim.name == 'attack' && dad.animation.curAnim.curFrame == 15)
			{
				biteWave.visible = true;
				biteWave.x = dad.x + dad.width;
				biteWave.velocity.x = 2000;
			}

			if (boyfriend.y + boyfriend.height - 100 > biteWave.y && biteWave.x >= boyfriend.x + 100 && biteWave.x < boyfriend.x + boyfriend.width - 100)
			{
				health -= 0.5;
				ralphCanAttack = false;
				biteWave.x = dad.x + dad.width;
				biteWave.velocity.x = 0;
				biteWave.visible = false;
			}
			if (biteWave.x > 5000)
			{
				ralphCanAttack = false;
				biteWave.x = dad.x + dad.width;
				biteWave.velocity.x = 0;
				biteWave.visible = false;
			}
		}
	}

	// item mechanic
	function moveNotes():Void
	{
		// x or y?
		var xy1 = FlxG.random.int(1,2);
		var xy2 = FlxG.random.int(1,2);
		var xy3 = FlxG.random.int(1,2);
		var xy4 = FlxG.random.int(1,2);

		// plus or minus?
		var pm1 = FlxG.random.int(1,2);
		var pm2 = FlxG.random.int(1,2);
		var pm3 = FlxG.random.int(1,2);
		var pm4 = FlxG.random.int(1,2);

		// move the notes
		if (xy1 == 1 && pm1 == 1)
			playerStrums.members[0].x += noteMoveAmount1;
		else if (xy1 == 1 && pm1 == 2)
			playerStrums.members[0].x -= noteMoveAmount1;
		else if (xy1 == 2 && pm1 == 1)
			playerStrums.members[0].y += noteMoveAmount1;
		else if (xy1 == 2 && pm1 == 2)
			playerStrums.members[0].y -= noteMoveAmount1;

		if (xy2 == 1 && pm2 == 1)
			playerStrums.members[1].x += noteMoveAmount2;
		else if (xy2 == 1 && pm2 == 2)
			playerStrums.members[1].x -= noteMoveAmount2;
		else if (xy2 == 2 && pm2 == 1)
			playerStrums.members[1].y += noteMoveAmount2;
		else if (xy2 == 2 && pm2 == 2)
			playerStrums.members[1].y -= noteMoveAmount2;

		if (xy3 == 1 && pm3 == 1)
			playerStrums.members[2].x += noteMoveAmount3;
		else if (xy3 == 1 && pm3 == 2)
			playerStrums.members[2].x -= noteMoveAmount3;
		else if (xy3 == 2 && pm3 == 1)
			playerStrums.members[2].y += noteMoveAmount3;
		else if (xy3 == 2 && pm3 == 2)
			playerStrums.members[2].y -= noteMoveAmount3;

		if (xy4 == 1 && pm4 == 1)
			playerStrums.members[3].x += noteMoveAmount4;
		else if (xy4 == 1 && pm4 == 2)
			playerStrums.members[3].x -= noteMoveAmount4;
		else if (xy4 == 2 && pm4 == 1)
			playerStrums.members[3].y += noteMoveAmount4;
		else if (xy4 == 2 && pm4 == 2)
			playerStrums.members[3].y -= noteMoveAmount4;
	}

	// battle mechanic
	// dodgeDir 0 is normal dodge, 1 is left, 2 is right
	// number 0 is opponent, 1, 2, amd 3 are the side characters in chapter 19
	function dodgeCheck(number:Int = 0, dodgeDir:Int = 0):Void
	{
		// Dodge normal
		if (dodgeCounter > 0 && dodgeDir == 0)
		{
			boyfriend.playAnim('dodge', true);
			dodged = true;
			dodging = true;

			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
		}
		else if (dodgeCounter <= 0 && dodgeDir == 0)
		{
			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
			dodged = false;
			dodging = false;
			if (dad.curCharacter == 'sticko')
				health -= 0.5;
			if (dad.curCharacter == 'yellow' || dad.curCharacter == 'yellow-f')
			{
				health -= 0.25;
				FlxG.camera.flash(FlxColor.RED, 0.25);
			}
		}
		// Dodge left
		if (dodgeLCounter > 0 && dodgeDir == 1)
		{
			boyfriend.playAnim('dodge', true);
			dodgedL = true;
			dodging = true;

			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
		}
		else if (dodgeLCounter <= 0 && dodgeDir == 1)
		{
			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
			dodgedL = false;
			dodging = false;
			if (dad.curCharacter == 'sticko')
				health -= 0.5;
			if (dad.curCharacter == 'yellow' || dad.curCharacter == 'yellow-f')
			{
				health -= 0.25;
				FlxG.camera.flash(FlxColor.RED, 0.25);
			}
		}
		// Dodge right
		if (dodgeRCounter > 0 && dodgeDir == 2)
		{
			boyfriend.playAnim('dodge', true);
			dodgedR = true;
			dodging = true;

			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
		}
		else if (dodgeRCounter <= 0 && dodgeDir == 2)
		{
			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
			{
				switch(number)
				{
					case 0:
						dad.playAnim('attack', true);
					case 1:
						stlaw.playAnim('attack', true);
					case 2:
						stibow.playAnim('attack', true);
					case 3:
						stickannon.playAnim('attack', true);
					default:
						dad.playAnim('attack', true);
				}
			}
			dodgedR = false;
			dodging = false;
			if (dad.curCharacter == 'sticko')
				health -= 0.5;
			if (dad.curCharacter == 'yellow' || dad.curCharacter == 'yellow-f')
			{
				health -= 0.25;
				FlxG.camera.flash(FlxColor.RED, 0.25);
			}
		}

		checkmark.visible = false;
		dodgeSprite.visible = false;
		dodgeSprite2.visible = false;
		dodgeSprite3.visible = false;
		canDodge = false;
		canDodgeL = false;
		canDodgeR = false;
	}

	// battle mechanic
	function attackCheck():Void
	{
		if (attackCounter > 0)
		{
			boyfriend.playAnim('attack', true);
			attacked = true;
			attacking = true;
		}
		else
		{
			if (dad.curCharacter == 'gooey-battle')
				dad.playAnim('attackMISS', true);
			else
				dad.playAnim('attack', true);
			attacked = false;
			attacking = false;
		}
		checkmark.visible = false;
		attackSprite.visible = false;
		canAttack = false;
	}

	// note blocking mechanic
	function arrowBlocker(noteBlocked:Int):Void
	{
		var blocker:FlxSprite;

		blocker = new FlxSprite();
		blocker.frames = Paths.getSparrowAtlas('arrow blocker', 'shared');
		blocker.animation.addByPrefix('block', 'appear', 24, false);
		blocker.animation.addByPrefix('idle', 'idle', 24, true);
		blocker.updateHitbox();
		blocker.antialiasing = true;
		blocker.scrollFactor.set(1, 1);
		blocker.cameras = [camHUD];
		blocker.animation.play('block', true);
		add(blocker);

		if (FlxG.save.data.downscroll)
		{
			blocker.flipY = true;
			blocker.y = -280;
		}
		else
		{
			blocker.y = playerStrums.members[1].y - 20;
		}

		new FlxTimer().start(0.67, function(tmr:FlxTimer)
		{
			blocker.animation.play('idle', true);
			switch(noteBlocked)
			{
				case 1:
					leftBlocked = true;
				case 2:
					downBlocked = true;
				case 3:
					upBlocked = true;
				case 4:
					rightBlocked = true;
			}
		}, 1);
		switch(noteBlocked)
		{
			case 1:
				leftBlocked = true;
				blocker.x = playerStrums.members[0].x - 40;
			case 2:
				downBlocked = true;
				blocker.x = playerStrums.members[1].x - 40;
			case 3:
				upBlocked = true;
				blocker.x = playerStrums.members[2].x - 40;
			case 4:
				rightBlocked = true;
				blocker.x = playerStrums.members[3].x - 40;
		}
	}

	// Dark-Purple stuff
	var lORr:Int = 0;
	function dpArrowTween():Void
	{
		lORr += 1;
		if (lORr > 2)
			lORr = 1;

		switch(lORr)
		{
			case 1:
				moveStrums(true, true, false, false, dpATtime, 1);
			case 2:
				moveStrums(true, false, false, true, dpATtime, 1);
		}

		new FlxTimer().start(dpATtime, function(t:FlxTimer)
		{
			dpArrowTween();
		}, 1);
	}

	function dpAlphaTween():Void
	{
		FlxTween.tween(leCoolBl, {alpha: 1}, dpBLtime, {ease: FlxEase.cubeIn});
	}

	function dpAlphaCancel():Void
	{
		resetSpaceCounter();
		FlxTween.cancelTweensOf(leCoolBl);
		FlxTween.tween(leCoolBl, {alpha: 0}, 0.15, {ease: FlxEase.cubeIn, onComplete: function(t:FlxTween)
		{
			dpAlphaTween();
		}});
	}

	// Player strumline movement
	function moveStrums(player:Bool = true, left:Bool = false, middle:Bool = false, right:Bool = false, time:Float = 0.2, easeFunc:Int = 0):Void
	{
		var easeType:Null<EaseFunction> = FlxEase.smoothStepInOut;

		switch(easeFunc)
		{
			case 1:
				easeType = FlxEase.sineInOut;
		}

		if (player)
		{
			if (left)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 100}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 100}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 100}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 100}, time, {ease: easeType});
			}
			if (middle)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 380}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 380}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 380}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 380}, time, {ease: easeType});
			}
			if (right)
			{
				FlxTween.tween(playerStrums.members[0], {x: strumLineNotes.members[0].x + 680}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[1], {x: strumLineNotes.members[1].x + 680}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[2], {x: strumLineNotes.members[2].x + 680}, time, {ease: easeType});
				FlxTween.tween(playerStrums.members[3], {x: strumLineNotes.members[3].x + 680}, time, {ease: easeType});
			}
		}
	}

	// Better way to switch chars
	function charSwitch(target:Character, x:Float, y:Float, newChar:String):Void
	{
		remove(target);
		target = new Character(x, y, newChar);
		add(target);
	}

	function bfSwitch(x:Float, y:Float, newChar:String):Void
	{
		remove(boyfriend);
		boyfriend = new Boyfriend(x, y, newChar);
		add(boyfriend);
	}

	var video:MP4Handler;

	function playCutscene(name:String)
	{
		inCutscene = true;

		video = new MP4Handler();
		video.finishCallback = function()
		{
			startCountdown();
		}
		video.playVideo(Paths.video(name));
	}

	function playMidCutscene(name:String)
	{
		video = new MP4Handler();
		video.playVideo(Paths.video(name));
	}

	function playEndCutscene(name:String)
	{
		inCutscene = true;

		video = new MP4Handler();
		video.finishCallback = function()
		{
			FlxG.sound.playMusic(Paths.music('menu drums'));
			LoadingState.loadAndSwitchState(new FNMStoryMenuState());
		}
		video.playVideo(Paths.video(name), null, true);
	}

	var curLight:Int = 0;
}
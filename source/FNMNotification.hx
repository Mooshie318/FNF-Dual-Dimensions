package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class FNMNotification extends FlxSpriteGroup
{
    var dir:Int = 1;
    var theNumber:Float = 285; // Look at "function theTween" for this

    var border:FlxSprite;
    var main:FlxSprite;

    var titleTxt:FlxText;
    var descTxt:FlxText;

    // How to add:
    // 
    // var n:FNMNotification = new FNMNotification(dir, title, desc);
    // add(n);

    // dir 1 = Coming from right
    // dir 2 = Coming from left
    public function new(d:Int = 1, title:String, desc:String)
    {
        super(d);
        dir = d;

        // if dir == 1, x = 1300/1305
        // else, x = -290/-285
        border = new FlxSprite(dir == 1 ? 1300 : -290, 0).makeGraphic(300, 80, FlxColor.WHITE);
        main = new FlxSprite(dir == 1 ? 1305 : -285, 5).makeGraphic(290, 70, FlxColor.BLACK);
        add(border);
        add(main);

        titleTxt = new FlxText(main.x + 5, main.y + 5, 0, title, 25);
		titleTxt.scrollFactor.set();
		titleTxt.setFormat("VCR OSD Mono", 23, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        descTxt = new FlxText(main.x + 5, main.y + 28, 0, desc, 20);
		descTxt.scrollFactor.set();
		descTxt.setFormat("VCR OSD Mono", 19, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(titleTxt);
        add(descTxt);

        theTween(border);
        theTween(main);
        theTween(titleTxt);
        theTween(descTxt);
    }

    function theTween(sprite:FlxObject):Void
    {
        // if dir == 1, move left because it's coming from the right
        // else, move right because it's coming from the left
        FlxTween.tween(sprite, {x: (dir == 1 ? (sprite.x - theNumber) : (sprite.x + theNumber))}, 0.5, {ease: FlxEase.sineOut, onComplete: function(t:FlxTween)
        {
            new FlxTimer().start(3, function(t:FlxTimer)
            {
                FlxTween.tween(sprite, {x: (dir == 1 ? (sprite.x + theNumber) : (sprite.x - theNumber))}, 0.5, {ease: FlxEase.sineIn, onComplete: function(t:FlxTween)
                {
                    remove(border);
                    remove(main);
                    remove(titleTxt);
                    remove(descTxt);
                }});
            });
        }});
    }
}
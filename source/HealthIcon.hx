package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		loadGraphic(Paths.image('iconGrid'), true, 150, 150);


		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-neon', [29, 30], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-dodge', [0, 1], 0, false, isPlayer);
		animation.add('bf-gf', [37, 38], 0, false, isPlayer);
		animation.add('bf-opponent', [0, 1], 0, false, isPlayer);
		animation.add('james', [2, 3], 0, false, isPlayer);
		animation.add('ghost', [4, 5], 0, false, isPlayer);
		animation.add('sheary', [6, 7], 0, false, isPlayer);
		animation.add('madcloud', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('slime', [12, 13], 0, false, isPlayer);
		animation.add('lemony', [12, 13], 0, false, isPlayer);
		animation.add('icy', [12, 13], 0, false, isPlayer);
		animation.add('slimy', [12, 13], 0, false, isPlayer);
		animation.add('fire', [12, 13], 0, false, isPlayer);
		animation.add('trooper', [22, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-airship', [16], 0, false, isPlayer);
		animation.add('cluckington', [17, 18], 0, false, isPlayer);
		animation.add('clooshie', [19, 20], 0, false, isPlayer);
		animation.add('gooey', [45, 46], 0, false, isPlayer);
		animation.add('gooey-squished', [45, 46], 0, false, isPlayer);
		animation.add('mooshie', [24, 25], 0, false, isPlayer);
		animation.add('supermooshie', [26, 27], 0, false, isPlayer);
		animation.add('supermooshie-mad', [26, 28], 0, false, isPlayer);
		animation.add('mooshep-sm', [31, 34], 0, false, isPlayer);
		animation.add('mooshep-sh', [32, 35], 0, false, isPlayer);
		animation.add('mooshep-both', [33, 36], 0, false, isPlayer);
		animation.add('cluck-clu', [39, 42], 0, false, isPlayer);
		animation.add('cluck-clo', [40, 43], 0, false, isPlayer);
		animation.add('cluck-both', [41, 44], 0, false, isPlayer);
		animation.play(char);
		switch(char){
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				{

				}
			default:
				{
					antialiasing = true;
				}
		}
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}

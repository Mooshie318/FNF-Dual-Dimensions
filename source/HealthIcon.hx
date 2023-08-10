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
		animation.add('bf-flipped', [0, 1], 0, false, isPlayer);
		animation.add('bf-battle', [0, 1], 0, false, isPlayer);
		animation.add('bf-bDiagonal', [0, 1], 0, false, isPlayer);
		animation.add('bf-bDiagonal-f', [0, 1], 0, false, isPlayer);
		animation.add('bf-frDiagonal', [0, 1], 0, false, isPlayer);
		animation.add('bf-frDiagonal-f', [0, 1], 0, false, isPlayer);
		animation.add('bf-front', [0, 1], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);

		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-airship', [16], 0, false, isPlayer);

		animation.add('james', [2, 3], 0, false, isPlayer);
		animation.add('ghost', [4, 5], 0, false, isPlayer);
		animation.add('sheary', [6, 7], 0, false, isPlayer);
		animation.add('madcloud', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('slime', [12, 13], 0, false, isPlayer);
		animation.add('lemony', [47, 48], 0, false, isPlayer);
		animation.add('icy', [49, 50], 0, false, isPlayer);
		animation.add('slimy', [53, 54], 0, false, isPlayer);
		animation.add('fire', [51, 52], 0, false, isPlayer);
		animation.add('fire-battle', [51, 52], 0, false, isPlayer);
		animation.add('trooper', [22, 23], 0, false, isPlayer);
		animation.add('cluckington', [17, 18], 0, false, isPlayer);
		animation.add('clooshie', [19, 20], 0, false, isPlayer);
		animation.add('gooey', [45, 46], 0, false, isPlayer);
		animation.add('gooey-battle', [45, 46], 0, false, isPlayer);
		animation.add('gooey-squished', [45, 46], 0, false, isPlayer);
		animation.add('mooshie', [24, 25], 0, false, isPlayer);
		animation.add('supermooshie', [26, 27], 0, false, isPlayer);
		animation.add('supermooshie-mad', [26, 28], 0, false, isPlayer);
		animation.add('supermooshie-battle', [26, 28], 0, false, isPlayer);
		animation.add('mooshep-sm', [31, 34], 0, false, isPlayer);
		animation.add('mooshep-sh', [32, 35], 0, false, isPlayer);
		animation.add('mooshep-both', [33, 36], 0, false, isPlayer);
		animation.add('cluck-clu', [39, 42], 0, false, isPlayer);
		animation.add('cluck-clo', [40, 43], 0, false, isPlayer);
		animation.add('cluck-both', [41, 44], 0, false, isPlayer);
		animation.add('ghost-front', [4, 5], 0, false, isPlayer);
		animation.add('sheary-diagonal', [6, 7], 0, false, isPlayer);
		animation.add('cluckington-f', [17, 18], 0, false, isPlayer);
		animation.add('clooshie-diagonal', [19, 20], 0, false, isPlayer);
		animation.add('trooper-back', [22, 23], 0, false, isPlayer);
		animation.add('gooey-back', [45, 46], 0, false, isPlayer);
		animation.add('supermooshie-diagonal', [26, 27], 0, false, isPlayer);

		animation.add('stickletto', [55], 0, false, isPlayer);
		animation.add('stickletto-f', [55], 0, false, isPlayer);
		animation.add('stickletto-i', [55], 0, false, isPlayer);
		animation.add('stickletto-c', [55], 0, false, isPlayer);
		animation.add('stickletto-unc', [55], 0, false, isPlayer);
		animation.add('stickletto-unc-f', [55], 0, false, isPlayer);
		animation.add('stickletto-b', [55], 0, false, isPlayer);
		animation.add('stickletta-f', [58], 0, false, isPlayer);
		animation.add('stickletta-c-f', [58], 0, false, isPlayer);
		animation.add('stickletta-gf', [58], 0, false, isPlayer);
		animation.add('stickletta-b', [58], 0, false, isPlayer);
		animation.add('stickletta-m', [58], 0, false, isPlayer);
		animation.add('sticklettabow-b', [55], 0, false, isPlayer);
		animation.add('swordletto-b', [55], 0, false, isPlayer);

		animation.add('sticko', [55], 0, false, isPlayer);
		animation.add('stickletta', [58], 0, false, isPlayer);
		animation.add('stickletta-c', [58], 0, false, isPlayer);
		animation.add('clonerman', [57], 0, false, isPlayer);
		animation.add('swordletto', [55], 0, false, isPlayer);
		animation.add('sticklettabow', [55], 0, false, isPlayer);
		animation.add('stickletto-i-w', [55], 0, false, isPlayer);
		animation.add('stickletto-i-w-f', [55], 0, false, isPlayer);
		animation.add('stickletto-dd', [55], 0, false, isPlayer);
		animation.add('striker', [55], 0, false, isPlayer);
		animation.add('striker-fr', [55], 0, false, isPlayer);
		animation.add('yellow', [59], 0, false, isPlayer);
		animation.add('yellow-f', [59], 0, false, isPlayer);
		animation.add('red', [56], 0, false, isPlayer);
		animation.add('red-f', [56], 0, false, isPlayer);
		animation.add('stiburn', [55], 0, false, isPlayer);
		animation.add('stiburn-fr', [55], 0, false, isPlayer);
		animation.add('stlaw', [55], 0, false, isPlayer);
		animation.add('stickannon', [55], 0, false, isPlayer);
		animation.add('stibow', [55], 0, false, isPlayer);
		animation.add('crocker', [60, 61], 0, false, isPlayer);

		animation.add('bofen', [0, 1], 0, false, isPlayer);
		animation.add('grilfen', [16], 0, false, isPlayer);

		animation.add('ralph', [62, 63], 0, false, isPlayer);

		animation.add('maroon', [64], 0, false, isPlayer);
		animation.add('blue', [65], 0, false, isPlayer);

		// TEMPLATE
		// animation.add('', [], 0, false, isPlayer);
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

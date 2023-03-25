import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class KeyBinds
{
    public static var gamepad:Bool = false;

    public static function resetBinds():Void{

        FlxG.save.data.upBind = "W";
        FlxG.save.data.downBind = "S";
        FlxG.save.data.leftBind = "A";
        FlxG.save.data.rightBind = "D";
        FlxG.save.data.attackBind = "I";
        FlxG.save.data.dodgeBind = "K";
        FlxG.save.data.dodgeLBind = "J";
        FlxG.save.data.dodgeRBind = "L";
        FlxG.save.data.killBind = "R";
        FlxG.save.data.gpupBind = "DPAD_UP";
        FlxG.save.data.gpdownBind = "DPAD_DOWN";
        FlxG.save.data.gpleftBind = "DPAD_LEFT";
        FlxG.save.data.gprightBind = "DPAD_RIGHT";
        FlxG.save.data.gpattackBind = "Y";
        FlxG.save.data.gpdodgeBind = "A";
        FlxG.save.data.gpdodgeLBind = "X";
        FlxG.save.data.gpdodgeRBind = "B";
        PlayerSettings.player1.controls.loadKeyBinds();
	}

    public static function keyCheck():Void
    {
        if(FlxG.save.data.upBind == null){
            FlxG.save.data.upBind = "W";
            trace("No UP");
        }
        if (StringTools.contains(FlxG.save.data.upBind,"NUMPAD"))
            FlxG.save.data.upBind = "W";
        if(FlxG.save.data.downBind == null){
            FlxG.save.data.downBind = "S";
            trace("No DOWN");
        }
        if (StringTools.contains(FlxG.save.data.downBind,"NUMPAD"))
            FlxG.save.data.downBind = "S";
        if(FlxG.save.data.leftBind == null){
            FlxG.save.data.leftBind = "A";
            trace("No LEFT");
        }
        if (StringTools.contains(FlxG.save.data.leftBind,"NUMPAD"))
            FlxG.save.data.leftBind = "A";
        if(FlxG.save.data.rightBind == null){
            FlxG.save.data.rightBind = "D";
            trace("No RIGHT");
        }
        if (StringTools.contains(FlxG.save.data.rightBind,"NUMPAD"))
            FlxG.save.data.rightBind = "D";
        if(FlxG.save.data.attackBind == null){
            FlxG.save.data.attackBind = "I";
            trace("No ATTACK");
        }
        if (StringTools.contains(FlxG.save.data.attackBind,"NUMPAD"))
            FlxG.save.data.attackBind = "I";
        if(FlxG.save.data.dodgeBind == null){
            FlxG.save.data.dodgeBind = "K";
            trace("No DODGE");
        }
        if (StringTools.contains(FlxG.save.data.dodgeBind,"NUMPAD"))
            FlxG.save.data.dodgeBind = "K";
        if(FlxG.save.data.dodgeLBind == null){
            FlxG.save.data.dodgeLBind = "J";
            trace("No LEFT DODGE");
        }
        if (StringTools.contains(FlxG.save.data.dodgeLBind,"NUMPAD"))
            FlxG.save.data.dodgeLBind = "J";
        if(FlxG.save.data.dodgeRBind == null){
            FlxG.save.data.dodgeRBind = "L";
            trace("No RIGHT DODGE");
        }
        if (StringTools.contains(FlxG.save.data.dodgRBind,"NUMPAD"))
            FlxG.save.data.dodgeRBind = "L";
        
        if(FlxG.save.data.gpupBind == null){
            FlxG.save.data.gpupBind = "DPAD_UP";
            trace("No GUP");
        }
        if(FlxG.save.data.gpdownBind == null){
            FlxG.save.data.gpdownBind = "DPAD_DOWN";
            trace("No GDOWN");
        }
        if(FlxG.save.data.gpattackBind == null){
            FlxG.save.data.gpattackBind = "Y";
            trace("No GATTACK");
        }
        if(FlxG.save.data.gpdodgeBind == null){
            FlxG.save.data.gpdodgeBind = "A";
            trace("No GDODGE");
        }
        if(FlxG.save.data.gpdodgeLBind == null){
            FlxG.save.data.gpdodgeLBind = "X";
            trace("No GLEFTDODGE");
        }
        if(FlxG.save.data.gpdodgeRBind == null){
            FlxG.save.data.gpdodgeRBind = "B";
            trace("No GRIGHTDODGE");
        }
        if(FlxG.save.data.gpleftBind == null){
            FlxG.save.data.gpleftBind = "DPAD_LEFT";
            trace("No GLEFT");
        }
        if(FlxG.save.data.gprightBind == null){
            FlxG.save.data.gprightBind = "DPAD_RIGHT";
            trace("No GRIGHT");
        }

        trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');
    }
}
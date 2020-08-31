import hxd.Key;

class Input {
    public static var keyMods:Map<Int, Bool> = [];

    public static function setMod(keyMod:Int, state:Bool) {
        keyMods.set(keyMod, state);
    }

    public static function checkMod(keyMod:Int):Bool {
        var state = keyMods.get(keyMod);
        if (state == null) return false;

        return state;
    }

    public static function checkKey(keyCode:Int, keys:Array<Int>):Bool {
        return keys.contains(keyCode);
    }

    public static final KEY_LEFT = [Key.A, Key.LEFT];
    public static final KEY_RIGHT = [Key.D, Key.RIGHT];
    public static final KEY_DOWN = [Key.S, Key.DOWN];
    public static final KEY_UP = [Key.W, Key.UP];

    public static final KEY_ENTER = [Key.ENTER, Key.NUMPAD_ENTER];
}
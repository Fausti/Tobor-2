import hxd.Event;
import hxd.Window;
import hxd.Key;

class Input {
    public static var mouseX:Int;
    public static var mouseY:Int;

    public static var mouseLeft:Bool = false;
    public static var mouseRight:Bool = false;
    public static var mouseMiddle:Bool = false;

    public static var mouseWheelUp:Bool = false;
    public static var mouseWheelDown:Bool = false;

    static var keyMods:Map<Int, Bool> = [];

    public static function init(window:Window) {
        window.addEventTarget(onEvent);
    }

    public static function onEvent(event:Event) {
        switch (event.kind) {
            // Maus
            case EMove:
                Input.mouseX = Math.floor(Tobor.root.mouseX);
                Input.mouseY = Math.floor(Tobor.root.mouseY);
            case EPush:
                Input.mouseX = Math.floor(Tobor.root.mouseX);
                Input.mouseY = Math.floor(Tobor.root.mouseY);

                switch (event.button) {
                    case 0: Input.mouseLeft = true;
                    case 1: Input.mouseRight = true;
                    case 2: Input.mouseMiddle = true;
                }
            case ERelease:
                Input.mouseX = Math.floor(Tobor.root.mouseX);
                Input.mouseY = Math.floor(Tobor.root.mouseY);

                switch (event.button) {
                    case 0: Input.mouseLeft = false;
                    case 1: Input.mouseRight = false;
                    case 2: Input.mouseMiddle = false;
                }
            case EWheel:
                if (event.wheelDelta < 0) {
                    mouseWheelUp = true;
                    mouseWheelDown = false;
                } else if (event.wheelDelta > 0) {
                    mouseWheelUp = false;
                    mouseWheelDown = true;
                } else {
                    mouseWheelUp = false;
                    mouseWheelDown = false;
                }
            
            // Tastatur
            case EKeyDown:
                // ALT, STRG, SHIFT abfangen
                switch (event.keyCode) {
                    case Key.ALT:
                        Input.setMod(Key.ALT, true);
                    case Key.SHIFT:
                        Input.setMod(Key.SHIFT, true);
                    case Key.CTRL:
                        Input.setMod(Key.CTRL, true);
                }
            case EKeyUp:
                // ALT, STRG, SHIFT abfangen
                switch (event.keyCode) {
                    case Key.ALT:
                        Input.setMod(Key.ALT, false);
                    case Key.SHIFT:
                        Input.setMod(Key.SHIFT, false);
                    case Key.CTRL:
                        Input.setMod(Key.CTRL, false);
                }
            case ETextInput:
            default:
        }
    }

    public static function setMod(keyMod:Int, state:Bool) {
        keyMods.set(keyMod, state);
    }

    public static function checkMod(keyMod:Int):Bool {
        var state = keyMods.get(keyMod);
        if (state == null) return false;

        return state;
    }

    public static function isKeyDown(keyCode:Int, keys:Array<Int>):Bool {
        return keys.contains(keyCode);
    }

    public static final KEY_LEFT = [Key.A, Key.LEFT];
    public static final KEY_RIGHT = [Key.D, Key.RIGHT];
    public static final KEY_DOWN = [Key.S, Key.DOWN];
    public static final KEY_UP = [Key.W, Key.UP];

    public static final KEY_ENTER = [Key.ENTER, Key.NUMPAD_ENTER];
    public static final KEY_TAB = [Key.TAB];
}
import hxd.System;
import hxd.Key;
import screens.StartScreen;
import h2d.Object;
import gfx.Tileset;
import gfx.Gfx;
import hxd.Event;
import hxd.Window;
import h2d.Scene;
import screens.Screen;
import hxd.Res;
import hxd.App;

class Tobor extends App {
    public static var root:Scene;
    public var window:Window;

    var baseAssets:Assets;
    
    public static var screen(default, null):Screen;

    var active:Bool = true;

    override function init() {
        Config.init();

        Gfx.fontNormal = Res.fnt.cga.toFont();
        Gfx.fontThin = Res.fnt.cga_thin.toFont();

        baseAssets = new Assets();

        // Basistileset aus eingebetteten Grafiken und Modgrafiken erstellen

        var list = baseAssets.getFileList("gfx", "png");
        Gfx.baseTileset = new Tileset();
        Gfx.baseTileset.loadSprites(list);
        Gfx.tileset = Gfx.baseTileset;

        Gfx.tileset.savePNG("tileset.png");

        Tobor.root = s2d;
        // Tobor.root.scaleMode = ScaleMode.LetterBox(Tobor.SCREEN_W, Tobor.SCREEN_H, true);
        Tobor.root.scaleMode = ScaleMode.Stretch(Tobor.SCREEN_W, Tobor.SCREEN_H);
        // Tobor.root.scaleMode = ScaleMode.Fixed(Tobor.SCREEN_W, Tobor.SCREEN_H, 1);
        
        this.window = hxd.Window.getInstance();
        this.window.addEventTarget(onEvent);

        Tobor.screen = new StartScreen(this, root);
    }

    override function update(dt:Float) {
        if (!active) return;
        if (Tobor.screen == null) return;

        Tobor.screen.update(dt);
    }

    public static function setScreen(newScreen:Screen) {
        if (Tobor.screen != null) {
            Tobor.screen.remove();
        }
        
        Tobor.screen = newScreen;
    }

    override public function onResize() {
        var stage = hxd.Window.getInstance();
        trace('Resized to ${stage.width}px * ${stage.height}px');
    }

    function onEvent(event:Event) {
        switch(event.kind) {
            case EMove:
                if (Tobor.screen != null) {
                    Tobor.screen.onMouseMove(Math.floor(event.relX), Math.floor(event.relY));
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

                if (event.keyCode == Key.ENTER) { // Fullscreen ALT+ENTER
                    if (Input.checkMod(Key.ALT)) {
                        engine.fullScreen = !engine.fullScreen;
                        return;
                    }
                } else if (event.keyCode == Key.F4) { // Beenden ALT+F4
                    if (Input.checkMod(Key.ALT)) {
                        System.exit();
                    }
                }

                if (Tobor.screen != null) {
                    Tobor.screen.onKeyDown(event.keyCode, event.charCode);
                }
            case EFocus:
                active = true;
            case EFocusLost:
                active = false;
            default:
                trace(event);
        }
        
    }

    // Programmeinstiegspunkt
    static function main() {
        Res.initEmbed();
        new Tobor();
    }

    public static inline var SCREEN_W:Int = 640;
    public static inline var SCREEN_H:Int = 348;

    public static inline var TILE_W:Int = 16;
    public static inline var TILE_H:Int = 12;
}
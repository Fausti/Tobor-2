import world.World;
import haxe.SysTools;
import screens.EpisodesScreen;
import hl.UI;
import hxd.System;
import hxd.Key;
import h3d.pass.Default;
import screens.Screen;
import h2d.Scene;
import hxd.Window;
import hxd.Window.DisplayMode;
import hxd.Event;
import hxd.Res;
import hxd.App;

class Tobor extends App {
    var active:Bool = true;

    var screen:Screen;

    public static var defaultLocale:String = "de";
    public static var locale:String;

    public static var world:World;

    override function init() {
        Tobor.locale = System.lang;
        trace("Userlocale: " + Tobor.locale);

        Tobor.window = Window.getInstance();
        
        Tobor.root = this.s2d;
        Tobor.root.scaleMode = ScaleMode.Stretch(Const.SCREEN_W, Const.SCREEN_H);

        // Config.init();
        // Text.init();

        Files.init();
        // Sound.init();

        Gfx.baseTileset = new Tileset();
        Gfx.baseTileset.loadSprites(Files.getAssetList("gfx", "png"));

        Gfx.fontNormal = Res.fnt.cga.toFont();
        Gfx.fontThin = Res.fnt.cga_thin.toFont();
        
        // Debugausgabe des Spriteatlases
        Gfx.tileset.savePNG("tileset.png");

        Input.init(Tobor.window);
        Tobor.window.addEventTarget(onEvent);

        setTitle("The World of Tobor");
        setScreen(new EpisodesScreen(this));
    }

    override function update(deltaTime:Float) {
        // Wenn Fenster keinen Focus hat nichts berechnen
        if (!active) return;

        // Wenn kein aktiver Screen, raus hier...
        if (screen == null) return;

        // aktiven Bildschirm aktualisieren
        screen._update(deltaTime);
    }

    function onEvent(event:Event) {
        switch (event.kind) {
            case EKeyDown:
                if (event.keyCode == Key.ENTER) {
                    // Fullscreen: ALT+ENTER
                    if (Input.checkMod(Key.ALT)) {
                        engine.fullScreen = !engine.fullScreen;
                        return;
                    }
                } else if (event.keyCode == Key.F4) {
                    // Beenden: ALT+F4
                    if (Input.checkMod(Key.ALT)) {
                        System.exit();
                        return;
                    }
                } else if (event.keyCode == Key.F12) { 
                    // Screenshot: F12
                }

                if (screen != null) {
                    screen._onKeyDown(event.keyCode, event.charCode);
                }
            case EWheel:
                if (screen != null) {
                    screen._onWheel();
                }
            case EFocus:
                active = true;
            case EFocusLost:
                active = false;
            default:
        }
    }

    public function setScreen(newScreen:Screen) {
        if (this.screen != null) {
            this.screen.hide();
            this.screen.remove();
        }

        // Input.clearKeys();

        this.screen = newScreen;
        this.screen.show();
    }

    public function setTitle(?title:String = null) {
        if (title == null) {
            Tobor.window.title = "The World of Tobor";
        } else {
            Tobor.window.title = "The World of Tobor: " + title;
        }
    }

    // statische Variablen
    public static var window:Window;
    public static var root:Scene;
    
    // Programmeinstiegspunkt
    public static function main() {
        Res.initEmbed();
        new Tobor();
    }
}
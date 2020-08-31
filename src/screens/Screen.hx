package screens;

import gfx.Gfx;
import h2d.Bitmap;
import h2d.Object;

class Screen extends Object {
    var app:Tobor;

    var bg:Bitmap;

    public function new(app:Tobor, ?parent:Object) {
        super(parent);

        this.app = app;

        bg = new Bitmap(Gfx.tileset.getSprite("white").getTile().sub(0, 0, 1, 1), this);
        bg.scaleX = Tobor.SCREEN_W;
        bg.scaleY = Tobor.SCREEN_H;

        init();
    }

    function init() {

    }

    public function update(deltaTime:Float) {

    }

    public function onMouseMove(mouseX:Int, mouseY:Int) {
        
    }

    public function onKeyDown(keyCode:Int, charCode:Int):Bool {
        return false;
    }
}
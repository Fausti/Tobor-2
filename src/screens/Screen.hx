package screens;

import ui.Dialog;
import h2d.Bitmap;
import h2d.Object;

class Screen extends Object {
    var app:Tobor;
    var background:Bitmap;

    var dialog:Dialog;

    public function new(app:Tobor) {
        super(Tobor.root);

        this.app = app;
        
        background = new Bitmap(Gfx.getWhitePixel(), this);
        background.width = Const.SCREEN_W;
        background.height = Const.SCREEN_H;

        init();
    }

    public function init() {

    }

    public function show() {

    }

    public function hide() {

    }

    public function _update(deltaTime:Float) {
        if (dialog != null) {
            dialog.update(deltaTime);
            return;
        }

        update(deltaTime);
    }

    public function update(deltaTime:Float) {
        
    }

    public function _onKeyDown(keyCode:Int, charCode:Int):Bool {
        if (dialog != null) {
            return dialog.onKeyDown(keyCode, charCode);
        }

        return onKeyDown(keyCode, charCode);
    }

    public function onKeyDown(keyCode:Int, charCode:Int):Bool {
        return false;
    }

    public function _onWheel() {
        onWheel();
    }

    public function onWheel() {

    }

    public function showDialog(d:Dialog) {
        if (this.dialog != null) {
            if (this.dialog != d) {
                this.dialog.hide();
                this.dialog.remove();
            }
        }

        this.dialog = d;
        if (d != null) d.show();
    }
}
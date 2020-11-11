package screens;

import ui.Frame;
import h2d.Bitmap;
import h2d.Text;
import h2d.Tile;
import h2d.TileGroup;

class IntroScreen extends Screen {
    var tileBackground:Tile;
    var batch:TileGroup;

    var textName:Text;
    var textDesc:Text;

    var boxList = {
        x: 2,
        y: 5,
        w: 36,
        h: 17
    }

    var boxCredits = {
        x: 1,
        y: 27,
        w: 38,
        h: 1
    }

    override function init() {
        app.setTitle(Tobor.world.getName());

        tileBackground = Gfx.tileset.getTile("wall_red");

        batch = new TileGroup(Gfx.tileset.getTexture(), this);

        for (_x in 0 ... Const.ROOM_W) {
            for (_y in 0 ... Const.ROOM_H + 1) {
                batch.add(_x * Const.TILE_W, _y * Const.TILE_H, tileBackground);
            }
        }

        var bgName = new Bitmap(Gfx.getWhitePixel(), this);

        textName = new Text(Gfx.fontNormal, this);
        textName.scaleX = 2;
        textName.text = " " + Tobor.world.getName() + " ";
        textName.textAlign = Align.Center;
        textName.color = Color.BLACK.getVector3();
        textName.x = Const.CENTER_X;
        textName.y = 3 * Const.TILE_H + 2;

        bgName.scaleX = textName.textWidth * 2;
        bgName.scaleY = Const.TILE_H;
        bgName.x = Const.CENTER_X - textName.textWidth;
        bgName.y = 3 * Const.TILE_H;

        var frameList = new Frame(boxList.x * Const.TILE_W, boxList.y * Const.TILE_H, boxList.w, boxList.h, "frame_highscore", this);

        // var bgDesc = new Bitmap(Gfx.getWhitePixel(), this);

        textDesc = new Text(Gfx.fontNormal, this);
        textDesc.text = " " + Tobor.world.getDesc() + " ";
        textDesc.textAlign = Align.Center;
        textDesc.color = Color.BLACK.getVector3();
        textDesc.x = Const.CENTER_X;
        textDesc.y = (boxList.y + 2) * Const.TILE_H;

        // bgDesc.scaleX = textDesc.textWidth;
        // bgDesc.scaleY = Const.TILE_H;
        // bgDesc.x = Const.CENTER_X - (textDesc.textWidth / 2);
        // bgDesc.y = 5 * Const.TILE_H;

        for (i in 0 ... 10) {
            if (i < Tobor.world.highscore.scores.length) {
                var score = Tobor.world.highscore.scores[i];

                var scoreString = StringTools.lpad(Std.string(i + 1), " ", 2);
                scoreString += " " + StringTools.lpad(score.name.substr(0, 15), " ", 15);
                scoreString += ": " + StringTools.lpad(Std.string(score.points), " ", 7);
                scoreString += " (" + StringTools.lpad(Std.string(score.rooms), " ", 2) + ")";

                var textScore = new Text(Gfx.fontNormal, frameList);
                textScore.text = scoreString;
                textScore.scaleX = 2;
                textScore.color = Color.BLACK.getVector3();
                textScore.y = (5 + i) * Const.TILE_H;
                textScore.x = 2 * Const.TILE_W;
            }
        }
    }

    override function onKeyDown(keyCode:Int, charCode:Int):Bool {
        if (Input.isKeyDown(keyCode, Input.KEY_ENTER)) {
            Tobor.world.load();
            return true;
        }

        return super.onKeyDown(keyCode, charCode);
    }
}
package screens;
import hxd.System;
import hxd.Key;
import h3d.Engine;
import hxd.App;
import ui.Scrollbar;
import h2d.Slider;
import ui.Frame;
import h3d.Vector;
import h2d.Bitmap;
import math.Rectangle;
import world.World;
import h2d.TileGroup;
import gfx.Color;
import gfx.Gfx;
import h2d.Text;

class StartScreen extends Screen {
    var bgTiles:TileGroup;

    var titleBox:Rectangle = new Rectangle(12, 2, 15, 5);

    var scrollingText:String = "Danke an TOM Productions für ihre tollen Robot Spiele! ";
    var scrollTxt:Text;
    var scrollTimeLeft:Float;
    var scrollSpeed:Float = 0.25;
    var scrollIndex:Int = 0;

    override function init() {
        addBackgroundTiles();

        var title:Text = new Text(Gfx.fontNormal, this);

        title.text = "The game of";
        title.textAlign = Align.Center;
        title.textColor = Color.BLACK;
        title.x = Tobor.SCREEN_W / 2;
        title.y = 2 * Tobor.TILE_H + 6;
        title.scaleX = 2;

        var creditsBG = new Bitmap(Gfx.tileset.getSprite("white").getTile().sub(0, 0, 1, 1), this);
        creditsBG.x = Tobor.TILE_W;
        creditsBG.y = 27 * Tobor.TILE_H;
        creditsBG.scaleX = 38 * Tobor.TILE_W;
        creditsBG.scaleY = Tobor.TILE_H;
        creditsBG.color = Color.ORANGE.getVector3();

        scrollingText = StringTools.rpad(scrollingText, " ", 38 * 2);
        scrollingText = scrollingText + scrollingText;

        scrollTxt = new Text(Gfx.fontNormal, this);
        scrollTxt.text = scrollingText.substr(0, 38 * 2);
        scrollTxt.x = creditsBG.x;
        scrollTxt.y = creditsBG.y + 2;
        scrollTxt.textColor = Color.DARK_RED;

        var frameList:Frame = new Frame(Gfx.baseTileset.getTexture(), Tobor.TILE_W, Tobor.TILE_H, "frame_big", this);
        // frameList.init(2 * Tobor.TILE_W, 8 * Tobor.TILE_W, 36, 16);

        frameList.x = 2 * Tobor.TILE_W;
        frameList.y = 10 * Tobor.TILE_H;
        frameList.width = 36 * Tobor.TILE_W;
        frameList.height = 15 * Tobor.TILE_H;

        // var scrollBar:Scrollbar = new Scrollbar(16, 12 * 15, this);
    }

    override function update(deltaTime:Float) {
        if (scrollTimeLeft > 0) {
            scrollTimeLeft = scrollTimeLeft - deltaTime;
        } else {
            scrollIndex++;
            if (scrollIndex >= (scrollingText.length / 2)) {
                scrollIndex = 0;
            }

            scrollTimeLeft = scrollTimeLeft + scrollSpeed;
            scrollTxt.text = scrollingText.substr(scrollIndex, 38 * 2);
        }
        

        super.update(deltaTime);
    }

    override function onKeyDown(keyCode:Int, charCode:Int):Bool {
        if (keyCode == Key.ESCAPE) {
            return true;
        } else if (keyCode == Key.ENTER) {
            Tobor.setScreen(new IntroScreen(app, parent));
            
            return true;
        }

        return super.onKeyDown(keyCode, charCode);
    }

    function addBackgroundTiles() {
        var wood = Gfx.baseTileset.getTiles("wood");
        var wall = Gfx.baseTileset.getTile("wall_black");

        bgTiles = new TileGroup(Gfx.baseTileset.getTexture(), this);

        for (tx in 0 ... World.ROOM_W) {
            for (ty in 0 ... World.ROOM_H + 1) {
                if (titleBox.contains(tx, ty)) continue;

                bgTiles.add(tx * Tobor.TILE_W, ty * Tobor.TILE_H, wood[5 + Std.random(5)]);
            }
        }

        for (tx in titleBox.ix ... titleBox.ix + titleBox.iw) {
            bgTiles.add(tx * Tobor.TILE_W, (titleBox.iy - 1) * Tobor.TILE_H, wall);
            bgTiles.add(tx * Tobor.TILE_W, (titleBox.iy + titleBox.ih) * Tobor.TILE_H, wall);
        }

        for (ty in titleBox.iy - 1 ... titleBox.iy + titleBox.ih + 1) {
            bgTiles.add((titleBox.ix - 1) * Tobor.TILE_W, ty * Tobor.TILE_H, wall);
            bgTiles.add((titleBox.ix + titleBox.iw) * Tobor.TILE_W, ty * Tobor.TILE_H, wall);
        }

        var chars = Gfx.baseTileset.getTiles("tobor");
        var cx:Int = Math.floor(Tobor.SCREEN_W / 2 - (14 * Tobor.TILE_W) / 2);
        var cy:Int = (titleBox.iy + 2) * Tobor.TILE_H;

        // T

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[0]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[1]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[10]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[11]
        );

        cx = cx + 2 * Tobor.TILE_W;

        // O

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[2]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[3]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[12]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[13]
        );

        cx = cx + 2 * Tobor.TILE_W;

        // B

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[4]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[5]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[14]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[15]
        );

        cx = cx + 2 * Tobor.TILE_W;

        // O

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[2]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[3]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[12]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[13]
        );

        cx = cx + 2 * Tobor.TILE_W;

        // R

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[6]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[7]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[16]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[17]
        );

        cx = cx + 3 * Tobor.TILE_W;

        // 2

        bgTiles.add(
            (cx + 0), 
            (cy + 0), chars[8]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + 0), chars[9]
        );
        bgTiles.add(
            (cx + 0), 
            (cy + Tobor.TILE_H), chars[18]
        );
        bgTiles.add(
            (cx + Tobor.TILE_W), 
            (cy + Tobor.TILE_H), chars[19]
        );
    }
}
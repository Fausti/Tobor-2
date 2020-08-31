package gfx;

import math.Rectangle;
import hxd.Pixels;
import h2d.Tile;

class TileEntry {
    var id:Int;
    
    public var subId:Int;
    public var name:String;

    var rect:Rectangle;
    var tile:Tile;

    var parent:Tileset;

    public function new(parent:Tileset, name:String, id:Int, subId:Int, x:Int, y:Int, w:Int, h:Int) {
        this.id = id;
        this.subId = subId;
        this.name = name;

        this.parent = parent;

        this.rect = new Rectangle(x, y, w, h);
        this.tile = parent.getTexture().sub(x, y, w, h);
    }

    public inline function getTile():Tile {
        return this.tile.clone();
    }

    public inline function getPixels():Pixels {
        return parent.getPixels().sub(rect.ix, rect.iy, rect.iw, rect.ih);
    }

    public function setPixels(pixels:Pixels) {
        parent.getPixels().blit(rect.ix, rect.iy, pixels, 0, 0, pixels.width, pixels.height);
    }
}
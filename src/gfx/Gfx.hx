package gfx;

import h2d.Font;
import h2d.Tile;
import h2d.Scene;

class Gfx {
    public static var baseTileset:Tileset;
    public static var gameTileset:Tileset;
    public static var tileset(get, null):Tileset;

    public static var fontNormal:Font;
    public static var fontThin:Font;

    public static inline function get_tileset():Tileset {
        if (gameTileset != null) return gameTileset;
        
        // Fallback
        return baseTileset;
    }

    public static function getWhitePixel(?w:Int = 1, ?h:Int = 1):Tile {
        var tile = Gfx.tileset.getSprite("white").getTile().sub(0, 0, 1, 1);
        tile.scaleToSize(w, h);

        return tile;
    }
}
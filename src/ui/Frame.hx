package ui;

import h2d.TileGroup;
import h2d.Object;
import h2d.ScaleGrid;
import gfx.Gfx;
import gfx.Tileset.TileList;

class Frame extends ScaleGrid {
    var tiles:TileList;
    var singleTile:Bool = false;

    public function new(x:Float, y:Float, w:Int, h:Int, name:String, parent:Object, ?singleTile:Bool = false) {
        super(Gfx.tileset.getTexture(), Const.TILE_W, Const.TILE_H, parent);

        this.x = x;
        this.y = y;
        this.width = w * Const.TILE_W;
        this.height = h * Const.TILE_H;

        var _tiles = Gfx.baseTileset.getTiles(name);
        
        this.singleTile = singleTile;
        if (singleTile) {
            tiles = [_tiles[0]];
            tiles.push(Gfx.getWhitePixel(Const.TILE_W, Const.TILE_H));
        } else {
            tiles = _tiles;
        }

    }

    override function updateContent() {
        var bw = borderWidth, bh = borderHeight;
        var t0, t1, t2, t3, t4, t5, t6, t7, t8;

        if (singleTile) {
            t0 = tiles[0];
            t1 = tiles[0];
            t2 = tiles[0];

            t3 = tiles[0];
            t4 = tiles[1];
            t5 = tiles[0];

            t6 = tiles[0];
            t7 = tiles[0];
            t8 = tiles[0];
        } else {
            t0 = tiles[0];
            t1 = tiles[1];
            t2 = tiles[2];

            t3 = tiles[3];
            t4 = tiles[4];
            t5 = tiles[5];

            t6 = tiles[6];
            t7 = tiles[7];
            t8 = tiles[8];
        }

		// 4 corners
		content.addColor(0, 0, curColor, t0);
		content.addColor(width - bw, 0, curColor, t2);
		content.addColor(0, height-bh, curColor, t6);
		content.addColor(width - bw, height - bh, curColor, t8);

		var sizeX = bw;
		var sizeY = bh;

			var rw = Std.int((width - bw * 2) / sizeX);
			for( x in 0...rw ) {
				content.addColor(bw + x * sizeX, 0, curColor, t1);
				content.addColor(bw + x * sizeX, height - bh, curColor, t7);
			}

			var rh = Std.int((height - bh * 2) / sizeY);
			for( y in 0...rh ) {
				content.addColor(0, bh + y * sizeY, curColor, t3);
				content.addColor(width - bw, bh + y * sizeY, curColor, t5);
			}

		var t = t4;
		t.scaleToSize(width - bw * 2,height - bh * 2);
		content.addColor(bw, bh, curColor, t);
    }

    public function getContent():TileLayerContent {
        return content;
    }
}
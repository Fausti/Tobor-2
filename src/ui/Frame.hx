package ui;

import h2d.ScaleGrid;
import gfx.Gfx;
import gfx.Tileset.TileList;

class Frame extends ScaleGrid {
    var tiles:TileList;

    public function new(tile, borderW, borderH, name:String, ?parent) {
        super(tile, borderW, borderH, parent);

        tiles = Gfx.baseTileset.getTiles(name);
    }

    public function init(x, y, w, h) {
        set_x(x);
        set_y(y);
        this.width = w * borderWidth;
        this.height = h * borderHeight;
    }

    override function updateContent() {
        var bw = borderWidth, bh = borderHeight;

		// 4 corners
		content.addColor(0, 0, curColor, tiles[0]);
		content.addColor(width - bw, 0, curColor, tiles[2]);
		content.addColor(0, height-bh, curColor, tiles[6]);
		content.addColor(width - bw, height - bh, curColor, tiles[8]);

		var sizeX = bw;
		var sizeY = bh;

			var rw = Std.int((width - bw * 2) / sizeX);
			for( x in 0...rw ) {
				content.addColor(bw + x * sizeX, 0, curColor, tiles[1]);
				content.addColor(bw + x * sizeX, height - bh, curColor, tiles[7]);
			}

			var rh = Std.int((height - bh * 2) / sizeY);
			for( y in 0...rh ) {
				content.addColor(0, bh + y * sizeY, curColor, tiles[3]);
				content.addColor(width - bw, bh + y * sizeY, curColor, tiles[5]);
			}

		var t = tiles[4];
		t.scaleToSize(width - bw * 2,height - bh * 2);
		content.addColor(bw, bh, curColor, t);
    }
}
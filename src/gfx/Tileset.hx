package gfx;

import sys.io.File;
import hxd.res.Image;
import Assets.FileList;
import hxd.Pixels;
import h2d.Tile;

typedef TileList = Array<Tile>;

class Tileset {
    static inline var TEXTURE_SIZE:Int = 32;

    var size:Int;

    var tileTexture:Tile;
    var tilePixels:Pixels;

    var count:Int = -1;
    var sprites:Array<TileEntry>;

    public function new() {
        sprites = [];

        tilePixels = Pixels.alloc(TEXTURE_SIZE * Tobor.TILE_W, TEXTURE_SIZE * Tobor.TILE_W, hxd.PixelFormat.ARGB);
        tilePixels.clear(0x00000000);
        tileTexture = Tile.fromPixels(tilePixels);
    }

    public function loadSprites(list:FileList) {
        var sprN = createSprite("white", 0);
        var pixN = sprN.getPixels();
        pixN.clear(0xffffffff);
        sprN.setPixels(pixN);

        for (f in list) {
			// trace(f, f.name, f.path);
			var baseName = f.name.split('.')[0];

			var img = new Image(f);
			var imgSize = img.getSize();

			var src = img.getPixels();

			if (imgSize.width % Tobor.TILE_W == 0 && imgSize.height % Tobor.TILE_H == 0) {
				var countX:Int, countY:Int, count:Int;

				countX = Math.floor(imgSize.width / Tobor.TILE_W);
				countY = Math.floor(imgSize.height / Tobor.TILE_H);
				count = countX * countY;

				// trace(count, countX, countY);

				for (i in 0 ... count) {
					var spr = this.createSprite(baseName, i);
					var dst = spr.getPixels();

					var srcX:Int = i % countX;
					var srcY:Int = Math.floor((i - srcX) / countX);

					for (x in 0 ... 16) {
						for (y in 0 ... 12) {
							dst.setPixel(x, y, src.getPixel(srcX * Tobor.TILE_W + x, srcY * Tobor.TILE_H + y));
						}
					}

					spr.setPixels(dst);
				}
			} else {
				trace('Image "${f.name}" has wrong size!');
			}
        }
        
        update();
    }

    public function getFreeIndex():Int {
        count++;
        return count;
    }

    public function getTexture():Tile {
        return tileTexture;
    }

    public function getTiles(name:String, ?list:TileList = null):TileList {
        if (list == null) {
            list = [];
        }

        for (spr in sprites) {
            if (spr.name == name) {
                list.push(spr.getTile());
            }
        }

        return list;
    }

    public function getTile(name:String, ?subIndex:Int = 0):Tile {
        var spr = getSprite(name, subIndex);
        var tile = spr.getTile();

        return tile;
    }

    public function getPixels():Pixels {
        return tilePixels;
    }

    public function createSprite(name:String, subIndex:Int):TileEntry {
        var index:Int = getFreeIndex();
        var dstX:Int = index % TEXTURE_SIZE;
        var dstY:Int = Math.floor((index - dstX) / TEXTURE_SIZE);

        // trace("Creating Sprite:", index, dstX * Tobor.TILE_W, dstY * Tobor.TILE_H);

        var sprite = new TileEntry(this, name, index, subIndex, dstX * Tobor.TILE_W, dstY * Tobor.TILE_H, Tobor.TILE_W, Tobor.TILE_H);
        sprites.push(sprite);

        return sprite;
    }

    public function getAllSprites(name:String):Array<TileEntry> {
        var arr:Array<TileEntry> = [];

        for (spr in sprites) {
            if (spr.name == name) {
                arr.push(spr);
            }
        }

        return arr;
    }

    public function getSprite(name:String, ?subIndex:Int = 0):TileEntry {
        if (name == null) {
            return null;
        } else {
            var sprite:TileEntry = null;

            for (spr in getAllSprites(name)) {
                if (spr.subId == subIndex) return spr;
            }
            
            if (sprite == null) {
                trace('Kein Sprite "${name}#${subIndex}" im Tileset gefunden!');
            }

            return sprite;
        }
    }

    public function update() {
        tileTexture.getTexture().uploadPixels(tilePixels);
    }

    public function savePNG(fileName:String) {
        var file = File.write(fileName, true);
        file.write(tilePixels.toPNG());
        file.close();
    }
}
package screens;

import h2d.Bitmap;
import h2d.Text;
import ui.Frame;
import h2d.TileGroup;

class EpisodesScreen extends Screen {
    var listEpisodes:FileList;

    var tilesBackground:TileList;
    var batch:TileGroup;

    var boxTitle = {
        x: 12,
        y: 1,
        w: 16,
        h: 6
    }

    var boxList = {
        x: 2,
        y: 9,
        w: 36,
        h: 16
    }

    var boxCredits = {
        x: 1,
        y: 27,
        w: 38,
        h: 1
    }

    var episodes:Array<FilesEpisode>;

    var listTexts = [];
    var selected:Int = 0;

    var scrollingText:String = "Danke an TOM Productions für ihre tollen Robot Spiele! ";
    var scrollTxt:Text;
    var scrollTimeLeft:Float;
    var scrollSpeed:Float = 0.25;
    var scrollIndex:Int = 0;

    var shadowText = {dx: 1.0, dy: 1.0, color:Color.BLACK, alpha: 0.25};

    override function init() {
        // Tileset zurücksetzen
        Gfx.gameTileset = null;

        tilesBackground = Gfx.tileset.getTiles("wood");

        batch = new TileGroup(Gfx.tileset.getTexture(), this);

        for (_x in 0 ... Const.ROOM_W) {
            for (_y in 0 ... Const.ROOM_H + 1) {
                batch.add(_x * Const.TILE_W, _y * Const.TILE_H, tilesBackground[5 + Std.random(5)]);
            }
        }

        var frameTitle = new Frame(boxTitle.x * Const.TILE_W, boxTitle.y * Const.TILE_H, boxTitle.w, boxTitle.h, "wall_black", this, true);

        var textTitle = new Text(Gfx.fontNormal, this);
        textTitle.text = "The world of";
        textTitle.color = Color.BLACK.getVector3();
        textTitle.dropShadow = shadowText;
        textTitle.textAlign = Align.Center;
        textTitle.scaleX = 2;
        textTitle.y = (boxTitle.y + 1) * Const.TILE_H + 5; // 4
        textTitle.x = Const.CENTER_X;

        var chars = Gfx.baseTileset.getTiles("tobor");
        var batchTitle = new TileGroup(Gfx.tileset.getTexture(), this);
        batchTitle.y = (boxTitle.y + 2) * Const.TILE_H;

        var cx:Int = 0;
        var cy:Int = 6;

        // T

        batchTitle.add(
            (cx + 0), 
            (cy + 0), chars[0]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + 0), chars[1]
        );
        batchTitle.add(
            (cx + 0), 
            (cy + Const.TILE_H), chars[10]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + Const.TILE_H), chars[11]
        );
        
        cx = cx + 2 * Const.TILE_W;

        // O

        batchTitle.add(
            (cx + 0), 
            (cy + 0), chars[2]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + 0), chars[3]
        );
        batchTitle.add(
            (cx + 0), 
            (cy + Const.TILE_H), chars[12]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + Const.TILE_H), chars[13]
        );

        cx = cx + 2 * Const.TILE_W;

        // B

        batchTitle.add(
            (cx + 0), 
            (cy + 0), chars[4]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + 0), chars[5]
        );
        batchTitle.add(
            (cx + 0), 
            (cy + Const.TILE_H), chars[14]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + Const.TILE_H), chars[15]
        );

        cx = cx + 2 * Const.TILE_W;

        // O

        batchTitle.add(
            (cx + 0), 
            (cy + 0), chars[2]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + 0), chars[3]
        );
        batchTitle.add(
            (cx + 0), 
            (cy + Const.TILE_H), chars[12]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + Const.TILE_H), chars[13]
        );

        cx = cx + 2 * Const.TILE_W;

        // R

        batchTitle.add(
            (cx + 0), 
            (cy + 0), chars[6]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + 0), chars[7]
        );
        batchTitle.add(
            (cx + 0), 
            (cy + Const.TILE_H), chars[16]
        );
        batchTitle.add(
            (cx + Const.TILE_W), 
            (cy + Const.TILE_H), chars[17]
        );

        batchTitle.x = Const.CENTER_X - batchTitle.getBounds().width / 2;

        var frameList = new Frame(boxList.x * Const.TILE_W, boxList.y * Const.TILE_H, boxList.w, boxList.h, "frame_big", this);
        
        var bgSelected = new Bitmap(Gfx.getWhitePixel((boxList.w - 2) * Const.TILE_W, 2 * Const.TILE_H), frameList);
        bgSelected.x = Const.TILE_W;
        bgSelected.y = Const.TILE_H + 3 * 2 * Const.TILE_H;
        bgSelected.color = Color.ORANGE.getVector3();

        for (i in 0 ... 7) {
            var lt = new Text(Gfx.fontNormal, frameList);
            // listText_0.text = gameList[i].filename;
            lt.color = Color.BLACK.getVector3();
            lt.textAlign = Align.Center;
            // listText_0.scaleX = 2;
            lt.dropShadow = shadowText;
            lt.y = Const.TILE_H + i * Const.TILE_H * 2 + 2 + Const.TILE_H / 2;
            lt.x = Math.floor(boxList.w * Const.TILE_W / 2);

            listTexts.push(lt);

            /*
            if (gameList[i].autor != "") {
                var listText_1 = new Text(Gfx.fontNormal, frameList);
                listText_1.text = "von " + gameList[i].autor;
                listText_1.color = Color.BLACK.getVector3();
                listText_1.dropShadow = shadowText;
                listText_1.textAlign = Align.Center;
                listText_1.x = Math.floor(boxList.w * Const.TILE_W / 2);
                listText_1.y = Const.TILE_H * 2 + i * Const.TILE_H * 2 + 2;
            }
            */
        }

        updateFileList();
        refreshList();

        // Credits
        var creditsBackground = Gfx.getWhitePixel(boxCredits.w * Const.TILE_W, boxCredits.h * Const.TILE_H);
        batch.addColor(
            boxCredits.x * Const.TILE_W, boxCredits.y * Const.TILE_H, 
            Color.ORANGE.r, Color.ORANGE.g, Color.ORANGE.b, Color.ORANGE.a, 
            creditsBackground
        );

        scrollingText = StringTools.rpad(scrollingText, " ", 38 * 2);
        scrollingText = scrollingText + scrollingText;

        scrollTxt = new Text(Gfx.fontNormal, this);
        scrollTxt.text = scrollingText.substr(0, 38 * 2);
        scrollTxt.x = boxCredits.x * Const.TILE_W;
        scrollTxt.y = boxCredits.y * Const.TILE_H + 2;
        scrollTxt.textColor = Color.DARK_RED;
        scrollTxt.dropShadow = {dx: 1.0, dy: 1.0, color:Color.DARK_RED, alpha: 0.5};

        // alle verfügbaren Episoden sammeln
        listEpisodes = Files.getGameList();
    }

    function updateFileList() {
        episodes = [];

        var files = Files.getGameList();

        for (f in files) {
            trace(f, f.isDirectory, f.extension.toLowerCase() == "zip");

            if (f.isDirectory || f.extension.toLowerCase() == "zip") {
                var ep = new FilesEpisode(f);
                if (ep.isOK) {
                    episodes.push(ep);
                }
            }
        }

        episodes.sort(function (ep0, ep1) {
            if (ep0.name < ep1.name) return -1;
            if (ep0.name > ep1.name) return 1;
            return 0;
        });

        episodes.push(new FilesEpisode(null));
    }

    function refreshList() {
        if (episodes.length == 0) return;

        var alphaList = [1, 0.8, 0.7, 0.6, 0.5];

        for (i in 1 ... 4) {
            if (selected - i >= 0) {
                listTexts[3 - i].text = episodes[selected - i].name;
                listTexts[3 - i].color.a = alphaList[i + 1];
            } else {
                listTexts[3 - i].text = "";
            }
        }

        listTexts[3].text = episodes[selected].name;

        for (i in 1 ... 4) {
            if (selected + i < episodes.length) {
                listTexts[3 + i].text = episodes[selected + i].name;
                listTexts[3 + i].color.a = alphaList[i + 1];
            } else {
                listTexts[3 + i].text = "";
            }
        }
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
    }

    override function onKeyDown(keyCode:Int, charCode:Int):Bool {
        if (Input.isKeyDown(keyCode, Input.KEY_UP)) {
            selected--;
            if (selected < 0) selected = 0;
            refreshList();
            return true;
        } else if (Input.isKeyDown(keyCode, Input.KEY_DOWN)) {
            selected++;
            if (selected >= episodes.length) {
                selected = episodes.length - 1;
            }
            refreshList();
            return true;
        } else if (Input.isKeyDown(keyCode, Input.KEY_ENTER)) {
            chooseEpisode();
            return true;
        }

        return super.onKeyDown(keyCode, charCode);
    }

    override function onWheel() {
        if (Input.mouseWheelUp) {
            selected--;
            if (selected < 0) selected = 0;
            refreshList();
        } else if (Input.mouseWheelDown) {
            selected++;
            if (selected >= episodes.length) {
                selected = episodes.length - 1;
            }
            refreshList();
        }
    }

    function chooseEpisode() {
        if (episodes[selected].isEditor) {
            trace("Neue Episode erstellen");
        } else {
            // trace(episodes[selected].name);
            Tobor.world = new World(episodes[selected]);
            app.setScreen(new IntroScreen(app));
        }
    }
}
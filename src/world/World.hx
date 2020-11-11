package world;

import sys.thread.Thread;
import haxe.Json;
import tjson.TJSON;

class World {
    var file:FilesEpisode;

    var rooms:RoomList;

    public var highscore:Highscore;

    public function new(file:FilesEpisode) {
        this.file = file;

        rooms = new RoomList();

        highscore = new Highscore();
        highscore.init();
    }

    public function getName():String {
        // .ZIP Endung entfernen falls vorhanden
        if (StringTools.endsWith(file.name.toLowerCase(), ".zip")) {
            return file.name.substring(0, file.name.length - 4);
        }

        return file.name;
    }

    public function getDesc():String {
        return file.desc;
    }

    public function load(?fileName:String = null) {
        if (fileName == null) {
            // Episode laden
            loadFromData();
        } else {
            // Spielstand laden
            loadFromSavegame(fileName);
        }
    }

    function loadFromData() {
        var content = file.load("rooms.json");
        if (content == null) {
            trace("Fehler beim Laden von " + file.name + "!");
            return;
        }

        var data = Json.parse(content);
        // trace(data);
        // trace(Reflect.fields(data), Reflect.fields(data).length);

        trace(Reflect.fields(data).length);
        
        for (k in Reflect.fields(data)) {
            var v = Reflect.field(data, k);
            parseKey(k, v);
        }

        /*
        for (r in rooms) {
            trace(r.position.id);
        }
        */
    }

    function parseKey(key, value) {
        if (StringTools.startsWith(key, "ROOM_")) {
            parseRoom(value);
        } else {
            trace(key, value);
        }
    }

    function parseRoom(data) {
        var rx:Int = 0, ry:Int = 0, rz:Int = 0;
        var rdata:Array<Dynamic> = null;

        for (key in Reflect.fields(data)) {
            switch(key) {
                case "x":
                    rx = Reflect.field(data, key);
                case "y":
                    ry = Reflect.field(data, key);
                case "z":
                    rz = Reflect.field(data, key);
                case "data":
                    rdata = Reflect.field(data, key);
            }
        }

        var newRoom = new Room(this, rx, ry, rz);
        newRoom.load(rdata);
        trace(rx, ry, rz, rdata.length);
        rooms.add(newRoom);
    }

    function loadFromSavegame(fileName:String) {

    }
}
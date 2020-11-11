import tjson.TJSON;
import haxe.Json;
import haxe.io.Bytes;
import fs.ZipFileSystem;
import hxd.fs.LocalFileSystem;
import hxd.fs.FileSystem;
import hxd.fs.FileEntry;

class FilesEpisode {
    public var name(get, default):String = "";
    public var desc:String = "";

    public var isZIP:Bool = false;
    public var isEmpty:Bool = false;
    public var isOK:Bool = false;

    public var isEditor:Bool = false;

    var fs:FileSystem;

    public function new(file:FileEntry) {
        if (file == null) {
            isEditor = true;
            return;
        }

        init(file);
    }

    function init(file:FileEntry) {
        // trace(file.path, file.name, file.directory);

        if (file.isDirectory) {
            fs = new LocalFileSystem(Files.instance.directoryGames + "/" + file.path, "");
        } else if (file.extension.toLowerCase() == "zip") {
            isZIP = true;
            fs = new ZipFileSystem(file.getBytes());
        }

        if (fs == null) return;

        desc = load("info." + Tobor.defaultLocale);

        if (desc != null) {
            if (fs.exists("rooms.json")) {
                name = StringTools.replace(file.name, "_", " ");
                isOK = true;
            }
        }
    }

    inline function get_name():String {
        if (isEditor) return "TXT_CREATE_NEW_ADVENTURE";

        return name;
    }

    public function load(fileName):String {
        var fe:FileEntry = null;

        try {
            fe = fs.get(fileName);
        } catch (e) {
            trace(e, fs);

            for (en in fs.dir("/")) {
                trace(en);
            }

            return null;
        }

        return fe.getText();
    }

    public function loadBytes(fileName):Bytes {
        var fe:FileEntry = null;

        try {
            fe = fs.get(fileName);
        } catch (e) {
            trace(e, fs);

            for (en in fs.dir("/")) {
                trace(en);
            }

            return null;
        }

        return fe.getBytes();
    }
}
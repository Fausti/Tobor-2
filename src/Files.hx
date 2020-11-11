import hxd.res.Embed;
import hxd.fs.EmbedFileSystem;
import hxd.Res;
import hxd.fs.FileSystem;
import fs.ZipFileSystem;
import hxd.fs.LocalFileSystem;
import haxe.io.Path;
import hxd.fs.FileEntry;

typedef FileList = Map<String, FileEntry>;

class Files {
    public var directoryUser:String;
    public var directoryHome:String;
    public var directoryGames:String;
    public var directorySaves:String;
    public var directoryMods:String;

    // global
    var fsEmbed:hxd.fs.FileSystem;
    var fsMods:hxd.fs.FileSystem;
    var fsGame:hxd.fs.FileSystem;

    // alle Episoden
    var fsGameList:hxd.fs.FileSystem;

    public function new() {
        var home = Sys.getEnv(if (Sys.systemName() == "Windows") "UserProfile" else "HOME");
        directoryUser = home;

        directoryHome = Path.join([home, Const.APP_NAME]);

        directoryGames = Path.join([directoryHome, "games"]);
        directorySaves = Path.join([directoryHome, "saves"]);
        directoryMods = Path.join([directoryHome, "mods"]);

        initDirs();

        // eingebettete Dateien
        fsEmbed = Res.loader.fs;

        // Mods im Benutzerverzeichnis
        fsMods = new LocalFileSystem(directoryMods, null);
    }

    function initDirs() {
        if (sys.FileSystem.exists(directoryUser)) {
            sys.FileSystem.createDirectory(directoryHome);
            sys.FileSystem.createDirectory(directoryGames);
            sys.FileSystem.createDirectory(directorySaves);
            sys.FileSystem.createDirectory(directoryMods);
        } else {
            trace('Could not find os user directory: ${directoryUser}');
        }
    }

    public function openGame(path:String) {
        var fs:FileSystem;

        try {
            fs = new LocalFileSystem(directoryGames, null);
        } catch (e) {
            trace(e);
            return;
        }

        var fe:FileEntry;
        try {
            fe = fs.get(path);
        } catch (e) {
            trace(e);
            return;
        }

        if (fe.isDirectory) {
            fsGame = new LocalFileSystem(directoryGames + "/" + path, null);
            return;
        }

        if (fe.extension.toLowerCase() == "zip") {
            fsGame = new ZipFileSystem(fe.getBytes());
        }
    }

    public function closeGame() {
        fsGame = null;
    }

    public static function getAssetList(path:String, ext:String, ?includeDirs:Bool = false):FileList {
        var list = new FileList();

        Files.instance.searchFiles(list, Files.instance.fsEmbed, path, ext, includeDirs);
        Files.instance.searchFiles(list, Files.instance.fsGame, path, ext, includeDirs);
        Files.instance.searchFiles(list, Files.instance.fsMods, path, ext, includeDirs);

        return list;
    }

    public static function getGameList():FileList {
        var list = new FileList();

        Files.instance.fsGameList = new LocalFileSystem(instance.directoryGames, null);

        Files.instance.searchFiles(list, Files.instance.fsGameList, "", "zip", true);

        return list;
    }

    function searchFiles(list:FileList, fs:FileSystem, path:String, ext:String, ?includeDirs:Bool = false):FileList {
        if (fs == null) return list;

        var fe:FileEntry = null;

        if (Std.isOfType(fs, EmbedFileSystem)) {
            try {
                fe = fs.get(path);
            } catch (e) {
                trace(fs, e);
                return list;
            }
        } else {
            if (path == null) {
                try {
                    fe = fs.getRoot();
                } catch (e) {
                    trace(fs, e);
                    return list;
                }
            } else {
                try {
                    fe = fs.get(path);
                } catch (e) {
                    trace(fs, e);
                    return list;
                }
            }
        }

        for (f in fe) {
            if (!f.isDirectory) {
                if (ext == null || ext == "") {
                    list.set(f.name, f);
                } else {
                    if (f.extension.toLowerCase() == ext.toLowerCase()) {
                        list.set(f.name, f);
                    }
                }
            } else {
                if (includeDirs) {
                    list.set(f.name, f);
                }
            }
        }

        return list;
    }

    public static var instance:Files;

    public static function init() {
        Files.instance = new Files();
    }
}
import haxe.io.Path;
import fs.ZipFileSystem;
import hxd.fs.FileEntry;
import hxd.fs.LocalFileSystem;
import hxd.fs.FileSystem;
import hxd.Res;

typedef FileList = Map<String, FileEntry>;

class Assets {
    public var directoryUser:String;
    public var directoryHome:String;
    public var directoryGames:String;
    public var directorySaves:String;
    public var directoryMods:String;

    var fsEmbed:hxd.fs.FileSystem;
    var fsMods:hxd.fs.FileSystem;
    var fsGame:hxd.fs.FileSystem;

    public function new(?gameName:String = null) {
        // Spielverzeichnis im Benutzerverzeichnis
        var home = Sys.getEnv(if (Sys.systemName() == "Windows") "UserProfile" else "HOME");
        directoryUser = home;

        directoryHome = Path.join([home, Config.appName]);

        directoryGames = Path.join([directoryHome, "games"]);
        directorySaves = Path.join([directoryHome, "saves"]);
        directoryMods = Path.join([directoryHome, "mods"]);

        initDirs();

        // eingebettete Dateien
        fsEmbed = Res.loader.fs;

        // Mods im Benutzerverzeichnis
        fsMods = new LocalFileSystem(directoryMods, null);

        // Episodendateien
        if (gameName != null) {
            openGame(Path.join([directoryGames, gameName]));
        }
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

    public function getFileList(path:String, ext:String, ?includeDirs:Bool = false):FileList {
        var list = new FileList();

        searchFiles(list, fsEmbed, path, ext, includeDirs);
        searchFiles(list, fsGame, path, ext, includeDirs);
        searchFiles(list, fsMods, path, ext, includeDirs);

        return list;
    }

    function searchFiles(list:FileList, fs:FileSystem, path:String, ext:String, ?includeDirs:Bool = false):FileList {
        if (fs == null) return list;

        var fe:FileEntry;

        try {
            fe = fs.get(path);
        } catch (e) {
            trace(fs, e);
            return list;
        }

        for (f in fe) {
            if (!f.isDirectory) {
                if (ext == null) {
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
}
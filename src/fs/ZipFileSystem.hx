package fs;

import hxd.impl.ArrayIterator;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.io.Bytes;
import hxd.fs.FileEntry;
import hxd.fs.FileSystem;

@:allow(ZipFileSystem)
@:access(ZipFileSystem)
class ZipFileEntry extends FileEntry {
    var fileSystem:ZipFileSystem;
    var entry:Entry;
    var pos:Int;

    public function new(fileSystem:ZipFileSystem, entry:Entry) {
        this.fileSystem = fileSystem;
        this.entry = entry;

        if (entry != null) {
            var p = entry.fileName.split('/');
            this.name = p[p.length - 1];
        } else {
            this.name = "root";
        }
    }

    override function getBytes():Bytes {
        return entry.data;
    }

    override function open() {
        pos = 0;
    }

    override function skip(nbytes:Int) {
        pos += nbytes;
    }

    override function readByte():Int {
        return entry.data.get(pos++);
    }

    override function read(out:Bytes, pos:Int, size:Int) {
        out.blit(pos, entry.data, this.pos, size);
    }

    override function close() {
        super.close();
    }

    override function iterator():ArrayIterator<FileEntry> {
        return new hxd.impl.ArrayIterator<FileEntry>(cast fileSystem.list);
    }

    override function get_isDirectory():Bool {
        return (entry.fileSize == 0);
    }

	override function get_size():Int {
        return entry.fileSize;
    }
    
    override function get_path() : String { 
        return entry.fileName;
    }

    override function get_directory():String {
        var p = entry.fileName.split('/');
        p.pop();
        return p.join('/');
    }

    override function get_extension():String {
        var np = entry.fileName.split('.');
        return np.length == 1 ? "" : np.pop().toLowerCase();
    }
}

@:allow(ZipFileEntry)
@:access(ZipFileEntry)
class ZipFileSystem implements FileSystem {
    var data:Bytes;
    var reader:Reader;

    var root:ZipFileEntry;
    public var list:Array<ZipFileEntry> = [];

    public function new(data:Bytes) {
        this.data = data;

        root = new ZipFileEntry(this, null);

        var entries = Reader.readZip(new haxe.io.BytesInput(data));
        for (e in entries) {
            var fileName = e.fileName;
            if (StringTools.endsWith(fileName, '/')) {
                fileName = fileName.substr(0, fileName.length - 1);
            }

            e.fileName = fileName;
            list.push(new ZipFileEntry(this, e));
            // trace(e);
        }

        /*
        trace("*DICT*");
        for (t in list) {
            trace(t, t.name, t.path, t.directory);
        }
        */
    }

    public function getRoot() : FileEntry {
        return root;
    }

	public function get(path : String) : FileEntry {
        for (e in list) {
            if (StringTools.endsWith(e.path, path)) {
                return e;
            }
        }

        return null;
    }

	public function exists( path : String ) : Bool {
        return false;
    }

	public function dispose() : Void {

    }

	public function dir( path : String ) : Array<FileEntry> {
        return [];
    }
}
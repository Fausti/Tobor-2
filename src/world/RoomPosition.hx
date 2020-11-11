package world;

class RoomPosition {
    public var id(get, null):String;

    var x:Int;
    var y:Int;
    var z:Int;

    public function new(?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    inline function get_id():String {
        return Std.string(x) + Std.string(y) + Std.string(z);
    }

    public inline function toString():String {
        return get_id();
    }
}
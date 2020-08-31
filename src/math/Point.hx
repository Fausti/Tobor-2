package math;

class Point {
    public var x:Float;
    public var y:Float;

    public function new(?x:Float = 0, ?y:Float = 0) {
        set(x, y);
    }

    public inline function set(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public inline function add(v:Point):Point {
        set(this.x + v.x, this.y = this.y + v.y);
        return this;
    }

    public inline function mul(v:Point):Point {
        return new Point(this.x * v.x, this.y * v.y);
    }

    public inline function scale(v:Float):Point {
        return new Point(this.x * v, this.y * v);
    }

    public inline function round() {
        this.x = Math.fround(this.x);
        this.y = Math.fround(this.y);
    }

    public inline function clone():Point {
        return new Point(this.x, this.y);
    }
}
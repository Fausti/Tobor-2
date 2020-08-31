package math;

class Rectangle {
    public var position:Point = new Point();

    public var x(get, set):Float;
    inline function get_x():Float { return position.x; }
    inline function set_x(v:Float) { position.x = v; return position.x; }
    public var y(get, set):Float;
    inline function get_y():Float { return position.y; }
    inline function set_y(v:Float) { position.y = v; return position.y; }
    
    public var width:Float;
    public var height:Float;

    public var ix(get, null):Int;
    inline function get_ix():Int { return Math.floor(x); }
    public var iy(get, null):Int;
    inline function get_iy():Int { return Math.floor(y); }
    public var iw(get, null):Int;
    inline function get_iw():Int { return Math.floor(width); }
    public var ih(get, null):Int;
    inline function get_ih():Int { return Math.floor(height); }

    public var top(get, set):Float;
    inline function get_top():Float { return y; }
	inline function set_top(v:Float):Float { y = v; return y; }
	public var bottom(get, set):Float;
	inline function get_bottom():Float { return y + height; }
	inline function set_bottom(v:Float):Float {	height = v - y; return v; }
	public var left(get, set):Float;
	inline function get_left():Float { return x; }
    inline function set_left(v:Float):Float { x = v; return v; }
    public var right(get, set):Float;
	inline function get_right():Float { return x + width; }
	inline function set_right(v:Float):Float { width = v - x; return v; }

    public function new(?x:Float = 0, ?y:Float = 0, ?w:Float = 0, ?h:Float = 0, ?pos:Point = null) {
        if (pos == null) {
            this.x = x;
            this.y = y;
        } else {
            this.position = pos;
        }

        this.width = w;
        this.height = h;
    }

    public inline function contains(targetX:Float, targetY:Float):Bool {
        if (targetX >= x && targetX < (x + width) && targetY >= y && targetY < (y + height)) return true;
        return false;
    }

    public inline function intersects(rect:Rectangle):Bool {
        if (rect == null) return false;

        var x0 = x < rect.x ? rect.x : x;
		var x1 = right > rect.right ? rect.right : right;

		if (x1 <= x0)
		{
			return false;
		}

		var y0 = y < rect.y ? rect.y : y;
		var y1 = bottom > rect.bottom ? rect.bottom : bottom;

		return y1 > y0;
    }
}
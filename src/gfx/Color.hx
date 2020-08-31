package gfx;

import h3d.Vector;

/**
 * ARGB color type based on a 32-bit integer.
 */
 abstract Color(Int) from Int to Int {

    public static inline var NONE:Color = 0x00000000;
	
	public static inline var BLACK:Color = 0xff000000;
	
	public static inline var YELLOW:Color = 0xffffff00;
	public static inline var DARK_GREEN:Color = 0xff00a84f;
	public static inline var GRAY:Color = 0xffacacac;
	
	public static inline var PURPLE:Color = 0xffaf00af;
	public static inline var DARK_RED:Color = 0xffaf0000;
	public static inline var RED:Color = 0xffff0000;
	
	public static inline var ORANGE:Color = 0xffffac00;
	public static inline var GREEN:Color = 0xff00ff52;
	public static inline var LIGHT_GREEN:Color = 0xffafffaf;
	
	public static inline var LIGHT_BLUE:Color = 0xff00a8af;
	public static inline var BLUE:Color = 0xff0000ff;
	public static inline var BLUE2:Color = 0xff4f50ff;
	
	public static inline var DARK_BLUE:Color = 0xff00004f;
	public static inline var BROWN:Color = 0xff4f5000;
	public static inline var WHITE:Color = 0xffffffff;
	
    public static inline var DARK_GRAY:Color = 0xff525252;
    public static inline var LIGHT_GRAY:Color = 0xffdddddd;
	
	public static inline var NEON_GREEN:Color = 0xffacff00;
	
	public static final palette:Array<Color> = [
		BLACK, YELLOW, DARK_GREEN, GRAY, PURPLE, DARK_RED, RED, ORANGE,
		GREEN, LIGHT_GREEN, LIGHT_BLUE, BLUE, BLUE2, DARK_BLUE, BROWN, WHITE
	];

	public static function getRandom():Color {
		return palette[Std.random(palette.length - 1)];
	}
    
    /**
     * Performs implicit casting from an ARGB hex string to a color.
     * @param   argb  ARGB hex string
     * @return  Color based on hex string
     */
    @:from public static inline function fromString(argb : String) : Color {
      return new Color(Std.parseInt(argb));
    }
    
    /**
     * Creates a new color from integer color components.
     * @param   a   Alpha channel value
     * @param   r   Red channel value
     * @param   g   Green channel value
     * @param   b   Blue channel value
     * @return  Color based on color components
     */
    public static inline function fromARGBi(a : Int, r : Int, g : Int, b : Int) : Color {
      return new Color((a << 24) | (r << 16) | (g << 8) | b);
    }
    
    /**
     * Creates a new color from floating point color components.
     * @param   a   Alpha channel value
     * @param   r   Red channel value
     * @param   g   Green channel value
     * @param   b   Blue channel value
     * @return  Color based on color components
     */
    public static inline function fromARGBf(a : Float, r : Float, g : Float, b : Float) : Color {
      return fromARGBi(Std.int(a * 255), Std.int(r * 255), Std.int(g * 255), Std.int(b * 255));
    }
    
    /**
     * Constructs a new color.
     * @param   argb  Color formatted as ARGB integer
     */
    inline function new(argb : Int) this = argb;
    
    /**
     * Integer color channel getters and setters.
     */
  
    public var ai(get, set) : Int;
    inline function get_ai() return (this >> 24) & 0xff;
    inline function set_ai(ai : Int) { this = fromARGBi(ai, ri, gi, bi); return ai; }
    
    public var ri(get, set) : Int;
    inline function get_ri() return (this >> 16) & 0xff;
    inline function set_ri(ri : Int) { this = fromARGBi(ai, ri, gi, bi); return ri; }
    
    public var gi(get, set) : Int;
    inline function get_gi() return (this >> 8) & 0xff;
    inline function set_gi(gi : Int) { this = fromARGBi(ai, ri, gi, bi); return gi; }
    
    public var bi(get, set) : Int;
    inline function get_bi() return this & 0xff;
    inline function set_bi(bi : Int) { this = fromARGBi(ai, ri, gi, bi); return bi; }
    
    /**
     * Floating point color channel getters and setters.
     */
  
    public var a(get, set) : Float;
    inline function get_a() return ai / 255;
    inline function set_a(a : Float) { this = fromARGBf(a, r, g, b); return a; }
    
    public var r(get, set) : Float;
    inline function get_r() return ri / 255;
    inline function set_r(r : Float) { this = fromARGBf(a, r, g, b); return r; }
    
    public var g(get, set) : Float;
    inline function get_g() return gi / 255;
    inline function set_g(g : Float) { this = fromARGBf(a, r, g, b); return g; }
    
    public var b(get, set) : Float;
    inline function get_b() return bi / 255;
    inline function set_b(b : Float) { this = fromARGBf(a, r, g, b); return b; }

    public inline function getVector3():Vector {
        return new Vector(r, g, b, a);
    }
  }
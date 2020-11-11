package world;

class Room {
    public var world:World;
    public var position:RoomPosition;

    public function new(world:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
        this.world = world;
        this.position = new RoomPosition(x, y, z);
    }
    
    public function update(deltaTime:Float) {
        
    }

    public function onRoomStart() {

    }

    public function onRoomEnd() {

    }

    public function load(data:Array<Dynamic>) {
        for (entry in data) {
            trace(entry);
        }
    }
}
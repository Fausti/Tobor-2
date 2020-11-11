package world;

class RoomList {
    var list:Map<String, Room>;

    public function new() {
        list = new Map();
    }

    public function iterator():Iterator<Room> {
        return list.iterator();
    }

    public function add(room:Room) {
        if (list.get(room.position.id) != null) {

        }

        list.set(room.position.id, room);
    }

    public function find(x:Int, y:Int, z:Int):Room {
        return list.get(new RoomPosition(x, y, z).id);
    }
}
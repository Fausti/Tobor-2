class Highscore {
    public var scores:Array<HighscoreEntry>;

    public function new() {
        scores = [];
    }

    public function add(name:String, points:Int, rooms:Int) {
        if (points <= 0) return;

        scores.push(new HighscoreEntry(name, points, rooms));

        sort();

        while (scores.length > 10) {
            scores.pop();
        }
    }

    public function sort() {
        scores.sort(function(a, b) {
            if (a.points == b.points) {
                if (a.rooms < b.rooms) {
                    return 1;
                } else if (a.rooms > b.rooms) {
                    return -1;
                } else {
                    return 0;
                }
            } else if (a.points < b.points) {
                return 1;
            } else if (a.points > b.points) {
                return -1;
            }

            return 0;
        });
    }

    public function init() {
        add("Unglaublicher", 400000, 30);
        add("Supermeister", 250000, 18);
        add("Der Meister", 100000, 11);
        add("Der Aufsteiger", 25000, 8);
        add("Der Anfänger", 10000, 4);
    }
}

class HighscoreEntry {
    public var name:String = "";
    public var points:Int = 0;
    public var rooms:Int = 0;

    public function new(name:String, points:Int, rooms:Int) {
        set(name, points, rooms);
    }

    public function set(name:String, points:Int, rooms:Int) {
        this.name = name;
        this.points = points;
        this.rooms = rooms;
    }
}
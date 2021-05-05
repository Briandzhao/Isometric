ArrayList<Event> events = new ArrayList<Event>();
void updateEvents() {
	for (int i = 0 ; i < events.size() ; i ++) {
		Event e = events.get(i);
		e.update();
		if (e.delay <= 0) {
			events.remove(i);
			i --;
		}
	}
}

class TowerDie extends Event {
	Tower tower;

	TowerDie(Tower rect, float ds) {
		super(ds);
		tower = rect;
	}

	void act() {
		tower.die();
	}
}

abstract class Event {
	int delay;

	Event(float ds) {
		delay = (int)ds;
	}

	void update() {
		if (delay > 0) {
			delay --;
		} else {
			act();
		}
	}

	abstract void act();
}
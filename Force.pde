ArrayList<Force> forces = new ArrayList<Force>();
void updateForces() {
	for (int i = 0 ; i < forces.size() ; i ++) {
		Force f = forces.get(i);
		f.update();
		if (f.lifeSpan <= 0) {
			forces.remove(i);
			i --;
		}
	}
}

class PForce extends Force {
	float mass = 2;

	PForce(Point p, float x, float y, float z, float ds, float ls) {
		super(p, x,y,z, ds, ls);
	}

	void act() {
		parent.a.sub((parent.p.x - amp.x)/mass, (parent.p.y - amp.y)/mass, (parent.p.z - amp.z)/mass);
	}
}

class VForce extends Force {
	VForce(Point p, float x, float y, float z, float ds, float ls) {
		super(p, x,y,z, ds, ls);
	}

	void act() {
		parent.P.add(amp.x,amp.y,amp.z);
	}
}

class Force {
	Point parent;
	PVector amp;
	int lifeSpan;
	int delay = 0;

	Force(Point p, float x, float y, float z, float ds, float ls) {
		parent = p;
		amp = new PVector(x,y,z);
		lifeSpan = (int)ls;
		delay = (int)ds;
		forces.add(this);
	}

	void update() {
		if (delay > 0) {
			delay --;
		} else {
			act();
			lifeSpan --;
		}
	}

	void act() {
		parent.a.add(amp.x,amp.y,amp.z);
	}
}
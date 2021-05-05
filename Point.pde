/*
Point represents a point in 3D space with its own mass, velocity, and acceleration

Each Point has a target position that it tries to stay at

I use Point to represent positions, angles, and color values
*/
class Point {
	PVector p = new PVector(0,0,0); // Position
	PVector P = new PVector(0,0,0); // Target position

	PVector m = new PVector(0,0,0); // Pushes this Point along this vector based on sound value
	PVector v = new PVector(0,0,0); // Velocity
	PVector a = new PVector(0,0,0); // Acceleration

	float vMult = defaultVMult; // Drag coefficient
	float mass  = defaultMass;
	int index = -1;
	float[] af = main;

	Point(PVector position, float vMult, float mass) {
		this(position.x, position.y, position.z, vMult, mass);
	}

	Point(PVector position) {
		this(position.x, position.y, position.z);
	}

	Point(float x, float y, float z) {
		p.set(x,y,z);
		P.set(x,y,z);
	}

	Point(float x, float y, float z, float vMult, float mass) {
		this(x,y,z);
		this.vMult = vMult;
		this.mass = mass;
	}

	Point() {
		this(0,0,0);
	}

	void update() {
		// Add a force directed at this Point's target
		a.add((P.x-p.x),(P.y-p.y),(P.z-p.z));

		// If listening to an value on a sound array, add the value to acceleration
		if (index != -1) {
			a.x += m.x * af[index];
			a.y += m.y * af[index];
			a.z += m.z * af[index];
		}
		a.div(mass);

		// Add acceleration to velocity and multiply velocity by vMult
		v.set((v.x+a.x)*vMult, (v.y+a.y)*vMult, (v.z+a.z)*vMult);
		p.add(v);

		a.set(0,0,0);
	}

	// If this is drawn, it's just a white dot
	void render() {
		push();
		stroke(360);
		strokeWeight(3);
		point(p.x,p.y,p.z);
		pop();
	}

	void setIndex(float[] af, float index) {
		this.af = af;
		this.setIndex(index);
	}

	void setIndex(float index) {
		this.index = (int)abs(index%af.length);
	}

	void setIndex(float[] af) {
		this.af = af;
		this.setIndex(index);
	}

	void translates() {
		translate(p.x,p.y,p.z);
	}

	void rotates() {
		rotateX(p.x);
		rotateY(p.y);
		rotateZ(p.z);
	}

	// Treats this Point as a color fill
	void fills(float a) {
		fill(p.x,p.y,p.z,a);
	}

	void fills() {
		fills(100);
	}

	// Treats this point as a color stroke
	void strokes(float a) {
		stroke(p.x,p.y,p.z,a);
	}

	void strokes() {
		strokes(100);
	}

	// Resets/teleports this Point to the position
	void reset(PVector position) {
		reset(position.x, position.y, position.z);
	}

	void reset(float x, float y, float z) {
		reset(x,y,z, x,y,z);
	}

	void reset(float x, float y, float z, float X, float Y, float Z) {
		p.set(x,y,z);
		P.set(X,Y,Z);
		v.set(0,0,0);
	}
}
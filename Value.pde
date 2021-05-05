/*
Value is a 1D version of Point
I use Value to represent single-value characterisitics such as size, stroke thickness, and opacity
*/
class Value extends Entity {
	float x;
	float X;
	float xm = 0;
	float v = 0;
	float a = 0;
	float vMult;
	float mass;
	int index = -1;
	float[] af = main;

	Value(float x, float X, float vMult, float mass) {
		this.x = x;
		this.X = x;
		this.vMult = vMult;
		this.mass = mass;
	}

	Value(float x, float vMult, float mass) {
		this(x,x,vMult,mass);
	}

	Value(float x, float X) {
		this(x,X,defaultVMult,defaultMass);
	}

	Value(float x) {
		this(x,x,defaultVMult, defaultMass);
	}

	Value() {
		this(1,1,defaultVMult, defaultMass);
	}

	void update() {
		a += X - x;
		if (index != -1) a += xm*af[index];
		a /= mass;
		v = (v + a) * vMult;
		x += v;
		a = 0;
	}

	void reset(float x, float X) {
		this.x = x;
		this.X = x;
		this.v = 0;
	}

	void reset(float x) {
		reset(x,x);
	}
}
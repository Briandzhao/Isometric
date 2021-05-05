abstract class Entity {
	int id;
	boolean finished = false; // Sentinel value. If true, remove this object from whatever structure it's in
	boolean alive = true; // Sentinel value for animation purposes. 
	// If false, then this object goes through a "dying" animation before setting finished = true

	boolean draw = true;
	int index = -1; // Index of the sound array that it listens to. -1 means not listening
	float[] af = main; // By default, there is only one sound array
	// Sometimes I experiment with adding more for bass, high notes, etc

	String[] fillType = new String[]{};
	Point fillStyle = new Point();

	void render() {} // How to draw this object to the screen

	abstract void update(); // Separate function for updating fields

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

	void getFill(float x, float y, float z, float ang) {
		fillv.set(0,0,0);
		for (int i = 0 ; i < fillType.length ; i ++) {
			fills(fillType[i], x,y,z,ang);
		}
		fill(fillv.x + fillStyle.p.x, fillv.y + fillStyle.p.y, fillv.z + fillStyle.p.z);
	}
}
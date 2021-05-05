/*
This is a special class that is used to control the point of view of the animation
*/
class Camera {
	Point p;
	Point pv = new Point();
	Point ang;
	Point av = new Point();
	Value z;
	PVector dp;
	PVector dang;
	boolean lock = true;

	Camera(float x, float y, float z, float ax, float ay, float az) {
		this.p = new Point(x, y, z);
		this.dp = this.p.p.copy();
		this.ang = new Point(ax, ay, az);
		this.dang = new PVector(ax, ay, az);
		this.ang.mass = 10;
		this.ang.vMult = 0.5;
		this.z = new Value(-de*2);
	}

	Camera(float x, float y, float z) {
		this(x,y,z,0,0,0);
	}

	void update() {
		// If the camera isn't locked, then let the user pan around with the mouse
		if (!lock) {
			cam.ang.P.y = (float)mouseX/width*2*PI - PI;
			cam.ang.P.x = -(float)mouseY/height*2*PI + PI;
		} else {
			cam.ang.P.add(av.p);
		}
		p.P.add(pv.p);
		p.update();
		pv.update();
		ang.P.add(av.p);
		ang.update();
		av.update();
		z.update();
	}

	// Uses translation and rotation functions to set the point of view
	void render() {
		translate(width/2,height/2,z.x);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
		translate(p.p.x,p.p.y,p.p.z);
	}
}
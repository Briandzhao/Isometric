ArrayList<Rect3> rects = new ArrayList<Rect3>();
int rectID;
void updateRects() {
	for (int i = 0 ; i < rects.size() ; i ++) {
		Rect3 rect = rects.get(i);
		rect.update();
		rect.render();
		if (rect.finished) {
			rects.remove(i);
			i --;
		}
	}
}

class Tower extends Rect3 {
	Tower(float x, float y, float z, float wx, float wy, float wz, float ls) {
		super(x,y,z,wx,wy,wz,ls);
		w.p.set(wx*1.2,wy*.5,wz*1.2);
		w.mass *= map(noise(id*.01),0,1, .5,2);
	}

	void render() {
		if (w.p.y > 2) {
			push();
			p.translates();
			getStroke();
			translate(0,-w.p.y/2,0);
			if (w.p.y < 10) {
				float t = w.p.y/10;
				renderBox(w.p.x*t,w.p.y,w.p.z*t);
			} else {
				renderBox(w.p.x,w.p.y,w.p.z);
			}
			pop();
		}
	}

	void renderBox(float x, float y, float z) {
		x /= 2; y /= 2; z /= 2; // -1,0: 0	0,-1: -HALF_PI	1,0: PI		0,1: HALF_PI
		renderSide(-x,-y,-z, x,-y,-z, x,y,-z, -x,y,-z, -HALF_PI);
		renderSide(-x,-y,z, x,-y,z, x,y,z, -x,y,z, HALF_PI);
		renderSide(-x,-y,-z, x,-y,-z, x,-y,z, -x,-y,z, PI);
		// renderSide(-x,y,-z, x,y,-z, x,y,z, -x,y,z, 0);
		renderSide(-x,-y,-z, -x,y,-z, -x,y,z, -x,-y,z, 0);
		renderSide(x,-y,-z, x,y,-z, x,y,z, x,-y,z, PI);
	}
}

class Floater extends Rect3 {
	boolean fixed = false;
	int axis = 0; // 0 is x, 1 is y, 2 is z

	Floater(float x, float y, float z, float wx, float wy, float wz, float ls) {
		super(x,y,z,wx,wy,wz,ls);
	}

	void render() {
		push();
		p.translates();
		getStroke();
		if (w.p.z > 2) {
			renderBox(w.p.x,w.p.y,w.p.z);
		} else {
			renderRect(w.p.x,w.p.y);
		}
		pop();
	}

	void renderRect(float x, float y) {
		x /= 2; y /= 2;
		switch(axis) {
			case 0:
			renderSide(0,-y,-x, 0,y,-x, 0,y,x, 0,-y,x, 0);
			translate(1,0,0);
			renderSide(0,-y,-x, 0,y,-x, 0,y,x, 0,-y,x, PI);
			break;
			case 1:
			renderSide(-y,0,-x, y,0,-x, y,0,x, -y,0,x, PI);
			translate(0,1,0);
			renderSide(-y,0,-x, y,0,-x, y,0,x, -y,0,x, 0);
			break;
			case 2:
			renderSide(-x,-y,0, x,-y,0, x,y,0, -x,y,0, -HALF_PI);
			translate(0,0,1);
			renderSide(-x,-y,0, x,-y,0, x,y,0, -x,y,0, HALF_PI);
			break;	
		}
	}
}

class Rect3 extends Entity {
	Point p,w;
	Point strokeStyle = new Point(0,0,100);
	Value strokeW = new Value(.25);
	int lifeSpan;
	int dieSpan = 25;
	int id;

	Rect3(float x, float y, float z, float wx, float wy, float wz, float ls) {
		p = new Point(x,y,z);
		w = new Point(wx,wy,wz);
		lifeSpan = (int)ls;
		rects.add(this);
		id = rectID;
		rectID ++;
	}

	void update() {
		p.update();
		w.update();
		fillStyle.update();
		strokeStyle.update();
		strokeW.update();
		if (alive) {
			if (lifeSpan > 0) lifeSpan --;
			if (lifeSpan == 0) die();
		} else {
			dieSpan --;
			if (dieSpan == 0) {
				finished = true;
			}
		}
	}

	void render() {
		push();
		p.translates();
		getFill(p.p.x,p.p.y,p.p.z, 0);
		getStroke();
		renderBox(w.p.x,w.p.y,w.p.z);
		pop();
	}

	void getStroke() {
		if (strokeW.x > .1) {
			strokeWeight(strokeW.x);
			strokeStyle.strokes();
		} else {
			noStroke();
		}
	}

	void renderBox(float x, float y, float z) {
		x /= 2; y /= 2; z /= 2; // -1,0: 0	0,-1: -HALF_PI	1,0: PI		0,1: HALF_PI
		renderSide(-x,-y,-z, x,-y,-z, x,y,-z, -x,y,-z, -HALF_PI);
		renderSide(-x,-y,z, x,-y,z, x,y,z, -x,y,z, HALF_PI);
		renderSide(-x,-y,-z, x,-y,-z, x,-y,z, -x,-y,z, PI);
		renderSide(-x,y,-z, x,y,-z, x,y,z, -x,y,z, 0);
		renderSide(-x,-y,-z, -x,y,-z, -x,y,z, -x,-y,z, 0);
		renderSide(x,-y,-z, x,y,-z, x,y,z, x,-y,z, PI);
	}

	void renderSide(float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3, float x4, float y4, float z4, float ang) {
		beginShape();
		getFill(x1 + p.p.x, y1 + p.p.y, z1 + p.p.z, ang);
		vertex(x1,y1,z1);
		getFill(x2 + p.p.x, y2 + p.p.y, z2 + p.p.z, ang);
		vertex(x2,y2,z2);
		getFill(x3 + p.p.x, y3 + p.p.y, z3 + p.p.z, ang);
		vertex(x3,y3,z3);
		getFill(x4 + p.p.x, y4 + p.p.y, z4 + p.p.z, ang);
		vertex(x4,y4,z4);
		endShape(CLOSE);
	}

	void die() {
		alive = false;
		w.P.set(0,0,0);
	}

	void setIndex(float k) {
		p.setIndex(k);
		w.setIndex(k);
		fillStyle.setIndex(k);
		strokeStyle.setIndex(k);
		strokeW.setIndex(k);
	}
}
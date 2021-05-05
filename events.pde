// SPAWNERS
Tower newTower(int xx, int zz, float wy, float ls) {
	float x = (xx-.5)*gridW;
	float z = (zz-.5)*gridW;
	Tower rect = new Tower(x,0,z, towerW,wy,towerW, ls);
	rect.fillType = towerFill;
	towers.add(rect);
	return rect;
}

Floater newFloater(int xx, float y, int zz, float w, float ls) {
	float x = (xx-.5)*gridW;
	float z = (zz-.5)*gridW;
	Floater rect = new Floater(x,y,z, w,w,0, ls);
	rect.axis = 1;
	rect.fillType = floaterFill;
	floaters.add(rect);
	return rect;
}

Floater newFloater(float x, float y, float z, float wx, float wy, float ls, int a) {
	if (a != 0) {
		z = roundToNearestGrid(z) + random(-2,2);
	} else {
		x = roundToNearestGrid(x) + random(-2,2);
	}
	Floater rect = new Floater(x,y,z, wx,wy,0, ls);
	rect.axis = a;
	rect.fillType = floaterFill;
	floaters.add(rect);
	return rect;
}

Floater newFloater(Rect3 rect, float y, float ls, int a) {
	return newFloater(rect.p.p.x,y,rect.p.p.z, rect.w.p.x, rect.w.p.z, ls, a);
}

Tower newBeam(Rect3 tower, float ls) {
	Tower rect = new Tower(tower.p.p.x,0,tower.p.p.z, tower.w.p.x,0,tower.w.p.z, ls);
	rect.w.P.set(0,gridWY*3,0);
	rect.w.mass = 2;
	rect.p.P.add(0,-gridWY*3,0);
	rect.p.mass = 12;
	beams.add(rect);
	return rect;
}

void spawnFloaters(float threshold, float num) {
	for (int i = 0 ; i < towers.size() ; i ++) {
		Rect3 rect = towers.get(i);
		if (main[(int)(i+tRate)%main.length] > threshold) {
			spawnFloaters(rect,num);
		}
	}
}

void spawnFloaters(Rect3 rect, float num) {
	for (int k = 0 ; k < num ; k ++) {
		Floater floater = newFloater(rect,rect.p.p.y-random(rect.w.p.y), random(35,65),(int)random(3));
		if (floater.axis != 1) floater.w.P.y = towerW*.33;
	}
}

void towerWaveEffect2(String source, String target, String which, float r, float g, float b) {
	Point p,t;
	float d = 0;
	for (Tower rect : towers) {
		switch (source) {
			case "p":
			p = rect.p;
			break;
			default:
			p = rect.p;
			break;
		}
		switch (target) {
			case "p":
			t = rect.p;
			break;
			case "w":
			t = rect.w;
			break;
			case "fillStyle":
			t = rect.fillStyle;
			break;
			default:
			t = rect.fillStyle;
		}
		switch(which) {
			case "circle":
			d = sin(tRate*.01 + dist(p.p.x,p.p.z, -cam.p.p.x,-cam.p.p.z)/de*4);
			break;
			case "diamond":
			d = sin(tRate*.01 + (abs(rect.p.p.x) + abs(rect.p.p.z))/de*4);
			break;
			case "x":
			d = sin(tRate*.01 - abs(p.p.x)/de*4);
			break;
			case "z":
			d = sin(tRate*.01 + p.p.z/de*4);
			break;
		}
		t.v.add(d*r,d*g,d*b);
	}
}

void towerWaveEffect(String point, String which, float r, float g, float b, float ds, float ls) {
	float d = 0;
	Point p;
	for (Tower rect : towers) {
		switch (point) {
			case "p":
			p = rect.p;
			break;
			case "w":
			p = rect.w;
			break;
			case "fillStyle":
			p = rect.fillStyle;
			break;
			default:
			p = rect.fillStyle;
		}
		switch(which) {
			case "circle":
			d = dist(rect.p.p.x,rect.p.p.z, cx*gridW,cz*gridW);
			break;
			case "diamond":
			d = abs(rect.p.p.x-cx*gridW) + abs(rect.p.p.z-cz*gridW);
			break;
			case "x":
			d = abs(rect.p.p.x - cx*gridW);
			break;
			case "z":
			d = abs(rect.p.p.z - cz*gridW);
			break;
		}
		forces.add(new Force(p, r,g,b, d*ds,ls));
	}
}

void effectFloaters(String which, float amp) {
	switch(which) {
		case "up":
		for (int i = 0 ; i < floaters.size() ; i ++) {
			Floater rect = floaters.get(i);
			if (rect.fixed) continue;
			int index = (int)(rect.id*.1 + tRate*.1)%main.length;
			rect.p.P.y -= main[index]*amp + de*.0035;
		}
		break;
		case "sine":
		for (int i = 0 ; i < floaters.size() ; i ++) {
			Floater rect = floaters.get(i);
			if (rect.fixed) continue;
			if (rect.axis != 0) {
				rect.p.P.x += sin(tRate*.01 + rect.id*.05) * amp;
			} else {
				rect.p.P.z += sin(tRate*.01 + rect.id*.05) * amp;
			}
		}
		break;
		case "squish":
		float ax,ay;
		for (Floater rect : floaters) {
			if (rect.fixed) continue;
			if (rect.axis == 0) {
				rect.w.v.x += abs(rect.p.v.z)*amp;
				rect.w.v.y -= abs(rect.p.v.z)*amp;
			} else {
				rect.w.v.x += abs(rect.p.v.x)*amp;
				rect.w.v.y -= abs(rect.p.v.x)*amp;
			}
			rect.w.v.x -= abs(rect.p.v.y)*amp;
			rect.w.v.y += abs(rect.p.v.y)*amp;
		}
		break;
	}
}

float roundToNearestGrid(float x) {
	float x2;
	if (x > 0) {
		x2 = x - x%gridW;
	} else {
		x2 = -(-x - (-x)%gridW);
	}
	if (abs(x2 - x) < (abs(x2 + gridW - x))) {
		return x2;
	}
	return x2 + gridW;
}

void drawGrid() {
	float camx = roundToNearestGrid(cam.p.p.x);
	float camz = roundToNearestGrid(cam.p.p.z);
	// fill(105,20,40);
	fill(0);
	push();
	translate(-camx,0,-camz);
	rotateX(-HALF_PI);
	rect(0,0,de*25,de*25);
	pop();
	push();
	translate(-camx,0,-camz);
	strokeWeight(.25);
	stroke(360);
	int grX = (int)(de*20/gridW);
	int grZ = (int)(de*20/gridW);
	for (int i = 0 ; i < grX ; i ++) {
		line((i-grX/2)*gridW,0,-gridW*grZ/2, (i-grX/2)*gridW,0,gridW*grZ/2);
	}
	for (int i = 0 ; i < grZ ; i ++) {
		line(-gridW*grX/2,0,(i-grZ/2)*gridW, gridW*grX/2,0,(i-grZ/2)*gridW);
	}
	pop();
}
boolean record = 1 == 1;

float gridW, gridWX, gridWY, gridWZ;
int gridX, gridZ;
float towerW; // fraction of gridW that rects take up
float floaterW; // floatW

int cx, cz; // current x,y,z

ArrayList<Tower> towers = new ArrayList<Tower>();
ArrayList<Floater> floaters = new ArrayList<Floater>();
ArrayList<Tower> beams = new ArrayList<Tower>();

int noteTick = 0;

void setGrid(int x, float y, int z, float w, float rw) {
	gridW = w;
	towerW = rw * w;
	gridX = x;
	gridZ = z;
	gridWX = gridW*gridX;
	gridWZ = gridW*gridZ;
	gridWY = gridW*y;
}

void setupSketch() {
	lines = loadStrings("isometric.txt");
	addNotes();

	// backFill = new Point(197,43,92);
	backFill = new Point(0,0,100);

	cam.z.reset(0);
	cam.ang.reset(-.3,0,0);
	cam.p.mass = 11;
	cam.z.mass = 32;
	cam.ang.mass = 100;

	cx = 0; cz = 0;

	setGrid(4,4,4, de*.12, .66);
	floaterW = towerW;

	seekTo(0);
}

void sequence() {
	for (int i = 0 ; i < towers.size() ; i ++) if (towers.get(i).finished) towers.remove(i);
	for (int i = 0 ; i < floaters.size() ; i ++) if (floaters.get(i).finished) floaters.remove(i);
	for (int i = 0 ; i < beams.size() ; i ++) if (beams.get(i).finished) beams.remove(i);
	updateForces();
	updateEvents();
	updateRects();
	drawGrid();

	if (notes.containsKey(frameCount)) {
		for (int i = 0 ; i < min(gridX*2,towers.size()) ; i ++) {
			int index = (int)(noise(noteTick,tRate*.003,i*.003)*towers.size() + i*gridX)%towers.size();
			Tower rect = towers.get(index);
			// rect.fillStyle.v.set(0,-500,1000);
			forces.add(new Force(rect.fillStyle,0,-25,100,0,30));
			rect.w.v.y += gridWY*2;
			spawnFloaters(rect,3);

			// newBeam(rect,120);
		}

		for (int i = -gridX/2+1 ; i < gridX/2+1 ; i ++) {
			Tower rect = newTower(cx + i,cz, random(.5,1)*gridWY, 360);
			// rect.fillStyle.v.set(0,-500,1000);
			forces.add(new Force(rect.fillStyle,0,-25,100,0,30));
		}

		cz ++;
		cam.p.P.z = -cz*gridW;
		noteTick = (noteTick+1) % 4;
	}

	if (notes2.containsKey(frameCount)) {
		for (Tower rect : towers) {
			float d = noise(100+rect.p.p.x*.01,100+rect.p.p.z*.01,tRate*.1 + rect.id*.01);
			forces.add(new Force(rect.w,0,towerW*3,0, d*35,5));
			forces.add(new Force(rect.fillStyle, 0,-11,44, d*30,5));
		}
	}

	for (int i = 0 ; i < floaters.size()*.25 ; i ++) {
		if (floaters.get(i).alive) floaters.get(i).die();
	}

	if (frameCount < 299) {

	} else if (frameCount < 2129) {
		effectFloaters("up", .25);
		if (frameCount == 299) {
			cam.z.X = -de*.75;
		}
		if (frameCount == 580) {
			gridX = 6;
			cam.z.X -= de*.25;
		}
		if (frameCount == 840) {
			gridX = 8;
			cam.z.X -= de*.1;
			cam.ang.P.x -= .2;
		}
		if (frameCount == 1316) {
			gridX = 14;
			cam.z.X -= de*.05;
			cam.ang.P.x -= .2;
		}
		if (frameCount == 1534) {
			gridX = 22;
		}
	} else if (frameCount < 3484) {
		effectFloaters("up", .5);
		if (frameCount > 2129 && frameCount < 2311) {
			towerWaveEffect2("p","w","circle",0,gridWY*.5,0);
		} else if (frameCount < 2486) {
			towerWaveEffect2("p","w","x",0,gridWY*.5,0);
		} else if (frameCount < 2651) {
			towerWaveEffect2("p","w","z",0,gridWY*.5,0);
		} else if (frameCount < 2815) {
			towerWaveEffect2("p","w","diamond",0,gridWY*.5,0);
		} else if (frameCount < 2974) {
			towerWaveEffect2("p","w","z",0,gridWY*.5,0);
		} else if (frameCount < 3120) {
			towerWaveEffect2("p","w","circle",0,gridWY*.5,0);
		} else if (frameCount < 3400) {
			towerWaveEffect2("p","w","x",0,gridWY*.5,0);
		}
		if (frameCount == 2129) {
			towerWaveEffect("","circle", 0,-25,100, .3,75);
		}
		if (frameCount == 2311) {
			towerWaveEffect("","x", 0,-25,100, .4,75);
		}
		if (frameCount == 2486) {
			towerWaveEffect("","z", 0,-25,100, .3,75);
		}
		if (frameCount == 2651) {
			towerWaveEffect("","diamond", 0,-25,100, .3,75);
		}
		if (frameCount == 2815) {
			towerWaveEffect("","circle", 0,-25,100, .3,75);
		}
		if (frameCount == 2974) {
			towerWaveEffect("","z", 0,-25,100, .3,75);
		}
		if (frameCount == 3120) {
			towerWaveEffect("","x", 0,-25,100, .3,75);
		}
	} else if (frameCount < 4440) {
		spawnFloaters(avg*2.5+20,1);
		effectFloaters("up", .3);
		for (int i = 0 ; i < towers.size() ; i ++) {
			Rect3 rect = towers.get(i);
			int index = (int)(noise(1000+rect.p.p.x*.01,tRate*.001+rect.p.p.z*.01,tRate*.001)*2555)%main.length;
			float r = (noise(1000+tRate+rect.p.p.x*.001,rect.p.p.z*.001,tRate*.01)-.5)*360;
			rect.fillStyle.v.add(r,main[index]*2,main[index]*4);
			rect.w.v.add(0,main[index]*de*.015,0);
		}

		// Quiet
		if (frameCount == 3484) {
			cam.ang.P.set(-.6,0,0);
			cam.av.P.set(0,.003,0);
			cam.z.X = -de*1;
			for (Tower rect : towers) {
				float d = dist(rect.p.p.x,rect.p.p.z, -cam.p.p.x,-cam.p.p.z);
				events.add(new TowerDie(rect,d*.1));
			}

			setGrid(36,5,36, de*.12, .6);

			for (int i = 0 ; i < gridX ; i ++) {
				for (int k = 0 ; k < gridZ ; k ++) {
					Tower rect = newTower(i-gridX/2+1 + cx,k-gridZ/2+1 + cz, 0,-1);
				}
			}
		}

		// Claps
		if (frameCount == 3503 || frameCount == 3512 || frameCount == 3521) {
			for (Tower rect : towers) {
				if (!rect.alive) continue;
				float d = dist(rect.p.p.x,rect.p.p.z, -cam.p.p.x,-cam.p.p.z);
				forces.add(new Force(rect.w, 0,random(.5,1)*gridWY,0,d*.03,5));
			}
		}

		// First note
		if (frameCount == 3557) {
			float maxD = 0;
			for (Tower rect : towers) {
				float d = dist(rect.p.p.x,rect.p.p.z, -cam.p.p.x,-cam.p.p.z);
				if (d > maxD) maxD = d;
			}
			for (Tower rect : towers) {
				float d = dist(rect.p.p.x,rect.p.p.z, -cam.p.p.x,-cam.p.p.z);
				rect.w.P.y = gridWY - map(d,0,maxD,0,gridWY)*.75;
				rect.w.P.y *= random(.5,1);
			}
		}

		// Snares
		if (frameCount == 3814 || frameCount == 4109 || frameCount == 4402) {
			for (Tower rect : towers) {
				float d = dist(rect.p.p.x,rect.p.p.z, -cam.p.p.x,-cam.p.p.z);
				forces.add(new Force(rect.w, 0,random(.5,1)*gridWY*.5,0,d*.06,10));
			}
			cam.z.X -= de*.07;
		}
	} else if (frameCount < 10000) {
		spawnFloaters(avg*.5+8,1);
		effectFloaters("up", .15);
		if (frameCount == 4440) {
			// cam.ang.mass = 32;
			cam.av.P.set(0,0,0);
		}
		if (frameCount == 4440 || frameCount == 4469 || frameCount == 4497 || frameCount == 4524) {
			cam.z.X -= de*.15;
			int i = 0;
			while (i < 36*36/5) {
				Rect3 rect = towers.get((int)random(towers.size()));
				if (rect.alive) {
					spawnFloaters(rect,6);
					rect.die();
					rect.w.P.set(0,gridWY*3,0);
					i ++;
				}
			}
		}
		if (frameCount == 4552) {
			for (Rect3 rect : towers) {
				if (!rect.alive) continue;
				spawnFloaters(rect,6);
				rect.die();
				rect.w.P.set(0,gridWY*3,0);
			}
		}
		// 74
		// 74.491
		// 74.956
		// 75.412
		// 75.868
	}

	if (record) saveFrame("F:/cubeanimations/isometric/#####.png");
}
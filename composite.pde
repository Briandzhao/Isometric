boolean record = 1 == 1;
String prefix = "F:/cubeanimations/isometricLowRes";
String output = "F:/cubeanimations/isometricComp";
int startFrame = 0;
int endFrame = 4850;

boolean[] mark;
color[] temp;
color[] src;
float d;

PFont swiss;

void setupSketch() {
	lines = loadStrings("../isometric.txt");
	mark = new boolean[wh];
	temp = new color[wh];
	src = new color[wh];
	swiss = createFont("swiss.ttf",32);
	textFont(swiss);
	textAlign(CENTER);
}

void composite() {
	image(fimg,0,0,width,height);
	if (frameCount > 60 && frameCount < 300) 
		text("MADEON\nISOMETRIC",width/2,height/2.5);

	loadPixels();
	copyPixels(pixels,src);

	for (int i = 0 ; i < wh ; i ++) {
		r = red(src[i]);
		g = green(src[i]);
		b = blue(src[i]);
		contrast(.1);
		contrast2(.2);
		// if (noise(i*.01, (float)frameCount*.1) < .2) {
		// 	r += 50; g += 50; b += 50;
		// }
		tvstatic(i,.1);
		r *= .9; g *= .9; b *= .9;
		pixels[i] = color(r,g,b);
	}

	if (frameCount > 160 && frameCount < 300) {
		for (int i = 0 ; i < wh ; i ++) mark[i] = false;
		for (int i = 0 ; i < wh ; i ++) {
			if (mark[i]) continue;
			int index = (int)(i/11 + noise(i,tRate*.1)*10)%main.length;
			if (brightness(pixels[i]) > 65 && main[index] > 5) {
				for (int k = 0 ; k < noise(i,tRate*.01)*main[index]/5 ; k ++) {
					pixels[getIndex(getX(i),getY(i)-k)] = color(pixels[i]);
				}
			}
		}
	}

	// lineEffect();

	// displaceEffect();

	// rgbDisplace();

	// dither();

	updatePixels();
}

void copyPixels(color[] source, color[] dest) {
	for (int i = 0 ; i < source.length ; i ++) {
		dest[i] = color(source[i]);
	}
}

void dither() {
	for (int i = 0 ; i < wh ; i ++) {
		x = getX(i); y = getY(i);
		if (x % 2 != (y%2)) pixels[i] = color(0,0,0);
	}
}

void rgbDisplace() {
	for (int i = 0 ; i < wh ; i ++) {
		temp[i] = color(pixels[i]);
		mark[i] = false;
	}

	for (int i = 0 ; i < wh ; i ++) {
		int x = getX(i); int y = getY(i);
		if (mark[i] || noise(.03*x,.03*y+tRate*.1,tRate*.01) < .5) continue;
		
		float r = red(temp[i]);
		float g = green(temp[i]);
		float b = blue(temp[i]);

		int k = getIndex(x + 5,y);
		pixels[k] = color(0,g,b);
		// mark[k] = true;

		k = getIndex(x + 10, y);
		pixels[k] = color(r,0,b);
		// mark[k] = true;

		k = getIndex(x + 15, y);
		pixels[k] = color(r,g,0);
		// mark[k] = true;
	}
}

void displaceEffect() {
	for (int i = 0 ; i < wh ; i ++) {
		temp[i] = color(pixels[i]);
	}
	for (int i = 0 ; i < wh ; i ++) {
		int x = getX(i); int y = getY(i);
		int dx = width/2 - abs(x - width/2);
		int dy = height/2 - abs(y - height/2);
		float amp = min(dx,dy,25);
		float x2 = (noise(x*.01,y*.01,tRate*.02+11111)-.5)*amp + x;
		float y2 = (noise(x*.01,y*.01,tRate*.01+22222)-.5)*amp + y;
		pixels[getIndex(x2,y2)] = color(temp[i]);
	}
}

void lineEffect() {
	for (int i = 0 ; i < mark.length ; i ++) mark[i] = false;
	for (index = 0 ; index < wh ; index ++) {
		int x = getX(index); int y = getY(index);
		if (mark[index] || noise(.01*x,.01*y,.01*frameCount) < .5) continue;
		float r = red(src[index]);
		float g = green(src[index]);
		float b = blue(src[index]);
		if (r < 125 && g < 125 && b < 125) {
			for (int j = 0 ; j < noise(.01*x,.01*y,.01*frameCount)*25 ; j ++) {
				pixels[getIndex(x+j,y)] = color(r,g,b);
				mark[getIndex(x+j,y)] = true;
			}
		}
	}
}

void contrast(float amp) {
	float r2 = r; float g2 = g; float b2 = b;
	r2 -= (g - r)*amp + (b - r)*amp;
	g2 -= (r - g)*amp + (b - g)*amp;
	b2 -= (r - b)*amp + (g - b)*amp;

	r = r2; g = g2; b = b2;
}

void contrast2(float amp) {
	r += (r - 127)*amp;
	g += (g - 127)*amp;
	b += (b - 127)*amp;
}

void tvstatic(int i, float amp) {
	// r *= random(1-amp,1+amp);
	// g *= random(1-amp,1+amp);
	// b *= random(1-amp,1+amp);
	d = (noise(1000+(float)getX(i)/wh*1000000,1000+(float)getY(i)/wh*1000000,tRate*.5)-.5);
	if (d > 0) {
		amp = 1 + amp;
	} else {
		amp = 1 - amp;
	}
	r *= amp; g *= amp; b *= amp;
}
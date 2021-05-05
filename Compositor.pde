String frameNum;
PImage fimg; // Image of #####.png frames
float r,g,b;
int index, x,y,x2,y2;
int wh;

// FFT VARIABLES
float tRate = 0;
float tRateAmp = .1;
float tRateInc = 1;
float[] main = new float[144];
String[] lines;

float bpm = 120;

int offset = 0;
float fpb = 3600.0/bpm;
float fpqb = fpb/4;
boolean beat = false;
boolean beatQ = false;
float currBeat = 0;
float avg;

void setup() {
	size(640,360);
	// size(720,480);
	wh = width * height;
	frameCount = startFrame;
	setupSketch();
}

void draw() {
	if (frameCount == endFrame + 1) exit();
	getFrameNum();
	getLines();
	fimg = loadImage(prefix + "/" + frameNum + ".png");
	composite();
	if (record) saveFrame(output + "/#####.png");
}

void getLines() {
	if (frameCount == lines.length - 1) exit();
	for (int i = 0 ; i < 144 ; i ++) {
		main[i] = convertDec("" + lines[frameCount].charAt(i*2) + lines[frameCount].charAt(i*2+1));
	}

	avg = 0;
	for (int i = 0 ; i < main.length ; i ++) {
		avg += main[i];
	}
	avg /= main.length;

	// Increment tRate by a fixed amount + the current volume
	tRate += tRateInc + avg*tRateAmp;

	// Check whether the current frame is on a beat/on a quarter beat
	if ((frameCount + offset) % fpb < 1) {
		beat = true;
		// Print to the console on every beat
		println(currBeat + " " + frameCount + " " + frameRate);
	} else {
		beat = false;
	}
	if ((frameCount + offset) % fpqb < 1) {
		beatQ = true;
		currBeat += .25;
	} else {
		beatQ = false;
	}
}

int getIndex(float x, float y) {
	return getIndex((int)x, (int)y);
}

int getIndex(int x, int y) {
	x = constrain(x, 0,width-1);
	y = constrain(y, 0,height-1);
	return x + y*width;
}

int getX(int i) {
	return i%width;
}

int getY(int i) {
	return constrain(i/width,0,height-1);
}

void getFrameNum() {
	frameNum = "";
	int temp = frameCount;
	int count = 0;
	while (temp > 0) {
		count ++;
		temp /= 10;
	}
	for (int i = 0 ; i < 5 - count ; i ++) {
		frameNum += "0";
	}
	frameNum += "" + frameCount;
}

int convertDec(String hum) {
	return convertDecChar(hum.charAt(0)) + convertDecChar(hum.charAt(1))*16;
}

int convertDecChar(char h) {
	switch (h) {
		default:
		return 0;
		case '1':
		return 1;
		case '2':
		return 2;
		case '3':
		return 3;
		case '4':
		return 4;
		case '5':
		return 5;
		case '6':
		return 6;
		case '7':
		return 7;
		case '8':
		return 8;
		case '9':
		return 9;
		case 'a':
		return 10;
		case 'b':
		return 11;
		case 'c':
		return 12;
		case 'd':
		return 13;
		case 'e':
		return 14;
		case 'f':
		return 15;
	}
}
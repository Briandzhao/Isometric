// DIMENSIONS
static float de; // 3rd dimension, depth. Determined by the size of the screen

// CAMERA
Camera cam;

// KEYBOARD
char keyR; // Last key released
char keyP; // Last key pressed
boolean paused = false;

// COLOR
static float colorHMax = 360; // By default, I use HSB color values
static float colorSMax = 100;
static float colorBMax = 100;
static float colorAMax = 100;

// SPECIAL VALUES
static float PI2 = PI * 2;
static float GR = 1.61803398875; // Golden ratio
static float GR2 = 1.0/GR;

// BACKGROUND
Point backFill;

// PHYSICS
float defaultMass = .5;
float defaultVMult = .1;

// FFT VARIABLES
float tRate = 0; // tRate is like the current frame of the song, but influenced by volume
float tRateAmp = .1;
float tRateInc = 1;
float[] main = new float[144]; // This array stores the current frame's sound values
String[] lines; // This array stores all of the sound values for every frame, represented as lines of hexidecimal numbers

float bpm = 120; // Beats per minute

int offset = 0; // Some songs' beats are offset from the starting frame
float fpb = 3600.0/bpm; // Frames per beat
float fpqb = fpb/4; // Frames per quarter beat
boolean beat = false; // If the current frame is on a beat
boolean beatQ = false; // If the current frame is on a quarter beat
float currBeat = 0; // The current beat number
float avg; // Stores the current frame's volume: the average over all sound values in main[]

// Setup is called once, when the sketch is started
void setup() {
	size(1280,720,P3D);
	smooth(8);
	
	de = (width + height)/2;

	cam = new Camera(0,0,0, 0,0,0);

	textSize(de/10);
	textAlign(CENTER);
	rectMode(CENTER);
	colorMode(HSB, colorHMax, colorSMax, colorBMax, colorAMax);

	setupSketch();
}

// Draw is called 60 times a second
void draw() {
	// Get the sound data values for the current frame
	getLines();

	// Fill the background color of the animation
	backFill.update();
	background(backFill.p.x, backFill.p.y, backFill.p.z);

	// Position the screen based on the camera's location
	cam.update();
	cam.render();

	// Animate the scene based on the current beat
	sequence();
}

void getLines() {
	// If it reaches the end of the sound data, quit the program
	if (frameCount == lines.length - 1) exit();
	// Otherwise, extract the sound data for the current frame
	for (int i = 0 ; i < 144 ; i ++) {
		main[i] = convertDec("" + lines[frameCount].charAt(i*2) + lines[frameCount].charAt(i*2+1));
	}

	// Calculate the current volume/average sound value
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

void mouseReleased() {
	// If I click and the animation is not paused, seek to a frame based on where I clicked on the screen
	if (!paused) {
		seekTo((int)((float)mouseX/width*lines.length));
	}
}

void keyPressed() {
	// Pressing e toggles the ability to rotate the camera with the mouse
	if (key == 'e') {
		if (!cam.lock) {
			cam.lock = true;
			cam.ang.P.set(cam.dang.x, cam.dang.y, cam.dang.z);
		} else {
			cam.lock = false;
		}
		println("Cam lock: " + cam.lock);
	}

	// Pressing the space bar pauses/unpauses the animation
	if (key == ' ') {
		if (paused) {
			loop();
		} else {
			noLoop();
		}
		paused = !paused;
	}

	println(key + " " + (int)frameRate + " " + frameCount);
}

// Sets the animation to be at the given frame
void seekTo(int frame) {
	frameCount = frame;
	println("Seeked to: " + frameCount);
}

// Sets the animation to be at the start of the given beat number
void seekToBeat(float beat) {
	currBeat = beat;
	seekTo((int)(beat*fpb + offset));
}

// If the current frame is within the given range of beat numbers
boolean beatInRange(float minBeat, float maxBeat) {
	return currBeat >= minBeat && currBeat < maxBeat;
}

// If the current frame is the start of the given beat number
boolean beatE(float b) {
	return beatQ && currBeat == b;
}

// Converts from number of beats to number of frames at 60 fps
int toFrames(float beats) {
	return (int)(fpb * beats);
}

// 2D, floating watermark I use when I send previews to people
void watermark() {
	push();
	fill(0);
	text("@cube.animations", 0, sin(frameCount*.01)*de);
	pop();
}

// Converts from hexidecimal to decimal. Used to read the sound data when the sketch starts
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
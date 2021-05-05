PVector fillv = new PVector();

String[] towerFill = {"tower","contrast"};
String[] floaterFill = {"tower","contrast","g25"};

void fills(String fillType, float x, float y, float z, float ang) {
	switch(fillType) {
		default:
		fillv.set(0,0,50);
		break;
		case "g75":
		fillv.add(0,0,75);
		break;
		case "g50":
		fillv.add(0,0,50);
		break;
		case "g25":
		fillv.add(0,0,25);
		break;
		case "noise":
		fillv.set((noise(x/de*3,z/de*3,tRate*.003)*120+tRate*.1)%360, 
			noise(2000+x/de*3,2000+z/de*3,tRate*.01)*55+55,
			noise(3000+x/de*3,3000+z/de*3,tRate*.01)*25+25
		);
		break;
		case "tower":
		fillv.set((noise(x/de*3,z/de*3,tRate*.003)*240+tRate*.1)%360, 
			noise(2000+x/de*3,2000+z/de*3,tRate*.01)*15+25,
			noise(3000+x/de*3,3000+z/de*3,tRate*.01)*15+45
		);
		break;
		case "contrast":
		fillv.add(0,fillv.y*sin(ang-HALF_PI)*.2,fillv.z*sin(ang-HALF_PI)*.7);
		break;
	}
}
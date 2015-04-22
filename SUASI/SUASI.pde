MercatorMap mercatorMap;
PImage fFade, baMAP;

void setup() {
  size(1920, 1079);
  smooth(8);
  fFade = loadImage("fakeFade.png");
  baMAP = loadImage("mapBA-01.png");
  ellipseMode(CENTER);
  background(0);
  //server = new SyphonServer(this, "Bicis");
  mercatorMap = new MercatorMap(1920, 1079, -34.512, -34.7129, -58.637, -58.2044); 
  LoadSuasiCalls() ;
  printCalls();
  buildColor();
  prinrtLabels();
  //printSUASI();
}

void draw() {
  background(0);
  prinrtLabels();
  if (showMap) {
    image(baMAP, 0, 0);
  }
  if (running) {
    background(0);
    printSUASI();
    upDateClock();
    prinrtLabels();
  }
}


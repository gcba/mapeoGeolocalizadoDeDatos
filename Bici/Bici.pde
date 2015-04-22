import codeanticode.syphon.*;

SyphonServer server;
PImage myBA;
float appCycles;
MercatorMap mercatorMap;
boolean showMap = false;
boolean running = false;
timeStamp clock; 


void setup() {
  size(1920, 1079,OPENGL);
  smooth(8);
  ellipseMode(CENTER);
  background(0);
  //server = new SyphonServer(this, "Bicis");
  mercatorMap = new MercatorMap(1920, 1079, -34.512, -34.7129, -58.637, -58.2044); 
  //BUILD STATIONS
  buildStations();
  // BUILD TRAVELS
  buildTravels();
}


void draw() {
  upDateClock();
  if(running){
  printTravels();
  save("bici_####.png");
  }
 // server.sendScreen();
}


void upDateClock() {
  if (running) {
    clock.segs+=SECONDS_SPEED;
      if (clock.segs>=60) {
      clock.segs =0;
      clock.mins+=MINUTES_SPEED;
    }
    if (clock.mins>=60) {
      clock.mins = 0;
      clock.hours+=HOURS_SPEED;
    }
    if(clock.hours >24){
    running = false;
    clock.hours=0;
    }
    println(">> "+clock.hours+":"+clock.mins+":"+clock.segs+" hrs.");
  }
}

int difTime(timeStamp clock, timeStamp tTime){
  int clockInMinutes = round(clock.hours*60+clock.mins+clock.segs*0.0166666667f);
  int timeInMinutes = round(tTime.hours*60+tTime.mins+tTime.segs*0.0166666667f);
  return clockInMinutes-timeInMinutes;
}





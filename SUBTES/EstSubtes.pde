ArrayList<EstSubtes> estSubtes = new ArrayList<EstSubtes>();

class EstSubtes {
  String    stName;
  String      line;
  float       qPassIn  = 0;
  float       pass     = 0; 
  float     x, y; 
  EstSubtes (float _x, float _y, String _line, String _stName) {
    x = _x; 
    y = _y; 
    stName = _stName; 
    line   = _line;
  }
}

void loadSubwayStations() {
  print("Loading Subway stations...");
  Table callsTable = loadTable("stSubte.csv", "header");
  int stLoaded = 0;
  for (TableRow row : callsTable.rows () ) {
    PVector marker = mercatorMap.getScreenLocation(new PVector(row.getFloat("latitude"), row.getFloat("longitude")));
    float    _x    = marker.x;
    float    _y    = marker.y;
    String _stName = row.getString("estacion");
    String _line   = row.getString("linea");
    estSubtes.add(new EstSubtes(_x, _y, _line , _stName));
    stLoaded++;
    print(".");
  }
  println(" OK!");
  println(stLoaded+" Subway Stations Loaded.");
}

void upDateStations() {
  for (int i= 0; i < subwayRegs.size(); i++) {
    travelReg tReg = subwayRegs.get(i);
    int timeDifference = difTime(clock, tReg.regDate);
    if ( timeDifference >= 0 ) {
      EstSubtes tStation = estSubtes.get(tReg.stID);
      int inc = round(map(tReg.molValue, MIN_PERSONS,MAX_PERSONS/2, MIN_STATION_SIZE, MAX_STATION_SIZE));
      tStation.qPassIn = inc;
      tStation.pass = 0;
      estSubtes.set(tReg.stID, tStation);
      subwayRegs.remove(i);
    }
  }
}

void printSubwayStations() {
  for (int i=0; i < estSubtes.size (); i++) {
    color lineColor = color(0,0,0);
    EstSubtes tSta = estSubtes.get(i);
    if (tSta.line.equals("A")) {lineColor = color(lineA[0], lineA[1], lineA[2],190);}
    if (tSta.line.equals("B")) {lineColor = color(lineB[0], lineB[1], lineB[2],190);}
    if (tSta.line.equals("C")) {lineColor = color(lineC[0], lineC[1], lineC[2],190);}
    if (tSta.line.equals("D")) {lineColor = color(lineD[0], lineD[1], lineD[2],190);}
    if (tSta.line.equals("E")) {lineColor = color(lineE[0], lineE[1], lineE[2],190);}
    if (tSta.line.equals("H")) {lineColor = color(lineH[0], lineH[1], lineH[2],190);}
    ellipseMode(CENTER);
    noStroke();
    fill(lineColor,120);
    float inc = (tSta.qPassIn/AUTO_DEC_SIZE)*tSta.pass;
    ellipse(tSta.x, tSta.y,inc+NORMAL_STATION_SIZE,inc+NORMAL_STATION_SIZE);
    fill(lineColor);
    ellipse(tSta.x, tSta.y, NORMAL_STATION_SIZE,NORMAL_STATION_SIZE);
    if ( tSta.qPassIn > 0 && tSta.pass >= AUTO_DEC_SIZE) {
      tSta.qPassIn-= tSta.qPassIn/tSta.passte;
    }  
    if(AUTO_DEC_SIZE > tSta.pass) {tSta.pass++;} 
      estSubtes.set(i,tSta);
    
  }
}


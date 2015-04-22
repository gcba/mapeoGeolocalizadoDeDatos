ArrayList<travelReg> subwayRegs = new ArrayList<travelReg>();

class travelReg {
  timeStamp regDate;
  int stID;
  int molValue;
  travelReg(int _stID, String _regDate, int _molValue) {
    regDate = new timeStamp(_regDate);
    stID    = _stID;
    molValue = _molValue;
  }
}

int getStationId(String st, String sLine) {
  int r = 0;
  for (int i= 0; i < estSubtes.size (); i++) {
    EstSubtes tSt = estSubtes.get(i);
    st = st.toUpperCase();
    String stName = tSt.stName;
    String stLine = tSt.line;
    if (stName.equals(st) == true && stLine.equals(sLine)) { 
      r = i;
    }
  }
  return r;
}

void loadRegs() {
  print("loading travel's regs...");
  Table suRegsTable = loadTable("subTravels.csv", "header");
  for (TableRow row : suRegsTable.rows () ) {
    //String fecha       = row.getString("fecha");
    String hora        = row.getString("desde");
    int _stID  = getStationId(row.getString("estacion"),row.getString("linea")); 
    String tline = row.getString("linea");
    int     _molValue      = row.getInt("pasajeros");
    subwayRegs.add(new travelReg(_stID, DATASET_DAY+hora+":00.000", _molValue));
    if(tline.equals("A")){if(_molValue > MAX_A){MAX_A = _molValue;}}
    if(tline.equals("B")){if(_molValue > MAX_B){MAX_B = _molValue;}}
    if(tline.equals("C")){if(_molValue > MAX_C){MAX_C = _molValue;}}
    if(tline.equals("D")){if(_molValue > MAX_D){MAX_D = _molValue;}}
    if(tline.equals("E")){if(_molValue > MAX_E){MAX_E = _molValue;}}
    if(tline.equals("H")){if(_molValue > MAX_H){MAX_H = _molValue;}}
    
    print(".");
  }
  println("OK!");
}

float s;
void upDateStations() {
  for (int i= 0; i < subwayRegs.size(); i++) {
    travelReg tReg = subwayRegs.get(i);
    int timeDifference = difTime(clock, tReg.regDate);
    if ( timeDifference >= 0 ) {
      EstSubtes tStation = estSubtes.get(tReg.stID);
      int pMAX=0;
      if(tStation.line.equals("A")){pMAX = MAX_A;}
      if(tStation.line.equals("B")){pMAX = MAX_B;}
      if(tStation.line.equals("C")){pMAX = MAX_C;}
      if(tStation.line.equals("D")){pMAX = MAX_D;}
      if(tStation.line.equals("E")){pMAX = MAX_E;}
      if(tStation.line.equals("H")){pMAX = MAX_H;}
      int inc = round(map(tReg.molValue, MIN_PERSONS,5000, MIN_STATION_SIZE, MAX_STATION_SIZE));
      tStation.qPassIn += round(inc);
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
    fill(lineColor);
    ellipse(tSta.x, tSta.y, NORMAL_STATION_SIZE+tSta.qPassIn, NORMAL_STATION_SIZE+tSta.qPassIn);
    if (0 < tSta.qPassIn) {
      tSta.qPassIn-=AUTO_DEC_SIZE;
      estSubtes.set(i,tSta);
    }
  }
}


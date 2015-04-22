ArrayList<travelReg> subwayRegs = new ArrayList<travelReg>();

class travelReg {
  timeStamp regDate;
  int stID;
  float molValue;
  
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
    if(_molValue >MAX_PERSONS){MAX_PERSONS = _molValue;}
    print(".");
  }
  println("OK!");
  println("MAX PERSONS: "+MAX_PERSONS);
}

float s;


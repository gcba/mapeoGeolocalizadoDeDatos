ArrayList<EstSubtes> estSubtes = new ArrayList<EstSubtes>();

class EstSubtes {
  String    stName;
  String      line;
  float       qPassIn   = 0;
  float       lsQPassIn = 0; 
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


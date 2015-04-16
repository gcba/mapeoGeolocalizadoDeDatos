ArrayList<Estacion> estaciones = new ArrayList<Estacion>();

class Estacion {
  float x;
  float y;
  int id; 
  String name;
  color  rColor=color(random(255), random(255), random(255));
  Estacion(float _x, float _y, String _name, int _id) {
    x    = _x;
    y    = _y;
    name = _name;
    id   = _id;
  }
}

void buildStations() {
  Table stTable = loadTable("estBiciPub.csv", "header");
  int stLoaded = 0;
  for (TableRow row : stTable.rows ()) {
    PVector marker = mercatorMap.getScreenLocation(new PVector(row.getFloat("lon"), row.getFloat("lat")));
    float   _x    = marker.x;
    float   _y    = marker.y;
    int     _id   = row.getInt("id");
    String  _name = row.getString("nombre");
    estaciones.add(new Estacion(_x, _y, _name, _id));
    stLoaded++;
  }
  stLoaded++;
  println("Cantidad de estaciones cargadas: "+stLoaded);
  image(drawEst(), 0, 0);
}

PImage drawEst() {
  PGraphics tempScreen = createGraphics(width, height);
  tempScreen.beginDraw();
  for (int i=0; i < estaciones.size (); i++ ) {
    Estacion tE = estaciones.get(i);
    tempScreen.stroke(tE.rColor, 120);
    tempScreen.strokeWeight(STATION_SIZE);
    tempScreen.fill(tE.rColor);
    tempScreen.ellipse(tE.x, tE.y,STATION_SIZE, STATION_SIZE);
    if(SHOW_LABELS){
     tempScreen.fill(tE.rColor);
     tempScreen.textSize(LABEL_SIZE);
     tempScreen.textAlign(RIGHT);
     tempScreen.text(tE.name, tE.x-15, tE.y+int(LABEL_SIZE/2));
    }
  }
  tempScreen.endDraw();
  return tempScreen.get();
}


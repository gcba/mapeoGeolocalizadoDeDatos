ArrayList<bTravel> viajes = new ArrayList<bTravel>();

class bTravel {
  int actX,actY,destino,origen;
  float travelTime;
  float dreco= 0;
  timeStamp timeStart;
  bTravel(int eO, int eD, float tT, timeStamp tStart, int apX, int apY) {
    origen     = eO; 
    destino    = eD; 
    travelTime = tT;
    timeStart = tStart;
    actX = apX; actY = apY;
  }
}

/* 2014-01-02 08:03:44.437 */
class timeStamp {
  int segs; 
  int mins; 
  int hours;
  int days; 
  int months; 
  int year;

  timeStamp(String _sTimeStamp) {
    year = parseInt(_sTimeStamp.substring(0, 4)); 
    months = parseInt(_sTimeStamp.substring(5, 7)); 
    days = parseInt(_sTimeStamp.substring(8, 10));
    hours = parseInt(_sTimeStamp.substring(11, 13)); 
    mins = parseInt(_sTimeStamp.substring(14, 16)); 
    days = parseInt(_sTimeStamp.substring(17, 19));
  }
}

//TRAVELS CONSTRUCTOR
void buildTravels() {
  Table stTable = loadTable("recBicis1d.csv", "header");
  int trLoaded = 0;
  for (TableRow row : stTable.rows ()) {
    int idOrigen  = row.getInt("origenestacionid");
    int idDestino = row.getInt("destinoestacionid"); 
    Estacion tEst = getStationById(idOrigen);
    int  useTime  = row.getInt("tiempouso")*60;
    timeStamp startUseAt = new timeStamp(row.getString("origenfecha"));
    viajes.add( new bTravel(idOrigen, idDestino, useTime, startUseAt, int(tEst.x) , int(tEst.y )));
    if (trLoaded == 0) {
      clock = startUseAt;
      TIME2RESET= row.getString("origenfecha");
      println(row.getString("origenfecha"));
      println(">> HORA INICIAL:  "+clock.hours+":"+clock.mins+":"+clock.segs+"hrs.");
      println(">> FECHA INICIAL:  "+clock.days+"/"+clock.months+"/"+clock.year+".");
    }
    trLoaded++;
  }
  trLoaded++;
  println("Viajes cargados: "+trLoaded);
}
PFont font = loadFont("/Users/jose/Documents/DESIGN/ciudad_emergente/Bici/data/Gotham-Bold-72.vlw");
void printTravels() {
  background(0);
  image(drawEst(), 0, 0);
  for (int i=0; i< viajes.size (); i++) {
    bTravel tempViaje = viajes.get(i);
    int timeDifference = difTime(clock, tempViaje.timeStart);
    if ( timeDifference >= 0) {
      Estacion eO = getStationById(tempViaje.origen);
      Estacion eD = getStationById(tempViaje.destino);
      float ny=0;
      float nx=0;
      nx  = eO.x -(eO.x - eD.x)/tempViaje.travelTime*tempViaje.dreco;
      ny = eO.y -(eO.y - eD .y)/tempViaje.travelTime*tempViaje.dreco;                    
      if (tempViaje.dreco <= tempViaje.travelTime) {
        noStroke();
        fill(255,180);
        ellipse(nx, ny,5,5);
        tempViaje.dreco+=SECONDS_SPEED;
        viajes.set(i, tempViaje);
      } else {
        viajes.remove(i);
      }
    }
  }
  
  fill(255);
  textFont(font, 54);
  String cp ="";
  if(clock.hours < 10){cp = "0"+str(clock.hours); }  else  {cp = str(clock.hours);   }
  if(clock.mins < 10){cp += ":0"+str(clock.mins);}  else  {cp +=":"+str(clock.mins);}
  if(clock.segs < 10){cp += ":0"+str(clock.segs);}  else  {cp +=":"+str(clock.segs);}
   
  text(cp, width-cp.length()*40, height-100);
}

Estacion getStationById(int id) {
  int e = 0;
  for (int i=0; i<estaciones.size (); i++) {
    Estacion temp = estaciones.get(i);
    if (temp.id == id) {
      e = i;
    }
  }
  return estaciones.get(e);
}



 

// DATASET: "suasiUnDia.csv"

ArrayList<String> types = new ArrayList<String>();
ArrayList<String> categories = new ArrayList<String>();
ArrayList<SuasiCall> suasiCalls = new ArrayList<SuasiCall>();
ArrayList<Color> typeColors = new ArrayList<Color>();

class Color {
  float R, G, B;
  Color(float _r, float _g, float _b) {
  R = _r; G = _g; B = _b;    
 }
}

int getTypeId(String type) {
  int r = -1;
  for (int i= 0; i < types.size (); i++) {
    String sType = types.get(i);
    if (sType.equals(type) == true) { 
      r = i;
    }
  }
  if (r == -1) {
    types.add(type);
    r = types.size()-1;
  }
  return r;
}

int getCategoryId(String cat) {
  int r = -1;
  for (int i= 0; i < categories.size (); i++) {
    String sCat = categories.get(i);
    if (sCat.equals(cat) == true ) { 
      r = i;
    }
  }
  if (r == -1) {
    categories.add(cat);
    r = categories.size()-1;
  }
  return r;
}

class SuasiCall {
  int callType;
  int callCategory;
  timeStamp callDate;
  float x, y; 
  float frameShowed = 90;
  SuasiCall(float _x, float _y, int _tll, int _r, String _callDate) {
    callDate = new timeStamp(_callDate);
    x = _x; 
    y = _y; 
    callCategory = _r; 
    callType     = _tll;
  }
}

void LoadSuasiCalls() {
  Table callsTable = loadTable("suasiUnDia.csv", "header");
  int callsLoaded = 0;
  for (TableRow row : callsTable.rows () ) {
    PVector marker = mercatorMap.getScreenLocation(new PVector(row.getFloat("latitud"), row.getFloat("longitud")));
    float   _x    = marker.x;
    float   _y    = marker.y;
    int     _type = getTypeId(row.getString("tipo_prestacion"));
    int    _cat   = getCategoryId(row.getString("rubro"));
    String cDate  = row.getString("fecha_ingreso");

    suasiCalls.add(new SuasiCall(_x, _y, _type, _cat, cDate));
    callsLoaded++;
  }
  println(callsLoaded+" Calls Loaded, "+types.size()+" new types added and "+categories.size()+" categories created too!");
}

void printCalls() {
  for (int i=0; i < suasiCalls.size (); i++) {
    SuasiCall thisCall = suasiCalls.get(i);
  }
}


void buildColor() {
  for (int i = 0; i<types.size (); i++) {  
    typeColors.add(new Color(random(255), random(255), random(255)));
  }
}


void printSUASI() {
  //image(fFade,0,0);
  background(0);
  
  for (int i = 0; i < suasiCalls.size (); i++) {
    SuasiCall tempCall = suasiCalls.get(i);
    int timeDifference = difTime(clock, tempCall.callDate);
    Color callColor = typeColors.get(tempCall.callType);
    if ( timeDifference >= 0 ) {
    //noStroke();
    stroke(callColor.R,callColor.G,callColor.B,120);
    fill(callColor.R,callColor.G,callColor.B);
    strokeWeight( tempCall.frameShowed);
    ellipseMode(CENTER);
    ellipse(tempCall.x, tempCall.y,20, 20);
    tempCall.frameShowed -= SECONDS_SPEED/6; 
    suasiCalls.set(i,tempCall);
    if( tempCall.frameShowed < 0 ){
    suasiCalls.remove(i);}
    }
  }
}


PGraphics labelsScreen;
void prinrtLabels(){
  labelsScreen = createGraphics(1920, 1079);
  labelsScreen.beginDraw();
  if(showMap){image(baMAP,0,0);}
  for(int i=0; i< types.size();i++){
    Color callColor = typeColors.get(i);
    labelsScreen.textSize(20);
    labelsScreen.fill(callColor.R,callColor.G,callColor.B);
    labelsScreen.ellipse(1600,800+(25*i),10,10);
    labelsScreen.fill(255);
    labelsScreen.text(types.get(i),1610,805+(25*i));
  }
  
  labelsScreen.fill(255);
  labelsScreen.textSize(54);
  String cp ="";
  if(clock.hours < 10){cp = "0"+str(clock.hours); }  else  {cp = str(clock.hours);   }
  if(clock.mins < 10){cp += ":0"+str(clock.mins);}  else  {cp +=":"+str(clock.mins);}
  if(clock.segs < 10){cp += ":0"+str(clock.segs);}  else  {cp +=":"+str(clock.segs);}
   
  labelsScreen.text(cp, width-cp.length()*40, height-120);
  labelsScreen.endDraw();
  image(labelsScreen.get(),0,0);
}

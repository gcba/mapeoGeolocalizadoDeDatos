import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.core.PApplet; 
import de.fhpotsdam.unfolding.UnfoldingMap; 
import de.fhpotsdam.unfolding.events.EventDispatcher; 
import de.fhpotsdam.unfolding.geo.Location; 
import de.fhpotsdam.unfolding.providers.Microsoft; 
import de.fhpotsdam.unfolding.utils.DebugDisplay; 
import de.fhpotsdam.unfolding.utils.MapUtils; 
import de.fhpotsdam.unfolding.*; 
import de.fhpotsdam.unfolding.geo.*; 
import de.fhpotsdam.unfolding.utils.*; 
import de.fhpotsdam.unfolding.providers.*; 
import de.fhpotsdam.unfolding.data.*; 
import de.fhpotsdam.unfolding.marker.*; 
import java.util.List; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class mapeoGeolocalizadoDeDatos extends PApplet {

/*
**
** UNUSED "data/MBTARapidTransitLines.json" old DataStream
** 
**/
//















ArrayList<dataServices> myServices = new ArrayList<dataServices>();
HUDView myHUD;

DebugDisplay debugDisplay1;
UnfoldingMap myBA_map;

public void setup() {
  size(960, 540, OPENGL);
  smooth();
  myHUD = new HUDView();
  mapInit();
  myServices.add(new dataServices("areas_hosp", "HospAreas.csv",MULTIPOLIGON_DATA));
  //myServices.add(new dataServices("OpDefCivil", "OpDefCivil.csv"));
  dataServices data = myServices.get(0);
  createDataLayer(MULTIPOLIGON_DATA, data.getJSONfile());
  EventDispatcher eventDispatcher = MapUtils.createDefaultEventDispatcher(this,myBA_map);
}


public void createDataLayer(int _mode, String _sfile) {
  switch(_mode) {
  case 2:
    {  
      List<Feature> myArea  = GeoJSONReader.loadData(this, _sfile);
      List<Marker> myAreaMarker = MapUtils.createSimpleMarkers(myArea);
      myBA_map.addMarkers(myAreaMarker);
      break;
    }
  }
}


//FUNCION DE INICIALIZACION DEL MAPA QUE SE A UTILIZAR
public void mapInit() {
  myBA_map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  myBA_map.zoomToLevel(13);
  myBA_map.panTo(myBA_loc);
  myBA_map.setZoomRange(9, 17);
  myBA_map.setPanningRestriction(myBA_loc, 50);
  MapUtils.createDefaultEventDispatcher(this, myBA_map);
}


public void keyPressed() {
  if (key == 'H') {
    myBA_map.getDefaultMarkerManager().toggleDrawing();
  }

  if (key == 'R') {
    myBA_map.rotate(MAP_ROTATION);
  }
  if (key == 'r') {
    myBA_map.rotate(-MAP_ROTATION);
  }
  if (key == 'h') {
    myHUD.ToggleView();
  }
}



public void draw() {
  myBA_map.draw();
 
}


/**
 ** Peque\u00f1o hud para presentacion de menu y/o data
 **/

class HUDView {
  private float    hudWidth;
  private float    hudHeight;
  private float    hudOpacity;
  private boolean  hudVisible = false;


  HUDView() {
    SetSize(width/4, height/4*3);
    hudOpacity = 20;
  }

  public void SetSize(float xSize, float ySize) {
    hudWidth = xSize;
    hudHeight = ySize;
  }

  public void ToggleView() {
    hudVisible = !hudVisible;
  }

  public void hPrint() {
    if (hudVisible) {
      fill(0, 0, 0, hudOpacity);
      rectMode(CORNER);
      rect(hudWidth*3-20, height/2-hudHeight/2, hudWidth, hudHeight);
    }
    else {
      fill(255,0,0);
      text("Presionar [h] para mostrar hud...",width/5*4,height-10); 
    }
  }
}

/*
**   CONFIGURACIONES GENERALES DE LA APLICACION
**
*/

final float  MAP_ROTATION =  radians(1.0f); // Rotacion de ajuste para el mapa

Location myBA_loc = new Location(-34.608965f, -58.426861f);//Centro "Aproximado de la ciudad de buenos Aires.

final int MULTIPOLIGON_DATA = 2;

final int HOSP_AREAS   = 0;
final int OP_DEF_CIVIL = 1;


/**
 **
 **/

class dataServices {
  boolean enabled = true; //Activar o desactivar este servicio.
  String wsName; // Nombre del recurso
  String host; // Host donde se aloja el recuerso
  String lsUpdate; //Ultima vez que se actualizo el recurso
  int eCount = 0; // Cantidad de elementos q posee este recurso
  private PrintWriter geoJSon; //Archivo de salida GEOJSON extraido del CSV de http://data.buenosaires.gob.ar/
  Table wsTable; //Archivo de entrada de datos formato CSV adquirido de http://data.buenosaires.gob.ar/
  int dataTypeView;

  dataServices (String _name, String _host, int _type) {
    host = _host;
    wsName = _name;
    dataTypeView = _type;
    updateData();
  }

  public void updateData() {
    wsTable = loadTable( host, "header");
    geoJSon = createWriter(getJSONfile()); 
    eCount = wsTable.getRowCount();


    //DEBUG-LINE
    println("loading DataSet: "+wsName+"... 0%");
    
    if (eCount > 0) {

      if (true) {
        loadMultipolygon();
      }

      lsUpdate = hour()+":"+minute()+":"+second();

      // DEBUG LINE 
      println("Created json file at: "+lsUpdate+", named: \""+getJSONfile()+"\".");
    }
  }

  public String getJSONfile() {
    String jsonfile = "data/"+wsName+".json";
    return jsonfile;
  }
  
//CARGAR GEODATA (MARKERS)
  private void loadMarkers(){
    println("loading DataSet: "+wsName+"... 0%");
    geoJSon.println("{\"type\":\"FeatureCollection\",\"features\":[");
    int ID = 0;
    for(TableRow row : wsTable.rows()){
      int    id       = row.getInt("ID");
      String nombre   = row.getString("NOMBRE");
      String geojson  = row.getString("GEOJSON");
      ID++;
    }
  }

//CARGAR GEODATA (MULTIPOLYGON)
  private void loadMultipolygon() {
    println("loading DataSet: "+wsName+"... 0%");
    geoJSon.println("{\"type\":\"FeatureCollection\",\"features\":[");
    int ID = 0;
    int loadedData = 0;
    for (TableRow row : wsTable.rows()) {
      int id = row.getInt("ID");
      String nombre = row.getString("NOMBRE");
      String geojson  = row.getString("GEOJSON");
      geoJSon.println("{\"type\":\"Feature\",\"properties\":{\"name\":\""+nombre+"\"},\"geometry\":"+geojson+",\"id\":\""+ID+"\"},");
      ID++;
      //DEBUG-LINE        
      loadedData++;

      println(">>"+round(loadedData*100/eCount)+"%");
    }
    geoJSon.println("]}");
    geoJSon.flush();
    geoJSon.close();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "mapeoGeolocalizadoDeDatos" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

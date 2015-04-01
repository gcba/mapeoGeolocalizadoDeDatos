/*
**
 ** UNUSED "data/MBTARapidTransitLines.json" old DataStream
 ** 
 **/
//
//import codeanticode.syphon.*;
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
import java.io.FilenameFilter;

ArrayList<dataServices> myServices = new ArrayList<dataServices>();
ArrayList<UnfoldingMap> myMaps = new ArrayList<UnfoldingMap>();
HUDView myHUD = new HUDView();
//SyphonServer server;

UnfoldingMap myBA_map;
plugins myPlugIns;
int actualLayer = 0;
void init()
{
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(displayWidth, displayHeight,OPENGL);
  //server = new SyphonServer(this, "mapedData");
  myHUD = new HUDView();
  myPlugIns = new plugins(); 
  myServices = myPlugIns.getServicesList();

  println("Cantidad de servicios: "+myServices.size());
  for (int i = 0; myServices.size () > i; i++) {
    dataServices data = myServices.get(i);
    myMaps.add( createDataLayer(data.dataTypeView, data.getJSONfile()));
    EventDispatcher eventDispatcher = MapUtils.createDefaultEventDispatcher(this, myMaps.get(i));
  }
  myBA_map = myMaps.get(0);
}


UnfoldingMap createDataLayer(int _mode, String _sfile) {
  UnfoldingMap newMap = mapInit();
  List<Feature> myArea  = GeoJSONReader.loadData(this, _sfile);
  List<Marker> myAreaMarker = MapUtils.createSimpleMarkers(myArea);
  newMap.addMarkers(myAreaMarker);
  return newMap;
  /*
  dataEntriesMap = loadPopulationDensityFromCSV(_sfile+".csv");
   for (Marker marker : countryMarkers) {
   // Find data for country of the current marker
   String countryId = marker.getId();
   DataEntry dataEntry = dataEntriesMap.get(countryId);
   
   // Encode value to transparency (value range: 0-700)
   float alpha = map(dataEntry.value, 0, 700, 10, 255);
   marker.setColor(color(255, 0, 0, alpha));
   }*/
}


//FUNCION DE INICIALIZACION DEL MAPA QUE SE A UTILIZAR
UnfoldingMap mapInit() {
  String tilesStr = sketchPath("data/noMapMBTiles.mbtiles");
  UnfoldingMap oneMap = new UnfoldingMap(this,  new MBTilesMapProvider(tilesStr));
  oneMap.zoomToLevel(12);
  oneMap.panTo(myBA_loc);
  oneMap.setZoomRange(12, 13);
  oneMap.setPanningRestriction(myBA_loc, 10);
  MapUtils.createDefaultEventDispatcher(this, oneMap);
  return oneMap;
}


void keyPressed() {
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
  if (key == '1') {
    actualLayer=0;
    myBA_map = myMaps.get(0);
  } 
  else if (key == '2') {
    actualLayer=1;
    myBA_map = myMaps.get(1);
  } 
  else if (key == '3') {
    actualLayer=2;
    myBA_map = myMaps.get(2);
  }
}

void simpleDalay(int _waitTime) {
  int m = millis()+_waitTime;
  float v = 256;
  int mul = -50;
  while (m > millis ()) {
    loadingImg(v);
    if (v>255) {
      mul*=-1;
    }
    else
      if (v<0) {
        mul*=-1;
      }
    v-=mul;
  }
}

void loadingImg(float alpha) {
  background(0);
  fill(255, alpha);
  text("Cargando..", width/2, height/2);
}

void draw() {
  background(0);
  myBA_map.draw();
  myHUD.draw(actualLayer);
  //server.sendScreen();
}


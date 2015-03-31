/*
**
** UNUSED "data/MBTARapidTransitLines.json" old DataStream
** 
**/
//
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
HUDView myHUD;

DebugDisplay debugDisplay1;
UnfoldingMap myBA_map;

void setup() {
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


void createDataLayer(int _mode, String _sfile) {
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
void mapInit() {
  myBA_map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  myBA_map.zoomToLevel(13);
  myBA_map.panTo(myBA_loc);
  myBA_map.setZoomRange(9, 17);
  myBA_map.setPanningRestriction(myBA_loc, 50);
  MapUtils.createDefaultEventDispatcher(this, myBA_map);
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
}



void draw() {
  myBA_map.draw();
 
}


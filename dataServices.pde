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

  dataServices (String _name, String _host, JSONObject fields, int _type) {
    host = _host;
    wsName = _name;
    dataTypeView = _type;
    updateData(fields);
  }

  void updateData(JSONObject _fields) {
    wsTable = loadTable( host, "header");
    geoJSon = createWriter(getJSONfile()); 
    eCount = wsTable.getRowCount();
    //DEBUG-LINE
    println("loading DataSet: "+wsName+"... 0%");

    if (eCount > 0) {
      String rID = _fields.getString("ID");
      String rName = _fields.getString("NAME");
      JSONArray geoData  = _fields.getJSONArray("GEODATA");
      if (dataTypeView == 2) {
        loadMultipolygon(rID, rName, geoData.getString(0));
      } else 
        if (dataTypeView == 0) {
        loadMarkers(rID, rName, geoData.getString(0), geoData.getString(1));
      }
      lsUpdate = hour()+":"+minute()+":"+second();
      // DEBUG LINE 
      println("Created json file at: "+lsUpdate+", named: \""+getJSONfile()+"\".");
    }
  }

  String getJSONfile() {
    String jsonfile = "data/"+wsName+".json";
    return jsonfile;
  }

  //CARGAR GEODATA (MARKERS)
  private void loadMarkers(String _id, String _nombre, String _lat, String _long) {
    println("loading DataSet: "+wsName+"... 0%");
    geoJSon.println("{\"type\":\"FeatureCollection\",\"features\":[");
    int loadedData = 0;
    for (TableRow row : wsTable.rows ()) {

      int    id       = row.getInt(_id);
      String nombre   = row.getString(_nombre);
      String latitud  = row.getString(_lat);
      String longitud = row.getString(_long);

      if ( nombre.length() > 0 && latitud.length() > 0 && longitud.length() > 0 ) {
        if (nombre.charAt(0) == '"') {
          nombre = nombre.substring(1, nombre.length()-1);
        }
        if (nombre.charAt(nombre.length()-1)=='"') {
          nombre = nombre.substring(0, nombre.length()-1);
        }
        if (loadedData>0) {
          geoJSon.println(",");
        }
        String geojson  = "{\"type\":\"Point\",\"coordinates\":["+latitud+","+longitud+"]}";
        geoJSon.print("{\"type\":\"Feature\",\"properties\":{\"name\":\""+nombre+"\"},\"geometry\":"+geojson+",\"id\":\""+id+"\"}");
      }
      //DEBUG-LINE        
      loadedData++;
      println(">>"+round(loadedData*100/eCount)+"%");
    }
    geoJSon.println("]}");
    geoJSon.flush();
    geoJSon.close();
  }

  //CARGAR GEODATA (MULTIPOLYGON)
  private void loadMultipolygon(String _id, String _name, String _geojson) {
    println("loading DataSet: "+wsName+"... 0%");
    geoJSon.println("{\"type\":\"FeatureCollection\",\"features\":[");
    int loadedData = 0;
    for (TableRow row : wsTable.rows ()) {
      int id = row.getInt(_id);
      String nombre = row.getString(_name);
      String geojson  = row.getString(_geojson);
      if(loadedData >0){print(",")}
      geoJSon.println("{\"type\":\"Feature\",\"properties\":{\"name\":\""+nombre+"\"},\"geometry\":"+geojson+",\"id\":\""+_id+"\"},");
      //DEBUG-LINE        
      loadedData++;
      println(">>"+round(loadedData*100/eCount)+"%");
    }
    geoJSon.println("]}");
    geoJSon.flush();
    geoJSon.close();
  }
}


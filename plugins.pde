class plugins {
  private int Count;
  private String path;
  private String[] pList;
  private ArrayList<dataServices> myDataServices = new ArrayList<dataServices>();

  plugins() {
    setPluginsPath("plugins");
    print("getting plugins list...");
    getPlugInsList();
    println(" DONE!");
    print("loading plugins...");
    myDataServices = loadPlugins();
    println(" DONE!");
  }

  void setPluginsPath(String _newPluginPath) {
    path = _newPluginPath;
  }

  private ArrayList<dataServices> loadPlugins() {
    ArrayList<dataServices> loadedPlugins = new ArrayList<dataServices>();
    for (int i=1; i<pList.length; i++) {

      if ((pList[i] != ".DS_Store")) {
        println("Loading: "+path+"/"+pList[i]);
        JSONObject plugIn = loadJSONObject(path+"/"+pList[i]);
        int id = plugIn.getInt("ID");
        String nombre = plugIn.getString("NOMBRE");
        int dataType = plugIn.getInt("DATA_GTYPE");
        String host = plugIn.getString("HOST_LOCAL")+"."+plugIn.getString("DATA_FORMAT");
        JSONObject campos=plugIn.getJSONObject("FIELDS");
        loadedPlugins.add(new dataServices(plugIn.getString("HOST_LOCAL"), host, campos, dataType));
      }
    }

    return loadedPlugins;
  }

  private void getPlugInsList() {
    File f = dataFile(path);
    pList = f.list();
  }
  String[] getList() {
    return pList;
  }

  ArrayList<dataServices> getServicesList() {
    return myDataServices;
  }
}


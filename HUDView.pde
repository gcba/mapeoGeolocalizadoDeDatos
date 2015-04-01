
/**
 ** Pequeño hud para presentacion de menu y/o data
 **/

class HUDView {
  private float    hudWidth;
  private float    hudHeight;
  private float    hudOpacity;
  private boolean  hudVisible = false;
  String _caption ="SOME CAPTION";
  String _xplain ="Some text explaining nothing...";


  HUDView() {
    SetSize(width/3, height/8);
    hudOpacity = 20;
  }

  void SetSize(float xSize, float ySize) {
    hudWidth = xSize;
    hudHeight = ySize;
  }

  void ToggleView() {
    hudVisible = !hudVisible;
  }
  void disclaimer(String disclaimerTxt){
  int fZise = 10;
  
  text("disclaimerTxt",2,2);
  }
  
  void draw(int idLayer) {
    dataServices servTemp = myServices.get(idLayer);
    String rName = servTemp.longName;
    String wHost = servTemp.wanHost;
    String dServ = servTemp.serv_desc;
    int fontSize = 8;
    if (hudVisible) {
      fill(20, 205, 242, hudOpacity);
      rectMode(CORNER);
      strokeWeight(0.7f);
      stroke(20, 205, 242,50);
      
      rect(hudWidth*2-15, height-hudHeight*1.2f, hudWidth, hudHeight);
      textSize(20);
      fill(255,95);
      text(rName,hudWidth*2,950);
      fill(255,70);
      textSize(14);
      text(dServ,hudWidth*2,970);
      fill(255,60);
      textSize(10.5f);
      text("["+wHost+"]",hudWidth*2,1035);
      //text();
      //text();      
      
    }
    else {
      fill(100,100,100);
      String hintTxt = "Presionar [h] para mostrar hud...";
      textSize(11);
      text(hintTxt,width-fontSize*hintTxt.length(),height-50); 
    }
  }
}


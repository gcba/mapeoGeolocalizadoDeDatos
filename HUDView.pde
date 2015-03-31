
/**
 ** Pequeño hud para presentacion de menu y/o data
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

  void SetSize(float xSize, float ySize) {
    hudWidth = xSize;
    hudHeight = ySize;
  }

  void ToggleView() {
    hudVisible = !hudVisible;
  }

  void hPrint() {
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


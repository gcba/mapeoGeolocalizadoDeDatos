void keyPressed() {
  switch(key) {
  case 'r': { running =!running; break; }
  case 'R': 
    {
      running =!running; 
      break;
    }
  case 'm' :{
              if (!showMap) {
                background(0);
                image(loadImage("mapBA-01.png"), 0, 0); 
                image(drawEst(), 0, 0);
              } else {
                background(0);
                image(drawEst(), 0, 0);
              }
              showMap = !showMap; break; }
  case 'l': { SHOW_LABELS = !SHOW_LABELS; }
  case 'i' :{
              running = false;
              clock = new timeStamp(TIME2RESET);
              background(0);
              if (!showMap) {
        
                image(loadImage("mapBA-01.png"), 0, 0);
              } 
              image(drawEst(), 0, 0);
              running = true;
            }
  }
}


//LABELS CONF
boolean SHOW_LABELS = false;
final int     LABEL_SIZE = 9;

//STATIONS CONF
final int STATION_SIZE = 12;

final int SECONDS_SPEED = 60;//10 FOR CAPTURE
final int MINUTES_SPEED = 1;
final int HOURS_SPEED = 1;

String TIME2RESET= "2014-01-01 00:00:00.000";

boolean running = false;
boolean showMap = false;

timeStamp clock = new timeStamp(TIME2RESET);
//SUBWAY DATASET DATE

String DATASET_DAY = TIME2RESET.substring(0,11);;
//Subway Stations color settings
 int[] lineA = {1  ,191,224};
 int[] lineB = {255,0  ,0  };
 int[] lineC = {0  ,0  ,255};
 int[] lineD = {0  ,255,0  };
 int[] lineE = {168,0  ,168};
 int[] lineH = {255,228,0  };
 
//Subway Stations size settings
final int MAX_STATION_SIZE = 200;// pixels.
final int MIN_STATION_SIZE = 0;// pixels.
final int NORMAL_STATION_SIZE = 10;// pixels.
final float AUTO_DEC_SIZE = 8;// pixels.
final float EASING = 0.05;


int MAX_PERSONS = 0;
final int MIN_PERSONS = 1;

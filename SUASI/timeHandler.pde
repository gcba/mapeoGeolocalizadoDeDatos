class timeStamp {
  int segs; 
  int mins; 
  int hours;
  int days; 
  int months; 
  int year;

  timeStamp(String _sTimeStamp) {
    year = parseInt(_sTimeStamp.substring(0, 4)); 
    months = parseInt(_sTimeStamp.substring(5, 7)); 
    days = parseInt(_sTimeStamp.substring(8, 10));
    hours = parseInt(_sTimeStamp.substring(11, 13)); 
    mins = parseInt(_sTimeStamp.substring(14, 16)); 
    days = parseInt(_sTimeStamp.substring(17, 19));
  }
}

void upDateClock() {
  if (running) {
    clock.segs+=SECONDS_SPEED;
      if (clock.segs>=60) {
      clock.segs =0;
      clock.mins+=MINUTES_SPEED;
    }
    if (clock.mins>=60) {
      clock.mins = 0;
      clock.hours+=HOURS_SPEED;
    }
    if(clock.hours >= 24){
    running = false;
    clock.hours=0;
    }
    println(">> "+clock.hours+":"+clock.mins+":"+clock.segs+" hrs.");
  }
}

int difTime(timeStamp clock, timeStamp tTime){
  int clockInMinutes = round(clock.hours*60+clock.mins+clock.segs*0.0166666667f);
  int timeInMinutes = round(tTime.hours*60+tTime.mins+tTime.segs*0.0166666667f);
  return clockInMinutes-timeInMinutes;
}




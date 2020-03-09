class Timer{
  
  int startMillis = 0;
  float lastNow;
  public Timer(){
    start();
  }
  
  
  void start(){
    startMillis = millis();
    
    lastNow = 0;
  }
  
  // returns the elapsed time since you last called this function
  float getElapsedTime(){
    float now =  getTimeSinceStart();
    float elapsedTime = now - lastNow;
    lastNow = now;
    return elapsedTime;    
  }
  
  float getTimeSinceStart(){
    return ((millis()-startMillis)/1000.0);
  }  
}

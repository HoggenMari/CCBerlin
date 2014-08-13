import DmxAhl.*;

DMXController dmx;
LEDScreen screen1, screen2;
PGraphics pg;

void setup(){
  
  pg = createGraphics(16,12,JAVA2D);

  screen1 = new LEDScreen(16, 12);
  screen1.update(pg);
    
  dmx = new DMXController("224.1.1.1", 5026, 4);  
  dmx.add(screen1);
  dmx.add(screen2);
  dmx.start();
    
}

void draw(){
  
}


/* --------------------------------------------------------------------------
 * SimpleOpenNI DepthImage Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import AhlDmx.*;
import SimpleOpenNI.*;
import processing.video.*;
import deadpixel.keystone.*;



SimpleOpenNI  context;
Capture cam;
DMXController dmx;
LEDScreen screen1, screen2, screen3, screen4, screen5, screen6, screen7, screen8;
PGraphics pg1,pg2,pg3,pg4,offscreen1,offscreen2,offscreen3;

Keystone ks;
CornerPinSurface surface1, surface2, surface3;

int x=0;
int y=0;

int[] userMap; 

void setup()
{
  size(1920, 1200, P3D);
  
  pg1 = createGraphics(4,4,JAVA2D);
  pg2 = createGraphics(4,4,JAVA2D);
  pg3 = createGraphics(4,4,JAVA2D);
  pg4 = createGraphics(4,4,JAVA2D);

    
  screen1 = new LEDScreen(4, 4);
  screen1.update(pg1);
  screen2 = new LEDScreen(4, 4);
  screen2.update(pg2);
  screen3 = new LEDScreen(4, 4);
  screen3.update(pg3);
  screen4 = new LEDScreen(4, 4);
  screen4.update(pg4);
  screen5 = new LEDScreen(4, 4);
  screen5.update(pg4);
  screen6 = new LEDScreen(4, 4);
  screen6.update(pg4);
  screen7 = new LEDScreen(4, 4);
  screen7.update(pg4);
  screen8 = new LEDScreen(4, 4);
  screen8.update(pg4);
  
  dmx = new DMXController("224.1.1.1", 5026, 4);  
  dmx.add(screen1);
  dmx.add(screen2);
  dmx.add(screen3);
  dmx.add(screen4);
  dmx.add(screen5);
  dmx.add(screen6);
  dmx.add(screen7);
  dmx.add(screen8);
  dmx.start();
  
  ks = new Keystone(this);
  surface1 = ks.createCornerPinSurface(400, 400, 20);
  surface2 = ks.createCornerPinSurface(400, 400, 20);
  surface3 = ks.createCornerPinSurface(400, 400, 20);

  
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // mirror is by default enabled
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();

  // enable ir generation
  context.enableRGB();
  
  context.enableUser();
  
  
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();
  
  offscreen1 = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(640, 480, P3D);
  offscreen3 = createGraphics(400, 400, P3D);


}

void draw()
{
  
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface1.getTransformedMouse();
  
  
  // update the cam
  context.update();

  background(0, 0, 0);

  // draw depthImageMap
  //image(context.depthImage(), 0, 0);

  // draw irImageMap
  //image(context.rgbImage(), context.depthWidth() + 10, 0);
  
  if (cam.available() == true) {
    cam.read();
  }
  //image(cam, context.depthWidth()*2, 0);
  
    // Draw the scene, offscreen
  offscreen1.beginDraw();
  offscreen1.background(255,0,0);
  offscreen1.noFill();
  offscreen1.stroke(255,255,255);
  offscreen1.strokeWeight(20);
  offscreen1.rect(0,0,x,y);
  //offscreen.image(cam,0,0);
  offscreen1.endDraw();
  surface1.render(offscreen1);

  if(x>offscreen1.width){
    x=0;
  }
  if(y>offscreen1.height){
    y=0;
  }
  
  x++;
  y++;
  
    // Draw the scene, offscreen
  offscreen2.beginDraw();
  offscreen2.background(255,255,255);
  //offscreen.image(cam,0,0);
  //offscreen2.image(context.depthImage(),0,0);
  if(context.getNumberOfUsers() > 0) 
  {    
    userMap = context.userMap();
    offscreen2.loadPixels();
    for(int i = 0; i < userMap.length; i++) 
    {
      if (userMap[i] !=0) 
      {
        //pixels[i] = context.rgbImage().pixels[i];
        offscreen2.pixels[i] = color(0,0,255);
        //println("true");
      }
    }
    offscreen2.updatePixels();
  }  
  offscreen2.endDraw();
  surface2.render(offscreen2);
  
      // Draw the scene, offscreen
  offscreen3.beginDraw();
  offscreen3.background(0,0,255);
  //offscreen.image(cam,0,0);
  offscreen3.endDraw();
  surface3.render(offscreen3);


  
  pg1.beginDraw();
  pg1.background(255,255,255);
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg1.set(ix,iy,c);
    }
  }  
  //pg1.image(cam,0,0,4,4);
  pg1.endDraw();
  
  pg2.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      println(c);
      pg2.set(ix,iy,c);
    }
  } 
  pg2.background(255,255,255);
  pg2.endDraw();
  
  pg3.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      println(c);
      pg3.set(ix,iy,c);
    }
  } 
  pg3.background(255,255,255);
  pg3.endDraw();
  
  pg4.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      println(c);
      pg4.set(ix,iy,c);
    }
  }
  pg4.background(255,255,255); 
  pg4.endDraw();
  
  image(pg1,0,0);
  
  screen1.update(pg1);
  screen2.update(pg2);
  screen3.update(pg3);
  screen4.update(pg4);
  screen5.update(pg4);
  screen6.update(pg4);
  screen7.update(pg4);
  screen8.update(pg4);
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}


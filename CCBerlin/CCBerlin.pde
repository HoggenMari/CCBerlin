
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
import processing.serial.*;



SimpleOpenNI  context;
Capture cam;
DMXController dmx;
LEDScreen screen1, screen2, screen3, screen4, screen5, screen6, screen7, screen8;
PGraphics pg,pg1,pg2,pg3,pg4,offscreen1,offscreen2,offscreen3;

Keystone ks;
CornerPinSurface surface1, surface2, surface3,surface4, surface5, surface6;

int x=0;
int y=0;

int[] userMap; 

Serial myPort;       


//structure
int  d=6;

float[][] val ;
float xSize,ySize;
float increment = 0.03;
float zoff = 0.0;
float zincrement = 0.01;
int t=0;
int br=0;

static String ARDUINO_DEVICE = null;
static int lf = 10;

double num;
String myString;

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
  surface1 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface2 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface3 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface4 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface5 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface6 = ks.createCornerPinSurface(62*6, 62*6, 20);
  
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


  //structure
  val = new float[400][400];
  xSize = 400;
  ySize = 400;
  
  
  val = new float[63][63];
  xSize = 63;
  ySize = 63;
  pg = createGraphics(63*6,63*6,P3D);
  
  // List all the available serial ports:
  println(Serial.list());
  
  for (int i = 0; i < Serial.list().length; i++) {
    System.out.println("Device " + i + " " + Serial.list()[i]);
    if(Serial.list()[i].contains("/dev/tty.HC-05")){
      ARDUINO_DEVICE = Serial.list()[i];
    }
  }
    

  // Open the port you are using at the rate you want:
  if(ARDUINO_DEVICE!=null){
  myPort = new Serial(this, ARDUINO_DEVICE, 38400);
  }else{
    exit();
  }
    
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
  offscreen1.background(0,0,0);
  offscreen1.noFill();
  offscreen1.stroke(255,255,255);
  offscreen1.strokeWeight(20);
  //offscreen1.rect(0,0,x,y);
  //offscreen.image(cam,0,0);
  offscreen1.image(pg,0,0);
  offscreen1.endDraw();

  if(x>offscreen1.width){
    x=0;
  }
  if(y>offscreen1.height){
    y=0;
  }
  x++;
  y++;
  
    // Draw the scene, offscreen
  offscreen1.beginDraw();
  offscreen1.image(cam,0,0,62*6,62*6);
  //offscreen2.background(255,255,255);
  //offscreen.image(cam,0,0);
  //offscreen2.image(context.depthImage(),0,0);
  
  PGraphics pgSaver = createGraphics(640,480);
  pgSaver.beginDraw();
  if(context.getNumberOfUsers() > 0) 
  {    
    userMap = context.userMap();
    pgSaver.background(255);
    pgSaver.loadPixels();
    for(int i = 0; i < userMap.length; i++) 
    {
      if (userMap[i] !=0) 
      {
        //pixels[i] = context.rgbImage().pixels[i];
        pgSaver.pixels[i] = color(0,0,0);
        //println("true");
      }
    }
    pgSaver.updatePixels();
  }  
  pgSaver.endDraw();
  
  for(int ix=0; ix<offscreen1.width; ix++){
    for(int iy=0; iy<offscreen1.height; iy++){
      if(pgSaver.get(ix,iy) == color(0,0,0)){
        color c1 = color(0,0,0,100);
        offscreen1.set(ix,iy,c1);
      }
    }
  }
    offscreen1.endDraw();
    surface1.render(offscreen1);

  surface2.render(offscreen1);
  
      // Draw the scene, offscreen
  offscreen3.beginDraw();
  offscreen3.background(0,0,255);
  //offscreen.image(cam,0,0);
  offscreen3.endDraw();
  surface3.render(offscreen1);

  surface4.render(offscreen1);
  surface5.render(offscreen1);
  surface6.render(offscreen1);

  
  pg1.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg1.set(ix,iy,c);
    }
  }  
  pg1.background(255);
  //pg1.image(cam,0,0,4,4);
  pg1.endDraw();
  
  pg2.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg2.set(ix,iy,c);
    }
  } 
  pg2.background(255,255,255);
  pg2.endDraw();
  
  pg3.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg3.set(ix,iy,c);
    }
  } 
  pg3.background(255,255,255);
  pg3.endDraw();
  
  pg4.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg4.set(ix,iy,c);
    }
  }
  pg4.background(255,255,255); 
  pg4.endDraw();
  

  
  
  //image(pg1,0,0);
  
  screen1.update(pg1);
  screen2.update(pg1);
  screen3.update(pg1);
  screen4.update(pg1);
  screen5.update(pg1);
  screen6.update(pg1);
  screen7.update(pg1);
  screen8.update(pg1);
  
  drawStructure();
  
  //image(pg,0,0);
  
  
  stroke(0);
  rect(50,(int)num,10,10);
  
  //image(cam, 0, 0);
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


void drawStructure(){
  
if(t>100){
    t=0;
  }
  t++;
  
if(br>255){
  br=0;
}
br++;

  //t=(int)(random(0,100));
  pg.beginDraw();
  pg.background(0);
  pg.lights();
  pg.fill(255, 0, 175);
  //stroke(0, 150, 150);
  pg.noStroke();
  /*camera(2000, 2000, 2000,
         0, 0, 0, // centerX, centerY, centerZ
        -1.0, 1.0, -1.0); // upX, upY, upZ*/
  //translate(0, height/2, -300);
  //rotateX(70);

 noiseSeed(1);
  float xoff = 0.0; // Start xoff at 0
  noiseDetail(8,0.3);
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < 63; x++) {
    xoff += increment;   // Increment xoff
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < 63; y++) {
      yoff += increment; // Increment yoff
      float z = noise(xoff,yoff,zoff)*600;
      val[x][y] = t*sin(0.4*x+5)+t*sin(0.4*y+5);
    }
  }

 for (int x=0; x<xSize-1; x++){
    for(int y=0; y<ySize-1; y++){
      pg.fill((val[x][y])+50,(val[x][y])+20,(val[x][y])+20);
      pg.beginShape();
      pg.vertex(x*d, y*d, 0);
      pg.vertex( x*d+d, y*d, 0);
      pg.vertex(x*d+d, y*d+d, 0);
      pg.vertex(x*d, y*d+d,0);
      pg.endShape(CLOSE);
    }
  }
  zoff += zincrement; // Increment zoff
  pg.endDraw();
  //image(pg,0,0);
  
}

void serialEvent(Serial myPort){
  try {
    myString = myPort.readStringUntil(lf);
    num = Double.parseDouble(myString);
  } catch (Exception e) {
     
  }
}


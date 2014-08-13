/* --------------------------------------------------------------------------
 * SimpleOpenNI Scene Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
import processing.video.*;


SimpleOpenNI  context;
Capture cam;

void setup()
{

  String[] cameras = Capture.list();

  cam = new Capture(this, cameras[15]);

    cam.start();

  context = new SimpleOpenNI(this);

  // enable depthMap generation
  if(context.enableScene() == false)
  {
     println("Can't open the sceneMap, maybe the camera is not connected!");
     exit();
     return;
  }

  background(200,0,0);
  size(context.sceneWidth()*2 , context.sceneHeight());
}

void draw()
{

  if (cam.available() == true) {
    cam.read();
  }
  image(cam, context.sceneWidth(), 0);

  // update the cam
  context.update();

  // draw irImageMap
  image(context.sceneImage(),0,0);

  PImage col = new PImage(context.sceneWidth(),context.sceneHeight());
  for(int ix=0; ix<context.sceneWidth(); ix++){
    for(int iy=0; iy<context.sceneHeight(); iy++){
      if(context.sceneImage().get(ix,iy)!=color(0,0,0)){
        //println("true");
        col.set(ix,iy,cam.get(ix,iy));
      }
    }
  }

  image(col, 0, 0);

  // // gives you a label map, 0 = no person, 0+n = person n
  // int[] map = new int[context.sceneWidth() * context.sceneHeight()];
  // context.sceneMap(map);

  // // get the floor plane
  // PVector point = new PVector();
  // PVector normal = new PVector();
  // context.getSceneFloor(point,normal);

}

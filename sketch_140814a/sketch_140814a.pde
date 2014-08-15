/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/11381*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

int  d=6;

float[][] val ;
float xSize,ySize;
float increment = 0.0003;
float zoff = 0.0;
float zincrement = 0.0001;
int t=0;

PGraphics pg;

void setup(){
  //smooth();
  size(800, 800, P3D);
  val = new float[63][63];
  xSize = 63;
  ySize = 63;
  pg = createGraphics(63*6,63*6,P3D);
}


void draw(){

  if(t>100){
    t=0;
  }
  t++;
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
      pg.fill((val[x][y])+20,(val[x][y])+20,(val[x][y])+20);
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
  image(pg,0,0);
}

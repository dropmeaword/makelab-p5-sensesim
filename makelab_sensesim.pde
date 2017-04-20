import controlP5.*;
import gab.opencv.*;
import java.util.*;
import peasy.*;

ControlP5 cp5;
PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3; 

int threshold = 100;
int detail = 100;
int sensitivity = 30;

final static int GRID_H = 8;
final static int GRID_W = 6;

SensorGrid grid;
LightGrid Lgrid;

PGraphics view2d;

PVector track;
PVector cursor;
Contour contour;

void init_gui() {
  cp5 = new ControlP5(this);

  cursor = new PVector(100, 100);

  //Group g1 = cp5.addGroup("g1")
  //              .setPosition(cursor.x, cursor.y)
  //              .setBackgroundHeight(100)
  //              .setBackgroundColor(color(255,50))
  //              ;


  cursor.y = 500;
  cursor.x = 40;

  cursor.y += 15;
  cp5.addSlider("detail")
    .setPosition(cursor.x, cursor.y)
    .setRange(0, 16)
    //.setGroup(g1)
    ;

  cursor.y += 15;
  cp5.addSlider("threshold")
    .setPosition(cursor.x, cursor.y)
    .setRange(0.01, 12)
    //.setGroup(g1)
    ;

  cursor.y += 15;
  cp5.addSlider("sensitivity")
    .setPosition(cursor.x, cursor.y)
    .setRange(0, 5000)
    //.setGroup(g1)
    ;

  cp5.setAutoDraw(false);
}

void setup() {
  size(1024, 600, P3D);
  g3 = (PGraphics3D)g;
  grid = new SensorGrid(GRID_W, GRID_H);
  Lgrid = new LightGrid(GRID_W, GRID_H);
  track = new PVector(0, 0, 0);

  view2d = createGraphics(800, 600, P3D);

  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1000);

  init_gui();
}


void draw_cp5_gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.draw();
  g3.camera = currCameraMatrix;
}

void draw_gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  view2d.beginDraw();
  int xloc = 40;
  int yloc = 40;

  track.x = mouseX - xloc;
  track.y = mouseY - yloc;

  grid.sense(track.x, track.y);
  grid.draw(view2d, xloc, yloc);
  Lgrid.draw(view2d, xloc+400, yloc);
  view2d.endDraw();

  image(view2d, 0, 0);

  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);

  
}

void update() {
  // was used to update the contour
}

void draw() {
  //camera(150,150,150,50,50,40,0,0,-1);
  //lights();

  background(0);

  //update();

  ////float cameraY = 200; //height/8.0;
  ////float fov = 1000/float(width) * PI/2;
  ////float cameraZ = cameraY / tan(fov / 2.0);
  ////float aspect = float(width)/float(height);
  ////perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);

  pushMatrix();
  translate(-10, -200);
  //contour.draw(0.001f);
  popMatrix();

  cam.beginHUD();
  draw_cp5_gui();
  cam.endHUD();

  draw_gui();
}
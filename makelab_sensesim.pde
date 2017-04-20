import controlP5.*;
import gab.opencv.*;
import java.util.*;
import peasy.*;
import hypermedia.net.*;
UDP udps;

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
Person []person;

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
  person = new Person[5];
  for (int i =0; i < person.length; i++) {
    PVector pos = new PVector(0, 0, 0);
    person[i]  = new Person(pos);
  }

  view2d = createGraphics(800, 600, P3D);

  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1000);

  init_gui();

  Lgrid.setCurrentAnimation(new Rest(50, 5, 5000, Lgrid.bounds(), Lgrid.Xoffset));
  //Lgrid.setCurrentAnimation(new Attack(100, Lgrid.bounds(), Lgrid.Xoffset));
  //Lgrid.setCurrentAnimation(new Sleep(1000));
  //Lgrid.setCurrentAnimation(new Lure(50, 2, 2000, Lgrid.bounds(), Lgrid.Xoffset));
  //there should be an "animation" added where 


  udps = new UDP( this, 6005 ); // this is the for the communication with Grasshopper
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
  for (int i = 0; i < person.length; i++) {
    //fill(255, 255, 0);
    ellipse(person[i]._pos.x, person[i]._pos.y, 20, 20);
    //println(person[0]._pos.x-xloc, person[0]._pos.y-yloc);
    //grid.sense(person[0]._pos.x-xloc, person[0]._pos.y-yloc);
  }

  grid.draw(view2d, xloc, yloc);
  Lgrid.draw(view2d, xloc, yloc);

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

  cam.beginHUD();
  draw_cp5_gui();
  cam.endHUD();

  draw_gui();
}



void mousePressed() {
  if (mouseButton == LEFT) {
  } else if (mouseButton == RIGHT) {
    PVector pos = new PVector(mouseX, mouseY, 0);
    person[0]._pos = pos;
  }
}
import ComputationalGeometry.*;
import gab.opencv.*;
import processing.video.*;
import java.util.*;
import peasy.*;

PeasyCam cam;

final static int GRID_H = 7;
final static int GRID_W = 7;

SensorGrid grid;

PGraphics view2d;

PVector track;
Contour contour;

void setup() {
  size(1024, 480, P3D);
  grid = new SensorGrid(GRID_W, GRID_H);
  track = new PVector(0 , 0, 0);

  view2d = createGraphics(800, 600, P3D);

  contour = new Contour(this, grid);
  contour.append( grid.getNodePositions() );

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}


void draw_gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  fill(255);
  
  view2d.beginDraw();
  int xloc = 40;
  int yloc = 40;

  track.x = mouseX - xloc;
  track.y = mouseY - yloc;
  
  grid.sense(track.x, track.y);
  grid.draw(view2d, xloc, yloc);
  view2d.endDraw();
  
  image(view2d, 0, 0);

  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void draw() {
  //camera(150,150,150,50,50,40,0,0,-1);
  lights();

  background(0);

  //float cameraY = 200; //height/8.0;
  //float fov = 1000/float(width) * PI/2;
  //float cameraZ = cameraY / tan(fov / 2.0);
  //float aspect = float(width)/float(height);
  //perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);

  contour.draw(0.001);
  
  draw_gui();
}
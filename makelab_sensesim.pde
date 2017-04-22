import controlP5.*;
import gab.opencv.*;
import java.util.*;
import peasy.*;
// import hypermedia.net.*;

import oscP5.*;
import netP5.*;

// UDP udps;

OscP5 ffosc; // incoming OSC for Firefly/Grasshopper
OscP5 oscin; // incoming OSC from the hardware nodes


ControlP5 cp5;
PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

int threshold = 100;
int detail = 100;
int sensitivity = 30;
boolean testpattern = false;

SensorGrid grid;
LightGrid Lgrid;

Behaviour behave;
// Control communication;

PGraphics view2d;

PVector track;
PVector cursor;
Contour contour;
Person []person;
PVector []path;
PVector []path2;

String pathData =  "3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,7 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,7 4,7 4,7 4,7 4,7 4,7 4,7 5,7 5,7 5,7 5,7 5,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 5,5 5,5 5,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 3,4 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,4 3,4 3,4 3,4 3,4 2,4 2,4 2,4 2,4 2,4 1,4 1,4 1,4 1,4 1,4 0,3 0,3 0,3 0,3 0,2 0,2 0,2 0,2 0,2 0,1 0,1 0,1 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 0,1 0,1 0,1 0,0 0,0 0,0 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,0 1,0 2,1 2,1 2,1 2,1 3,1 3,1 3,1 3,1 3,1 3,2 3,2 3,2 3,2 3,2 3,2 3,3 3,3 3,3 2,3 2,3 2,3 2,3 2,4 2,4 2,4 2,4 2,4 2,4 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 2,5 2,5 2,5 2,5 2,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 3,5 3,4 3,4 3,4 3,4 3,4 3,4 3,4 2,4 2,4 2,3 2,3 2,3 2,3 2,3 1,2 1,2 1,2 1,2 1,2 1,2 1,2 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 1,0 1,0 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 1,1 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 1,0 1,0 2,1 2,1 2,1 2,1 2,1 3,2 3,2 3,2 3,2 3,2 3,2 2,2 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 1,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,1 3,1 3,1 3,1 3,2 3,2 3,2 2,2 2,2 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,1 3,2 3,2 3,2 2,2 2,2 2,2 2,2 2,3 2,3 2,3 2,3 1,2 1,2 1,2 1,2 1,2 1,2 1,2 1,1 1,1 1,1 1,1 1,1 2,1 2,1 2,1 2,1 2,1 3,1 3,1 3,2 3,2 3,2 3,2 3,2 3,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 1,1 1,1 1,1 1,1 1,1 2,1 2,2 2,2 2,2 3,2 3,2 3,3 3,3 3,3 3,3 3,3 3,4 3,4 3,4 3,4 3,4 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 4,4 4,4 4,4 3,4 3,4 3,4 3,4 3,4 3,4 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 5,6 5,6 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 2,5 2,5 2,5 2,5 3,6 3,6 3,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 3,5 3,5 3,5 3,4 3,4 3,4 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,5 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,5 4,5 4,5 4,5 4,5 4,5 3,4 3,4 3,4 3,4 3,4 3,4 3,4 2,3 2,3 2,3 2,3 2,3 2,3 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,1 1,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 2,2 2,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 0,1 1,1 1,1 1,1 1,1 1,1 1,0 1,0 1,0 1,0 1,0 2,1 2,1 2,1 2,1 2,1 2,1 2,1 2,2 2,2 2,2 2,2 2,2 2,2 2,3 2,3 2,3 2,3 2,3 1,2 1,2 1,2 1,2 1,2 1,2 1,2 0,1 0,1 4,5 3,5 2,5 2,5 1,4 1,4 0,3 0,2 1,2 1,1 1,1 1,0 1,0 2,0 3,1 3,1 3,1 4,2 3,2 3,2 2,2 1,2 1,3 1,4 1,4 1,5 1,5 1,6 1,6 1,6 1,6 2,6 2,6 3,6 3,6 4,6 4,6 4,6 4,5 4,5 4,4 4,4 3,3 3,3 3,2 3,2 3,1 4,1 4,1 4,1 4,2 4,2 4,3 4,3 4,4 4,4 3,4 3,4 3,4 3,3 3,3 2,2 2,2 2,1 1,1 1,1 1,1 1,2 1,2 0,2 0,3 0,4 0,4 0,5 0,5 0,6 0,6 0,6 1,7 1,7 1,6 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 5,6 5,6 5,6 5,6 5,5 4,5 4,5 3,4 3,4 3,5 2,5 2,5 2,5 1,5 1,4 1,4 1,3 1,3 2,3 2,3 2,3 3,3 3,3 4,3 4,3 4,2 4,2 4,2 3,1 2,1 2,1 2,1 1,1 1,1 1,1 1,1 0,0 0,0 0,0 1,0 1,0 2,0 3,0 3,0 4,1 4,1 4,1 4,1 4,1 4,1 4,0 4,0 3,0 3,0 3,0 3,1 3,1 3,2 3,3 3,3 3,3 3,4 4,4 4,5 3,5 3,5 3,6 3,5 2,5 2,4 3,4 3,4 3,3 3,3 3,2 2,2 2,2 1,2 1,3 1,4 2,5 2,5 2,6 2,6 1,6 1,6 1,6 1,6 1,7 1,7 1,6 1,6 1,6 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 5,7 5,7 5,7 5,6 5,5 5,5 5,4 5,3 5,3 5,3 5,2 5,2 5,1 5,1 5,1 5,0 5,0 5,0 5,0 5,0 4,0 4,0 4,0 4,0 3,0 3,0 3,0 2,0 2,0 1,0 1,0 0,0 0,0 0,1 0,1 0,1 0,2 0,2 0,2 0,3 0,3 0,4 0,5 0,5 0,5 0,6 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,7 2,7 2,7 2,7 3,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,6 5,5 5,5 5,4 5,4 5,3 5,2 4,2 4,2 4,3 4,3 3,4 3,4 2,4 2,5 2,5 1,5 1,5 1,5 0,4 1,3 1,3 2,3 2,2 3,2 3,2 3,1 3,1 3,1 2,0 2,0 2,0 2,0 3,0 4,1 4,2 4,2 4,3 4,4 4,4 4,5 4,5 3,5 2,5 2,5 1,4 1,4 0,3 0,2 1,2 1,1 1,1 1,0 1,0 2,0 3,1 3,1 3,1 4,2 3,2 3,2 2,2 1,2 1,3 1,4 1,4 1,5 1,5 1,6 1,6 1,6 1,6 2,6 2,6 3,6 3,6 4,6 4,6 4,6 4,5 4,5 4,4 4,4 3,3 3,3 3,2 3,2 3,1 4,1 4,1 4,1 4,2 4,2 4,3 4,3 4,4 4,4 3,4 3,4 3,4 3,3 3,3 2,2 2,2 2,1 1,1 1,1 1,1 1,2 1,2 0,2 0,3 0,4 0,4 0,5 0,5 0,6 0,6 0,6 1,7 1,7 1,6 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 5,6 5,6 5,6 5,6 5,5 4,5 4,5 3,4 3,4 3,5 2,5 2,5 2,5 1,5 1,4 1,4 1,3 1,3 2,3 2,3 2,3 3,3 3,3 4,3 4,3 4,2 4,2 4,2 3,1 2,1 2,1 2,1 1,1 1,1 1,1 1,1 0,0 0,0 0,0 1,0 1,0 2,0 3,0 3,0 4,1 4,1 4,1 4,1 4,1 4,1 4,0 4,0 3,0 3,0 3,0 3,1 3,1 3,2 3,3 3,3 3,3 3,4 4,4 4,5 3,5 3,5 3,6 3,5 2,5 2,4 3,4 3,4 3,3 3,3 3,2 2,2 2,2 1,2 1,3 1,4 2,5 2,5 2,6 2,6 1,6 1,6 1,6 1,6 1,7 1,7 1,6 1,6 1,6 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 5,7 5,7 5,7 5,6 5,5 5,5 5,4 5,3 5,3 5,3 5,2 5,2 5,1 5,1 5,1 5,0 5,0 5,0 5,0 5,0 4,0 4,0 4,0 4,0 3,0 3,0 3,0 2,0 2,0 1,0 1,0 0,0 0,0 0,1 0,1 0,1 0,2 0,2 0,2 0,3 0,3 0,4 0,5 0,5 0,5 0,6 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,7 2,7 2,7 2,7 3,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,6 5,5 5,5 5,4 5,4 5,3 5,2 4,2 4,2 4,3 4,3 3,4 3,4 2,4 2,5 2,5 1,5 1,5 1,5 0,4 1,3 1,3 2,3 2,2 3,2 3,2 3,1 3,1 3,1 2,0 2,0 2,0 2,0 3,0 4,1 4,2 4,2 4,3 4,4 4,4 4,5 4,5 3,5 2,5 2,5 1,4 1,4 0,3 0,2 1,2 1,1 1,1 1,0 1,0 2,0 3,1 3,1 3,1 4,2 3,2 3,2 2,2 1,2 1,3 1,4 1,4 1,5 1,5 1,6 1,6 1,6 1,6 2,6 2,6 3,6 3,6 4,6 4,6 4,6 4,5 4,5 4,4 4,4 3,3 3,3 3,2 3,2 3,1 4,1 4,1 4,1 4,2 4,2 4,3 4,3 4,4 4,4 3,4 3,4 3,4 3,3 3,3 2,2 2,2 2,1 1,1 1,1 1,1 1,2 1,2 0,2 0,3 0,4 0,4 0,5 0,5 0,6 0,6 0,6 1,7 1,7 1,6 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 5,6 5,6 5,6 5,6 5,5 4,5 4,5 3,4 3,4 3,5 2,5 2,5 2,5 1,5 1,4 1,4 1,3 1,3 2,3 2,3 2,3 3,3 3,3 4,3 4,3 4,2 4,2 4,2 3,1 2,1 2,1 2,1 1,1 1,1 1,1 1,1 0,0 0,0 0,0 1,0 1,0 2,0 3,0 3,0 4,1 4,1 4,1 4,1 4,1 4,1 4,0 4,0 3,0 3,0 3,0 3,1 3,1 3,2 3,3 3,3 3,3 3,4 4,4 4,5 3,5 3,5 3,6 3,5 2,5 2,4 3,4 3,4 3,3 3,3 3,2 2,2 2,2 1,2 1,3 1,4 2,5 2,5 2,6 2,6 1,6 1,6 1,6 1,6 1,7 1,7 1,6 1,6 1,6 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 5,7 5,7 5,7 5,6 5,5 5,5 5,4 5,3 5,3 5,3 5,2 5,2 5,1 5,1 5,1 5,0 5,0 5,0 5,0 5,0 4,0 4,0 4,0 4,0 3,0 3,0 3,0 2,0 2,0 1,0 1,0 0,0 0,0 0,1 0,1 0,1 0,2 0,2 0,2 0,3 0,3 0,4 0,5 0,5 0,5 0,6 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,7 2,7 2,7 2,7 3,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,6 5,5 5,5 5,4 5,4 5,3 5,2 4,2 4,2 4,3 4,3 3,4 3,4 2,4 2,5 2,5 1,5 1,5 1,5 0,4 1,3 1,3 2,3 2,2 3,2 3,2 3,1 3,1 3,1 2,0 2,0 2,0 2,0 3,0 4,1 4,2 4,2 4,3 4,4 4,4 4,5 4,5 3,5 2,5 2,5 1,4 1,4 0,3 0,2 1,2 1,1 1,1 1,0 1,0 2,0 3,1 3,1 3,1 4,2 3,2 3,2 2,2 1,2 1,3 1,4 1,4 1,5 1,5 1,6 1,6 1,6 1,6 2,6 2,6 3,6 3,6 4,6 4,6 4,6 4,5 4,5 4,4 4,4 3,3 3,3 3,2 3,2 3,1 4,1 4,1 4,1 4,2 4,2 4,3 4,3 4,4 4,4 3,4 3,4 3,4 3,3 3,3 2,2 2,2 2,1 1,1 1,1 1,1 1,2 1,2 0,2 0,3 0,4 0,4 0,5 0,5 0,6 0,6 0,6 1,7 1,7 1,6 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 5,6 5,6 5,6 5,6 5,5 4,5 4,5 3,4 ";
String pathData2 = "5,6 4,6 4,6 4,6 4,7 4,7 4,7 4,7 3,7 3,7 3,7 2,7 2,7 1,7 1,7 1,7 1,7 1,7 0,7 0,7 0,7 0,7 0,7 0,6 0,6 0,5 0,5 0,5 0,4 0,4 0,4 0,4 0,4 0,4 1,4 1,4 1,4 1,4 1,4 1,3 1,3 1,3 2,3 2,3 2,3 2,3 2,3 2,2 2,2 2,2 2,2 2,2 3,2 3,2 3,2 3,2 3,2 3,2 3,1 3,1 3,1 3,1 2,0 2,0 2,0 1,0 1,0 1,1 1,1 1,1 1,1 1,1 1,2 1,2 1,2 1,2 1,2 1,2 1,3 1,3 2,3 2,3 2,3 2,3 2,4 2,4 2,4 2,4 3,4 3,4 3,4 3,5 3,5 3,5 4,5 4,5 4,5 4,5 4,5 4,5 4,4 5,4 5,4 5,4 5,3 5,3 5,3 5,2 5,2 5,2 5,2 5,2 5,2 5,2 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 1,0 1,0 1,1 1,1 1,1 0,1 1,2 0,2 1,3 1,3 1,4 1,4 1,4 2,5 2,5 2,5 2,5 2,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,7 3,6 3,6 3,6 2,6 2,6 2,6 2,6 1,5 1,5 1,5 1,4 1,4 2,4 2,4 2,3 3,3 3,3 3,3 4,3 4,3 4,3 4,3 4,3 4,2 4,2 4,2 4,1 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 2,1 2,2 2,2 2,2 1,2 1,2 1,3 1,3 0,3 0,3 0,3 0,4 0,4 1,5 1,5 1,5 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 4,6 5,6 5,6 5,6 5,5 5,5 5,5 4,4 4,4 4,4 4,4 4,3 3,3 3,2 3,2 3,2 3,1 3,1 3,1 3,1 3,0 2,0 2,0 2,0 1,0 1,0 1,1 0,1 0,2 0,2 0,3 0,4 0,4 1,5 1,6 1,6 1,6 2,7 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,5 5,5 5,4 4,3 4,3 4,2 4,2 4,1 4,1 4,1 4,1 3,0 2,0 2,0 2,1 1,1 1,2 1,2 1,3 1,4 1,4 0,4 0,5 0,5 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,6 2,6 2,6 5,6 4,6 4,6 4,6 4,7 4,7 4,7 4,7 3,7 3,7 3,7 2,7 2,7 1,7 1,7 1,7 1,7 1,7 0,7 0,7 0,7 0,7 0,7 0,6 0,6 0,5 0,5 0,5 0,4 0,4 0,4 0,4 0,4 0,4 1,4 1,4 1,4 1,4 1,4 1,3 1,3 1,3 2,3 2,3 2,3 2,3 2,3 2,2 2,2 2,2 2,2 2,2 3,2 3,2 3,2 3,2 3,2 3,2 3,1 3,1 3,1 3,1 2,0 2,0 2,0 1,0 1,0 1,1 1,1 1,1 1,1 1,1 1,2 1,2 1,2 1,2 1,2 1,2 1,3 1,3 2,3 2,3 2,3 2,3 2,4 2,4 2,4 2,4 3,4 3,4 3,4 3,5 3,5 3,5 4,5 4,5 4,5 4,5 4,5 4,5 4,4 5,4 5,4 5,4 5,3 5,3 5,3 5,2 5,2 5,2 5,2 5,2 5,2 5,2 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 1,0 1,0 1,1 1,1 1,1 0,1 1,2 0,2 1,3 1,3 1,4 1,4 1,4 2,5 2,5 2,5 2,5 2,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,7 3,6 3,6 3,6 2,6 2,6 2,6 2,6 1,5 1,5 1,5 1,4 1,4 2,4 2,4 2,3 3,3 3,3 3,3 4,3 4,3 4,3 4,3 4,3 4,2 4,2 4,2 4,1 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 2,1 2,2 2,2 2,2 1,2 1,2 1,3 1,3 0,3 0,3 0,3 0,4 0,4 1,5 1,5 1,5 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 4,6 5,6 5,6 5,6 5,5 5,5 5,5 4,4 4,4 4,4 4,4 4,3 3,3 3,2 3,2 3,2 3,1 3,1 3,1 3,1 3,0 2,0 2,0 2,0 1,0 1,0 1,1 0,1 0,2 0,2 0,3 0,4 0,4 1,5 1,6 1,6 1,6 2,7 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,5 5,5 5,4 4,3 4,3 4,2 4,2 4,1 4,1 4,1 4,1 3,0 2,0 2,0 2,1 1,1 1,2 1,2 1,3 1,4 1,4 0,4 0,5 0,5 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,6 2,6 2,6 5,6 4,6 4,6 4,6 4,7 4,7 4,7 4,7 3,7 3,7 3,7 2,7 2,7 1,7 1,7 1,7 1,7 1,7 0,7 0,7 0,7 0,7 0,7 0,6 0,6 0,5 0,5 0,5 0,4 0,4 0,4 0,4 0,4 0,4 1,4 1,4 1,4 1,4 1,4 1,3 1,3 1,3 2,3 2,3 2,3 2,3 2,3 2,2 2,2 2,2 2,2 2,2 3,2 3,2 3,2 3,2 3,2 3,2 3,1 3,1 3,1 3,1 2,0 2,0 2,0 1,0 1,0 1,1 1,1 1,1 1,1 1,1 1,2 1,2 1,2 1,2 1,2 1,2 1,3 1,3 2,3 2,3 2,3 2,3 2,4 2,4 2,4 2,4 3,4 3,4 3,4 3,5 3,5 3,5 4,5 4,5 4,5 4,5 4,5 4,5 4,4 5,4 5,4 5,4 5,3 5,3 5,3 5,2 5,2 5,2 5,2 5,2 5,2 5,2 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 1,0 1,0 1,1 1,1 1,1 0,1 1,2 0,2 1,3 1,3 1,4 1,4 1,4 2,5 2,5 2,5 2,5 2,6 3,6 3,6 3,6 3,6 3,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,6 4,7 3,6 3,6 3,6 2,6 2,6 2,6 2,6 1,5 1,5 1,5 1,4 1,4 2,4 2,4 2,3 3,3 3,3 3,3 4,3 4,3 4,3 4,3 4,3 4,2 4,2 4,2 4,1 4,1 4,1 4,1 3,1 3,1 3,1 2,1 2,1 2,1 2,2 2,2 2,2 1,2 1,2 1,3 1,3 0,3 0,3 0,3 0,4 0,4 1,5 1,5 1,5 2,6 2,6 2,6 3,6 3,6 3,6 4,6 4,6 4,6 5,6 5,6 5,6 5,5 5,5 5,5 4,4 4,4 4,4 4,4 4,3 3,3 3,2 3,2 3,2 3,1 3,1 3,1 3,1 3,0 2,0 2,0 2,0 1,0 1,0 1,1 0,1 0,2 0,2 0,3 0,4 0,4 1,5 1,6 1,6 1,6 2,7 2,7 2,7 3,7 3,7 3,7 4,7 4,7 4,7 4,7 5,6 5,6 5,6 5,5 5,5 5,4 4,3 4,3 4,2 4,2 4,1 4,1 4,1 4,1 3,0 2,0 2,0 2,1 1,1 1,2 1,2 1,3 1,4 1,4 0,4 0,5 0,5 0,6 0,6 0,6 0,6 1,7 1,7 1,7 1,7 2,7 2,6 2,6 2,6 5,6 4,6 4,6 4,6 4,7 4,7 4,7 4,7 3,7 3,7 3,7 2,7 2,7 1,7 1,7 1,7 1,7 1,7 0,7 0,7 0,7 0,7 0,7 0,6 0,6 0,5 0,5 0,5 0,4 0,4 0,4 0,4 0,4 0,4 1,4 1,4 1,4 1,4 1,4 1,3 1,3 1,3 2,3 2,3 2,3 2,3 2,3 2,2 2,2 2,2 2,2 2,2 3,2 3,2 3,2 3,2 3,2 3,2 3,1 3,1 3,1 3,1 2,0 2,0 2,0 1,0 1,0 1,1 1,1 1,1 1,1 1,1 1,2 1,2 1,2 1,2 1,2 1,2 1,3 1,3 2,3 2,3 2,3 2,3 2,4 2,4 2,4 2,4 3,4 3,4 3,4 3,5 3,5 3,5 4,5 4,5 4,5 ";
String[] ary = pathData.split(" ");
String[] ary2= pathData2.split(" ");
ArrayList<PVector> positions = new ArrayList<PVector>();

void init_osc()
{
  println("Listening for Firefly data on port " + OSC_IN_FIREFLY);
  ffosc = new OscP5(this, OSC_IN_FIREFLY);
  println("Listening for node data " + OSC_IN_HARDWARE);
  oscin = new OscP5(this, OSC_IN_HARDWARE);
}

void init_gui() {
  cp5 = new ControlP5(this);

  cursor = new PVector(100, 100);

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
  cursor.y += 20;
  cp5.addButton("testpattern")
    .setPosition(cursor.x, cursor.y)
    ;

  cp5.setAutoDraw(false);
}

void load_sample_paths() {
  path = new PVector[ary.length];
  path2 = new PVector[ary.length];

  for (int i =0; i < ary.length; i++) {
    String[] pos = ary[i].split(",");
    path[i] = new PVector(Integer.parseInt(pos[0]), Integer.parseInt(pos[1]));
  }
  for (int i =0; i < ary2.length; i++) {
    String[] pos = ary2[i].split(",");
    path2[i] = new PVector(Integer.parseInt(pos[0]), Integer.parseInt(pos[1]));
  }
}

void setup() {
  size(1024, 600, P3D);

  init_osc();
  init_networking(GRID_W, GRID_H);

  int []loc = ip_to_grid_pos(123);
  println(">>> grid x "+loc[0]+", grid y "+loc[1]+" of ip 192.168.8."+123+" <<<");


  g3 = (PGraphics3D)g;
  grid = new SensorGrid(GRID_W, GRID_H);
  Lgrid = new LightGrid(GRID_W, GRID_H);

  behave = new Behaviour();

  load_sample_paths();

  //communication = new Control();

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

  //with this i test the different animations made by Thomas
  //Lgrid.setCurrentAnimation(new Rest(50, 5, 5000, Lgrid.bounds(), Lgrid.Xoffset));
  //Lgrid.setCurrentAnimation(new Attack(100, Lgrid.bounds(), Lgrid.Xoffset));
  //Lgrid.setCurrentAnimation(new Sleep(500));
  //Lgrid.setCurrentAnimation(new Lure(50, 2, 2000, Lgrid.bounds(), Lgrid.Xoffset));
  Lgrid.setCurrentAnimation(new Dead());
  Lgrid.setCurrentBehaviour(new FieldBehaviour());
  Lgrid.setCurrentBehaviour(new TestBehaviour());
  //Lgrid.setCurrentAnimation(new Heatmap());
  //there should be an "animation" added where

  // udps = new UDP( this, 6005 ); // this is the for the communication with Grasshopper
}

void draw_cp5_gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.draw();
  g3.camera = currCameraMatrix;
}

int time = millis();
int stepIndex = 0;
int stepIndex2 = 0;
void draw_gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  view2d.beginDraw();
  int xloc = 40;
  int yloc = 40;

  track.x = mouseX - xloc;
  track.y = mouseY - yloc;

  grid.sense(track.x, track.y); //for this i should use

  // with this I create a path
  walkTheGrid();

  //test for the ACK test
  //println(iptopos("192.168.8.147")[0]);
  //println(iptopos("192.168.8.147")[1]);



  grid.draw(view2d, xloc, yloc);
  Lgrid.draw(view2d, xloc, yloc);

  //testValuesSensors();
  if (testpattern) {
    Lgrid.setCurrentBehaviour(new TestBehaviour());
    testpattern = false;
  }

  view2d.endDraw();

  image(view2d, 0, 0);

  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}//draw_gui


void testValuesSensors() {
  int randomInt = int(random(100, 147));
  String ip = "192.168.8." + randomInt;

  int g = ip_to_grid_pos(ip)[0];
  int h = ip_to_grid_pos(ip)[1];

  for (int j = 0; j < GRID_H; j++) {
    for (int i = 0; i < GRID_W; i++) {
      if ( i == g && j == h ) {
        grid.grid[g][h]._triggerCount++;
        grid.grid[g][h]._triggered = true;
      } else {
        grid.grid[i][j]._triggered = false;
      }
    }//for
  }//for
}//void

void walkTheGrid() { // these are the RHINO  / GRASSHOPPER files
  if (millis() > time + 1) {
    time = millis();
    if (stepIndex == ary.length-1) {
      stepIndex= 0;
    }
    if (stepIndex2 == ary2.length-1) {
      stepIndex2= 0;
    }
    //println(stepIndex);
    stepIndex++;
    stepIndex2++;

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (i == path[stepIndex].x && j == path[stepIndex].y) {
          grid.grid[int(path[stepIndex].x)][int(path[stepIndex].y)]._triggerCount++;
          grid.grid[int(path[stepIndex].x)][int(path[stepIndex].y)]._triggered = true;
        } else if (i == path2[stepIndex2].x && j == path2[stepIndex2].y) {
          grid.grid[int(path2[stepIndex2].x)][int(path2[stepIndex2].y)]._triggerCount++;
          grid.grid[int(path2[stepIndex2].x)][int(path2[stepIndex2].y)]._triggered = true;
        } else {
          grid.grid[i][j]._triggered = false;
        }
      }
    }
  }
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
    person[0].pos = pos;
  }
}
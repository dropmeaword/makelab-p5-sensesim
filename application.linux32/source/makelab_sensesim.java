import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import controlP5.*;
import gab.opencv.*;
import java.util.*;
import peasy.*;
import oscP5.*;
import netP5.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class makelab_sensesim extends PApplet {





// import hypermedia.net.*;




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
String []selectedBehaviour;
int AmoutOfBehaviours = 4;

boolean behaviour1 = false;
boolean behaviour2 = false;
boolean behaviour3 = false;
String behaviour4;

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


public void init_osc()
{
  println("Listening for Firefly data on port " + OSC_IN_FIREFLY);
  ffosc = new OscP5(this, OSC_IN_FIREFLY);
  println("Listening for node data " + OSC_IN_HARDWARE);
  oscin = new OscP5(this, OSC_IN_HARDWARE);
}

public void init_gui() {
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
    .setRange(0.01f, 12)
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

  cursor.x += 200;
  cursor.y -= 50;

  cp5.addButton("behaviour1")
    .setPosition(cursor.x, cursor.y)
    ;
  cursor.y += 20;
  cp5.addButton("behaviour2")
    .setPosition(cursor.x, cursor.y)
    ;
  cursor.y +=20;
  cp5.addButton("behaviour3")
    .setPosition(cursor.x, cursor.y)

    ;
  cp5.setAutoDraw(false);
}

public void load_sample_paths() {
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

public void setup() {


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
  Lgrid.setCurrentBehaviour(new heatmap_behaviour());
  //Lgrid.setCurrentAnimation(new Heatmap());
  //there should be an "animation" added where

  // udps = new UDP( this, 6005 ); // this is the for the communication with Grasshopper
}

public void draw_cp5_gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.draw();
  g3.camera = currCameraMatrix;
}

int time = millis();
int stepIndex = 0;
int stepIndex2 = 0;
public void draw_gui() {
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

  grid.draw(view2d, xloc, yloc);
  Lgrid.draw(view2d, xloc, yloc);

  //testValuesSensors();
  if (testpattern) {
    Lgrid.setCurrentBehaviour(new TestBehaviour());
    testpattern = false;
  }



  if (behaviour1 == true) {
    Lgrid.setCurrentBehaviour(new heatmap_behaviour());
    behaviour1 = false;
  } else if (behaviour2 == true) {
    Lgrid.setCurrentBehaviour(new AttackBehaviour(4, 4));
    behaviour2 = false;
  } else if (behaviour3 == true) {
    Lgrid.setCurrentBehaviour(new SleepBehaviour(100));
    behaviour3 = false;
  }



  view2d.endDraw();

  image(view2d, 0, 0);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}//draw_gui


public void testValuesSensors() {
  int randomInt = PApplet.parseInt(random(100, 147));
  String ip = "192.168.8." + randomInt;

  int g = ip_to_grid_pos(ip)[0];
  int h = ip_to_grid_pos(ip)[1];

  for (int j = 0; j < GRID_H; j++) {
    for (int i = 0; i < GRID_W; i++) {
      if ( i == g && j == h ) {
        grid.grid[g][h]._triggerCount++;
        grid.grid[g][h].trigger(); // was: _triggered = true;
      } else {
        grid.grid[i][j]._triggered = false;
      }
    }//for
  }//for
}//void

public void walkTheGrid() { // these are the RHINO  / GRASSHOPPER files
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
          grid.grid[PApplet.parseInt(path[stepIndex].x)][PApplet.parseInt(path[stepIndex].y)]._triggerCount++;
          grid.grid[PApplet.parseInt(path[stepIndex].x)][PApplet.parseInt(path[stepIndex].y)].trigger(); //was: _triggered = true;
        } else if (i == path2[stepIndex2].x && j == path2[stepIndex2].y) {
          grid.grid[PApplet.parseInt(path2[stepIndex2].x)][PApplet.parseInt(path2[stepIndex2].y)]._triggerCount++;
          grid.grid[PApplet.parseInt(path2[stepIndex2].x)][PApplet.parseInt(path2[stepIndex2].y)].trigger(); // was: _triggered = true;
        } else {
          grid.grid[i][j]._triggered = false;
        }
      }
    }
  }
}

public void update() {
  // was used to update the contour
}

public void draw() {
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
class Dead extends Animation {

  Dead() {
  }

  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        gridAnimation.node[i][j].paint_solid(color(0));
      }
    }
  }
}

class Sleep extends Animation {

  int pulse, base;
  int brightness;
  String state = "on";

  Sleep(int pluse) {
    this.pulse = pluse;
    this.base = pulse;
  }

  public void update() {

    if (pulse <= 0) {
      state = "off";
    }
    if (pulse >= base) {
      state = "on";
    }

    if (state == "off") {
      pulse++;
    }
    if (state == "on") {
      pulse--;
    }

    brightness = PApplet.parseInt(map(pulse, 0, base, 0, 255));
  }

  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        gridAnimation.node[i][j].paint_solid(color(brightness));
      }
    }
  }
}


class Rest extends Animation {

  int size, movement, dist;
  PVector pos;
  int startTime, delay;
  PVector _bounds;
  int xOffset;
  int a, b;

  Rest(int size, int movement, int delay, PVector bounds, int xOff) {
    this.size = size;
    this.delay = delay;
    this.movement = movement;
    _bounds = bounds;
    xOffset = xOff;
    pos = new PVector(bounds.x/2+xOff, bounds.y/2);
    startTime = millis();
    a = color(random(255), random(255), random(255));
    b = color(random(255), random(255), random(255));
  }

  public void update() {

    if (millis() - startTime > delay) {
      pos.x = random(_bounds.x+20, _bounds.x+xOffset-20);
      pos.y = random(20, _bounds.y-20);
      startTime = millis();
    }
    pos.x += PApplet.parseInt(random(-movement, movement));
    pos.y += PApplet.parseInt(random(-movement, movement));
  }
  public void show() {
    //fill(255, 0, 0);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = PApplet.parseInt( dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5f, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5f) );

        if (dist < size) {
          gridAnimation.node[i][j].paint_gradient(a, b);
        } else {
          gridAnimation.node[i][j].paint_solid(color(0));
        }
      }
    }
  } // show
} // class


class Lure extends Animation {

  int size, dist, movement;
  PVector pos;
  int current;
  int startTime, delay, colorTime, colorDelay = 1000;
  int[] fade = {color(255, 0, 0), color(0, 0, 255)};
  float fadeAmt= 0;

  PVector _bounds;
  int xOffset;

  Lure(int size, int movement, int delay, PVector bounds, int xOff) {
    this.size = size;
    _bounds = bounds;
    xOffset = xOff;
    this.delay = delay;
    this.movement = movement;
    pos = new PVector(random(20, bounds.x + xOffset -20), random(20, bounds.y - 20));
    startTime = colorTime = millis();
  }

  public void update() {
    if (millis() - startTime > delay) {
      pos.x = random(_bounds.x+20, _bounds.x+xOffset-20);
      pos.y = random(20, _bounds.y-20);
      startTime = millis();
    }

    fadeAmt+=0.01f;
    current = lerpColor(fade[0], fade[1], fadeAmt);
    if (fadeAmt >= 1) {
      fadeAmt = 0;
      fade[0] = fade[1];
      fade[1] = color(random(255), random(255), random(255));
    }

    pos.x += PApplet.parseInt(random(-movement, movement));
    pos.y += PApplet.parseInt(random(-movement, movement));
  }

  public void show() {
    //fill(255, 0, 0);
    //ellipseMode(CENTER);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = PApplet.parseInt(dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5f, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5f));
        if (dist < size) {
          gridAnimation.node[i][j].paint_solid(color(current));
        } else {
          gridAnimation.node[i][j].paint_solid(color(0));
        }
      }
    }
  }
}


class Attack extends Animation {

  int size, dist, op;
  PVector pos;
  int startTime, delay = 2000;
  boolean runAni = false;

  PVector _bounds;
  int xOffset;

  Attack(int size, PVector bounds, int xOff) {
    this.size = size;
    _bounds = bounds;
    xOffset = xOff;
    pos = new PVector(bounds.x/2+xOff, bounds.y/2);
    op= 0;
  }

  public void update() {
    if (millis() - startTime > delay) {
      op = 0;
      runAni = true;
      pos.x = PApplet.parseInt(random(_bounds.x+20, _bounds.x+xOffset-20));
      pos.y = PApplet.parseInt(random(20, _bounds.y-20));
      startTime = millis();
    }
    if (runAni) {
      op+=20;
      if (op >= 255) {
        op = 255;
        runAni = false;
      }
    }
  }

  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = PApplet.parseInt(dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5f, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5f));
        if (dist < size) {
          gridAnimation.node[i][j].paint_solid(color(op));
        } else {
          gridAnimation.node[i][j].paint_solid(color(0));
        }
      }
    }
  }
}
public class Animation {

  public LightGrid gridAnimation;

  public void setParentGrid(LightGrid lg) {
    this.gridAnimation = lg;
  }

  public void update() {
  }

  public void show() {
    // nothing yet
  }
}
//class Behaviour {
//  int [][]triggerCount;
//  color a,b;
//  int maxVal = 1;
//  Behaviour() {
//    triggerCount = new int[GRID_W][GRID_H];
//    a = color(random(255), random(255), random(255));
//    b = color(random(255), random(255), random(255));
//  }

//  void update() {
//    for (int j = 0; j < GRID_H; j++) {
//      for (int i = 0; i < GRID_W; i++) {
//        if(int(grid.grid[i][j]._triggerCount) >maxVal){
//        maxVal = int(grid.grid[i][j]._triggerCount);
//        }
//        triggerCount[i][j] = int(grid.grid[i][j]._triggerCount);
//        if (triggerCount[i][j] < maxVal/10) {
//          Lgrid.node[i][j].paint_solid(a);
//        }
//      }
//    }
//  }
//  void show() {
//  }
//}


class Behaviour {
  public int [][]totalCountPerTrigger;
  public  int activeTriggerCounter;
  boolean on = false;
  ModelSensor [][]lastTriggered;
  ModelSensor [][]prevTriggered;
  public LightGrid gridBehaviour;
  public boolean attacked = false;
  public int maxValue = 1;

  //I want to have something that gives me the last triggered sencor. But this can be multiple sensors..
  //I also want to have al little history on the seosores that have been triggered in the past so the behaviour can react to that

  Behaviour() {
    totalCountPerTrigger = new int[GRID_W][GRID_H];
    activeTriggerCounter = 0;
  }

  public void setParentGrid(LightGrid lg) {
    this.gridBehaviour = lg;
  }

  public void update() {
    int triggerCount = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        totalCountPerTrigger[i][j] = PApplet.parseInt(grid.grid[i][j]._triggerCount);
        if (grid.grid[i][j]._triggered) {
          triggerCount++;
        }
        //if (totalCountPerTrigger[i][j] > 50 && attacked == false) {
        //Lgrid.setCurrentBehaviour(new AttackBehaviour(i, j));
        //}
      }
    }
    activeTriggerCounter = triggerCount;
  }//update

  public void show() {
  }//show
}//class


class FieldBehaviour extends Behaviour {

  int []nodesPerField;

  FieldBehaviour() {
    makeFields();
  }
  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (Lgrid.node[i][j]._whatField == 0) {
          Lgrid.node[i][j].paint_solid(color(255, 0, 0));
        }
        if (Lgrid.node[i][j]._whatField == 1) {
          Lgrid.node[i][j].paint_solid(color(0, 255, 0));
        }
        if (Lgrid.node[i][j]._whatField == 2) {
          Lgrid.node[i][j].paint_solid(color(0, 0, 255));
        }
        if (Lgrid.node[i][j]._whatField == 3) {
          Lgrid.node[i][j].paint_solid(color(255, 255, 0));
        }
      }
    }
  }
  public void makeFields() {
    nodesPerField = new int[4];
    //print(nodesPerField[0]);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (i < 3 && j < 4) {
          Lgrid.node[i][j]._whatField = 0;
        } else if (i >2 &&j <4) {
          Lgrid.node[i][j]._whatField = 1;
        } else if (i <3 && j >3) {
          Lgrid.node[i][j]._whatField = 2;
        } else if (i >2 && j>3) {
          Lgrid.node[i][j]._whatField = 3;
        }
      }
    }
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        nodesPerField[Lgrid.node[i][j]._whatField]++;
      }
    }
  }
}


class SleepBehaviour extends Behaviour{
  int pulse, base;
  int brightness;
  String state = "on";
  SleepBehaviour(int pluse) {
    this.pulse = pluse;
    this.base = pulse;
  }
  public void update() {
    if (pulse <= 0) {
      state = "off";
    }
    if (pulse >= base) {
      state = "on";
    }
    if (state == "off") {
      pulse++;
    }
    if (state == "on") {
      pulse--;
    }
    brightness = PApplet.parseInt(map(pulse, 0, base, 0, 255));
  }

  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_solid(color(brightness));
      }
    }
  }

}


class AttackBehaviour extends Behaviour {
  PVector pointToAttack;
  PVector attackStart1;
  PVector attackStart2;
  int     lengthOfPath = 6;
  PVector []attackPath;
  int attackX;
  int attackY;

  AttackBehaviour(int x, int y) {
    attackX = x;
    attackY = y;
    attacked = true;

    pointToAttack = new PVector(x, y);

    println(pointToAttack);

    attackStart1 = pickPointOnStepsAway(pointToAttack, lengthOfPath);
    println(x, y);
    println(pointToAttack);
    //attackStart2 = pickPointOnStepsAway(pointToAttack, lengthOfPath);
    println(pointToAttack, attackStart1, attackStart2);
    //calculatePath(pointToAttack, attackStart, lengthOfPath);
  }

  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_solid(color(0));
      }
    }
    Lgrid.node[attackX][attackY].paint_solid(color(255, 0, 0));
  }

  public PVector pickPointOnStepsAway(PVector p, int howManySteps) {
    PVector result = p;
    boolean found = false;
    while (found == false) {
      int ranX  = PApplet.parseInt(random(6));
      int ranY  = PApplet.parseInt(random(8));
      int x = PApplet.parseInt(p.x) - ranX;
      int y = PApplet.parseInt(p.y) - ranY;
      x = abs(x);
      y = abs(y);
      int distance = x+y;
      if (distance == howManySteps) {
        found = true;
        result.x = x;
        result.y = y;
      }
    }
    return result;
  }

  public void calculatePath(PVector start, PVector end, int l) {
    attackPath = new PVector[lengthOfPath];
    for (int i = 0; i < attackPath.length; i++) {
      print(i);
    }
  }
}


class heatmap_behaviour extends Behaviour {

  int c = color(0);
  heatmap_behaviour() {
  }
  public void update() {
    int counter = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (PApplet.parseInt(grid.grid[i][j]._triggerCount) > maxValue) {
          maxValue = PApplet.parseInt(grid.grid[i][j]._triggerCount);
        }
        int TriggerCount = PApplet.parseInt(grid.grid[i][j]._triggerCount);
        int green = color(0, 255, 0);
        int red = color(255, 0, 0);
        float inter = map(TriggerCount, 0, maxValue, 0, 1);
        c = lerpColor(green, red, inter);
        sendData(i, j, c);
        counter++;
      }
    }
  }
  public void show() {
  }
  public void sendData(int i, int j, int c) {
    Lgrid.node[i][j].paint_solid( color(c));
  }
}
class TestBehaviour extends Behaviour {
  TestBehaviour() {
  }
  public void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_testPattern(color(255, 0, 255));
      }
    }
    Lgrid.setCurrentBehaviour(new SleepBehaviour(10));
  }
}
public static class Geometry {
  public static boolean inRect(double centerX, double centerY, double radius, double x, double y)
  {
          return x >= centerX - radius && x <= centerX + radius &&
              y >= centerY - radius && y <= centerY + radius;
  }

  public static boolean inCircle(double centerX, double centerY, double radius, double x, double y)
  {
      if(inRect(centerX, centerY, radius, x, y))
      {
          double dx = centerX - x;
          double dy = centerY - y;
          dx *= dx;
          dy *= dy;
          double distanceSquared = dx + dy;
          double radiusSquared = radius * radius;
          return distanceSquared <= radiusSquared;
      }
      return false;
  }


}
class Heatmap extends Animation {
  int maxValue = 1;
  int c = color(0);
  Heatmap() {
  }
  public void update() {

    int counter = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (PApplet.parseInt(grid.grid[i][j]._triggerCount) > maxValue) {
          maxValue = PApplet.parseInt(grid.grid[i][j]._triggerCount);
        }
        int TriggerCount = PApplet.parseInt(grid.grid[i][j]._triggerCount);
        int green = color(0, 255, 0);
        int red = color(255, 0, 0);
        float inter = map(TriggerCount, 0, maxValue, 0, 1);
        c = lerpColor(green, red, inter);
        sendData(i, j, c);
        counter++;
      }
    }
  }
  public void show() {
  }
  public void sendData(int i, int j, int c) {
    Lgrid.node[i][j].paint_solid( color(c));
  }
}
class LightGrid {
  public int _width, _height;
  public LightNode [][]node;
  public int _step;
  public PVector testValues;
  int Xoffset = 400;

  public Animation animation;
  public Behaviour behave;

  public LightGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;
    node = new LightNode[_width][_height];

    int id = 0 ;
    for (int j =0; j < GRID_H; j++) {
      for (int i =0; i < GRID_W; i++) {
        PVector pos = new PVector((i*_step)+Xoffset, (j*_step));
        node[i][j] = new LightNode(this, pos, 30, id++);

        // now that we have created the node we get the IP address
        // based on its row,col position in the grid
        NetAddress ip = grid_pos_to_ip_address(i, j);
        println("Assigning ip " + ip + " to node in position ("+ i + ", "+ j+")");
        node[i][j].setNetworkAddress( ip );
      }
    }

    testValues = new PVector();
  }
  public PVector bounds() {
    return new PVector((_width * _step ), (_height * _step), 100);
  }

  public List<PVector> getNodePositions() {
    List<PVector> retval = new ArrayList<PVector>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( node[i][j]._pos );
      }
    }
    return retval;
  }

  public void setCurrentAnimation(Animation anim) {
    this.animation = anim;
    this.animation.setParentGrid( this );
  }

  public void setCurrentBehaviour(Behaviour beh) {
    this.behave = beh;
    this.behave.setParentGrid( this );
  }

  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);

    animation.update();
    animation.show();

    //there has to be a way to trigger this testValues with the sensors

    testValues(testValues);

    behave.update(); // this is where i trigger the BAHAVE class
    behave.show(); // this is where i trigger the BAHAVE class

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        //println(grid.grid[i][j]._triggerCount + " nee " );
        //println(node[i][j]._pos);
        textSize(40);
        text(PApplet.parseInt(grid.grid[i][j]._triggerCount), node[i][j]._pos.x+40, node[i][j]._pos.y+40);

        node[i][j].draw(where);
      }
    }

    where.popMatrix();
  }//draw

  public void testValues(PVector p) {

    int a = color(255, 0, 0);
    int b = color(0, 255, 100);

    //Lgrid.node[int(p.x)][int(p.y)].paint_gradient(color(a), color(b));

    //Lgrid.node[int(p.x)][int(p.y)].paint_solid( color(b));



    if (PApplet.parseInt(p.x) > 0) {
      //Lgrid.node[int(p.x)-1][int(p.y)].paint_solid( color(a));
    }
  }
}//LightGrid class
class LightNode {

  public class GradientType {
    final public int LINEAR = 0;
    final public int SINUS = 0;
  };

  final public int PIXEL_COUNT = 36;
  public PVector _pos;
  public boolean _on;
  public int _id;
  public int []pix;
  public float _radius;
  protected LightGrid _parent;
  public boolean _updated = false;
  public int _whatField;

  public boolean testing = false;


  public NetAddress ipaddress;


  public LightNode(LightGrid parent, PVector position, int radius, int id) {
    _pos = position;
    _radius = radius;
    _on = false;
    _id = id;
    pix = new int[PIXEL_COUNT*3];
  }

  public void setNetworkAddress(NetAddress address) {
    this.ipaddress = address;
  }

  public void paint_testPattern(int c) {
    for (int i = 0; i < PIXEL_COUNT *3; i+=3) {
      pix[i] = PApplet.parseInt(red(c));
      pix[i+1] = PApplet.parseInt(green(c));
      pix[i+2] = PApplet.parseInt(blue(c));
    }
    if (testing == false) {
      testpattern();
      testing = true;
    }
  }

  public void testpattern() {
    OscMessage out = new OscMessage("/node/testpattern");
    if (ipaddress != null) {
      oscin.send(out, ipaddress);
    } else {
      //println("(!!!) I don't have an IP why?");
    }
  }

  public void osc_dispatch_solid(int c) {
    OscMessage out = new OscMessage("/node/solid");

    out.add( red(c) );
    out.add( green(c) );
    out.add( blue(c) );
    if (ipaddress != null) {
      //println(out, ipaddress);
      oscin.send(out, ipaddress);
    } else {
      //println("(!!!) I don't have an IP why?");
    }
  }

  public void paint_solid(int c) {
    //this is the code for the simulator

    for (int i = 0; i < PIXEL_COUNT *3; i+=3) {
      pix[i] = PApplet.parseInt(red(c));
      pix[i+1] = PApplet.parseInt(green(c));
      pix[i+2] = PApplet.parseInt(blue(c));
    }
    osc_dispatch_solid(c);
  }

  public void osc_dispatch_gradient(int a, int b) {
    OscMessage out = new OscMessage("/node/gradient");
    // add gradient endpoints RGB
    out.add( red(a) );
    out.add( green(a) );
    out.add( blue(a) );
    out.add( red(b) );
    out.add( green(b) );
    out.add( blue(b) );
    oscin.send(out, ipaddress);
  }

  public void paint_gradient(int a, int b) {
    // draw on sim
    for (int i = 0; i < PIXEL_COUNT*3; i+=3) {
      float inter = map(i, 0, PIXEL_COUNT*3, 0, 1);
      int c = lerpColor(a, b, inter);
      pix[i] = PApplet.parseInt(red(c));
      pix[i+1] = PApplet.parseInt(green(c));
      pix[i+2] = PApplet.parseInt(blue(c));
    }

    // dispatch to network
    osc_dispatch_gradient(a, b);
  }


  public void paint_pixels(int []colors) {   // this thing takes an array of 36*3 integers
    // read the contents of pix[] and push them to the sim/hard node.

    //osc.send("/node/pixels", this.pix);

    // this is how to address individual pixel values in our node:
    //for(int i = 0; i < PIXEL_COUNT*3; i += 3) {
    //  int r = this.pix[i];
    //  int g = this.pix[i+1];
    //  int b = this.pix[i+2];
    //}

    for (int i =0; i < PIXEL_COUNT*3; i +=3) {
      pix[i] = colors[i];
      pix[i+1] = colors[i+1];
      pix[i+2] = colors[i+2];
    }
  }

  public double weight() {
    return 0.0d;
  } // i dont think i need this in the LightNode

  public void draw_node_sim(PGraphics where, PVector c, float r) {
    PVector pos = new PVector();
    float step = 2*PI / PIXEL_COUNT;
    float phi = .0f;

    for (int i = 0; i < PIXEL_COUNT* 3; i+= 3) {
      phi += step;
      pos.x = cos(phi)*r + c.x;
      pos.y = sin(phi)*r + c.y;
      //println("(" + pos.x + ", " + pos.y+")");
      where.noStroke();
      where.fill( color(pix[i], pix[i+1], pix[i+2]) );
      //println(color(pix[i]));
      where.ellipse(pos.x, pos.y, 4, 4);
    }
  }

  public void draw_basic_circle(PGraphics where) {
    where.pushMatrix();
    where.translate(_pos.x, _pos.y);
    where.noFill();
    where.stroke(0, 255, 255);
    where.strokeWeight(1);
    where.ellipse(0, 0, _radius*2, _radius*2);
    where.textSize(25);
    where.fill(255, 0, 0);
    //where.text(_id, -20, +20);
    where.popMatrix();
  }

  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void draw(PGraphics where) {
    //draw_basic_circle(where);
    draw_node_sim(where, _pos, _radius);
    //text(_id, _pos.x+50, _pos.y +50);
  }

  public String toString() {
    //This is where i make a String that we can send to Grasshopper. I dont know if we also can send this to the arduinos. EDIT: it is better to send ints to the arduinos
    //the format of the string is r,g,b r,g,b r,g,b
    String s = "";
    for (int i = 0; i < PIXEL_COUNT*3; i+=3) {
      int r = pix[i];
      int g = pix[i+1];
      int b = pix[i+2];
      s = s + r + "," + g + "," + b + " ";
    }
    return s;
  }
}
class ModelSensor {
  PVector _pos;

  public int _sensitivity; // how many ms the thing must be present before it's detected
  public float _radius; // radius of the area sensed
  public long _lastDetected;
  public boolean _triggered;
  public long _triggerCount;
  public boolean _alive;

  protected SensorGrid _parent;

  public ModelSensor(SensorGrid parent, PVector position, int sensitivity, int radius) {
    _pos = position;
    _sensitivity = sensitivity;
    _radius = radius;
    _lastDetected = -1;
    _triggered = false;
    _triggerCount = 0;
    _alive = false;
  }

  public double weight() {
    return 0.0d;
  }

  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void setSensitivity(int s) {
    this._sensitivity = s;
  }

  public void draw(PGraphics where) {
    // draw a respresentation of the sensor's state
    //background(0, 0, 0);
    //int halfr = int(1.0 * _radius / 2.0);

    where.pushMatrix();
    where.translate(_pos.x, _pos.y);
    where.noFill();
    if ( _alive) {
      where.stroke(0, 255, 0);
    }
     else {
      where.stroke(255, 0, 0);
    }

    where.strokeWeight(1);
    //rect(-halfr, -halfr, _radius, _radius);
    where.ellipse(0, 0, _radius*2, _radius*2);

    if (_triggered) {
      where.noStroke();
      where.fill(255);
    } else {
      where.fill(0);
      where.ellipse(0, 0, 10, 10);
      where.noFill();
      where.stroke(255);
      where.strokeWeight(1);
    }

    where.ellipse(0, 0, 10, 10);
    where.popMatrix();
  }

  //public boolean sense(float tx, float ty) {
  //  //println("sense called (" + _pos.x + ", " + _pos.y + ")");
  //  boolean retval = false;
  //    if ( Geometry.inCircle(_pos.x, _pos.y, _radius, tx, ty) ) {
  //      if (-1 == _lastDetected) {
  //        _lastDetected = millis();
  //      } else {
  //        if ( (millis() - _lastDetected) > _sensitivity) {
  //          _lastDetected = -1;
  //          _triggered = retval = true;
  //          _triggerCount++;
  //          // @NOTE must debounce so that it's not triggered more than once
  //          // every time you go under the sensor
  //        }
  //      }
  //    } else {
  //      _triggered = retval = false;
  //    }
  //  return retval;
  //} // sense()
} // class
class Person {

  PVector pos;
  PVector[] locs;

  Person(PVector pos) {
    this.pos = pos;
    locs = new PVector[2]; // create the array that holds the vectors
    // create the vectors
    for (int i = 0; i < 2; i++) {
      locs[i] = new PVector();
    }
  }

  public void update() {
//    pos.x = mouseX;
//    pos.y = mouseY;
  }

  public void show() {

//    fill(255, 0, 0);
//    ellipse(pos.x, pos.y, 30, 30);
//    for (int i = 0; i < points.length; i++) {
//      float dist = dist(p.pos.x, p.pos.y, points[i].x, points[i].y);
//      if (dist < 30) {
//        points[i].c = color(255, 0, 0);

//        locs[1] = locs[0].copy();

//        locs[0].x = mouseX;
//        locs[0].y = mouseY;

//        float dot = dist(locs[0].x , locs[0].y, locs[1].x, locs[1].y);
//        println(dot);
//      } else {
//        points[i].c = color(255);
//      }
//    }
  }
}
class SensorGrid {

  public int _width, _height;
  public ModelSensor [][]grid;
  public int _step;
  public int _avgTriggers;
  public boolean [][]activatedSensors;

  public SensorGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;
    activatedSensors = new boolean[w][h];

    grid = new ModelSensor[_width][_height]; //new ArrayList<PVector>(400);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        PVector pos = new PVector((i * _step), (j*_step));
        grid[i][j] = new ModelSensor(this, pos, 30, 30);
      }
    }
  }

  // the bounding box of this grid is from 0, 0, 0 to <PVector> bounds()
  public PVector bounds() {
    return new PVector( (_width * _step), (_height * _step), 100);
  }

  public void sense(float xpos, float ypos) {
    _avgTriggers = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        //grid[i][j].sense(xpos, ypos);
        _avgTriggers += grid[i][j]._triggerCount;
      }
    }
    _avgTriggers = _avgTriggers / (GRID_H*GRID_W);
  }

  public List<PVector> getNodePositions() {
    List<PVector> retval = new ArrayList<PVector>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( grid[i][j]._pos );
      }
    }

    //println("node positions: " + retval.size() );
    return retval;
  }

  public List<Float> getNodeWeights() {
    List<Float> retval = new ArrayList<Float>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( new Float(grid[i][j]._triggerCount) );
      }
    }
    return retval;
  }

  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        grid[i][j].setSensitivity(sensitivity);
        if (grid[i][j]._triggered) {
          //activatedSensors[i][j]


          PVector testVal = new PVector(i, j);
          Lgrid.testValues = testVal;
        }

        grid[i][j].draw(where);
      }
    }
    where.popMatrix();
  }
} // class
final static int GRID_H = 8;
final static int GRID_W = 6;


final int OSC_IN_FIREFLY = 2048;
final int OSC_IN_HARDWARE = 12345;
final int OSC_OUT_HARDWARE = 54321;
public NetAddress[][] nodes;

public void init_networking(int rows, int cols) {
  // create the map between node col,row positions and IP addresses
  nodes = new NetAddress[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      String address = "192.168.8." + (j * rows + i + 100);
      nodes[i][j] = new NetAddress(address, OSC_OUT_HARDWARE);
    }
  }
}

public NetAddress grid_pos_to_ip_address(int row, int col) {
  if ( nodes != null) {
    //println("dest >> " + nodes[row][col]);
    return nodes[row][col];
  } else {
    return null;
  }
}


//PVector



public int[] ip_to_grid_pos(int device_id) {
  return ip_to_grid_pos("192.168.8."+device_id);
}

public int[] ip_to_grid_pos(String ipstr) {
  int []coords = new int[2];
  for (int i = 0; i < GRID_W; i++) {
    for (int j = 0; j < GRID_H; j++) {
      if ( nodes[i][j].address().equals(ipstr) ) {
        coords[0] = i; // grid X
        coords[1] = j; // grid Y
      } // if
    } // for
  } // for

  return coords;
}



public void handle_firefly_message(OscMessage inmsg) {

  String payload = inmsg.get(0).stringValue();

  String[] chunkedmessage = payload.split(":");
  for (int c = 0; c < chunkedmessage.length; c++) {
    String[] parts = chunkedmessage[c].split(" ");

    int gridx = 0, gridy = 0;
    String[] locs = parts[1].split(",");
    for (int i = 0; i < locs.length; i++) {
      gridx = PApplet.parseInt(locs[0]);
      gridy = PApplet.parseInt(locs[1]);
    }

    OscMessage outmsg = new OscMessage(parts[0]);

    String[] colors = parts[2].split(",");
    for (int i = 0; i < colors.length; i++) {
      int colVal = PApplet.parseInt(colors[i]);
      outmsg.add(colVal);
    }

    //// calculate IP addres of my node given position in grid
    NetAddress dest = grid_pos_to_ip_address(gridx, gridy);
    forward_to_node(outmsg, dest);
  }
}

public void forward_to_node(OscMessage outmsg, NetAddress dest) {
  println("forwarding message from FF >> " + outmsg + " to destination " + dest);
  oscin.send(outmsg, dest);
}

public void handle_node_heartbeat(OscMessage inmsg) {
  println("HEARTBEAT from node " + inmsg.get(0).intValue() );  /// 206  ->  192.168.8.206
  int x = ip_to_grid_pos(inmsg.get(0).intValue())[0];
  int y = ip_to_grid_pos(inmsg.get(0).intValue())[1];
  grid.grid[x][y]._alive = true;
}

public void handle_node_sensor_data(OscMessage inmsg) {
  println("SENSOR from node " + inmsg.get(0).intValue() );

  int x = ip_to_grid_pos(inmsg.get(0).intValue())[0];
  int y = ip_to_grid_pos(inmsg.get(0).intValue())[1];
  grid.grid[x][y].trigger(); // was: _triggered = true;
}

public void handle_hardware_message(OscMessage inmsg) {
  if (inmsg.checkAddrPattern("/node/ack") == true) {
    handle_node_heartbeat( inmsg );
  } else if (inmsg.checkAddrPattern("/node/sensor") == true) {
    handle_node_sensor_data( inmsg );
  }
}

public void oscEvent(OscMessage inmsg) {
  if (inmsg.checkAddrPattern("/0/Panel") == true) {
    handle_firefly_message( inmsg );
  } else {
    handle_hardware_message( inmsg );
  }
} // global OSC input handler
  public void settings() {  size(1024, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "makelab_sensesim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

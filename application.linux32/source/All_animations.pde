class Dead extends Animation {

  Dead() {
  }

  void show() {
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

  void update() { 

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

    brightness = int(map(pulse, 0, base, 0, 255));
  }

  void show() {
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
  color a, b;

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

  void update() {

    if (millis() - startTime > delay) {
      pos.x = random(_bounds.x+20, _bounds.x+xOffset-20);
      pos.y = random(20, _bounds.y-20);
      startTime = millis();
    }
    pos.x += int(random(-movement, movement));
    pos.y += int(random(-movement, movement));
  }
  void show() {
    //fill(255, 0, 0);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int( dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5) );

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
  color current;
  int startTime, delay, colorTime, colorDelay = 1000;
  color[] fade = {color(255, 0, 0), color(0, 0, 255)};
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

  void update() {
    if (millis() - startTime > delay) {
      pos.x = random(_bounds.x+20, _bounds.x+xOffset-20);
      pos.y = random(20, _bounds.y-20);
      startTime = millis();
    }

    fadeAmt+=0.01;
    current = lerpColor(fade[0], fade[1], fadeAmt);
    if (fadeAmt >= 1) {
      fadeAmt = 0;
      fade[0] = fade[1];
      fade[1] = color(random(255), random(255), random(255));
    }

    pos.x += int(random(-movement, movement));
    pos.y += int(random(-movement, movement));
  }

  void show() {
    //fill(255, 0, 0);
    //ellipseMode(CENTER);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int(dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5));
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

  void update() {
    if (millis() - startTime > delay) {
      op = 0;
      runAni = true;
      pos.x = int(random(_bounds.x+20, _bounds.x+xOffset-20));
      pos.y = int(random(20, _bounds.y-20));
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

  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int(dist(pos.x, pos.y, gridAnimation.node[i][j]._pos.x+gridAnimation._step/1.5, gridAnimation.node[i][j]._pos.y+gridAnimation._step/1.5));
        if (dist < size) {
          gridAnimation.node[i][j].paint_solid(color(op));
        } else {
          gridAnimation.node[i][j].paint_solid(color(0));
        }
      }
    }
  }
}
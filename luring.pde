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
    fill(255, 0, 0);
    ellipseMode(CENTER);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int(dist(pos.x, pos.y, grid.node[i][j]._pos.x+grid._step/1.5, grid.node[i][j]._pos.y+grid._step/1.5));
        if (dist < size) {
          grid.node[i][j].paint_solid(color(current));
        } else {
          grid.node[i][j].paint_solid(color(0));
        }
      }
    }
  }
}
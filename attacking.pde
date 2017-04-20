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
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, size*2, size*2);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int(dist(pos.x, pos.y, grid.node[i][j]._pos.x+grid._step/1.5, grid.node[i][j]._pos.y+grid._step/1.5));
        if (dist < size) {
          grid.node[i][j].paint_solid(color(op));
        } else {
          grid.node[i][j].paint_solid(color(op));
        }
      }
    }
  }
}
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
    a = color(random(255),random(255),random(255));
    b = color(random(255),random(255),random(255));
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
    fill(255, 0, 0);
    //ellipse(pos.x, pos.y, size, size);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int( dist(pos.x, pos.y, grid.node[i][j]._pos.x+grid._step/1.5, grid.node[i][j]._pos.y+grid._step/1.5) );

        if (dist < size) {
          //grid.node[i][j].paint_solid(color(255));
          //grid.node[i][j].paint_gradient(color(255, 0, 0), color(0, 0, 255));
          grid.node[i][j].paint_gradient(a,b);          
        } else {
          grid.node[i][j].paint_solid(color(0));
        }
      }
    }
  } // show
} // class
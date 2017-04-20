class Rest extends Animation {

  int size, movement, dist;
  PVector pos;
  int startTime, delay = 1000;
  //print(grid.bounds());

  PVector _bounds;
  int xOffset;


  Rest(int size, int movement,PVector bounds,int xOff) {
    this.size = size;
    this.movement = movement;
    _bounds = bounds;
    xOffset = xOff;
    pos = new PVector(bounds.x/2+xOff, bounds.y/2);
    startTime = millis();
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
    ellipse(pos.x, pos.y, size, size);
    println(grid._step);

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        dist = int( dist(pos.x, pos.y,grid.node[i][j]._pos.x+grid._step/1.5, grid.node[i][j]._pos.y+grid._step/1.5) );

        if (dist < size) {
          grid.node[i][j].paint_solid(color(255));
        } else {
          grid.node[i][j].paint_solid(color(0));
        } 
      }
    }
  } // show
} // class
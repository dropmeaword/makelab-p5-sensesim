class Rest extends Animation {

  int size, movement, dist;
  PVector pos;
  int startTime, delay = 10000;

  Rest(int size, int movement) {
    this.size = size;
    this.movement = movement;
    pos = new PVector(width/2, height/2);
    startTime = millis();
  }

  void update() {
    if (millis() - startTime > delay) {
      pos.x = random(100, width-100);
      pos.y = random(100, height-100);
      startTime = millis();
    }

    pos.x += int(random(-movement, movement));
    pos.y += int(random(-movement, movement));
  }

  void show() {
    fill(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(pos.x, pos.y, size, size);

    //for (int i = 0; i < points.length; i++) {
    //  dist = int(dist(pos.x, pos.y, points[i].x, points[i].y));
    //  if (dist < size) {
    //    points[i].c = color(255);
    //  } else {
    //    points[i].c = color(0);
    //  }
    //} // for

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {

        dist = int( dist(pos.x, pos.y, grid.node[i][j]._pos.x, grid.node[i][j]._pos.y) );
        
        if (dist < size) {
          grid.node[i][j]._col = color(255);
        } else {
          grid.node[i][j]._col = color(0);
        } // if
        
      }
    }

  } // show

} // class
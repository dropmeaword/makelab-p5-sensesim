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

  void update() {
//    pos.x = mouseX;
//    pos.y = mouseY;
  }

  void show() {
    
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
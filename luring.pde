class Lure {

  int size, dist, movement;
  PVector pos;
  color current;
  int startTime, delay = 20000, colorTime, colorDelay = 1000;
  color[] fade = {color(255, 0, 0), color(0, 0, 255)};
  float fadeAmt= 0;

  Lure(int size, int movement) {
    this.size = size;  
    this.movement = movement;
    pos = new PVector(random(100, width-100), random(100, height-100));
    startTime = colorTime = millis();
  }

  void update() {
    if (millis() - startTime > delay) {
      pos.x = random(100, width-100);
      pos.y = random(100, height-100);
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
    ellipse(pos.x, pos.y, size, size);

    for (int i = 0; i < points.length; i++) {
      dist = int(dist(pos.x, pos.y, points[i].x, points[i].y));
      if (dist < size) {
        points[i].c = color(current);
      } else {
        points[i].c = color(0);
      }
    }
  }
}
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
        grid.node[i][j].paint_solid(color(brightness));
      }
    }
  }
}
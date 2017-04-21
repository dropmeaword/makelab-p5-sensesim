class Heatmap extends Animation {
  int maxValue = 1;
  Heatmap() {
  }
  void update() {
  }
  void show() {
    int counter = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (int(grid.grid[i][j]._triggerCount) > maxValue) {
          maxValue = int(grid.grid[i][j]._triggerCount);
        }
        int TriggerCount = int(grid.grid[i][j]._triggerCount);
        color green = color(0, 255, 0);
        color red = color(255, 0, 0);
        float inter = map(TriggerCount, 0, maxValue, 0, 1);
        color c = lerpColor(green, red, inter);
        Lgrid.node[i][j].paint_solid( color(c));
        counter++;
      }
    }
  }
}
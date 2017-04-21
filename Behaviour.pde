class Behaviour {
  int [][]triggerCount;
  color a,b;
  int maxVal = 1;
  Behaviour() {
    triggerCount = new int[GRID_W][GRID_H];
    a = color(random(255), random(255), random(255));
    b = color(random(255), random(255), random(255));
  }

  void update() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if(int(grid.grid[i][j]._triggerCount) >maxVal){
        maxVal = int(grid.grid[i][j]._triggerCount);
        }
        triggerCount[i][j] = int(grid.grid[i][j]._triggerCount);
        if (triggerCount[i][j] < maxVal/10) {
          Lgrid.node[i][j].paint_solid(a);
        }
      }
    }
  }
  void show() {
  }
}
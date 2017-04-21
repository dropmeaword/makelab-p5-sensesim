//class Behaviour {
//  int [][]triggerCount;
//  color a,b;
//  int maxVal = 1;
//  Behaviour() {
//    triggerCount = new int[GRID_W][GRID_H];
//    a = color(random(255), random(255), random(255));
//    b = color(random(255), random(255), random(255));
//  }

//  void update() {
//    for (int j = 0; j < GRID_H; j++) {
//      for (int i = 0; i < GRID_W; i++) {
//        if(int(grid.grid[i][j]._triggerCount) >maxVal){
//        maxVal = int(grid.grid[i][j]._triggerCount);
//        }
//        triggerCount[i][j] = int(grid.grid[i][j]._triggerCount);
//        if (triggerCount[i][j] < maxVal/10) {
//          Lgrid.node[i][j].paint_solid(a);
//        }
//      }
//    }
//  }
//  void show() {
//  }
//}


class Behaviour {
  public int [][]totalCountPerTrigger;
  public  int activeTriggerCounter;
  boolean on = false;
  ModelSensor [][]lastTriggered;
  ModelSensor [][]prevTriggered;
  public LightGrid gridBehaviour;

  //I want to have something that gives me the last triggered sencor. But this can be multiple sensors.. 
  //I also want to have al little history on the seosores that have been triggered in the past so the behaviour can react to that

  Behaviour() {
    totalCountPerTrigger = new int[GRID_W][GRID_H];
    activeTriggerCounter = 0;
  }

  public void setParentGrid(LightGrid lg) {
    this.gridBehaviour = lg;
  }


  void update() {
    int triggerCount = 0; 
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        totalCountPerTrigger[i][j] = int(grid.grid[i][j]._triggerCount);
        if (grid.grid[i][j]._triggered) {
          triggerCount++;
        }
      }
    }
    activeTriggerCounter = triggerCount;
  }
}


class FieldBehaviour extends Behaviour {
}
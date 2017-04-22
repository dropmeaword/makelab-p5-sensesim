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
  public boolean attacked = false;

  //I want to have something that gives me the last triggered sencor. But this can be multiple sensors.. 
  //I also want to have al little history on the seosores that have been triggered in the past so the behaviour can react to that

  Behaviour() {
    totalCountPerTrigger = new int[GRID_W][GRID_H];
    activeTriggerCounter = 0;
  }

  public void setParentGrid(LightGrid lg) {
    this.gridBehaviour = lg;
  }

  public void update() {
    int triggerCount = 0; 
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        totalCountPerTrigger[i][j] = int(grid.grid[i][j]._triggerCount);
        if (grid.grid[i][j]._triggered) {
          triggerCount++;
        }
        if (totalCountPerTrigger[i][j] > 5 && attacked == false) {
          Lgrid.setCurrentBehaviour(new AttackBehaviour(i, j));
        }
      }
    }
    activeTriggerCounter = triggerCount;
  }//update

  public void show() {
  }//show
}//class


class FieldBehaviour extends Behaviour {

  int []nodesPerField; 

  FieldBehaviour() {
    makeFields();
  } 
  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (Lgrid.node[i][j]._whatField == 0) {
          Lgrid.node[i][j].paint_solid(color(255, 0, 0));
        }
        if (Lgrid.node[i][j]._whatField == 1) {
          Lgrid.node[i][j].paint_solid(color(0, 255, 0));
        }
        if (Lgrid.node[i][j]._whatField == 2) {
          Lgrid.node[i][j].paint_solid(color(0, 0, 255));
        }
        if (Lgrid.node[i][j]._whatField == 3) {
          Lgrid.node[i][j].paint_solid(color(255, 255, 0));
        }
      }
    }
  }
  public void makeFields() {
    nodesPerField = new int[4];
    //print(nodesPerField[0]);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (i < 3 && j < 4) {
          Lgrid.node[i][j]._whatField = 0;
        } else if (i >2 &&j <4) {
          Lgrid.node[i][j]._whatField = 1;
        } else if (i <3 && j >3) {
          Lgrid.node[i][j]._whatField = 2;
        } else if (i >2 && j>3) {
          Lgrid.node[i][j]._whatField = 3;
        }
      }
    }
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {        
        nodesPerField[Lgrid.node[i][j]._whatField]++;
      }
    }
  }
}


class AttackBehaviour extends Behaviour {
  PVector pointToAttack;
  PVector attackStart1;
  PVector attackStart2;
  int     lengthOfPath = 6;
  PVector []attackPath;
  int attackX; 
  int attackY;

  AttackBehaviour(int x, int y) {
    attackX = x;
    attackY = y;
    attacked = true;

    pointToAttack = new PVector(x, y);

    println(pointToAttack);

    attackStart1 = pickPointOnStepsAway(pointToAttack, lengthOfPath);
    println(x, y);
    println(pointToAttack);
    //attackStart2 = pickPointOnStepsAway(pointToAttack, lengthOfPath);
    println(pointToAttack, attackStart1, attackStart2);
    //calculatePath(pointToAttack, attackStart, lengthOfPath);
  }

  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_solid(color(0));
      }
    }
    Lgrid.node[attackX][attackY].paint_solid(color(255, 0, 0));
    
    
    
    
    //Lgrid.node[int(attackStart1.x)][int(attackStart1.y)].paint_solid(color(255));
    //Lgrid.node[int(attackStart2.x)][int(attackStart2.y)].paint_solid(color(255));
  }

  public PVector pickPointOnStepsAway(PVector p, int howManySteps) {
    PVector result = p;
    boolean found = false;
    while (found == false) {
      int ranX  = int(random(6));
      int ranY  = int(random(8));
      int x = int(p.x) - ranX;
      int y = int(p.y) - ranY;
      x = abs(x);
      y = abs(y);
      int distance = x+y;
      if (distance == howManySteps) {
        found = true;
        result.x = x;
        result.y = y;
      }
    }
    return result;
  }

  void calculatePath(PVector start, PVector end, int l) {
    attackPath = new PVector[lengthOfPath];
    for (int i = 0; i < attackPath.length; i++) {
      print(i);
    }
  }
}
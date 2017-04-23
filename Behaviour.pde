public boolean attacked = false; //<>//
public boolean walkMode = true;
public int nextThingTimer = 0; 
public int nextThingInterval = 100;

class Behaviour {
  public int [][]totalCountPerTrigger;
  public  int activeTriggerCounter;
  boolean on = false;
  ModelSensor [][]lastTriggered;
  ModelSensor [][]prevTriggered;
  public LightGrid gridBehaviour;
  public int totalCount = 0 ; 
  public int maxValue = 1;
  public int currBehaviour = 0;
  public String name = "none";

  //I want to have something that gives me the last triggered sencor. But this can be multiple sensors.. 
  //I also want to have al little history on the seosores that have been triggered in the past so the behaviour can react to that
  Behaviour() {
    totalCountPerTrigger = new int[GRID_W][GRID_H];
    activeTriggerCounter = 0;
  }
  public void setParentGrid(LightGrid lg) {
    this.gridBehaviour = lg;
  }

  public void updateParent() {

    if (Lgrid.behave.name == "sleep") {
      nextThingTimer++;
      if (nextThingTimer == 100) {
        Lgrid.setCurrentBehaviour(new heatmap_behaviour());
        nextThingTimer = 0;
      }
    }

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        //println(grid.grid[i][j]._trgrCnt);
        if (grid.grid[i][j]._trgrCnt > 5) {
          //Lgrid.setCurrentBehaviour(new AttackBehaviour(i, j));
          grid.grid[i][j]._trgrCnt = 0 ;
        }
      }
    }
    
    
    
  }//updateParent

  public void update() {
  }

  public void show() {
  }//show
}//class

class FieldBehaviour extends Behaviour {

  int []nodesPerField; 

  FieldBehaviour() {
    makeFields();
    name = "field";
  } 
  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (Lgrid.node[i][j]._whatField == 0) {
          Lgrid.node[i][j].paint_solid(color(10, 0, 0));
        }
        if (Lgrid.node[i][j]._whatField == 1) {
          Lgrid.node[i][j].paint_solid(color(0, 10, 0));
        }
        if (Lgrid.node[i][j]._whatField == 2) {
          Lgrid.node[i][j].paint_solid(color(0, 0, 10));
        }
        if (Lgrid.node[i][j]._whatField == 3) {
          Lgrid.node[i][j].paint_solid(color(10, 10, 0));
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

class SleepBehaviour extends Behaviour {
  int pulse, base;
  int brightness;
  String state = "on";


  SleepBehaviour(int pluse) {
    this.pulse = pluse;
    this.base = pulse;
    name = "sleep";
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
    brightness = int(map(pulse, 0, base, 0, 10));
  }

  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_solid(color(brightness));
      }
    }
  }
}

class AttackBehaviour extends Behaviour {
  PVector pointToAttack;
  PVector []attackStart = new PVector[10];
  int     lengthOfPath = 6;
  int attackX; 
  int attackY;
  int time;
  int attackCounter = 0 ; 

  AttackBehaviour(int x, int y) {
    attackX = x;
    attackY = y;
    attacked = true;
    pointToAttack = new PVector(x, y);
    time = millis();
    name = "attack";

    for (int i = 0; i <attackStart.length; i++) {
      attackStart[i] = pickPointOnStepsAway(x, y, lengthOfPath);
    }
  }

  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_solid(color(0));
      }
    }

    //println(attackStart.length);

    if (millis() - time >speedAttackAnimation) {
      lengthOfPath--;
      attackCounter++;
      time = millis();
      if (attackCounter > 10) {
        attacked = false;
        Lgrid.setCurrentBehaviour(new SleepBehaviour(50));
      }
    }

    if (lengthOfPath == 0 ) {
      lengthOfPath = 6;
    }


    for (int i = 0; i <attackStart.length; i++) {
      attackStart[i] = pickPointOnStepsAway(attackX, attackY, lengthOfPath);
      Lgrid.node[int(attackStart[i].x)][int(attackStart[i].y)].paint_solid(color(10, 10, 10));
    }

    Lgrid.node[int(pointToAttack.x)][int(pointToAttack.y)].paint_gradient(color(10, 0, 0), color(10));
  }//show

  public PVector pickPointOnStepsAway(int incommingX, int incommingY, int howManySteps) {
    PVector result = new PVector(incommingX, incommingY);
    boolean found = false;
    int security = 0; 
    while (found == false) {
      int ranX  = int(random(GRID_W-1));
      int ranY  = int(random(GRID_H-1));
      int x = incommingX - ranX;
      int y = incommingY - ranY;
      x = abs(x);
      y = abs(y);
      int distance = x+y;
      if (distance == howManySteps) { 
        found = true;
        result.x = ranX;
        result.y = ranY;
      }
      security++;
      if (security >100) {
        found = true;
      }
    }
    return result;
  }//pickPointsOnStepsAway
}//attack


class heatmap_behaviour extends Behaviour {
  color c = color(0);
  heatmap_behaviour() {
    name = "heatmap";
  }
  void update() {
    int counter = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        if (int(grid.grid[i][j]._triggerCount) > maxValue) {
          maxValue = int(grid.grid[i][j]._triggerCount);
        }
        int TriggerCount = int(grid.grid[i][j]._triggerCount);
        color green = color(0, 20, 20);
        color red = color(20, 200, 0);
        float inter = map(TriggerCount, 0, maxValue, 0, 1);
        c = lerpColor(green, red, inter);
        sendData(i, j, c);
        counter++;
      }
    }
  }
  void show() {
  }
  void sendData(int i, int j, color c) {


    Lgrid.node[i][j].paint_solid( color(c));
  }
}


class followBehaviour extends Behaviour {
  int personX, personY;
  followBehaviour(int x, int y) {
    personX = x;
    personY = y;
  }
  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
      }
    }
    if (personX> 0) {
      Lgrid.node[personX-1][personY].paint_solid(color(10));
    }
    if (personX<GRID_W-1) {
      Lgrid.node[personX+1][personY].paint_solid(color(10));
    }
    if (personY> 0) {
      Lgrid.node[personX][personY-1].paint_solid(color(10));
    }
    if (personY < GRID_H-1) {
      Lgrid.node[personX][personY+1].paint_solid(color(10));
    }
  }
}

int stage =0;
int LineBehaviourCount = 0;
boolean up = false;
class LineBehaviour extends Behaviour {

  LineBehaviour() {
    name = "line";
  }
  void show() {
    //println(time);
    //println(millis()-time);

    if (LineBehaviourCount >25) {
      LineBehaviourCount = 0;
      if (up) {
        up= false;
      } else if (!up) {
        up= true;
      }
    }
    if (up) {
      if (millis() - time > 100) {
        stage++;
        time = millis();

        if (stage > 13) {
          stage = 0;
        }
        lelijkeCode();
        LineBehaviourCount++;
      }
    } else if (!up) {

      if (millis() - time > 100) {
        stage--;
        time = millis();

        if (stage<0) {
          stage = 13;
        }
        lelijkeCode();
        LineBehaviourCount++;
      }
    }
  }
}


void lelijkeCode() {

  for (int j = 0; j < GRID_H; j++) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][j].paint_solid(color(0));
    }
  }



  if (stage == 0) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 1) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 2) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 3) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 4) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 5) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 6) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 7) {
    for (int i = 0; i < GRID_W; i++) {
      Lgrid.node[i][stage].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 8) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 9) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 10) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 11) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 12) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 13) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  } else if (stage == 13) {
    for (int i = 0; i < GRID_H; i++) {
      Lgrid.node[stage-8][i].paint_gradient(color(10, 0, 10), color(10, 10, 10));
    }
  }
}


class Disco extends Behaviour {
  Disco() {
  }
  void show() {
    int ranA = int(random(255));
    int ranB = int(random(255));
    int ranC = int(random(255));
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_gradient(color(10,10,10), color(10,0,10));
      }
    }
  }
}


class TestBehaviour extends Behaviour {
  TestBehaviour() {
  }
  void show() {
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        Lgrid.node[i][j].paint_testPattern(color(10, 0, 10));
      }
    }
    Lgrid.setCurrentBehaviour(new heatmap_behaviour());
  }
}
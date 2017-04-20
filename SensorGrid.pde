class SensorGrid {

  public int _width, _height;
  public ModelSensor [][]grid;
  public int _step;

  public int _avgTriggers;

  public SensorGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;

    grid = new ModelSensor[_width][_height]; //new ArrayList<PVector>(400);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        PVector pos = new PVector((i * _step), (j*_step));
        grid[i][j] = new ModelSensor(this, pos, 30, 30);
      }
    }
  }

  // the bounding box of this grid is from 0, 0, 0 to <PVector> bounds()
  public PVector bounds() {
    return new PVector( (_width * _step), (_height * _step), 100);
  }

  public void sense(float xpos, float ypos) {
    _avgTriggers = 0;
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        grid[i][j].sense(xpos, ypos);
        _avgTriggers += grid[i][j]._triggerCount;
      }
    }
    _avgTriggers = _avgTriggers / (GRID_H*GRID_W);
  }

  public List<PVector> getNodePositions() {
    List<PVector> retval = new ArrayList<PVector>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( grid[i][j]._pos );
      }
    }

    //println("node positions: " + retval.size() );
    return retval;
  }

  public List<Float> getNodeWeights() {
    List<Float> retval = new ArrayList<Float>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( new Float(grid[i][j]._triggerCount) );
      }
    }
    return retval;
  }

  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        grid[i][j].setSensitivity(sensitivity);
        grid[i][j].draw(where);
         
      }
    }
    where.popMatrix();
  }
} // class
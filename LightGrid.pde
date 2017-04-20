class LightGrid {
  public int _width, _height;
  public LightNode [][]node;
  public int _step;

  public Animation animation;
  
  public LightGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;

    node = new LightNode[_width][_height];
    
    int id = 0 ; 
    for (int j =0; j < GRID_H; j++) {
      for (int i =0; i < GRID_W; i++) {
        PVector pos = new PVector((i*_step), (j*_step));
        node[i][j] = new LightNode(this,pos,30,id++); // i have to give the proper properties to this
      }
    }
  }
  
  public PVector bounds() {
    return new PVector((_width * _step ), (_height * _step), 100);
  }
  
  public List<PVector> getNodePositions() {
    List<PVector> retval = new ArrayList<PVector>();
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        retval.add( node[i][j]._pos );
      }
    }  
    return retval;
  }

  public void setCurrentAnimation(Animation anim) {
    this.animation = anim;
  }
  
  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        node[i][j].draw(where);
      }
    }
    where.popMatrix();
  }//draw
  
}//LightGrid class
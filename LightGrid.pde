class LightGrid {
  public int _width, _height;
  public LightNode [][]node;
  public int _step;
  int Xoffset = 400;

  public Animation animation;

  public LightGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;
    node = new LightNode[_width][_height];

    int id = 0 ; 
    for (int j =0; j < GRID_H; j++) {
      for (int i =0; i < GRID_W; i++) {
        PVector pos = new PVector((i*_step)+Xoffset, (j*_step));
        node[i][j] = new LightNode(this, pos, 30, id++); // i have to give the proper properties to this
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
    this.animation.setParentGrid( this );
  }

  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);

    //with this you can turn on and of a solid color
    //node[0][0].paint_solid(color(255, 0, 0));
    //node[4][4].paint_solid(color(255, 0, 0));

    //with this i tested the gradient colors
    //node[0][0].paint_gradient(color (255, 0, 0), color (0, 255, 250));
    //node[1][0].paint_gradient(color (255, 0, 0), color (0, 255, 250));
    //node[2][3].paint_gradient(color (0, 255, 0), color (0, 255, 100));

   

    animation.update();
    animation.show();

    String ip ="127.0.0.1";
    int port = 6406;
    String message = "";

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        node[i][j].draw(where);
        message = message + node[i][j].toString();
      }
    }
    //println(message);
    udps.send(message, ip, port);

    where.popMatrix();
  }//draw
}//LightGrid class
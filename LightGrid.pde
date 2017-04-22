class LightGrid {
  public int _width, _height;
  public LightNode [][]node;
  public int _step;
  public PVector testValues;
  int Xoffset = 400;

  public Animation animation;
  public Behaviour behave;

  public LightGrid(int w, int h) {
    _width = w;
    _height = h;
    _step = 60;
    node = new LightNode[_width][_height];

    int id = 0 ;
    for (int j =0; j < GRID_H; j++) {
      for (int i =0; i < GRID_W; i++) {
        PVector pos = new PVector((i*_step)+Xoffset, (j*_step));
        node[i][j] = new LightNode(this, pos, 30, id++);

        // now that we have created the node we get the IP address
        // based on its row,col position in the grid
        NetAddress ip = grid_pos_to_ip_address(i, j);
        println("Assigning ip " + ip + " to node in position ("+ i + ", "+ j+")");
        node[i][j].setNetworkAddress( ip );
      }
    }

    testValues = new PVector();
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

  public void setCurrentBehaviour(Behaviour beh) {
    this.behave = beh;
    this.behave.setParentGrid( this );
  }

  public void draw(PGraphics where, int xpos, int ypos) {
    where.smooth();
    where.pushMatrix();
    where.translate(xpos, ypos);

    animation.update();
    animation.show();

    //there has to be a way to trigger this testValues with the sensors

    testValues(testValues);

    behave.update(); // this is where i trigger the BAHAVE class
    behave.show(); // this is where i trigger the BAHAVE class

    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        //println(grid.grid[i][j]._triggerCount + " nee " );
        //println(node[i][j]._pos);
        textSize(40);
        text(int(grid.grid[i][j]._triggerCount), node[i][j]._pos.x+40, node[i][j]._pos.y+40);

        node[i][j].draw(where);
        //message = message + node[i][j].toString();
      }
    }




    //println(message);
    // udps.send(message, ip, port);

    where.popMatrix();
  }//draw

  public void testValues(PVector p) {

    color a = color(255, 0, 0);
    color b = color(0, 255, 100);

    //Lgrid.node[int(p.x)][int(p.y)].paint_gradient(color(a), color(b));

    //Lgrid.node[int(p.x)][int(p.y)].paint_solid( color(b));



    if (int(p.x) > 0) {
      //Lgrid.node[int(p.x)-1][int(p.y)].paint_solid( color(a));
    }
  }
}//LightGrid class
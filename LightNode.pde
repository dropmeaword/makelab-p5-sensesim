class LightNode {
  
  public class GradientType {
    final public int LINEAR = 0;
    final public int SINUS = 0;
  };
  
  final public int PIXEL_COUNT = 36;
  
  PVector _pos;
  boolean _on; 
  int _id;
  
  color _col;
  
  int []pix;

  public float _radius;
  protected LightGrid _parent;

  public LightNode(LightGrid parent, PVector position, int radius, int id) {
    _pos = position;
    _radius = radius;
    _on = false;
    _id = id;
    pix = new int[PIXEL_COUNT*3];
  }

  public void testpattern() {
    // something happens here that sends the test pattern command to the node (bothin the simulator and the hardware)
  }

  public void paint_solid(color c) {
    this._col = c;
    // something happens here that sends the test pattern command to the node (bothin the simulator and the hardware)
  }
  

  public void paint_gradient(color a, color b, GradientType type) {
    // something happens here that sends the test pattern command to the node (bothin the simulator and the hardware)
  }

  
  public void paint_pixels() {
    // read the contents of pix[] and push them to the sim/hard node.

    //osc.send("/node/pixels", this.pix);
    
    // this is how to address individual pixel values in our node:
    //for(int i = 0; i < PIXEL_COUNT*3; i += 3) {
    //  int r = this.pix[i];
    //  int g = this.pix[i+1];
    //  int b = this.pix[i+2];
    //}
  }


  public double weight() {
    return 0.0d;
  } // i dont think i need this in the LightNode 

  void draw_node_sim(PGraphics where, PVector c, float r) {
    PVector pos = new PVector();
    float step = 2*PI / PIXEL_COUNT;
    float phi = .0;
    
    for(int i = 0; i < PIXEL_COUNT; i++) {
      phi += step;
      pos.x = cos(phi)*r + c.x;
      pos.y = sin(phi)*r + c.y;
      //println("(" + pos.x + ", " + pos.y+")");
      where.fill( color(pix[i]) );
      where.ellipse(pos.x, pos.y, 4, 4);
     }    
  }

  public void draw_basic_circle(PGraphics where) {
    pulsing();
    where.pushMatrix();
    where.translate(_pos.x, _pos.y);
    where.noFill();
    //if (_on) {
    //  where.fill(255);
    //}
    where.stroke(0, 255, 255);
    where.strokeWeight(1);
    where.ellipse(0, 0, _radius*2, _radius*2);
    where.textSize(25);
    where.fill(255, 0, 0);
    where.text(_id, -20, +20);
    where.popMatrix();
  }
  
  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void draw(PGraphics where) {
    //draw_basic_circle(where);
    draw_node_sim(where, _pos, _radius);
  }
  
  int pulsingBallSize = 10;
  boolean pulsingBallGrowing = true;
  void pulsing() {
    noStroke();
    //ellipse(2, 2, pulsingBallSize, pulsingBallSize);
    if (pulsingBallSize > 700 ) {
      pulsingBallGrowing = false;
    }
    if (pulsingBallSize < 10) {
      pulsingBallGrowing = true;
    }
    if (pulsingBallGrowing == true) {
      pulsingBallSize += 15;
    } else if (pulsingBallGrowing == false) {
      pulsingBallSize -= 15;
    }
  }
}
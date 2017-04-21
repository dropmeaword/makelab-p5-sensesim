 class LightNode {

  public class GradientType {
    final public int LINEAR = 0;
    final public int SINUS = 0;
  };

  final public int PIXEL_COUNT = 36;
  public PVector _pos;
  public boolean _on;
  public int _id;
  public int []pix;
  public float _radius;
  protected LightGrid _parent;
  public boolean _updated = false;

  public NetAddress ipaddress;


  public LightNode(LightGrid parent, PVector position, int radius, int id) {
    _pos = position;
    _radius = radius;
    _on = false;
    _id = id;
    pix = new int[PIXEL_COUNT*3];
  }

  public void setNetworkAddress(NetAddress address) {
    this.ipaddress = address;
  }

  public void testpattern() {
    OscMessage out = new OscMessage("/node/testpattern");
    oscin.send(out, ipaddress);
  }

  public void osc_dispatch_solid(color c) {
    OscMessage out = new OscMessage("/node/solid");
    out.add( red(c) );
    out.add( green(c) );
    out.add( blue(c) );
    oscin.send(out, ipaddress);
  }

  public void paint_solid() {
    //this is the code for the simulator
    for (int i = 0; i < PIXEL_COUNT *3; i+=3) {
      pix[i] = int(red(c));
      pix[i+1] = int(green(c));
      pix[i+2] = int(blue(c));
    }

    osc_dispatch_solid(c);
  }

  //!!! For now I use the gradient type that i got from the Arduino code
  //public void paint_gradient(color a, color b, GradientType type) {
  //    // something happens here that sends the test pattern command to the node (bothin the simulator and the hardware)

  //  }

  public void osc_dispatch_gradient(color a, color b) {
    OscMessage out = new OscMessage("/node/gradient");
    // add gradient endpoints RGB
    out.add( red(a) );
    out.add( greeb(a) );
    out.add( blue(a) );
    out.add( red(b) );
    out.add( greeb(b) );
    out.add( blue(b) );

    oscin.send(out, ipaddress);
  }

  public void paint_gradient(color a, color b) {
    // draw on sim
    for (int i = 0; i < PIXEL_COUNT*3; i+=3) {
      float inter = map(i, 0, PIXEL_COUNT*3, 0, 1);
      color c = lerpColor(a, b, inter);
      pix[i] = int(red(c));
      pix[i+1] = int(green(c));
      pix[i+2] = int(blue(c));
    }

    // dispatch to network
    osc_dispatch_gradient(a, b);
  }


  public void paint_pixels(int []colors) {   // this thing takes an array of 36*3 integers
    // read the contents of pix[] and push them to the sim/hard node.

    //osc.send("/node/pixels", this.pix);

    // this is how to address individual pixel values in our node:
    //for(int i = 0; i < PIXEL_COUNT*3; i += 3) {
    //  int r = this.pix[i];
    //  int g = this.pix[i+1];
    //  int b = this.pix[i+2];
    //}

    for (int i =0; i < PIXEL_COUNT*3; i +=3) {
      pix[i] = colors[i];
      pix[i+1] = colors[i+1];
      pix[i+2] = colors[i+2];
    }
  }

  public double weight() {
    return 0.0d;
  } // i dont think i need this in the LightNode

  void draw_node_sim(PGraphics where, PVector c, float r) {
    PVector pos = new PVector();
    float step = 2*PI / PIXEL_COUNT;
    float phi = .0;

    for (int i = 0; i < PIXEL_COUNT* 3; i+= 3) {
      phi += step;
      pos.x = cos(phi)*r + c.x;
      pos.y = sin(phi)*r + c.y;
      //println("(" + pos.x + ", " + pos.y+")");
      where.noStroke();
      where.fill( color(pix[i], pix[i+1], pix[i+2]) );
      //println(color(pix[i]));
      where.ellipse(pos.x, pos.y, 4, 4);
    }


  }

  public void draw_basic_circle(PGraphics where) {
    where.pushMatrix();
    where.translate(_pos.x, _pos.y);
    where.noFill();
    where.stroke(0, 255, 255);
    where.strokeWeight(1);
    where.ellipse(0, 0, _radius*2, _radius*2);
    where.textSize(25);
    where.fill(255, 0, 0);
    //where.text(_id, -20, +20);
    where.popMatrix();
  }

  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void draw(PGraphics where) {
    //draw_basic_circle(where);
    draw_node_sim(where, _pos, _radius);
    //text(_id, _pos.x+50, _pos.y +50);
  }

  String toString() {
    //This is where i make a String that we can send to Grasshopper. I dont know if we also can send this to the arduinos. EDIT: it is better to send ints to the arduinos
    //the format of the string is r,g,b r,g,b r,g,b
    String s = "";
    for (int i = 0; i < PIXEL_COUNT*3; i+=3) {
      int r = pix[i];
      int g = pix[i+1];
      int b = pix[i+2];
      s = s + r + "," + g + "," + b + " ";
    }
    return s;
  }
}

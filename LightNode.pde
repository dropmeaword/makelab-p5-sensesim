class LightNode {
  PVector _pos;
  
  public float _radius;
  protected LightGrid _parent;

  public LightNode(LightGrid parent, PVector position, int radius) {
    _pos = position;
    _radius = radius;
  }

  public double weight() {
    return 0.0d;
  }

  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void draw(PGraphics where) {
    where.pushMatrix();
    where.translate(_pos.x,_pos.y);
    where.noFill();
    where.stroke(0,255,255);
    where.strokeWeight(1);
    where.ellipse(0,0,_radius*2,_radius*2);
    where.popMatrix();
  }
  
  public void sleepMode(){
  //Geometry.inCircle(_pos.x, _pos.y, _radius, tx, ty);
  

  }
  
}
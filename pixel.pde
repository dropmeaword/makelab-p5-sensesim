class Pixel {
  LightNode _parent;
  PVector _position;
  float _radius;
  public color _c;
  public int _id;

  public Pixel(LightNode parent, PVector position, float radius,int id) {
    _parent = parent;
    _position = position;
    _radius = radius;
    _id = id;
    _c = color(0);
  }
  
  public void setColor(color c) {
    _c = c;
  }
  
  public int getId(){
    return _id;
  }
  
}
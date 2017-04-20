class Pixel {
  LightNode _parent;
  PVector _position;
  float _radius;
  color _c;

  Pixel(LightNode parent, PVector position, float radius) {
    _parent = parent;
    _position = position;
    _radius = radius;
    _c = color(0);
  }
  
  void setColor(color c) {
    _c = c;
  }
}
 
class ModelSensor {
  PVector _pos;

  public int _sensitivity; // how many ms the thing must be present before it's detected
  public float _radius; // radius of the area sensed
  public long _lastDetected;
  public boolean _triggered;
  public long _triggerCount;
  public boolean _alive;
  public int _triggerTimer = 0;

  protected SensorGrid _parent;

  public ModelSensor(SensorGrid parent, PVector position, int sensitivity, int radius) {
    _pos = position;
    _sensitivity = sensitivity;
    _radius = radius;
    _lastDetected = -1;
    _triggered = false;
    _triggerCount = 0;
    _alive = false;
  }
  

  public double weight() {
    return 0.0d;
  }

  public void setRadius(float rad) {
    this._radius = rad;
  }

  public void setSensitivity(int s) {
    this._sensitivity = s;
  }

  public void draw(PGraphics where) {
    // draw a respresentation of the sensor's state
    //background(0, 0, 0);
    //int halfr = int(1.0 * _radius / 2.0);

    where.pushMatrix();
    where.translate(_pos.x, _pos.y);
    where.noFill();
    if ( _alive) {
      where.strokeWeight(2.0);
      where.stroke(0, 255, 0);
    }
     else {
      where.stroke(255, 0, 0);
    }

    where.strokeWeight(1);
    //rect(-halfr, -halfr, _radius, _radius);
    where.ellipse(0, 0, _radius*2, _radius*2);

    if (_triggered) {
      where.noStroke();
      where.fill(255);
      _triggerTimer++;
      if(_triggerTimer > 100){
      _triggered = false;
      _triggerTimer =0; 
      }
    } else {
      where.fill(0);
      where.ellipse(0, 0, 10, 10);
      where.noFill();
      where.stroke(255);
      where.strokeWeight(1);
    }

    where.ellipse(0, 0, 10, 10);
    where.popMatrix();
  }

  //public boolean sense(float tx, float ty) {
  //  //println("sense called (" + _pos.x + ", " + _pos.y + ")");
  //  boolean retval = false;
  //    if ( Geometry.inCircle(_pos.x, _pos.y, _radius, tx, ty) ) {
  //      if (-1 == _lastDetected) {
  //        _lastDetected = millis();
  //      } else {
  //        if ( (millis() - _lastDetected) > _sensitivity) {
  //          _lastDetected = -1;
  //          _triggered = retval = true;
  //          _triggerCount++;
  //          // @NOTE must debounce so that it's not triggered more than once
  //          // every time you go under the sensor
  //        }
  //      }
  //    } else {
  //      _triggered = retval = false;
  //    }
  //  return retval;
  //} // sense()
} // class
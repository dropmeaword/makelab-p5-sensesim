import ComputationalGeometry.*;

public class Contour {
  IsoSurface iso;
  SensorGrid grid;

  public Contour(PApplet parent, SensorGrid g) {
    // Creating the Isosurface
    grid = g;
    iso = new IsoSurface(parent, new PVector(0,0,0), grid.bounds(), 16);
  } 

  public void update(List <PVector>points, List<Float> weights) {
    for(int i = 0; i < points.size(); i++) {
      iso.clear();
      Float w = weights.get(i);
      // @TODO correctly update weights
      iso.addPoint( points.get(i), (random(100)/100)); //w.floatValue()/grid._avgTriggers );
    }
  } // update

  public void append(List <PVector>points) {
    for(int i = 0; i < points.size(); i++) {
      float w = 1.0f; //(random(100)/100);
      if( ((i % 2) == 0) ) { w = 2.9f; }
      iso.addPoint(points.get(i), (random(100)/100) );
    }
  } // append
  
  public void draw(float threshold) {
    iso.plot(threshold); //mouseX/10000.0);
  }
  
} // class
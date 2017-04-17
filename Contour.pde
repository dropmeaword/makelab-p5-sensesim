import ComputationalGeometry.*;

public class Contour {
  IsoSurface iso;
  SensorGrid grid;

  public Contour(PApplet parent, SensorGrid g) {
    // Creating the Isosurface
    grid = g;
    iso = new IsoSurface(parent, new PVector(0,0,0), grid.bounds(), 16);
  }

  public void update(List <PVector>points) {
    for(int i = 0; i < points.size(); i++) {
      iso.clear();
      iso.addPoint( points.get(i), (random(100)/100) );
    }
  } // update

  public void append(List <PVector>points) {
    for(int i = 0; i < points.size(); i++) {
      iso.addPoint(points.get(i), (random(100)/100) );
    }
  } // append
  
  public void draw(float threshold) {
    iso.plot(threshold); //mouseX/10000.0);
  }
  
} // class
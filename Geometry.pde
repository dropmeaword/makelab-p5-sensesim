public static class Geometry {
  static boolean inRect(double centerX, double centerY, double radius, double x, double y)
  {
          return x >= centerX - radius && x <= centerX + radius && 
              y >= centerY - radius && y <= centerY + radius;
  }    
  
  static boolean inCircle(double centerX, double centerY, double radius, double x, double y)
  {
      if(inRect(centerX, centerY, radius, x, y))
      {
          double dx = centerX - x;
          double dy = centerY - y;
          dx *= dx;
          dy *= dy;
          double distanceSquared = dx + dy;
          double radiusSquared = radius * radius;
          return distanceSquared <= radiusSquared;
      }
      return false;
  }
}
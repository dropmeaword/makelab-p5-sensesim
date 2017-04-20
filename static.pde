class Dead extends Animation{

  Dead(){
    
  }
  
  void show(){
    for (int j = 0; j < GRID_H; j++) {
      for (int i = 0; i < GRID_W; i++) {
        grid.node[i][j].paint_solid(color(0));
      }
    }
  }
  
}
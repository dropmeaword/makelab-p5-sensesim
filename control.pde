class Control {

  int rows = 6; 
  int cols = 8;

  NetAddress [][]nodes;

  OscP5 oscP5;
  NetAddress destination;


  Control() {
    oscP5 = new OscP5(this, 2048);

    nodes = new NetAddress[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        String address = "192.168.8." + (j * rows + i + 100);
        nodes[i][j] = new NetAddress(address, 54321);
      }
    }
  }

  void update() {
  }

  void oscEvent(OscMessage inmsg) {

    String payload = inmsg.get(0).stringValue(); 
    String[] parts = payload.split(" ");


    PVector nodepos = new PVector();
    String[] locs = parts[1].split(",");
    for (int i = 0; i < locs.length; i++) {
      nodepos.x = int(locs[0]);
      nodepos.y = int(locs[1]);
    }

    println(nodepos);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (i == nodepos.x && j == nodepos.y) {
          //destination = nodes[i][j];
          println(nodepos.y * rows + nodepos.x + 100);
          //println(destination);
          //println("----------------------");
        }
      }
    }
    //println(destination);

    OscMessage outmsg = new OscMessage(parts[0]);

    String[] colors = parts[2].split(",");
    for (int i = 0; i < colors.length; i++) {
      int colVal = int(colors[i]);
      outmsg.add(colVal);
    }

    forward_to_node(outmsg);
  }

  void forward_to_node(OscMessage outmsg) {
    oscP5.send(outmsg, destination);
  }
  
  
}
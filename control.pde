public NetAddress[][] nodes;

void init_networking(int rows, int cols) {
  // create the map between node col,row positions and IP addresses
  nodes = new NetAddress[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      String address = "192.168.8." + (j * rows + i + 100);
      nodes[i][j] = new NetAddress(address, OSC_OUT_HARDWARE);
    }
  }
}

public NetAddress get_ip_from_grid(int row, int col) {
  if( nodes != null) { return nodes[row][col]; } else { return null; }
}

void handle_firefly_message(OscMessage inmsg) {
    String payload = inmsg.get(0).stringValue();
    String[] parts = payload.split(" ");

    int gridx = 0, gridy = 0;
    String[] locs = parts[1].split(",");
    for (int i = 0; i < locs.length; i++) {
      gridx = int(locs[0]);
      gridy = int(locs[1]);
    }

    println("received FF message for node " + gridx + ", " + gridy);

    // build a new message from faulty firefly shizzle to forward to node
    OscMessage outmsg = new OscMessage(parts[0]);

    String[] colors = parts[2].split(",");
    for (int i = 0; i < colors.length; i++) {
      int colVal = int(colors[i]);
      outmsg.add(colVal);
    }

    // calculate IP addres of my node given position in grid
    NetAddress dest = get_ip_from_grid(gridx, gridy);
    forward_to_node(outmsg, dest);
}

void forward_to_node(OscMessage outmsg, NetAddress dest) {
  println("forwarding message from FF >> " + outmsg + " to destination " + dest);
  oscin.send(outmsg, dest);
}

void handle_node_heartbeat(OscMessage inmsg) {
  println("HEARTBEAT from node " + inmsg.get(0).intValue() );
}

void handle_node_sensor_data(OscMessage inmsg) {
  println("SENSOR from node " + inmsg.get(0).intValue() );
}

void handle_hardware_message(OscMessage inmsg) {
  if(inmsg.checkAddrPattern("/node/ack") == true) {
    handle_node_heartbeat( inmsg );
  } else if (inmsg.checkAddrPattern("/node/sensor") == true) {
    handle_node_sensor_data( inmsg );
  }
}

void oscEvent(OscMessage inmsg) {
  if(inmsg.checkAddrPattern("/0/Panel") == true) {
    handle_firefly_message( inmsg );
  } else {
    handle_hardware_message( inmsg );
  }
} // global OSC input handler

class Monitor { 
    void displayServerPoolStats() {
          pushMatrix();
          translate(layoutManager.serverPoolLeftMargin+layoutManager.serverBoxWidth,layoutManager.serverPoolTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("size " + server.pool.size(), 0, 0);
          text("busy " + server.poolBusy, 0, 20);
          popMatrix();
    }
}

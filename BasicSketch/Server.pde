class Server { 
    void display() {
          stroke(0);
          strokeWeight(1);  
          fill(255);
          rectMode(CORNERS);
          rect(layoutManager.serverSideLeftMargin,
            layoutManager.serverSideTopMargin,
            layoutManager.serverSideLeftMargin + layoutManager.serverSideWidth,
            layoutManager.serverSideTopMargin + layoutManager.serverSideHeight);
          // text
          fill(0);
          textFont(f,18);
          text("server", layoutManager.serverSideLeftMargin,
            layoutManager.serverSideTopMargin-10);
    }
}

class LayoutManager { 
  float clientSideRad = 20;
  int clientSideTopMargin = 50;
  int clientSideLeftMargin = 10;
  int clientSideVertSpacer = 2;
  int clientSideMaxRows = 15;
  
  int serverBoxTopMargin = 30;
  int serverBoxLeftMargin = 300;
  int serverBoxHeight = 400 - serverBoxTopMargin*2;
  int serverBoxWidth = 150;
  int serverBoxVertSpacer = 2;
  
  int serverPoolLeftMargin = serverBoxLeftMargin + 3;
  int serverPoolTopMargin = serverBoxTopMargin + 50;
  
    void displayServerBox() {
          pushMatrix();
          translate(layoutManager.serverBoxLeftMargin,layoutManager.serverBoxTopMargin);
          // text
          fill(0);
          textFont(f,18);
          text("server", 0, -4);
          //box
          stroke(#ABCBE5);
          strokeWeight(1);  
          fill(#CBDEED);
          rectMode(CORNERS);
          rect(0, 0, layoutManager.serverBoxWidth, layoutManager.serverBoxHeight);
          popMatrix();
          displayServerPool();
    }

    void displayServerPool() {
          pushMatrix();
          translate(serverPoolLeftMargin,serverPoolTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("pool", 0, -4);
          //box
          // TOOD when limited pool size
          //stroke(178);
          //strokeWeight(2);  
          //fill(255);
          //rectMode(CORNERS);
          //rect(0, 0, 20, 20);
          popMatrix();
    }

}

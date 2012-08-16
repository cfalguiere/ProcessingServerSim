import org.uncommons.maths.random.GaussianGenerator;

class LayoutManager { 
  float clientSideRad = 20;
  float clientSideRadMoving = 15;
  int clientSideTopMargin = 130;
  int clientSideLeftMargin = 10;
  int clientSideVertSpacer = 2;
  
  int serverBoxTopMargin = 40;
  int serverBoxLeftMargin = 300;
  int serverBoxHeight = 400 - serverBoxTopMargin*2;
  int serverBoxWidth = 140;
  int serverBoxVertSpacer = 2;
  
  int serverBacklogLeftMargin = serverBoxLeftMargin + 3;
  int serverBacklogTopMargin = serverBoxTopMargin + 30;
  int serverBacklogWidth = serverBoxWidth - 6;
  int serverBacklogHeight =  round(clientSideRad*2) + clientSideVertSpacer*3;
  
  int serverPoolLeftMargin = serverBoxLeftMargin + 3;
  int serverPoolTopMargin = (optionsManager.useMaxPoolSize?serverBacklogTopMargin + serverBacklogHeight:30) + 50;
  int serverPoolWidth = serverBoxWidth - 6;

  int transferAnimationDuration = 300;

  float respTimeBoxLeftMargin = 10;
  float respTimeBoxTopMargin = 50;
  float respTimeChartWidth = 250;
  float respTimeChartHeight = 40;
  color lineColor = #ABCBE5;

  float resourcesBoxLeftMargin = serverBoxLeftMargin + serverBoxWidth + 20;
  float resourcesBoxTopMargin = serverBoxTopMargin;

  PVector respTimeBoxPosition = new PVector(10, 50);
  PVector respTimeBoxSize = new PVector(250, 40);
  float gaugeDiameter = 80;

  PVector memoryBoxPosition = new PVector(resourcesBoxLeftMargin, resourcesBoxTopMargin + 200);
  PVector memoryBoxSize = new PVector(150, 40);
  
  
  GaussianGenerator rng = new GaussianGenerator(3, 2, new Random());

    void displayServerBox() {
          pushMatrix();
          translate(serverBoxLeftMargin, serverBoxTopMargin);
          // text
          fill(0);
          textFont(f,18);
          text("server", 0, -4);
          //box
          stroke(#ABCBE5);
          strokeWeight(1);  
          fill(#CBDEED);
          rectMode(CORNERS);
          rect(0, 0, serverBoxWidth, serverBoxHeight);
          popMatrix();
          displayServerBacklog();
          displayServerPool();
    }

    void displayServerBacklog() {
      if (optionsManager.useMaxPoolSize) {
          pushMatrix();
          translate(serverBacklogLeftMargin, serverBacklogTopMargin);
          fill(0);
          textFont(f,14);
          text("backlog", 0, -8);
          stroke(#ABCBE5);
          fill(#E1E8ED);
          rect(0, 0, serverBacklogWidth, serverBacklogHeight);
          popMatrix();
      }
    }

    void displayServerPool() {
          pushMatrix();
          translate(serverPoolLeftMargin, serverPoolTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("pool", 0, -24);
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

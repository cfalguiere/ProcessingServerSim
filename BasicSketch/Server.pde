class Server { 
    List<Conversation> pool = new ArrayList<Conversation>();
    
    int incomingRequest(Conversation pConversation) {
      pool.add(pConversation);
      return pool.size()-1;
    }
    
    int terminatingRequest(Conversation pConversation) {
      int pos = pool.indexOf(pConversation);
      pool.set(pos, null);
      return pos;
    }
    
    void displayBox() {
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
    
    void displayEntry(int i) {
          stroke(128,128,128,128);
          strokeWeight(1);  
          color fillColor = pool.get(i).fillColor;
          fill(fillColor, 255);
          rectMode(CENTER);
          //translate(200,0);
          float rad = layoutManager.clientSideRad;
          float xpos = layoutManager.serverSideLeftMargin + 10 + rad/2;
          float ypos = layoutManager.serverSideTopMargin + 10 + i*(rad+layoutManager.serverSideVertSpacer) + rad/2;
          ellipse(xpos, ypos, rad, rad);
    }
    
    void eraseEntry(int i) {
          stroke(255);
          strokeWeight(2);  
          fill(255);
          rectMode(CENTER);
          //translate(200,0);
          float rad = layoutManager.clientSideRad;
          float xpos = layoutManager.serverSideLeftMargin + 10 + rad/2;
          float ypos = layoutManager.serverSideTopMargin + 10 + i*(rad+layoutManager.serverSideVertSpacer) + rad/2;
          ellipse(xpos, ypos, rad, rad);
          //TODO factoriser
    }
}

class Server { 
    List<Conversation> pool = new ArrayList<Conversation>();
    
    int incomingRequest(Conversation pConversation) {
      int pos = -1;
      for (int i=0; i<pool.size(); i++) {
        if (pool.get(i)==null) {
          pos = i;
          break;
        }
      }
      if (pos >= 0) {
        pool.set(pos, pConversation);
      } else {
        pool.add(pConversation);
        pos = pool.size()-1;
      }  
      println("SERVER incoming request for conversation " 
        + pConversation.id + " at position " + pos);
      return pos;
    }
    
    int terminatingRequest(Conversation pConversation) {
      int pos = pool.indexOf(pConversation);
      pool.set(pos, null);
      println("SERVER terminating request for conversation " 
        + pConversation.id + " at position " + pos);
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
    
    void display() {
      for (int i=0; i<pool.size(); i++) {
        //println("SERVER displaying entry at position " + i);
        Conversation entry = pool.get(i);
        if (entry != null) {
          stroke(128,128,128,128);
          strokeWeight(1);  
          color fillColor = entry.fillColor;
          fill(fillColor, 255);
          rectMode(CENTER);
          float rad = layoutManager.clientSideRad;
          float xpos = layoutManager.serverSideLeftMargin + 10 + rad/2;
          float ypos = getYPos(i);
          ellipse(xpos, ypos, rad, rad);
        }
      }
    }
    
    float getYPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          return layoutManager.serverSideTopMargin + 10 + posInPool*(rad+layoutManager.serverSideVertSpacer) + rad/2;
    }

}

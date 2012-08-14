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
    
    //TODO faire dessiner par le layout manager 
    void displayBox() {
          pushMatrix();
          translate(layoutManager.serverSideLeftMargin,layoutManager.serverSideTopMargin);
          // text
          fill(0);
          textFont(f,18);
          text("server", 0, -4);
          //box
          stroke(#ABCBE5);
          strokeWeight(1);  
          fill(#CBDEED);
          rectMode(CORNERS);
          rect(0, 0, layoutManager.serverSideWidth, layoutManager.serverSideHeight);
          popMatrix();
    }
    
    void display() {
      for (int i=0; i<pool.size(); i++) {
        //println("SERVER displaying entry at position " + i);
        Conversation entry = pool.get(i);
        if (entry != null) {
          if (entry.currentState==State.StateValue.WAITING) {
            // wait until the translation is done
            stroke(128,128,128,128);
            strokeWeight(1);  
            color fillColor = entry.fillColor;
            fill(fillColor, 255);
            rectMode(CENTER);
            pushMatrix();
            translate(layoutManager.serverSideLeftMargin,layoutManager.serverSideTopMargin);
            float rad = layoutManager.clientSideRad;
            float xpos = 10 + rad/2;
            float ypos = getYPos(i);
            ellipse(xpos, ypos, rad, rad);
            popMatrix();
          }
        }
      }
    }
    
    float getYPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          return 10 + posInPool*(rad+layoutManager.serverSideVertSpacer) + rad/2;
    }

}

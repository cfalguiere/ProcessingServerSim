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
      monitor.incPoolBusyCount();
      return pos;
    }
    
    int terminatingRequest(Conversation pConversation) {
      int pos = pool.indexOf(pConversation);
      pool.set(pos, null);
      println("SERVER terminating request for conversation " 
        + pConversation.id + " at position " + pos);
      monitor.decPoolBusyCount();
      return pos;
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
            translate(layoutManager.serverPoolLeftMargin,layoutManager.serverPoolTopMargin);
            float rad = layoutManager.clientSideRad;
            float xpos = getXPos(i);
            float ypos = getYPos(i);
            ellipse(xpos, ypos, rad, rad);
            popMatrix();
          }
        }
      }
    }
    
    float getXPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          int col = posInPool / layoutManager.serverPoolMaxRows;
          return col*(rad+layoutManager.serverBoxVertSpacer) + rad/2;
    }
    
    float getYPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          int row = posInPool % layoutManager.serverPoolMaxRows;
          return row*(rad+layoutManager.serverBoxVertSpacer) + rad/2;
    }
//TODO vector
}

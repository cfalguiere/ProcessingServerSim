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
            float ypos = getYPos(i);
            ellipse(rad/2, ypos, rad, rad);
            popMatrix();
          }
        }
      }
    }
    
    float getYPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          return posInPool*(rad+layoutManager.serverSideVertSpacer) + rad/2;
    }

}

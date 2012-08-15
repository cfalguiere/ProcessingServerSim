class Server { 
    List<Conversation> pool = new ArrayList<Conversation>();
    List<Conversation> backlog = new ArrayList<Conversation>();
    
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
        scheduler.scheduleDoing(pConversation);
        //TODO factorise on pool
        monitor.incPoolBusyCount();
      } else {
        if (optionsManager.useMaxPoolSize && pool.size()>=optionsManager.maxPoolSize) {
          backlog.add(pConversation);
          //TODO real response time in conversation
        } else {
          pool.add(pConversation);
          scheduler.scheduleDoing(pConversation);
          monitor.incPoolBusyCount();
          pos = pool.size()-1;
        }
      }  
      println("SERVER incoming request for conversation " 
        + pConversation.id + " at position " + pos);
      return pos;
    }
    
    int terminatingRequest(Conversation pConversation) {
      //TODO c'est pas au client de faire ça
      int pos = pool.indexOf(pConversation);
      pool.set(pos, null);
      println("SERVER terminating request for conversation " 
        + pConversation.id + " at position " + pos);
      monitor.decPoolBusyCount();
      return pos;
    }
    
    
    void checkBacklog() {
      while (monitor.poolBusy<pool.size() && backlog.size()>0) {
        Conversation conversation = backlog.get(0);
        int pos = incomingRequest(conversation);
        println("SERVER moving conversation " 
        + conversation.id + " from backlog to pool at position " + pos);
        backlog.remove(conversation);
      }
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
          int col = posInPool / optionsManager.serverPoolMaxRows;
          return col*(rad+layoutManager.serverBoxVertSpacer) + rad/2;
    }
    
    float getYPos(int posInPool) {
          float rad = layoutManager.clientSideRad;
          int row = posInPool % optionsManager.serverPoolMaxRows;
          return row*(rad+layoutManager.serverBoxVertSpacer) + rad/2;
    }
//TODO vector
}

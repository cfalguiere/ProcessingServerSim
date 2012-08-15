class Server { 
    List<Conversation> pool = new ArrayList<Conversation>();
    List<Conversation> backlog = new ArrayList<Conversation>();
    List<PVector> backlogCoord = new ArrayList<PVector>();
    
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
      logger.debug("Server", "incoming request for conversation " 
        + pConversation.id + " at position " + pos);
      return pos;
    }
    
    int terminatingRequest(Conversation pConversation) {
      //TODO c'est pas au client de faire ça
      int pos = pool.indexOf(pConversation);
      pool.set(pos, null);
      logger.debug("Server", "terminating request for conversation " 
        + pConversation.id + " at position " + pos);
      monitor.decPoolBusyCount();
      return pos;
    }
    
    
    void checkBacklog() {
      while (monitor.poolBusy<pool.size() && backlog.size()>0) {
        Conversation conversation = backlog.get(0);
        int pos = incomingRequest(conversation);
        logger.debug("Server", "moving conversation " 
        + conversation.id + " from backlog to pool at position " + pos);
        backlog.remove(conversation);
      }
    }
    
    void display() {
        displayPool();
        displayBacklog();
    }
    
    void displayBacklog() {
        for (int i=0; i<backlog.size(); i++) {
            Conversation entry = backlog.get(i);
            stroke(128,128,128,128);
            strokeWeight(1);  
            color fillColor = entry.fillColor;
            fill(fillColor, 255);
            rectMode(CENTER);
            pushMatrix();
            translate(layoutManager.serverBacklogLeftMargin,layoutManager.serverBacklogTopMargin);
            float rad = layoutManager.clientSideRad;
            PVector coord = (i<backlogCoord.size()?backlogCoord.get(i):null);
            if (coord == null) {
              int n = round(layoutManager.serverBacklogWidth /  (rad/2)) - 1;
              float x = (i%n)*(rad/2) + rad/2 + layoutManager.rng.nextValue().intValue();
              int rows = (i/n)%3;
              float y = rows*(rad/2) + rad/2 + layoutManager.rng.nextValue().intValue();
              coord = new PVector(x, y);
              backlogCoord.add(coord);
            }
            ellipse(coord.x, coord.y, rad, rad);
            popMatrix();
        }
    }
      
    void displayPool() {
        for (int i=0; i<pool.size(); i++) {
            //logger.debug("Server", "displaying entry at position " + i);
            Conversation entry = pool.get(i);
            if (entry != null) {
                if (entry.currentState==State.StateValue.DOING) { /*entry.currentState==State.StateValue.WAITING || */
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

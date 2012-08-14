class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = layoutManager.clientSideRad;
  State.StateValue currentState;
  color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
  float xTranslate;
  float yTranslate;
  int posInPool;
  int currentResponseTime;
  
  Conversation() {
    id = conversationCounter++;
    currentState = State.StateValue.INITIALIZED;
    int row = id % layoutManager.clientSideMaxRows;
    float col = id / layoutManager.clientSideMaxRows / 2.0f;
    xpos = col*(rad+layoutManager.clientSideVertSpacer) + rad/2 + layoutManager.rng.nextValue().intValue();
    ypos = row*(rad+layoutManager.clientSideVertSpacer) + rad/2 + layoutManager.rng.nextValue().intValue();
  }
  
  void changeState(State.StateValue pState) {
    currentState = pState;
    switch (currentState) {
      case STARTED:
        scheduler.scheduleSendRequest(this);
        monitor.incConversationStartedCount();
        break;
      case SENDING:
        scheduler.scheduleSending(this);
        posInPool = server.incomingRequest(this);
        xTranslate = layoutManager.clientSideLeftMargin + xpos;
        yTranslate = layoutManager.clientSideTopMargin + ypos;
        monitor.incPendingRequestsCount();
        break;
      case WAITING:
        scheduler.scheduleResponse(this);
        break;
      case RECEIVING:
        scheduler.scheduleReceiving(this);
        posInPool = server.terminatingRequest(this);
        xTranslate = layoutManager.serverPoolLeftMargin;
        yTranslate = layoutManager.serverPoolTopMargin + server.getYPos(posInPool);
        monitor.decPendingRequestsCount();
        monitor.incTotalRequestsCount();
        break;
      case THINKING:
        scheduler.scheduleThinkTime(this);
        break;
    }
  }
  
  void display() {
      if (currentState == State.StateValue.INITIALIZED) {
        return;
      }
      
      pushMatrix();
      translate(layoutManager.clientSideLeftMargin,layoutManager.clientSideTopMargin);
      stroke(255);
      strokeWeight(4);  
      fill(255);
      ellipse(xpos, ypos, rad, rad);

      switch (currentState) {
        case STARTED:
          stroke(128,128,128,128);
          strokeWeight(1);  
          fill(fillColor, 255);
          break;
        case SENDING:
          stroke(255,255,255,255);
          strokeWeight(4);  
          fill(fillColor, 255);
          break;
        case WAITING:
          stroke(128,128,128,128);
          strokeWeight(1);  
          fill(fillColor, 64);
          break;
        case RECEIVING:
          stroke(255,255,255,255);
          strokeWeight(4);  
          fill(fillColor, 64);
          break;
        case THINKING:
          stroke(128,128,128,128);
          strokeWeight(1);  
          fill(fillColor, 255);
          break;
        default:
          println("received unknown state " + currentState);
      }
      
      rectMode(CENTER);
      ellipse(xpos, ypos, rad, rad);
      popMatrix();
  }
  
  void displayTranslationAfter() {
      switch (currentState) {
        case SENDING:
          xTranslate = xTranslate + 10;
          float yPosServer = layoutManager.serverPoolTopMargin + server.getYPos(posInPool);
          yTranslate = yTranslate + (yPosServer-ypos)/30; //TODO enlever l'approximation
          if (yTranslate>yPosServer) yTranslate=yPosServer; // TODO constrain
          if (xTranslate<layoutManager.serverPoolLeftMargin) {
            pushMatrix();
            translate(xTranslate, yTranslate);
            fill(fillColor);
            ellipse(0, 0, 15, 15); //TODO parameter
            popMatrix();
          } 
        break;
        default:
        break;
      }
  }
  
  void displayTranslationBefore() {
      switch (currentState) {
        case RECEIVING:
          //translate(x, height/2-w/2);
          xTranslate = xTranslate - 10;
          float yPosServerR = layoutManager.serverPoolTopMargin + server.getYPos(posInPool);
          yTranslate = yTranslate - (yPosServerR-ypos)/30; //TODO enlever l'approximation
          if (yTranslate>yPosServerR) yTranslate=ypos; // TODO constrain
          if (xTranslate>layoutManager.clientSideLeftMargin+rad) {
            pushMatrix();
            translate(xTranslate, yTranslate);
            fill(fillColor);
            ellipse(0,0, 15, 15);
            popMatrix();
          } 
        break;
        default:
        break;
      }
  }
  
}

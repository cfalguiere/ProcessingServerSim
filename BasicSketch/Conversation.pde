class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = layoutManager.clientSideRad;
  State.StateValue currentState;
  color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
  int posInPool;
  int currentResponseTime;
  Animation animation;
  
  Conversation() {
    id = conversationCounter++;
    currentState = State.StateValue.INITIALIZED;
    int row = id % optionsManager.clientSideMaxRows;
    float col = id / optionsManager.clientSideMaxRows / 2.0f;
    xpos = col*(rad+layoutManager.clientSideVertSpacer) + rad/2 + layoutManager.rng.nextValue().intValue();
    ypos = row*(rad+layoutManager.clientSideVertSpacer) + rad/2 + layoutManager.rng.nextValue().intValue();
    animation = new Animation(this, State.AnimationValue.NONE);
  }
  
  void changeState(State.StateValue pState) {
    currentState = pState;
    switch (currentState) {
      case STARTED:
        scheduler.scheduleSendRequest(this);
        monitor.incConversationStartedCount();
        break;
      case SENDING:
        scheduler.scheduleSending(this); // TODO enlever et simplifier les constructeurs
        animation = new Animation(this, State.AnimationValue.SENDING);
        break;
      case WAITING:
        posInPool = server.incomingRequest(this);
        monitor.incPendingRequestsCount();
        break;
      case DOING:
        scheduler.scheduleResponse(this);
        break;
      case RECEIVING:
        scheduler.scheduleReceiving(this);
        posInPool = server.terminatingRequest(this);
        animation = new Animation(this, State.AnimationValue.RECEIVING);
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
        case DOING:
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
          logger.error("Conversation", "received unknown state " + currentState);
      }
      
      rectMode(CENTER);
      ellipse(xpos, ypos, rad, rad);
      popMatrix();
  }
  
  /*
  void displayTranslationAfter() {
      switch (currentState) {
        case SENDING:
          float nbFrames = layoutManager.transferAnimationDuration / frameRate;
          xTranslate = xTranslate + 10;
          float yPosServer = layoutManager.serverPoolTopMargin + server.getYPos(posInPool);
          yTranslate = yTranslate + (yPosServer-ypos)/30; //TODO enlever l'approximation
          logger.debug("Conversation", "ypos " + ypos +" yTranslate " + yTranslate + " yPosServer " + yPosServer);
          if (yTranslate>yPosServer) yTranslate=yPosServer; // TODO constrain
          if (xTranslate<layoutManager.serverPoolLeftMargin) {
            pushMatrix();
            translate(xTranslate, yTranslate);
            fill(fillColor);
            ellipse(0, 0, layoutManager.clientSideRadMoving, layoutManager.clientSideRadMoving); //TODO parameter
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
  */
  
}

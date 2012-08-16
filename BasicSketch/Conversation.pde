class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = layoutManager.clientSideRad;
  State.StateValue currentState;
  color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
  int posInPool;
  //int currentResponseTime;
  int requestStartTime;
  int nbRequestsInSession;
  Animation animation;
  boolean isInPeak = false;
  
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
        requestStartTime = millis();
        break;
      case WAITING:
        posInPool = server.incomingRequest(this);
        monitor.incPendingRequestsCount();
        break;
      case DOING:
        scheduler.scheduleResponse(this);
        monitor.reportResponseBegin(); 
        break;
      case RECEIVING:
        scheduler.scheduleReceiving(this);
        posInPool = server.terminatingRequest(this);
        animation = new Animation(this, State.AnimationValue.RECEIVING);
        monitor.reportResponseEnd(millis() - requestStartTime);
        monitor.decPendingRequestsCount();
        break;
      case THINKING:
        if (!isInPeak) {
            scheduler.scheduleThinkTime(this);
        } else {
            if (nbRequestsInSession<optionsManager.maxNbRequestsInSessionInPeaks) {
                scheduler.scheduleThinkTime(this);
                nbRequestsInSession++;
            } else {
              int pos = conversations.indexOf(this);
              conversations.set(pos, null);
              monitor.decConversationStartedCount();
            }
        }
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
      
      ellipseMode(CENTER);
      ellipse(xpos, ypos, rad, rad);
      popMatrix();
  }
  
}

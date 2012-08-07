class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = layoutManager.clientSideRad;
  State.StateValue currentState;
  color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
  float xTranslate;
  int posInPool;
  
  Conversation() {
    id = conversationCounter++;
    currentState = State.StateValue.INITIALIZED;
    xpos = layoutManager.clientSideLeftMargin + rad/2;
    ypos = layoutManager.clientSideTopMargin + id*(rad+layoutManager.clientSideVertSpacer) + rad/2;
  }
  
  void changeState(State.StateValue pState) {
    currentState = pState;
    switch (currentState) {
      case STARTED:
        scheduler.add(new Event(millis()+1000, this, State.StateValue.SENDING));
        break;
      case SENDING:
        scheduler.add(new Event(millis()+300, this, State.StateValue.WAITING));
        posInPool = server.incomingRequest(this);
        xTranslate = xpos;
        break;
      case WAITING:
        scheduler.add(new Event(millis()+5000, this, State.StateValue.RECEIVING));
        break;
      case RECEIVING:
        scheduler.add(new Event(millis()+300, this, State.StateValue.THINKING));
        posInPool = server.terminatingRequest(this);
        xTranslate = layoutManager.serverSideLeftMargin;
        break;
      case THINKING:
        if (!stopping) {
          scheduler.add(new Event(millis()+5000, this, State.StateValue.SENDING));
        }
        break;
    }
      //TODO variable timers 
  }
  
  void display() {
      if (currentState == State.StateValue.INITIALIZED) {
        return;
      }
      
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
  }
  
  void displayTranslation() {
      switch (currentState) {
        case SENDING:
          //translate(x, height/2-w/2);
          xTranslate = xTranslate + 10;
          if (xTranslate<layoutManager.serverSideLeftMargin) {
            pushMatrix();
            translate(xTranslate, 0);
            fill(fillColor);
            ellipse(layoutManager.clientSideLeftMargin+rad, ypos, 15, 15);
            popMatrix();
            //TODO actual location on the server side
          } 
        break;
        case RECEIVING:
          //translate(x, height/2-w/2);
          xTranslate = xTranslate - 10;
          if (xTranslate>layoutManager.clientSideLeftMargin+rad) {
            pushMatrix();
            translate(xTranslate, 0);
            fill(fillColor);
            ellipse(-layoutManager.clientSideLeftMargin+rad, ypos, 15, 15);
            popMatrix();
            //TODO actual location on the server side
          } 
        break;
        default:
        break;
      }
  }
}

class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = layoutManager.clientSideRad;
  State.StateValue currentState;
  color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
  
  Conversation() {
    id = conversationCounter++;
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
        scheduler.add(new Event(millis()+100, this, State.StateValue.WAITING));
        break;
      case WAITING:
        scheduler.add(new Event(millis()+1000, this, State.StateValue.RECEIVING));
        break;
      case RECEIVING:
        scheduler.add(new Event(millis()+100, this, State.StateValue.THINKING));
        break;
    }
      //TODO loop after thinking
      //TODO timers as parameters
      //TODO stop on click
  }
  
  void display() {
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
          int pos = server.incomingRequest(this);
          server.displayEntry(pos);
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
          int pos2 = server.terminatingRequest(this);
          server.eraseEntry(pos2);
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
}

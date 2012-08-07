class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = 20;
  State.StateValue currentState;
  color fillColor = color(random(255),random(255), random(255));
  
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
    }
      
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
          break;
        case WAITING:
          stroke(128,128,128,128);
          strokeWeight(1);  
          fill(fillColor, 64);
          break;
        default:
          println("received unknown state " + currentState);
      }
      
      rectMode(CENTER);
      //translate(200,0);
      ellipse(xpos, ypos, rad, rad);
  }
}

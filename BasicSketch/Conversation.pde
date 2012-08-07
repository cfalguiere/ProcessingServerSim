class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = 20;
  State.StateValue currentState;
  
  Conversation() {
    id = conversationCounter++;
    xpos = layoutManager.clientSideLeftMargin + rad/2;
    ypos = layoutManager.clientSideTopMargin + id*(rad+layoutManager.clientSideVertSpacer) + rad/2;
  }
  
  void changeState(State.StateValue pState) {
    currentState = pState;
    switch (currentState) {
      case STARTED:
        //scheduler.add(new Event(millis()+1000, this));
      break;
    }
      
  }
  
  void display() {
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(xpos, ypos, rad, rad);
  }
}

class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = 20;
  
  Conversation() {
    id = conversationCounter++;
    xpos = layoutManager.clientSideLeftMargin + rad/2;
    ypos = layoutManager.clientSideTopMargin + id*(rad+layoutManager.clientSideVertSpacer) + rad/2;
  }
  
  void display() {
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(xpos, ypos, rad, rad);
  }
}

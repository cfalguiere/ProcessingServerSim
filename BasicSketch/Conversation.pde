class Conversation { 
  int id;
  float xpos;
  float ypos;
  float rad = 20;
  
  Conversation() {
    id = conversationCounter++;
    xpos = 10;
    ypos = id*rad + 10;
  }
  
  void display() {
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(xpos, ypos, rad, rad);
  }
}

class Conversation { 
  Conversation() {
  }
  
  void display() {
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(random(380)+10, random(380)+10,random(40)+10,random(40)+10);
  }
}

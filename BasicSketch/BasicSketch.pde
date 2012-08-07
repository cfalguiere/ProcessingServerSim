
import java.util.TreeSet;

TreeSet scheduler;

void setup() {
  size(400, 400);
  background(255);
  
  scheduler = new TreeSet();
  scheduler.add(new Event(1000));
  scheduler.add(new Event(2000));
  scheduler.add(new Event(3000));
  
}
 
void draw() {
  //background(255);
  
 if (scheduler.size()>0) {
    Event next = (Event)scheduler.first();
    println("millis " + millis() + " got event at " + next.startMs ); 
    if (next.startMs<=millis()) {
      println("displaying event " ); 
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(random(380)+10, random(380)+10,random(40)+10,random(40)+10);
      scheduler.remove(next);
    }
  }


}



import java.util.TreeSet;

TreeSet scheduler;
int frameCount;

void setup() {
  size(400, 400);
  background(255);
  
  frameCount = 0;
  scheduler = new TreeSet();
  scheduler.add(new Event(1, 1000));
  scheduler.add(new Event(2, 1000));
  scheduler.add(new Event(3, 2000));
  scheduler.add(new Event(4, 3000));
  
}
 
void draw() {
  //background(255);
 frameCount++;
 if (scheduler.size()>0) {
    Event next = (Event)scheduler.first();
    //println("millis " + millis() + " got event at " + next.startMs ); 
    while (next!=null && next.startMs<=millis()) {
      println("frame " + frameCount + " millis " + millis() + " displaying event " ); 
      stroke(128,128,128,128);
      fill(color(random(255),random(255), random(255)));
      rectMode(CENTER);
      //translate(200,0);
      ellipse(random(380)+10, random(380)+10,random(40)+10,random(40)+10);
      scheduler.remove(next);
      next = (scheduler.size()>0?(Event)scheduler.first():null);
    }
  }


}


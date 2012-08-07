
import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
TreeSet scheduler;
int frameCount;
static int conversationCounter = 0;
static int eventCounter = 0;

void setup() {
  size(400, 400);
  background(255);
  
  frameCount = 0;
  scheduler = new TreeSet();
  scheduler.add(new Event(1000, new Conversation()));
  scheduler.add(new Event(1000, new Conversation()));
  scheduler.add(new Event(2000, new Conversation()));
  scheduler.add(new Event(3000, new Conversation()));
  
}
 
void draw() {
  //background(255);
 frameCount++;
 if (scheduler.size()>0) {
    Event next = (Event)scheduler.first();
    //println("millis " + millis() + " got event at " + next.startMs ); 
    while (next!=null && next.startMs<=millis()) {
      println("frame " + frameCount + " millis " + millis() + " displaying event " ); 
      next.conversation.display();
      scheduler.remove(next);
      next = (scheduler.size()>0?(Event)scheduler.first():null);
    }
  }


}


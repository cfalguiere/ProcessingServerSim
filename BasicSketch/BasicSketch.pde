
import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
TreeSet scheduler;
Server server = new Server();
int frameCount;
static int conversationCounter = 0;
static int eventCounter = 0;
PFont f;

void setup() {
  size(400, 400);
  background(255);
  smooth();
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  
  frameCount = 0;
  scheduler = new TreeSet();
  scheduler.add(new Event(1000, new Conversation()));
  scheduler.add(new Event(1000, new Conversation()));
  scheduler.add(new Event(2000, new Conversation()));
  scheduler.add(new Event(3000, new Conversation()));

  server.displayBox();
  
}
 
void draw() {
  //background(255);
 frameCount++;
 if (scheduler.size()>0) {
    Event next = (Event)scheduler.first();
    //println("millis " + millis() + " got event at " + next.startMs ); 
    while (next!=null && next.startMs<=millis()) {
      println("frame " + frameCount + " millis " + millis() 
        + " displaying event for conversation " + next.conversation.id + " " + next.nextState); 
      next.conversation.changeState(next.nextState);
      next.conversation.display();
      scheduler.remove(next);
      next = (scheduler.size()>0?(Event)scheduler.first():null);
    }
  }

}

//TODO translations between client and server side


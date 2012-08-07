
import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
List<Conversation> conversations;
static int conversationCounter = 0;
TreeSet<Event> scheduler;
static int eventCounter = 0;
Server server = new Server();
int frameCount;
PFont f;

void setup() {
  size(400, 400);
  background(255);
  smooth();
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  
  frameCount = 0;
  conversations = new ArrayList<Conversation>();
  for (int i=0; i<5; i++) {
    conversations.add(new Conversation());
  }
  scheduler = new TreeSet();
  for (int i=0; i<conversations.size(); i++) {
    scheduler.add(new Event(i*1000, conversations.get(i)));
  }
  
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
//TODO must reset background for translate

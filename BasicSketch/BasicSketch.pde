
import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
List<Conversation> conversations;
static int conversationCounter = 0;
TreeSet<Event> scheduler;
static int eventCounter = 0;
Server server = new Server();
int frameCount;
PFont f;
boolean stopping = false;

void setup() {
  size(400, 400);
  background(255);
  smooth();
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  
  frameCount = 0;

  initializeLoad();  
}
 
void draw() {
  background(255);
 
  server.displayBox();
  
  frameCount++;
  
  manageEventLoop();

  for (int i=0; i<conversations.size(); i++) {
    conversations.get(i).displayTranslationBefore();
    conversations.get(i).display();
    conversations.get(i).displayTranslationAfter();
  }
  
  server.display();
 
}

void mousePressed() {
  stopping = true;
}

void manageEventLoop() {
 if (scheduler.size()>0) {
    Event next = (Event)scheduler.first();
    //println("millis " + millis() + " got event at " + next.startMs ); 
    while (next!=null && next.startMs<=millis()) {
      println("frame " + frameCount + " millis " + millis() 
        + " handling event for conversation " + next.conversation.id + " " + next.nextState); 
      next.conversation.changeState(next.nextState);
      scheduler.remove(next);
      next = (scheduler.size()>0?(Event)scheduler.first():null);
    }
  }
}

void initializeLoad() {
  conversations = new ArrayList<Conversation>();
  for (int i=0; i<5; i++) {
    conversations.add(new Conversation());
  }
  scheduler = new TreeSet();
  for (int i=0; i<conversations.size(); i++) {
    scheduler.add(new Event(i*1000, conversations.get(i)));
  }
}



import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
OptionsManager optionsManager = new OptionsManager();
Scheduler scheduler = new Scheduler();
List<Conversation> conversations;
static int conversationCounter = 0;
TreeSet<Event> schedulerEvents;
static int eventCounter = 0;
Server server = new Server();
Monitor monitor = new Monitor();
int frameCount;
PFont f;
boolean stopping = false;

void setup() {
  size(600, 400);
  background(255);
  smooth();
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  
  frameCount = 0;

  initializeLoad();  
}
 
void draw() {
  background(255);
 
  layoutManager.displayServerBox();
  
  frameCount++;
  
  manageEventLoop();

  for (int i=0; i<conversations.size(); i++) {
    conversations.get(i).displayTranslationBefore();
    conversations.get(i).display();
    conversations.get(i).displayTranslationAfter();
  }
  
  server.display();
  
  monitor.displayServerPoolStats();
  monitor.displayRequestsStats();
}

void mousePressed() {
  stopping = true;
}

//TODO deplacer dans une classe scheduler
//TODO calcul des temps dans le scheduler
void manageEventLoop() {
 if (schedulerEvents.size()>0) {
    Event next = (Event)schedulerEvents.first();
    //println("millis " + millis() + " got event at " + next.startMs ); 
    while (next!=null && next.startMs<=millis()) {
      println("frame " + frameCount + " millis " + millis() 
        + " handling event for conversation " + next.conversation.id + " " + next.nextState); 
      next.conversation.changeState(next.nextState);
      schedulerEvents.remove(next);
      next = (schedulerEvents.size()>0?(Event)schedulerEvents.first():null);
    }
  }
}

void initializeLoad() {
  conversations = new ArrayList<Conversation>();
  for (int i=0; i<optionsManager.maxConversations; i++) {
    conversations.add(new Conversation());
  }
  schedulerEvents = new TreeSet();
  for (int i=0; i<conversations.size(); i++) {
    int startOffset = optionsManager.startDelayMs + (i*1000/optionsManager.rampupS);
    schedulerEvents.add(new Event(startOffset, conversations.get(i)));
  }
}



import java.util.TreeSet;

LayoutManager layoutManager = new LayoutManager();
OptionsManager optionsManager = new OptionsManager();
Scheduler scheduler = new Scheduler();
List<Conversation> conversations;
static int conversationCounter = 0;
Server server = new Server();
Monitor monitor = new Monitor();
Logger logger = new Logger();
int frameCount;
PFont f;
boolean stopping = false;

void setup() {
  size(600, 400);
  background(255);
  smooth();
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  
  frameCount = 0;

  scheduler.initializeLoad();  
}
 
void draw() {
  background(255);
  
  if (monitor.usedMemory>optionsManager.memoryGCThreshold && optionsManager.showResourceUsageImpact) {
    scheduler.scheduleGC();
  }
 
  layoutManager.displayServerBox();
  
  frameCount++;
  
  scheduler.manageEventLoop();

  for (int i=0; i<conversations.size(); i++) {
    conversations.get(i).displayTranslationBefore();
    conversations.get(i).display();
    conversations.get(i).displayTranslationAfter();
  }
  server.checkBacklog();
  
  server.display();
  
  monitor.displayServerPoolStats();
  monitor.displayBacklogStatus();
  monitor.displayRequestsStats();
  if (optionsManager.showResourceUsage) {
      monitor.displayResourceUsage();
  }
}


void mousePressed() {
  stopping = true;
}




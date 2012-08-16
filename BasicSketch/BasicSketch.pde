
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
  layoutManager.displayRespTimeChartBox();
  
  frameCount++;
  
  scheduler.manageEventLoop();

  for (int i=0; i<conversations.size(); i++) {
      Conversation conversation = conversations.get(i);
      conversation.animation.displayReceiving(); // TODO switch in display
      conversation.display();
      conversation.animation.displaySending();
  }
  server.checkBacklog();
  
  server.display();
  
  monitor.displayRequestsStats();
  monitor.displayRespTimeSparkLine();
  monitor.displayServerPoolStats();
  monitor.displayBacklogStatus();
  if (optionsManager.showResourceUsage) {
      monitor.displayResourceUsage();
  }
}


void mousePressed() {
  stopping = true;
}




import org.uncommons.maths.random.GaussianGenerator;

class Scheduler {
    TreeSet<Event> schedulerEvents;
    int eventCounter = 0;
    GaussianGenerator responseTimeRNG;
    GaussianGenerator thinkTimeRNG;
    long gcUntilMs = 0;
    boolean inGc = false;
  
    Scheduler() {
      responseTimeRNG = new GaussianGenerator(optionsManager.responseTimeMean, optionsManager.responseTimeSD, new Random());
      thinkTimeRNG = new GaussianGenerator(optionsManager.thinkTimeMean, optionsManager.thinkTimeSD, new Random());
    }
  
    int getResponseTimeRandom() {
      return constrain(responseTimeRNG.nextValue().intValue(),0,200000) 
          + monitor.cpuUsage*optionsManager.cpuImpactCoef + monitor.cpuQueue*optionsManager.cpuQueueImpactCoef;
    }
    
    int getThinkTimeRandom() {
      return constrain(thinkTimeRNG.nextValue().intValue(),0,10000);
    }
    
    void scheduleSendRequest(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+1000, conversation, State.StateValue.SENDING));
    }
    
    void scheduleSending(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+300, conversation, State.StateValue.WAITING));
    }
    
    void scheduleResponse(Conversation conversation) {
        conversation.currentResponseTime = scheduler.getResponseTimeRandom();
        println(conversation.id + " Waiting " +  conversation.currentResponseTime);
        schedulerEvents.add(new Event(millis()+ conversation.currentResponseTime, conversation, State.StateValue.RECEIVING));
        monitor.reportResponseTime( conversation.currentResponseTime);
    }
    
    void scheduleReceiving(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+300, conversation, State.StateValue.THINKING));
    }
  
    void scheduleThinkTime(Conversation conversation) {
        if (!stopping) {
          int thinktime = scheduler.getThinkTimeRandom();
          schedulerEvents.add(new Event(millis()+thinktime, conversation, State.StateValue.SENDING));
        }
    }
 
    void scheduleGC() {
        if (!inGc) {
            inGc = true;
            gcUntilMs = millis() + optionsManager.gcDuration;
        }
    }
  
    void manageEventLoop() {
       if (inGc) {
         if (gcUntilMs<=millis()) {
              inGc = false;
              monitor.mimicGarbage();
              monitor.incGcPause(optionsManager.gcDuration);
         }
         return;
       }
         
       
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
}



import org.uncommons.maths.random.GaussianGenerator;

class Scheduler {
    TreeSet<Event> schedulerEvents;
    int eventCounter = 0;
    GaussianGenerator responseTimeRNG;
    GaussianGenerator thinkTimeRNG;
    GaussianGenerator arrivalRNG;
    long gcUntilMs = 0;
    boolean inGc = false;
    long nextPeak = 0;
  
    Scheduler() {
      responseTimeRNG = new GaussianGenerator(optionsManager.responseTimeMean, optionsManager.responseTimeSD, new Random());
      thinkTimeRNG = new GaussianGenerator(optionsManager.thinkTimeMean, optionsManager.thinkTimeSD, new Random());
      arrivalRNG = new GaussianGenerator(optionsManager.arrivalIntervalMsMean, optionsManager.arrivalIntervalMsSD, new Random());
    }
  
    int getResponseTimeRandom() {
        int rt = constrain(responseTimeRNG.nextValue().intValue(),optionsManager.responseTimeMean/2,optionsManager.responseTimeMean*5);
        if (optionsManager.showResourceUsageImpact) {
          rt += monitor.cpuUsage*optionsManager.cpuImpactCoef + monitor.cpuQueue*optionsManager.cpuQueueImpactCoef;
        }
        return rt;
    }
    
    int getThinkTimeRandom() {
      return constrain(thinkTimeRNG.nextValue().intValue(),optionsManager.thinkTimeMean/2,optionsManager.thinkTimeMean*5);
    }
    
    void scheduleSendRequest(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+1000, conversation, State.StateValue.SENDING));
    }
    
    void scheduleSending(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+layoutManager.transferAnimationDuration, conversation, State.StateValue.WAITING));
    }
    
    void scheduleDoing(Conversation conversation) {
        schedulerEvents.add(new Event(millis()+layoutManager.transferAnimationDuration, conversation, State.StateValue.DOING));
    }
    
    void scheduleResponse(Conversation conversation) {
        int serverResponseTime = scheduler.getResponseTimeRandom();
        //logger.debug("Scheduler", conversation.id + " Waiting " +  serverResponseTime);
        schedulerEvents.add(new Event(millis()+ serverResponseTime, conversation, State.StateValue.RECEIVING));
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
            gcUntilMs = millis() + optionsManager.gcDurationMs;
        }
    }
  
    void manageEventLoop() {
       if (inGc) {
         if (gcUntilMs<=millis()) {
              inGc = false;
              monitor.mimicGarbage();
              monitor.incGcPause(optionsManager.gcDurationMs);
         }
         return;
       }
         
       
       if (schedulerEvents.size()>0) {
            Event next = (Event)schedulerEvents.first();
            while (next!=null && next.startMs<=millis()) {
                //logger.debug("Scheduler", "frame " + frameCount + " millis " + millis() 
                //  + " handling event for conversation " + next.conversation.id + " " + next.nextState); 
                next.conversation.changeState(next.nextState);
                schedulerEvents.remove(next);
                next = (schedulerEvents.size()>0?(Event)schedulerEvents.first():null);
            }
       }
       
       if (optionsManager.usePeaks && millis()>=nextPeak) {
          initializePeak();
       }
    }

    void initializeLoad() {
        conversations = new ArrayList<Conversation>();
        for (int i=0; i<optionsManager.maxConversations; i++) {
          conversations.add(new Conversation());
        }
        schedulerEvents = new TreeSet();
        int cumulatedInterval = 0; // TODO overflow ?
        for (int i=0; i<conversations.size(); i++) {
          cumulatedInterval += constrain(arrivalRNG.nextValue().intValue(),optionsManager.arrivalIntervalMsMean/2,optionsManager.arrivalIntervalMsMean*5);
          int startOffset = optionsManager.startDelayMs + cumulatedInterval;
          schedulerEvents.add(new Event(startOffset, conversations.get(i)));
        }
        nextPeak = millis() + optionsManager.intervalMsBetweenPeaks;
    }
    
    void initializePeak() {
        int nbUsers = optionsManager.maxConversationsInPeaks - conversations.size();
        int cumulatedInterval = 0; // TODO overflow ?
        for (int i=0; i<nbUsers; i++) { //TODO remove magic number
            Conversation conversation = new Conversation();
            conversation.isInPeak = true;
            int pos = -1;
            for (int p=0; p<conversations.size(); p++) {
                if (conversations.get(p)==null) {
                      pos = i;
                      break;
                }
            }
            if (pos >= 0) {
                conversations.set(pos, conversation);
            } else {
                conversations.add(conversation);
            }

            cumulatedInterval += constrain(arrivalRNG.nextValue().intValue()/4,optionsManager.arrivalIntervalMsMean/8,optionsManager.arrivalIntervalMsMean*5); //TODO magic numbers
            int startOffset = millis() + cumulatedInterval;
            schedulerEvents.add(new Event(startOffset, conversation));
        }
        nextPeak = millis() + optionsManager.intervalMsBetweenPeaks;
    }

}



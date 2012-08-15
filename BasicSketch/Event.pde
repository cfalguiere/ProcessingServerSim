class Event implements Comparable<Event> { 
  long startMs;
  int id;
  Conversation conversation;
  State.StateValue nextState;
  
  Event(long pStartMs, Conversation  pConversation) {
    id = scheduler.eventCounter++;
    startMs = pStartMs;
    conversation = pConversation;
    nextState = State.StateValue.STARTED;
  }
  
  Event(long  pStartMs, Conversation  pConversation, State.StateValue  pNextState) {
    id = scheduler.eventCounter++;
    startMs =  pStartMs;
    conversation = pConversation;
    nextState = pNextState;
  }
  
  public int compareTo(Event o) {
    int diff = (int)(this.startMs - o.startMs) ;
    if (diff == 0) {
      diff = (this.id - o.id) ;
    }
    return diff;
  }
}



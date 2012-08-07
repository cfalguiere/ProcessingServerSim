class Event implements Comparable<Event> { 
  long startMs;
  int id;
  Conversation conversation;
  State.StateValue nextState;
  
  Event(long tempStartMs, Conversation tempConversation) {
    id = eventCounter++;
    startMs = tempStartMs;
    conversation = tempConversation;
    nextState = State.StateValue.STARTED;
  }
  
  Event(long tempStartMs, Conversation tempConversation, State.StateValue tempNextState) {
    id = eventCounter++;
    startMs = tempStartMs;
    conversation = tempConversation;
    nextState = tempNextState;
  }
  
  public int compareTo(Event o) {
    int diff = (int)(this.startMs - o.startMs) ;
    if (diff == 0) {
      diff = (this.id - o.id) ;
    }
    return diff;
  }
}

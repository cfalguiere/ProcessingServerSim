class Event implements Comparable<Event> { 
  long startMs;
  int id;
  Conversation conversation;
  Event(long tempStartMs, Conversation tempConversation) {
    id = eventCounter++;
    startMs = tempStartMs;
    conversation = tempConversation;
  }
  public int compareTo(Event o) {
    int diff = (int)(this.startMs - o.startMs) ;
    if (diff == 0) {
      diff = (this.id - o.id) ;
    }
    return diff;
  }
}

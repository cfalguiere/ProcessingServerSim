class Event implements Comparable<Event> { 
  long startMs;
  int id;
  Conversation conversation;
  Event(int tempId, long tempStartMs, Conversation tempConversation) {
    id = tempId;
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

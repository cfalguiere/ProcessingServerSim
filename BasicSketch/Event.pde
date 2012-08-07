class Event implements Comparable<Event> { 
  long startMs;
  int id;
  Event(int tempId, long tempStartMs) {
    id = tempId;
    startMs = tempStartMs;
  }
  public int compareTo(Event o) {
    int diff = (int)(this.startMs - o.startMs) ;
    if (diff == 0) {
      diff = (this.id - o.id) ;
    }
    return diff;
  }
}

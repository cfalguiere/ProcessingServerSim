class Event implements Comparable<Event> { 
  long startMs;
  Event(long tempStartMs) {
    startMs = tempStartMs;
  }
  public int compareTo(Event o) {
    return (int)(this.startMs - o.startMs) ;
  }
}

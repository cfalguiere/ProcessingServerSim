class State {
  public enum StateValue {
    STARTED, SENDING, WAITING, RECEIVING, THINKING 
  }
  
  
  public String toString(StateValue state) {
    String s = null;
    switch (state) {
      case STARTED:
        s = "STARTED";
      break;
      default:
        s = "TODO";
      break;
    }
    return s;
  }
}


class State {
  public enum StateValue {
     INITIALIZED, STARTED, SENDING, WAITING, DOING, RECEIVING, THINKING 
  }
 
  public enum AnimationValue {
     NONE, SENDING, RECEIVING
  }
  
  public enum UnitType {
     DURATION, BYTES  
  }
  
  public enum BytesUnit {
     o, Ko, Mo, Go  
  }
  
  public enum DurationUnit {
     ms, s
  }
  
}


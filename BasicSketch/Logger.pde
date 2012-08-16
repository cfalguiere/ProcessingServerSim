class Logger {

    void log(String severity, String sender, String message) {
        String s = String.format("%s fr:%s ts:%s - %s - %s", severity, frameCount, millis(), sender, message);
        println(s);   
    }

    void debug(String sender, String message) {
      if (sender.equals("Monitor")){
          log("D", sender, message);    
      }
    }

    void info(String sender, String message) {
        log("I", sender, message);    
    }

    void error(String sender, String message) {
        log("E", sender, message);    
    }
}


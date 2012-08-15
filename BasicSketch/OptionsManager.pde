class OptionsManager { 
  int maxConversations = 100;
  int startDelayMs = 1000;
  // nb new conversations per seconds
  int rampupS = 5;

  int clientSideMaxRows = 12;
  int serverPoolMaxRows = 10;
  
  int responseTimeMean = 2000;
  float responseTimeSD = 500;
  int thinkTimeMean = 5000;
  float thinkTimeSD = 0;

  boolean showResourceUsage = false;
  int memoryPerRequest;
  int poolSaturation;
  
  boolean showResourceUsageImpact = false;
  int cpuImpactCoef;
  int cpuQueueImpactCoef;
  int memoryGCThreshold;
  int gcDuration;
  
  boolean useMaxPoolSize = false;
  int maxPoolSize;
  
  OptionsManager() {
       configureResourceUsage();
       configureResourceUsageImpact();
       configureVariableThinktime();
       configureLimitedPoolAndBacklog();
       //configureDebug();
  }
  
  void configureResourceUsage() {
      showResourceUsage = true;
      memoryPerRequest = 15000;
      poolSaturation = 25; // pool = 25 -> 100% CPU
  }
  
  void configureResourceUsageImpact() {
    showResourceUsageImpact = true;
    cpuImpactCoef = 10;
    cpuQueueImpactCoef = 100;
    memoryGCThreshold = 1000000;
    gcDuration = 20;
  }
  
  void configureVariableThinktime() {
      thinkTimeSD = 4500;
  }
  
  void configureLimitedPoolAndBacklog() {
    useMaxPoolSize = true;
    maxPoolSize = 20;
    serverPoolMaxRows = 5;
  }
  
  
  void configureDebug() {
    maxConversations = 2;
    clientSideMaxRows = 2;
    serverPoolMaxRows = 2;
    responseTimeMean = 5000;
    thinkTimeMean = 5000;
    useMaxPoolSize = true;
    maxPoolSize = 1;
  }
}


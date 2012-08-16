class OptionsManager { 
  int maxConversations = 100;
  int startDelayMs = 1000;

  int arrivalIntervalMsMean = 100;
  float arrivalIntervalMsSD = 0;

  int clientSideMaxRows = 10;
  //int serverPoolMaxRows = 10;
  
  int responseTimeMean = 1500;
  float responseTimeSD = 0;
  int thinkTimeMean = 4000;
  float thinkTimeSD = 0;

  boolean showResourceUsage = false;
  int startupMemory;
  int memoryPerRequest;
  int memoryPerSession;
  int poolSaturation;
  
  boolean showResourceUsageImpact = false;
  int cpuImpactCoef;
  int cpuQueueImpactCoef;
  int memoryGCThreshold;
  int gcDurationMs;
  
  boolean useMaxPoolSize = false;
  int maxPoolSize;
  
  boolean useTimeouts = true; 
  int timeoutThresholdMs = 10000;

  boolean usePeaks = false; 
  int intervalMsBetweenPeaks = 0;
  int maxConversationsInPeaks = 0;
  int maxNbRequestsInSessionInPeaks = 0;
  
  OptionsManager() {
       configureResourceUsage();
       configureResourceUsageImpact();
       configureVariability();
       //configureLimitedPoolAndBacklog();
       //configureDebug();
  }
  
  void configureResourceUsage() {
      showResourceUsage = true;
      startupMemory = 500000000; // 500Mo
      memoryPerRequest = 2000000; // 2Mo
      memoryPerSession = 5000000; // 5Mo
      poolSaturation = 25; // pool = 25 -> 100% CPU
  }
  
  void configureResourceUsageImpact() {
    showResourceUsageImpact = true;
    cpuImpactCoef = 5;
    cpuQueueImpactCoef = 300;
    memoryGCThreshold = 2000000000; //1Go
    gcDurationMs = 100;
  }
  
  void configureVariability() {
      responseTimeSD = responseTimeMean*3;
      thinkTimeSD = thinkTimeMean*3;
      arrivalIntervalMsSD = arrivalIntervalMsMean*3;
      usePeaks = true;
      intervalMsBetweenPeaks = 30000;
      maxConversations = 50;
      maxConversationsInPeaks = 150;
      maxNbRequestsInSessionInPeaks = 1;
  }
  
  void configureLimitedPoolAndBacklog() {
    useMaxPoolSize = true;
    maxPoolSize = 20;
    //serverPoolMaxRows = 5;
  }
  
  
  void configureDebug() {
    maxConversations = 10;
    clientSideMaxRows = 10;
    //serverPoolMaxRows = 5;
    responseTimeMean = 1000;
    thinkTimeMean = 1000;
    useMaxPoolSize = false;
    maxPoolSize = 10;
  }
}


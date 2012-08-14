class OptionsManager { 
  int maxConversations = 100;
  int startDelayMs = 1000;
  // nb new conversations per seconds
  int rampupS = 5;
  
  int responseTimeMean = 2000;
  float responseTimeSD = 500;
  int thinkTimeMean = 5000;
  float thinkTimeSD = 500;

  int memoryPerRequest = 10000;
  int poolSaturation = 20; // pool = 20 -> 100% CPU
  //boolean showResourceUsage = true;
}

import org.uncommons.maths.random.GaussianGenerator;

class Scheduler {
  GaussianGenerator responseTimeRNG;
  GaussianGenerator thinkTimeRNG;
  
  Scheduler() {
    responseTimeRNG = new GaussianGenerator(optionsManager.responseTimeMean, optionsManager.responseTimeSD, new Random());
    thinkTimeRNG = new GaussianGenerator(optionsManager.thinkTimeMean, optionsManager.thinkTimeSD, new Random());
  }
  
  int getResponseTimeRandom() {
    return responseTimeRNG.nextValue().intValue();
  }
  
  int getThinkTimeRandom() {
    return thinkTimeRNG.nextValue().intValue();
  }
}



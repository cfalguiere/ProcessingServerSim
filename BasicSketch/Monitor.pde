class Monitor { 
    int conversationStartedCount = 0;
    int totalRequestsCount = 0;
    int pendingRequestsCount = 0;
    long cumResponseTime = 0;
    int poolBusy = 0;
    int cpuUsage;
    int cpuQueue;

    void displayServerPoolStats() {
          pushMatrix();
          translate(layoutManager.serverPoolLeftMargin+layoutManager.serverBoxWidth/2,layoutManager.serverPoolTopMargin - 24);
          // text
          fill(0);
          textFont(f,14);
          text("size " + "busy", 0, 0);
          textFont(f,22);
          String values = String.format("%02d %02d", server.pool.size(), poolBusy);
          text(values, 0, 20);
          popMatrix();
    }

    void displayRequestsStats() {
          pushMatrix();
          translate(layoutManager.clientSideLeftMargin,20);
          // text
          fill(0);
          textFont(f,14);
          text("users   requests              resp. time", 0, 0);
          textFont(f,22);
          long avgResponseTime = (totalRequestsCount>0?cumResponseTime/totalRequestsCount:-1);
          String values = String.format("%03d  %03d - %02d/s",  conversationStartedCount,  
              pendingRequestsCount, totalRequestsCount*1000/millis());
          if (avgResponseTime >= 0) {
            values = String.format("%s  %04dms",  values, avgResponseTime);  
          }
          text(values, 0, 20);
          popMatrix();
    }

    void  displayResourceUsage() {
        // pool = 20 -> 100% CPU
        cpuUsage = constrain(poolBusy*5, 0, 100);
        cpuQueue = constrain(poolBusy - 20, 0, 10000);
          pushMatrix();
          translate(layoutManager.serverBoxLeftMargin+layoutManager.serverBoxWidth + 10,layoutManager.serverBoxTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("CPU Usage", 0, 10);
          text("CPU Queue", 0, 50);
          // bars
          fill(255*cpuUsage/100,255*(100-cpuUsage)/100,64);
          noStroke();
          rectMode(CORNERS);
          rect(0, 15, cpuUsage, 35);
          fill(64,64,64);
          rect(0, 55, cpuQueue, 75);
          popMatrix();
    }
    
    void incPoolBusyCount() {poolBusy++;}
    void decPoolBusyCount() {poolBusy--;}
    void incConversationStartedCount() {conversationStartedCount++;}
    void incTotalRequestsCount() {totalRequestsCount++;}
    void incPendingRequestsCount() {pendingRequestsCount++;}
    void decPendingRequestsCount() {pendingRequestsCount--;}
    void reportResponseTime(int duration) {cumResponseTime+=duration;}

}

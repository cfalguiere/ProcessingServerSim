class Monitor { 
    int conversationStartedCount = 0;
    int totalRequestsCount = 0;
    int pendingRequestsCount = 0;
    long cumResponseTime = 0;

    void displayServerPoolStats() {
          pushMatrix();
          translate(layoutManager.serverPoolLeftMargin+layoutManager.serverBoxWidth,layoutManager.serverPoolTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("size " + "busy", 0, 0);
          textFont(f,22);
          String values = String.format("%02d %02d", server.pool.size(), server.poolBusy);
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
    
    void incConversationStartedCount() {conversationStartedCount++;}
    void incTotalRequestsCount() {totalRequestsCount++;}
    void incPendingRequestsCount() {pendingRequestsCount++;}
    void decPendingRequestsCount() {pendingRequestsCount--;}
    void reportResponseTime(int duration) {cumResponseTime+=duration;}

}

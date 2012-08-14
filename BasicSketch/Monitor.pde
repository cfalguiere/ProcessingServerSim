class Monitor { 
    int conversationStartedCount = 0;
    int totalRequestsCount = 0;
    int pendingRequestsCount = 0;

    void displayServerPoolStats() {
          pushMatrix();
          translate(layoutManager.serverPoolLeftMargin+layoutManager.serverBoxWidth,layoutManager.serverPoolTopMargin);
          // text
          fill(0);
          textFont(f,14);
          text("size " + server.pool.size(), 0, 0);
          text("busy " + server.poolBusy, 0, 20);
          popMatrix();
    }

    void displayRequestsStats() {
          pushMatrix();
          translate(layoutManager.clientSideLeftMargin,20);
          // text
          fill(0);
          textFont(f,14);
          text("users: " + conversationStartedCount + " - pending requests: " + pendingRequestsCount, 0, 0);
          text("total requests: " + totalRequestsCount + " - " + totalRequestsCount*1000/millis() + "/s", 0, 20);
          popMatrix();
    }
    
    void incConversationStartedCount() {conversationStartedCount++;}
    void incTotalRequestsCount() {totalRequestsCount++;}
    void incPendingRequestsCount() {pendingRequestsCount++;}
    void decPendingRequestsCount() {pendingRequestsCount--;}

}

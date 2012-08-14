import java.text.DecimalFormatSymbols;

class Monitor { 
    int conversationStartedCount = 0;
    int totalRequestsCount = 0;
    int pendingRequestsCount = 0;
    long cumResponseTime = 0;
    int poolBusy = 0;
    int cpuUsage;
    int cpuQueue;
    int usedMemory;
    int gcPauses;
    DecimalFormat formatter;
    
    Monitor() {
      DecimalFormatSymbols symbols = new DecimalFormatSymbols();
      symbols.setGroupingSeparator(' ');
      formatter = new DecimalFormat("###,###.##", symbols);
    }
    

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
        
        cpuUsage = constrain(poolBusy*(100/optionsManager.poolSaturation), 0, 100);
        cpuQueue = constrain(poolBusy - optionsManager.poolSaturation, 0, 10000);
          pushMatrix();
          translate(layoutManager.serverBoxLeftMargin+layoutManager.serverBoxWidth + 10,layoutManager.serverBoxTopMargin + 10);
          // text
          fill(0);
          textFont(f,14);
          text("CPU Usage", 0, 10);
          text("CPU Queue", 0, 50);
          text("Memory", 0, 90);
          text("GC Pauses ", 0, 130);
          // bars
          fill(255*cpuUsage/100,255*(100-cpuUsage)/100,128);
          noStroke();
          rectMode(CORNERS);
          rect(0, 15, cpuUsage, 35);
          fill(64,64,64);
          rect(0, 55, cpuQueue, 75);
          // text memory
          fill(0);
          textFont(f,18);
          text(formatter.format(usedMemory), 0, 110);
          text(formatter.format(gcPauses), 0, 150);
          popMatrix();
    }
    
    void incGcPause(int duration) {gcPauses+=duration;}
    void incPoolBusyCount() {poolBusy++;}
    void decPoolBusyCount() {poolBusy--;}
    void incConversationStartedCount() {conversationStartedCount++;}
    void incTotalRequestsCount() {
      totalRequestsCount++;
      usedMemory += optionsManager.memoryPerRequest;
    }
    void incPendingRequestsCount() {pendingRequestsCount++;}
    void decPendingRequestsCount() {pendingRequestsCount--;}
    void reportResponseTime(int duration) {cumResponseTime+=duration;}

    void mimicGarbage() {
      usedMemory = poolBusy*optionsManager.memoryPerRequest;
      if (usedMemory>2000000) {
          println("warning usedMemory " + usedMemory);
      }
    }
    
}

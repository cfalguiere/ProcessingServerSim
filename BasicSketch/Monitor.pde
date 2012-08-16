import java.text.DecimalFormatSymbols;

class Monitor { 
    int conversationStartedCount = 0;
    int totalRequestsCount = 0;
    int pendingRequestsCount = 0;
    int poolBusy = 0;
    int cpuUsage;
    int cpuQueue;
    int gcPauses;
    DecimalFormat formatter;
    DecimalFormat sparklineFormatter;
    List<Long> responseTimes = new ArrayList<Long>();
    List<Long> memorySize = new ArrayList<Long>();
    long cumResponseTime = 0;
    long avgResponseTime = 0;
    long maxResponseTime = 0;
    long usedMemory = optionsManager.startupMemory;
    long maxMemorySize = optionsManager.startupMemory;
    int timeoutCount = 0;
    
    Monitor() {
      DecimalFormatSymbols symbols = new DecimalFormatSymbols();
      symbols.setGroupingSeparator(' ');
      formatter = new DecimalFormat("###,###.##", symbols);
      sparklineFormatter = new DecimalFormat("##.#", symbols);
    }
    
    void displayConfig() {
        if (optionsManager.usePeaks) {
            fill(0);
            textFont(f,10);
            text(String.format("peak in %ds", (scheduler.nextPeak - millis())/1000), 10, 400 - 5);
        }
    }
    

    void displayServerPoolStats() {
          pushMatrix();
          translate(layoutManager.serverPoolLeftMargin+layoutManager.serverBoxWidth/2,layoutManager.serverPoolTopMargin - 24);
          // text
          fill(0);
          textFont(f,14);
          text((optionsManager.useMaxPoolSize?"size " + "busy":"size"), 0, 0);
          textFont(f,22);
          String values = (optionsManager.useMaxPoolSize?String.format("%02d %02d", server.pool.size(), poolBusy):String.format("%02d", server.pool.size()));
          text(values, 0, 20);
          popMatrix();
    }

    void displayBacklogStatus() {
      if (optionsManager.useMaxPoolSize) {
          pushMatrix();
          translate(layoutManager.serverBacklogLeftMargin,layoutManager.serverBacklogTopMargin);
          fill(0);
          textFont(f,16);
          String value = String.format("%02d", server.backlog.size());
          text(value, layoutManager.serverBacklogWidth - 25, -5);
          popMatrix();
      }
    }

    void displayRequestsStats() {
          pushMatrix();
          translate(layoutManager.clientSideLeftMargin,20);
          // text
          fill(0);
          textFont(f,14);
          text("users", 0, 0);
          textFont(f,22);
          String values = String.format("%03d",  conversationStartedCount);
          text(values, 0, 20);
          
          translate(50,0);
          textFont(f,14);
          text("requests", 0, 0);
          textFont(f,22);
          values = String.format("%3d - %2d/s",  totalRequestsCount, totalRequestsCount*1000/millis());
          text(values, 0, 20);
          
          if (optionsManager.useTimeouts) {
              translate(120,0);
              float errorRate = (totalRequestsCount>0?timeoutCount*100/totalRequestsCount:0);
              fill(255*errorRate/100,0,0);
              textFont(f,14);
              text("errors", 0, 0);
              textFont(f,22);
              //values = String.format("%2.0f%% - %2d/s",  errorRate, timeoutCount*1000/millis());
              values = String.format("%2.0f%%",  errorRate);
              text(values, 0, 20);
          }
          popMatrix();
          displayRespTimeSparkLine();
          
    }

    void  displayResourceUsage() { // TODO refactor
        
        cpuUsage = constrain(poolBusy*(100/optionsManager.poolSaturation), 0, 100);
        cpuQueue = constrain(poolBusy - optionsManager.poolSaturation, 0, 1000);
        
        // requests
        pushMatrix();
        translate(layoutManager.resourcesBoxLeftMargin,layoutManager.resourcesBoxTopMargin+10);
        textFont(f,14);
        text("pending", 0, 0);
        text("requests", 0, 14);
        textFont(f,22);
        String values = String.format("%3d",  pendingRequestsCount);
        text(values, 0, 35);
        popMatrix();
        
        // CPU title
        pushMatrix();
        translate(layoutManager.cpuBoxPosition.x, layoutManager.cpuBoxPosition.y);
        fill(0);
        textFont(f,14);
        text("CPU", 0, -5);
        displayCpuUsage();
        displayCpuQueue();
        popMatrix();

        
        displayMemorySparkLine();
    }

    void  displayCpuUsage() { 
        // gauge
        noStroke();
        fill(255*cpuUsage/100,255*(100-cpuUsage)/100,96);
        ellipseMode(CORNERS);
        float gaugeDiameter = layoutManager.gaugeDiameter;
        arc(0, 0, gaugeDiameter, gaugeDiameter, PI, PI*cpuUsage/100+PI); 
        if (cpuUsage>0){
            textFont(f,16);
            text(String.format("%02d%%",cpuUsage), gaugeDiameter/2-15, gaugeDiameter/2+15);
        }
    }

    void  displayCpuQueue() { 
        if (cpuQueue>0){
            float gaugeDiameter = layoutManager.gaugeDiameter;
            float spacer = 20;
            // vert bar
            noStroke();
            rectMode(CORNERS);
            fill(64,64,64);
            rect(gaugeDiameter + 20, gaugeDiameter/2, gaugeDiameter + 20 + 20, gaugeDiameter/2 - cpuQueue);
            // vert bar text
            textFont(f,16);
            text(String.format("%02d",cpuQueue), gaugeDiameter + spacer, gaugeDiameter/2 - cpuQueue - 5);
            textFont(f,12);
            text("Queue", gaugeDiameter + spacer, gaugeDiameter/2 + 13);
        }
    }
    
        
    void displayMemorySparkLine() { 
        Plotter plotter = new Plotter();
        plotter.drawSparkline("memory", memorySize, maxMemorySize, layoutManager.memoryBoxPosition, layoutManager.memoryBoxSize, State.UnitType.BYTES);
    }
    
    void displayRespTimeSparkLine() { 
        Plotter plotter = new Plotter();
        plotter.drawSparkline("resp. time", responseTimes, maxResponseTime, layoutManager.respTimeBoxPosition, layoutManager.respTimeBoxSize, State.UnitType.DURATION);
    }
    

    
    void incGcPause(int duration) {gcPauses+=duration;}
    void incPoolBusyCount() {poolBusy++;}
    void decPoolBusyCount() {poolBusy--;}
    void incConversationStartedCount() {
        conversationStartedCount++;
        usedMemory += optionsManager.memoryPerSession;
    }
    void decConversationStartedCount() {conversationStartedCount--;}
    
    void incTotalRequestsCount() {
    }
    
    void incPendingRequestsCount() {
        pendingRequestsCount++;
    }
    void decPendingRequestsCount() {pendingRequestsCount--;}

    void reportResponseBegin() {
        usedMemory += optionsManager.memoryPerRequest;
        memorySize.add(new Long(usedMemory));
        maxMemorySize = (long)max(usedMemory, maxMemorySize);
    }
    
    void reportResponseEnd(int duration) {
        cumResponseTime+=duration;
        totalRequestsCount++;
        
        avgResponseTime = (int)(cumResponseTime/totalRequestsCount); 
        responseTimes.add(new Long(avgResponseTime));
        maxResponseTime = (long)max(avgResponseTime, maxResponseTime);
        
        if (duration>optionsManager.timeoutThresholdMs) {
            timeoutCount++;
        }
    }

    void mimicGarbage() {
      usedMemory = optionsManager.startupMemory + poolBusy*optionsManager.memoryPerRequest + conversationStartedCount*optionsManager.memoryPerSession;
      if (usedMemory>2000000) {
          logger.info("Monitor", "warning usedMemory " + usedMemory);
      }
    }
    
}

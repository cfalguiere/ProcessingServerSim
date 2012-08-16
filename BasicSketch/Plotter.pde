class Plotter {
    DecimalFormat valueFormatter;
  
    Plotter() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator(' ');
        valueFormatter = new DecimalFormat("###.#", symbols);
    }

    void drawSparkline(String pTitle, List<Long> pData, long pMaxValue, PVector pBoxPosition, PVector pBoxSize, State.UnitType pUnitType) {
          pushMatrix();
          translate(pBoxPosition.x, pBoxPosition.y);
          drawSparklineFrame(pBoxSize);
          drawSparklineTitle(pTitle, pBoxSize);
          drawValues(pData, pMaxValue, pBoxSize, pUnitType);
          popMatrix();
    }
    
    void drawSparklineFrame(PVector pBoxSize) {
          stroke(layoutManager.lineColor);
          strokeWeight(1);  
          noFill();
          rectMode(CORNERS);
          line(0, pBoxSize.y, pBoxSize.x, pBoxSize.y);
          line(0, 0, 0, pBoxSize.y);
    }
    
    void drawSparklineTitle(String pTitle, PVector pBoxSize) {
          fill(0);
          textFont(f,14);
          text(pTitle, 0, pBoxSize.y +12);
    }

    
    State.BytesUnit getUnit(long value) {
            if (value < 1000000L) { // 1 or 2
                if (value < 1000L) {
                    return State.BytesUnit.o;
                } else {
                    return State.BytesUnit.Ko;
                }
            } else { // 3 or 4
                if (value < 1000000000L) {
                    return State.BytesUnit.Mo;
                } else {
                    return State.BytesUnit.Go;
                }
            }           
    }
    
    void drawValues(List<Long> pData, long pMaxValue, PVector pBoxSize, State.UnitType pUnitType) { //TODO unit type
          pushMatrix();
          stroke(#ABCBE5);
          strokeWeight(2);  
          noFill();
          float sparklineWidth = pBoxSize.x - 40;
          float sparklineHeight = pBoxSize.y * 3/4;
          float x = 0;
          float memY = pBoxSize.y; 
          float value = 0;
          State.BytesUnit unit = getUnit(pMaxValue);
          logger.debug("Plotter", "pMaxValue " + pMaxValue +  " unit " + unit);
          float scaleFactor =  pow(1000, unit.ordinal());
          float pMaxValueScaled = pMaxValue / scaleFactor;
          for (int i=0; i<pData.size(); i++) {
              value = pData.get(i).longValue() / scaleFactor;
              //logger.debug("Plotter", "raw " + pData.get(i).longValue() + " value " + value +  " unit " + unit);
              x = (pData.size()<sparklineWidth?1:(1*sparklineWidth/pData.size()));
              float y = pBoxSize.y - value*sparklineHeight/pMaxValueScaled;
              line(0, memY, x, y);
              memY = y;
              translate(x,0);
          }
          if (x>0) {
              textFont(f,15);
              fill(0);
              String label = String.format("%s %s", valueFormatter.format(value),unit);  
              text(label, x+3, memY+5);
          }
          popMatrix();
    }
}

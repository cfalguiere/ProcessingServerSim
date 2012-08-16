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

    
    State.BytesUnit getBytesUnit(long value) {
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
    
    State.DurationUnit getDurationUnit(long value) {
        if (value < 1000L) {
            return State.DurationUnit.ms;
        } else {
            return State.DurationUnit.s;
        }
    }
    
    void drawValues(List<Long> pData, long pMaxValue, PVector pBoxSize, State.UnitType pUnitType) { //TODO unit type
          pushMatrix();
          stroke(#ABCBE5);
          strokeWeight(2);  
          noFill();
          float sparklineWidth = pBoxSize.x - 40;
          float sparklineHeight = pBoxSize.y * 3/4;
          String unitName = "";
          int unitOrdinal = 0;
          switch (pUnitType) {
              case DURATION:
                State.DurationUnit unitd = getDurationUnit(pMaxValue);
                //logger.debug("Plotter", "pMaxValue " + pMaxValue +  " unit " + unitd);
                unitName = unitd.name();
                unitOrdinal = unitd.ordinal();
              break;
              case BYTES:
                State.BytesUnit unitb = getBytesUnit(pMaxValue);
                //logger.debug("Plotter", "pMaxValue " + pMaxValue +  " unit " + unitb);
                unitName = unitb.name();
                unitOrdinal = unitb.ordinal();
              break;
          }
          float x = 0;
          float memY = pBoxSize.y; 
          double value = 0;
          double scaleFactor =  pow(1000, unitOrdinal);
          double pMaxValueScaled = pMaxValue / scaleFactor;
          for (int i=0; i<pData.size(); i++) {
              value = pData.get(i).longValue() / scaleFactor;
              //logger.debug("Plotter", "raw " + pData.get(i).longValue() + " value " + value +  " unit " + unit);
              x = (pData.size()<sparklineWidth?1:(1*sparklineWidth/pData.size()));
              float y = (float)(pBoxSize.y - value*sparklineHeight/pMaxValueScaled);
              if (y<0) {
                logger.debug("Plotter", "y " + y + " raw " + pData.get(i).longValue() + " value " + value);
                logger.debug("Plotter", "unitOrdinal " + unitOrdinal + " scaleFactor " + scaleFactor +  " pMaxValue " + pMaxValue  + " pMaxValueScaled " + pMaxValueScaled);
              }
              line(0, memY, x, y);
              memY = y;
              translate(x,0);
          }
          if (x>0) {
              textFont(f,15);
              fill(0);
              String label = String.format("%s %s", valueFormatter.format(value),unitName);  
              text(label, x+3, memY+5);
          }
          popMatrix();
    }
}

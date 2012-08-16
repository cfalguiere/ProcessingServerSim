class Animation {
    Conversation conversation;
    State.AnimationValue animation;
    float xTranslate;
    float wTranslate;
    float yTranslate;
    float hTranslate;
    float yPosServer;
    long stopAt;
    float nbFrames;
  
    Animation(Conversation pConversation, State.AnimationValue pAnimation) {
        conversation = pConversation;
        animation = pAnimation;
        stopAt = millis() + layoutManager.transferAnimationDuration;
        nbFrames = layoutManager.transferAnimationDuration * frameRate / 1000 +1 ; 
        yPosServer = layoutManager.serverPoolTopMargin + server.getYPos(conversation.posInPool);
        switch (animation) {
            case SENDING:
                logger.debug("Animation", "SND creating sending animation for conversation " + conversation.id);
                xTranslate = layoutManager.clientSideLeftMargin + pConversation.xpos;
                wTranslate = layoutManager.serverPoolLeftMargin - layoutManager.clientSideRadMoving - xTranslate;
                yTranslate = layoutManager.clientSideTopMargin + pConversation.ypos;
                hTranslate = 0; //yPosServer - yTranslate; // TODO test en backlog
                logger.debug("Animation", "SND xTranslate " + xTranslate  + " wTranslate " + wTranslate );
                logger.debug("Animation", "SND frameRate " + frameRate  
                      + " layoutManager.transferAnimationDuration " + layoutManager.transferAnimationDuration 
                      + " nbFrames " + nbFrames );                
                 break;
            case RECEIVING:
                logger.debug("Animation", "REC Creating receiving animation for conversation " + conversation.id);
                xTranslate = layoutManager.serverPoolLeftMargin - layoutManager.clientSideRadMoving;
                wTranslate = layoutManager.clientSideLeftMargin - xTranslate;
                yTranslate = yPosServer; 
                hTranslate = (layoutManager.clientSideTopMargin + pConversation.ypos) - yTranslate; 
                logger.debug("Animation", "REC xTranslate " + xTranslate  + " wTranslate ");
                logger.debug("Animation", "REC frameRate " + frameRate  
                      + " layoutManager.transferAnimationDuration " + layoutManager.transferAnimationDuration 
                      + " nbFrames " + nbFrames );
                break;
        }
    }
  
    void displaySending() {
        switch (animation) {
            case SENDING:
                xTranslate = constrain(xTranslate + (wTranslate/nbFrames), conversation.xpos, layoutManager.serverPoolLeftMargin - layoutManager.clientSideRadMoving );
                yTranslate = constrain(yTranslate + (hTranslate/nbFrames), conversation.ypos, yPosServer); 
                logger.debug("Animation", "SND xpos " + conversation.xpos +" xTranslate " + xTranslate + " xPosServer " + layoutManager.serverPoolLeftMargin 
                      + " wTranslate " + wTranslate);
                logger.debug("Animation", "SND ypos " + conversation.ypos +" yTranslate " + yTranslate + " yPosServer " + yPosServer);
                pushMatrix();
                translate(xTranslate, yTranslate);
                noStroke();
                fill(conversation.fillColor);
                ellipse(0, 0, layoutManager.clientSideRadMoving, layoutManager.clientSideRadMoving); 
                popMatrix();
                attemptToStop();
                break;
        }
    }
    
    void displayReceiving() { // TODO ne pas appeler directement
        switch (animation) {
            case RECEIVING:
                xTranslate = constrain(xTranslate + (wTranslate/nbFrames), conversation.xpos, layoutManager.serverPoolLeftMargin);
                yTranslate = constrain(yTranslate + (hTranslate/nbFrames),  conversation.ypos, yPosServer); //TODO actual position
                logger.debug("Animation", "REC xpos " + conversation.xpos +" xTranslate " + xTranslate + " xPosServer " + layoutManager.serverPoolLeftMargin 
                      + " wTranslate " + wTranslate);
                logger.debug("Animation", "REC ypos " + conversation.ypos +" yTranslate " + yTranslate + " yPosServer " + yPosServer);
                pushMatrix();
                translate(xTranslate, yTranslate);
                noStroke();
                fill(conversation.fillColor);
                ellipse(0,0, 15, 15);
                popMatrix();
                attemptToStop();
                break;
        }
    }
    
    void attemptToStop() {
        if (millis()>stopAt) {
          logger.debug("Animation", "stopping animation for " + conversation.id);
          conversation.animation = new Animation(conversation, State.AnimationValue.NONE); // TODO singleton
        }
    }

}

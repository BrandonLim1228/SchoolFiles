void TestSwitches(void){
// Keep track of previous switch states for comparison
  
   int prevLeftSwitchState = leftSwitchState; 
   int prevRightSwitchState = rightSwitchState;
    
// Update the switch state variables

   int leftSwitchTempState = digitalRead(switchL);
   int rightSwitchTempState = digitalRead(switchR);

// Left switch debounce code
   if(leftSwitchTempState != prevLeftSwitchState){
    timeSinceLastLeftSwitchChange = millis() - leftSwitchChangeTime;
      if(timeSinceLastLeftSwitchChange > switchDebounceTime){
        leftSwitchChangeTime = millis();
        leftSwitchTempState = leftSwitchState;
      }
   }

// Right switch Debounce code
 if(rightSwitchTempState != prevRightSwitchState){
    timeSinceLastRightSwitchChange = millis() - rightSwitchChangeTime;
      if(timeSinceLastRightSwitchChange > switchDebounceTime){
        rightSwitchChangeTime = millis();
        rightSwitchTempState = rightSwitchState;
      }
   }
// If appropriate, print a new message
  timeSinceLastPrint = millis() - printTime;
   if((leftSwitchTempState != prevLeftSwitchState) | (rightSwitchTempState != prevRightSwitchState) | (timeSinceLastPrint > printDelay)){
    printTime = millis();
    Serial.print(F("Left Switch: "));
    Serial.print(leftSwitchTempState);
    Serial.print(F("...."));
    Serial.print(F(" Right Switch: "));
    Serial.println(rightSwitchTempState);
    
   }
  
}

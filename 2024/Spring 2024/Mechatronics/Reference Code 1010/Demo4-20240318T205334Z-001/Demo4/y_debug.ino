void DebugPrint(String debugText, int debugVal) {
  // *** This function requires the following GLOBAL variables: ***
  //  unsigned long debugPrintTime = 0;
  //  unsigned long debugTimeSinceLastPrint = 0;
  //  int debugPrintDelay = 200;  // you can choose this time

  // *** Sample calling syntax: ***
  //  DebugPrint("buttonPressed: ", buttonPressed);
  //  DebugPrint("The value of black is ", black);
  
  debugTimeSinceLastPrint = millis() - debugPrintTime;

  if (debugTimeSinceLastPrint > debugPrintDelay) {
    debugPrintTime = millis();
    Serial.print(debugText);
    Serial.println(debugVal);
  } // end if
  
} // end function


void DebugBlink(int debugBlinkDelay) {
  // *** This function requires the following GLOBAL variables: ***
  //  const int debugLedPin = 13;   // onboard LED
  //  unsigned long debugBlinkTime = 0;
  //  unsigned long debugTimeSinceLastBlink = 0;
  //  int debugLedHiLo = 0;

  // *** Sample calling syntax: ***
  //  DebugBlink(200);    
  //  DebugBlink(500);    
  
  pinMode(debugLedPin, OUTPUT);
  
  debugTimeSinceLastBlink = millis()-debugBlinkTime;
  
  if (debugTimeSinceLastBlink > debugBlinkDelay) {
    debugBlinkTime = millis();
    debugLedHiLo = 1-debugLedHiLo;
    digitalWrite(debugLedPin, debugLedHiLo);
  }  // end if
  
} // end function

void TestIRLED(void){
 if(ledOn == 0){
  if(timeSinceLastBlink > ledOffTime){
    digitalWrite(irPin, HIGH);
    ledOn = 1;
    blinkTime = millis();
    Serial.println(F("The LED is on"));
  }
 }
 else{
  if(timeSinceLastBlink > ledOnTime){
    digitalWrite(irPin, LOW);
    ledOn = 0;
    blinkTime = millis();
    Serial.println(F("The LED is off"));
  }
 
 
 }
 
}

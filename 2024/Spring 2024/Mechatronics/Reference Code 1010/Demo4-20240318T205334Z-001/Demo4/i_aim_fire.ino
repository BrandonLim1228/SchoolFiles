// Function Test Aim Fire
  // Inputs/Outputs = none
  // Uses Uses UP/DOWN to increment/decrement desiredServoAngle variable by 5 degrees
  // Uses LEFT/RIGHT to decrement/increment desiredServoAngle variable by 1 degree
  // Uses SELECT to command the servo to desiredServoAngle and fire the solenoid
  
void TestAimFire(void){
  int prevButtonPressed = buttonPressed;
  ReadButtons();
  switch (buttonPressed){

  case 3:
  case 1:
  case 4:
  case 2:
  switch (buttonPressed){
    
    case 3: // UP button 
    servoAngleIncrement = 5;
    break;
    
    case 1: // DOWN button
    servoAngleIncrement = -5;
    break;
    
    case 4: // LEFT button
    servoAngleIncrement = -1;
    break;
    
    case 2: // RIGHT button
    servoAngleIncrement = 1;
    break;
  }
    timeSinceLastIncrement = millis() - incrementTime;
    if (buttonPressed != prevButtonPressed || timeSinceLastIncrement > 250){
      incrementTime = millis();
      desiredServoAngle = desiredServoAngle + servoAngleIncrement;
      desiredServoAngle = constrain(desiredServoAngle, 0, 180);
      Serial.print(F("Current Desired Servo Angle is: "));
      Serial.println(desiredServoAngle);      
    }
  break;

  case 5:
   if (buttonPressed != prevButtonPressed){
       if(state > 0){ 
       Serial.println(F("previous aim/fire sequence is still in progress"));
     }
       else{
       state = 1;
       stateChangeTime = millis();
     }  
   }
  break;
  
  case 0:
  // nothing
  break;
  
  default:
  // something went wrong do nothing
  break;
  
  }
switch(state){
  case 1:  // delay, then command the servo  
  timeSinceLastStateChange = millis() - stateChangeTime;
  if(timeSinceLastStateChange > 1000){
    launcherServo.write(desiredServoAngle);
    Serial.print(F("Launcher servo commanded to: "));
    Serial.println(desiredServoAngle);
    state = 2;
    stateChangeTime = millis();
  }
  break;
  
  case 2:  // delay, then turn the solenoid on
  timeSinceLastStateChange = millis() - stateChangeTime;
  if(timeSinceLastStateChange > 1000){
    digitalWrite(solenoidDirectPin, HIGH);
    analogWrite(solenoidPowPin, solenoidPower);
    Serial.println(F("Firing"));
    state = 3;
    stateChangeTime = millis();
  }      
  break;

  case 3:  // delay, then turn the solenoid off
    timeSinceLastStateChange = millis() - stateChangeTime;
    if(timeSinceLastStateChange > solenoidActivationTime){
    analogWrite(solenoidPowPin, 0);
    Serial.println(F("Done Firing"));
    state = 0; 
    }
  break;

}
}

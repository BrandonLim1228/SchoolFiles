// Function Test Motor
  // Inputs/Outputs = none
  // Uses LEFT/RIGHT buttons to move the launcher left/right along the linear stage
void TestMotor(void){
  int prevButtonPressed = buttonPressed;
  ReadButtons();
      switch(buttonPressed){
          
        case 3: //Up button
        case 1: //Down button
          timeSinceLastIncrement = millis() - incrementTime;
          if(buttonPressed != prevButtonPressed || timeSinceLastIncrement > 250){
            incrementTime = millis();
            if(buttonPressed == 3){
              counts = counts + 1;
            }
            else{
              counts = counts - 1;
            }
            Serial.print(F("The position is "));
            Serial.println(counts);
          }
        break;
    
        case 4:
           motorRight = 0; // Left button
           TurnMotorOn();
        break;
    
        case 2:
           motorRight = 1; // Right button
           TurnMotorOn();
        break;
    
        case 5: //Select button, 24 is the center strip
           if(counts != 24){
            counts = 24;
            Serial.print(F("The current position is "));
            Serial.println(counts);
           }
        break;
    
        case 0:  // No button
           TurnMotorOff(reverseDelay);     // turn motor off
           if(userInput == 'g'){
            CountStripes();
           }
        break;
    
        default:
          // Something went wrong, doing nothing
        break;
        }
    if(motorOn == 1)  {
      switch(userInput){
      
      case'd':
        PrintLeftRight();
      break;

      case'e':
        PrintSensorValue();
      break;

      case'f':
        PrintBlackWhite();
      break;

      case'g':
        CountStripes();
      break;
    }
  }
}

// Function PrintLeftRight
  // inputs/outputs = none
  // Description: Prints "Launcher is moving LEFT" or "Launcher is moving RIGHT" as appropriate. 
void PrintLeftRight(void){
  timeSinceLastPrint = millis() - printTime;
   if(timeSinceLastPrint > printDelay){
    printTime = millis();
    Serial.print(F("Launcher is moving "));
      if(motorRight == 1){
        Serial.println(F("RIGHT"));
      }
    else{
    Serial.println(F("LEFT"));
    }
  }
}

//Function PrintSensorValue
  // inputs/outputs = none
  // IR sensor value will print in the serial monitor if the launcher is moving
void PrintSensorValue(void){
 irSensorValue = analogRead(irSensor);
 timeSinceLastPrint = millis() - printTime;
 if(timeSinceLastPrint > 50){
  printTime = millis();
  Serial.print(F("The IR Sensor Value is "));
  Serial.println(irSensorValue);
 }
}

//Function PrintBlackWhite
  //inputs/outs = none
  // Prints "Over black" if global variable black is 1 and "Over white" if global variable black is 0.
  // It should ONLY print "Over black" or "Over white" when a change in black occurs.
void PrintBlackWhite(void){
  bool prevBlack = black;
  black = GetEncoderBoolean();
  if(black != prevBlack){
    if(black == 1){
    Serial.println(F("Over Black"));
  }
  else{
    Serial.println(F("Over White"));
  }
}
}

//Function MoveLauncher
//Inputs: none
//Outputs: none
//Depending on flag variables motorOn and startMotion, calls functions to manage launcher motion or prepare the launcher for motion. 
  void MoveLauncher(void){
    //DebugPrint("Calling Demo1 function; startMotion = ", startMotion);
    if(motorOn == 1){
      Moving();
    }
    else {
      if (startMotion == 1){
       PreparingToMove();
    }
    else{
      NotMoving();
    }
  }
  }

//Function PreparingToMove
//Inputs: none
//Outputs: none
  void PreparingToMove(void){
    // set desiredPosition
    // set motorRight
    if (userInput == 'k' || userInput == 'v'){
      switch(headed){
      case 0: 
        leftSwitchState = digitalRead(switchL);
          if(leftSwitchState ==1){
            Serial.println(F("Already home"));
            counts = 5;
            desiredPosition = 5;
            startMotion = 0;
            headed = 1;
          }
          else{
            Serial.println(F("Headed home"));
            desiredPosition = -50;
          }
      break;

      case 1: 
        desiredPosition = driveTo[target];
      break;
      
      case 2:
        desiredPosition = 100;
      break;
      }
    }
    
      if(desiredPosition > counts){
        motorRight = 1; //need to move right
      }
      else{
        motorRight = 0; //need to move left
      }
    // turn motor on
      if(counts != desiredPosition){
        TurnMotorOn();
        startMotion = 0;
   }
  }

//Functinon Moving
//Inputs: none
//Outputs: none
  void Moving(void){
    //count stripes 
      CountStripes();
    //stop at target
    if(counts == 42 && headed == 2){
      AtReloader();
      
    }
      if(counts == desiredPosition){
        if(target > 0 && target < 5 && headed == 1){
        TurnMotorOff(reverseDelay);
        CountStripes();
        Serial.print(F("Launcher at stripe "));
        Serial.println(counts);
        }
        else{
          TurnMotorOff(0);
          CountStripes();
        Serial.print(F("Launcher at stripe "));
        Serial.println(counts);
        }
        
      }
    //read switches
      leftSwitchState = digitalRead(switchL);
      rightSwitchState = digitalRead(switchR);
    //stop at home (moving left, left switch tripped)
      if(motorRight == 0 && leftSwitchState == 1){
        TurnMotorOff(reverseDelay);
        CountStripes();
        counts = 5;
        Serial.println(F("Launcher at home - counts set to 5"));
      }
    //stop at reloader(moving right, right switch tripped)
        if(motorRight == 1 && rightSwitchState == 1){
        TurnMotorOff(reverseDelay);
        CountStripes();
        counts = 43;
        Serial.println(F("Launcher at reloader - counts set to 43"));
      }
      if(headed == 1 && counts < 39){
        
              desiredServoAngle = writeToServo[target]; 
              launcherServo.write(desiredServoAngle);
            }
              if(headed == 1 && target == 0){
                if (counts == driveTo[target]-2){
                   switch(state){
                   case 1: state = 2; 
                   break;
                    
                   case 2:
                    timeSinceLastStateChange = millis() - stateChangeTime;
                    if (timeSinceLastStateChange > 20){ // good time for cannon to be accurate
                  digitalWrite(solenoidDirectPin, 255);
                  analogWrite(solenoidPowPin, solenoidPower);
                  Serial.println(F("Firing"));
                  state = 3;
                  stateChangeTime = millis();
                  }
                  break;
           
                  case 3:
                  timeSinceLastStateChange = millis() - stateChangeTime;
                  if(timeSinceLastStateChange > solenoidActivationTime){
                  analogWrite(solenoidPowPin, 0);
                  Serial.println(F("Done firing"));
                  state = 4;
                  stateChangeTime = millis();
                 }
                 break;
                 
                 case 4:
                 startMotion = 1;
                 headed = 2;
                 break;
              }
              }
              }
      if(headed == 1 && target == 5){
        if (counts == driveTo[target] + 1){
           switch(state){
                   case 1: state = 2; 
                   break;
                    
                   case 2:
                    timeSinceLastStateChange = millis() - stateChangeTime;
                    if (timeSinceLastStateChange > 20){ // good time for cannon to be accurate
                  digitalWrite(solenoidDirectPin, HIGH);
                  analogWrite(solenoidPowPin, solenoidPower);
                  Serial.println(F("Firing"));
                  state = 3;
                  stateChangeTime = millis();
                  }
                  break;
           
                  case 3:
                  timeSinceLastStateChange = millis() - stateChangeTime;
                  if(timeSinceLastStateChange > solenoidActivationTime){
                  analogWrite(solenoidPowPin, 0);
                  Serial.println(F("Done firing"));
                  state = 4;
                  stateChangeTime = millis();
                 }
                 break;
                 
                 case 4:
                 startMotion = 1;
                 headed = 0;
                 break;
              }
          
      }
      }
  }

// function not moving
  // inputs: none
  // outputs: none
void NotMoving(void){
  if(leftSwitchState == 1){
    AtHome();
  }
  //else if(rightSwitchState == 1){
    // state = 2;
     //stateChangeTime = millis();
    //AtReloader();   
  //}

  else if(desiredPosition == counts){
    AtTarget();  
  }
}

//Function at reloader
    // inputs: none
    // outputs: none

void AtReloader(void){
  switch(state){
    case 1: // dispense ball
        reloaderServo.write(dispenseAngle);
        Serial.println(F("Dispensing"));
        state = 2;
        stateChangeTime = millis();
    break;

    case 2: // delay then stop dispensing
        timeSinceLastStateChange = millis() - stateChangeTime;
        if(timeSinceLastStateChange > reloaderDownDelay){ // good time so ball reloads correct
            reloaderServo.write(holdAngle);
            Serial.println(F("Holding"));
            state = 3;
            stateChangeTime = millis();
        }   
    break;

    case 3: // delay then set motion variables
      timeSinceLastStateChange = millis() - stateChangeTime;
        if(timeSinceLastStateChange > LauncherAtReloaderDelay){ // good time so ball reloads correct
          startMotion = 1;
          headed = 1;
          target = target + 1;
          Serial.println(F("ball reloaded - setting motion variables"));        
          state = 1; 
        }
   break;
       
  }
}

//function AtHome
  // inputs: none
  // outputs: none
void AtHome(void){
  switch (state){
    case 1: //turning the led on
      digitalWrite(irPin, HIGH);
      Serial.println(F("Starting timer - LED on"));
      state = 2;
      stateChangeTime = millis();
    break;

    case 2: 
      timeSinceLastStateChange = millis() - stateChangeTime;
        if(timeSinceLastStateChange > 1000){
          digitalWrite(irPin, LOW);
          Serial.println(F("Triggering timer - LED off"));
          state = 3;
        }
    break;

    case 3:
      Serial.println(F("Setting motion variables"));
        if (target < 5){
          if(target == 0 && userInput == 'v'){
          Serial.println(F("Calling ComputeStuff")); 
          ComputeStuff();
          }
          startMotion = 1;
          headed = 1;
          state = 1;
        }
        else{
          target = 0;
          state = 0;
          Serial.println(F("All done"));
          userInput = 'x';
          if(userInput == 'v'){
            Serial.println(F("done"));
          }
        }
    break;

    
  }
}

//Function AtTarget
  //inputs: none
  //outputs: none
void AtTarget(void){
  switch(state){
    
    case 1:
      /*desiredServoAngle = writeToServo[target];                                     
      launcherServo.write(desiredServoAngle);
      Serial.print(F("Commanding launcher servo to "));
      Serial.print(desiredServoAngle);
      Serial.print(F(" for target "));
      Serial.println(target);*/
      state = 2;
      stateChangeTime = millis();
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
          state = 5;
          stateChangeTime = millis();
      }
    break;

    /*case 4:
      timeSinceLastStateChange = millis() - stateChangeTime;
        if(timeSinceLastStateChange > 50){ // good time for cannon to be accurate was 50
          launcherServo.write(55);
          Serial.println(F("Commanding launcher servo to reloader angle"));
          state = 5;
        }
    break;*/

    case 5:
      startMotion = 1;
        if (target < 5){
          headed = 2;
        }
        else{
          headed = 0;
        }
      Serial.println(F("Target actions complete - setting motion variables"));
      state = 1;
    break;
  }
}

/*void DropReloaderEarly(void){
   switch(state){
  case 1: // dispense ball
        reloaderServo.write(dispenseAngle);
        Serial.println(F("Dispensing"));
        state = 2;
        stateChangeTime = millis();
    break;

    case 2: // delay then stop dispensing
        timeSinceLastStateChange = millis() - stateChangeTime;
        if(timeSinceLastStateChange > reloaderDownDelay){ // good time so ball reloads correct
            reloaderServo.write(holdAngle);
            Serial.println(F("Holding"));
            state = 3;
            stateChangeTime = millis();
        }   
    break;
   }
}*/

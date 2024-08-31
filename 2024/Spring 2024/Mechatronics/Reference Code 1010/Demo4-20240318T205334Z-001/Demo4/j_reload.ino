// function TestReloader
    // inputs: none
    // outputs: none
    // Moves the reloader link rod to the dispense angle and then back to the hold angle when the SELECT button is pressed

void TestReloader(void){
     int prevButtonPressed = buttonPressed;
     ReadButtons();
     switch (buttonPressed){
        case 5: // SELECT 
              if(prevButtonPressed != buttonPressed){
                  if(state > 0){
                    Serial.println(F("The previous reload event is in progress"));                  
                  }
                  else
                  state = 1;
              }    
      break;
     }
     
    switch (state){
       case 1: // command reloader servo to the dispense angle
             reloaderServo.write(dispenseAngle);
             Serial.println(F("Dispensing"));
             state = 2;
             stateChangeTime = millis();
       break;

       case 2: // Delay then command the reloader to servo hold angle
             timeSinceLastStateChange = millis() - stateChangeTime;
             if(timeSinceLastStateChange > dispenseDelay){
                 reloaderServo.write(holdAngle);
                 Serial.println(F("Holding"));
                 state = 0;            
              }
       break;
       
    }
}

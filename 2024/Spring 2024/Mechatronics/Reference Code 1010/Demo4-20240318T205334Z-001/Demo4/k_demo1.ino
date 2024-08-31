// function demo1
    // inputs: none
    // outputs: none
    // Uses UP/DOWN to increment target variable.
      // Uses LEFT/RIGHT to increment headed variable.
           // Uses SELECT to assign 1 to startMotion, which will result in MoveLauncher() being called repeatedly until the 
           //launcher arrives at desiredPosition. 
 
void Demo1(void){
  int prevButtonPressed = buttonPressed;
   ReadButtons();
   switch (buttonPressed){
      case 3:
      case 1:
         timeSinceLastIncrement = millis() - incrementTime;
            if(buttonPressed != prevButtonPressed || timeSinceLastIncrement > 250){
              incrementTime = millis();
                 if(buttonPressed == 3){
                   target = target + 1;
              }
              else{
                target = target - 1;
              }
              target = constrain(target, 0, 5);
              Serial.print(F("The target is "));
              Serial.println(target);
            }
      break;
      
      case 4:
      case 2:
        timeSinceLastIncrement = millis() - incrementTime;
            if(buttonPressed != prevButtonPressed || timeSinceLastIncrement > 250){
              incrementTime = millis();
                 if(buttonPressed == 4){
                   headed = headed - 1;
              }
              else{
                headed = headed + 1;
              }
              headed = constrain(headed, 0, 2);
              Serial.print(F("The headed value is "));
              Serial.println(headed);  
            }   
       break; 
            

      case 5:
          startMotion = 1;
          state = 1;
      break;

      case 0:
        MoveLauncher();
      break;
  
  }
}

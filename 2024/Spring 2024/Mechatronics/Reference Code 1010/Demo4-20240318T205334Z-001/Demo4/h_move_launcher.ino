//Function TestMoveLauncher
//Inputs: none
//Outputs: none
//Uses UP/DOWN to increment counts variable.
  //Uses LEFT/RIGHT to increment desiredPosition variable.
  //Uses SELECT to tell the launcher that it is time to move (by setting the startMotion variable to 1)
  //When no buttons are pressed, calls the MoveLauncher() function.
  void TestMoveLauncher(void){
    int prevButtonPressed = buttonPressed;
    ReadButtons();
    switch(buttonPressed){
      case 3:
      case 1:
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
      case 2:
          timeSinceLastIncrement = millis() - incrementTime;
          if(buttonPressed != prevButtonPressed || timeSinceLastIncrement > 250){
            incrementTime = millis();
            if(buttonPressed == 2){
              desiredPosition = desiredPosition + 1;
            }
            else{
              desiredPosition = desiredPosition - 1;
            }
            Serial.print(F("The desired position is "));
            Serial.println(desiredPosition);
          }
      break;

      case 5:
        startMotion = 1;
      break; 

      case 0:
        MoveLauncher();
      break;

      default:
        //Do nothing
      break;
    }
    
  }

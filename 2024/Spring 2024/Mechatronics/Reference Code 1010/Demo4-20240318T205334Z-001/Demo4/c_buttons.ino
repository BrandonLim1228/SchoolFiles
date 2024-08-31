void TestButtons(void){
// Keep track of the previously pressed button
  int prevButtonPressed = buttonPressed;
  
// Check what button is currently pressed
ReadButtons(); 
buttonPressed = buttonNumber;
// If appropriate, print a new message
  timeSinceLastPrint = millis() - printTime;
  if((timeSinceLastPrint > printDelay) | ( buttonPressed != prevButtonPressed)){
    printTime = millis();
    switch(buttonPressed){
      
    case(3):
      Serial.println(F("Up Button Pressed"));
    break;

    case(1):
      Serial.println(F("Down Button Pressed"));
    break;

    case(4):
      Serial.println(F("Left Button Pressed"));
    break;

    case(2):
      Serial.println(F("Right Button Pressed"));
    break;

    case(5):
      Serial.println(F("Select Button Pressed"));
    break;

    case(0):
      Serial.println(F("No Button Pressed"));
    break;

    default:
      Serial.println(F("Something went wrong"));
    break;
    }
  }
}



void ReadButtons(void){
// Keep track of the previous button number
   
   int prevButtonNumber = buttonNumber; 

// Read the button value
   
   int buttonValue = analogRead(pushPin);
   
// Determine the button number that corresponds to the button value
   if(buttonValue < 5){
    buttonNumber = 1;
   }
   else if(buttonValue > 115 && buttonValue < 175){
   buttonNumber = 2;
   }
   else if(buttonValue > 305 && buttonValue <365){
    buttonNumber = 3;
   }
   else if(buttonValue > 480 && buttonValue < 540){
    buttonNumber = 4;
   }
   else if(buttonValue > 715 && buttonValue < 775){
    buttonNumber = 5;
   }
   else if(buttonValue > 1015){
    buttonNumber = 0;
   }
   else{
    buttonNumber = -1;
   }
// Determine if the button number is an actual button press or a bounce
  if(buttonNumber == prevButtonNumber){
    cibn = cibn + 1;
    if(cibn > 100){
    buttonPressed = buttonNumber;
   }
  }
  else{
    cibn = 0;
  }
}

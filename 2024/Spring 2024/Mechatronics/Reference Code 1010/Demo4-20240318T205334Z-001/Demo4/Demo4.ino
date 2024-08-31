 /****************************************************************
Author Names: Brandon Lim, Mikael Mrotek
Lab section: 04
Team number: 24
Date:  
Sketch Description:  

Button Usage: Up/Down    s3/s1  
              Left/Right s4/s2
              Select     s5  

Pin Usage:    Pin type/number     Hardware 
              Digital / 13        LED 
              
              Digital / 11        Left Contact Switch
              Digital / 12        Right Contact Switch
             
              Analog / A7         Onboard Buttons 

              Digital / 4         DC Motor direction
              Analog  / 5         DC Motor Power

              Analog / A5         IR sensor circuit

              Digital / 9         Launcher Servo

              Analog / A6         Solenoid Motor Power
              Digital / 7         Solenoid Direction

              digital / 10        reloader servo motor
                                
              
*******************************************************************/
 
/****************************
 ** #defines and #includes **
 ****************************/ 
#include<Servo.h>
/***********************
 ** Global Variables ***
 ***********************/
  // *** Declare & Initialize Pins ***
  // GVariables for IR LED Sketch
      const int irPin = 13;
      
  // GVarables for Switch Sketch
      const int switchL = 11; 
      const int switchR = 12;
  
  // GVariables for Test Button Sketch
      const int pushPin = A7;
    
  // GVariables for DC motor Sketch
      const int pinDirectDc = 4;
      const int pinPwrDc = 5; 

  // GVariables for IR Sensor
      const int irSensor = A5;
      
  // GVariables for Encoder
      bool black = 1; // Stores a 1 if the IR reflectance sensor is over a black stripe or a 0 if over a white stripe.

  // GVariables for i_aim_fire
      const int launcherServoPin = 9; 
      const int solenoidPowPin = 6;
      const int solenoidDirectPin = 7; 

  // GVariables for J_Reload
     const int reloaderServoPin = 10;


                             
// *** Create Servo Objects ***
   Servo launcherServo;
   Servo reloaderServo;
// *** Declare & Initialize Program Variables ***
  // Variables for print menu
      char userInput = 'z';                // 1 means user just entered a letter
      bool newUserInput = 1;               // 0 means user did not enter a letter this time through the loop function
                                          
                       
  // Variables for IR LED Sketch
      int ledOnTime = 1000;                 // Length of time in milliseconds that the LED should stay on
      int ledOffTime = 2000;                // Length of time in milliseconds that the LED should stay off
      unsigned long blinkTime = 0;          // Time* that the LED last turned on or off (*in milliseconds, as returned by the millis() function)
      unsigned long timeSinceLastBlink = 0; // Length of time in milliseconds that has elapsed since the LED last turned on or off
      bool ledOn = 0;                       // Flag variable used to keep track of whether or not the LED is on (1) or off (0). 
                                                // You will need to assign a 1 to this variable every time you turn the LED on and 
                                                // assign a 0 to this variable every time you turn the LED off.
  // Variables for Switch Sketch
     int leftSwitchState = 0;               // Stores the state (0 = open or 1 = closed) of the left switch
     int rightSwitchState = 0;              // Stores the state (0 = open or 1 = closed) of the right switch
     unsigned long printTime = 0;           // Time* that the switch states were last printed to the Serial Monitor 
                                                 // (*in milliseconds, as returned by the millis() (Links to an external site.) function)
     unsigned long timeSinceLastPrint = 0;  // Length of time in milliseconds that has elapsed since the last message printed  
     int printDelay = 2000;                 // Desired length of time between printed messages when the switch states are not changing

  // Updated Variables for Switch Sketch
      unsigned long leftSwitchChangeTime = 0;            // Time* that the left switch last changed state 
      unsigned long rightSwitchChangeTime = 0;          // Time that the right switch last changed state
      unsigned long timeSinceLastLeftSwitchChange = 0;  // Length of time in milliseconds that has elapsed since the left switch last changed state
      unsigned long timeSinceLastRightSwitchChange = 0; // Length of time in milliseconds that has elapsed since the right switch last changed state
      int switchDebounceTime = 10;                      // Time in milliseconds to wait for the switches to stop bouncing (20 ms may be too long; you can lower this value as appropriate)

  // Variables for Button Test Sketch
      int buttonNumber = 0;                  // Stores the number of the button that corresponds to the 0 to1023 value read from pin A7
      unsigned long cibn = 0;                // cibn stands for consecutive identical button numbers
                                                  // Keeps track of how many times in a row buttonNumber is the same
      int buttonPressed = 0;                 // Stores the number of the button that has actually been pressed

  // Variables for DebugPrint function
      unsigned long debugPrintTime = 0;
      unsigned long debugTimeSinceLastPrint = 0;
      int debugPrintDelay = 200;  // you can choose this time

   // Variables for DebugBlink function
      const int debugLedPin = 13;   // onboard LED
      unsigned long debugBlinkTime = 0;
      unsigned long debugTimeSinceLastBlink = 0;
      int debugLedHiLo = 0;

    // Variables for DC Motor Sketch
      const int motorPwr = 255;           // full power
      bool motorOn = 0;                   // Flag variable used to keep track whether the motor is on (motorOn = 1) or off (motorOn = 0)
      bool motorRight = 0;                // Flag variable used to keep track whether the motor is to the right (motorRight = 1) or to the left (motorRight = 0)

    // Variables for IR Sensor Sketch
      int irSensorValue = 0; // Stores the 0 to1023 value representing the voltage read from the IR sensor pin
      int lowThreshold = 100; // lowest value is 32
      int highThreshold = 250; // highest was 556

    // Variables for Count Stripes
      unsigned long stripeChangeTime = 0;           //Variable used to keep track of the time at which the IR reflectance sensor moves from a black stripe to a white stripe or vice versa
      unsigned long timeSinceLastStripeChange = 0;  //Variable used to store the time that has elapsed since the IR reflectance sensor moved from stripe to stripe
      int counts = 24;                              //Counter variable used to store the stripe number that the IR reflectance sensor is over

      unsigned long incrementTime = 0;
      unsigned long timeSinceLastIncrement = 0;   //incrementTime and timeSinceLastIncrement will be used to control the speed at which a variable's value is incremented by a button press
      
    // Variables for m_motion
      bool startMotion = 0;  //When true, this flag variable indicates that the launcher should start moving somewhere. 
                             //When the motor is turned on and the launcher starts moving, startMotion should be set to false.

    // Variables for TestMoveLauncher
      int desiredPosition = 24;

    // Variables for Test Aim Fire
      int desiredServoAngle = 90;
      int servoAngleIncrement = 5;
      int state = 0;                                 // Variable used to control what action is taken
      unsigned long stateChangeTime = 0;             // Variable used to keep track of the time that state changed value
      unsigned long timeSinceLastStateChange = 0;    // Variable used to store the time that has elapsed since state changed value
      int solenoidPower = 255;
      int solenoidActivationTime = 500;              // milliseconds, time solenoid is on

    // Variables for Test Reloader
      int holdAngle = 30;       // a guess for servo angle that holds ball
      int dispenseAngle = 0;   // a guess for servo angle that will drop the ball
      int dispenseDelay = 0; // ms time between lowering link rod and raising the link rod
      int receiveAngle = 55; 
      int reloaderDownDelay = 300; // leave this at 200 temp to 300 for test
      int LauncherAtReloaderDelay = 75;
    // Variables for demo 1
      int target = 0;                                // You will use this variable to keep track of which target you are on.
      int headed = 0;                                // You will use this variable to specify where the launcher should move next, 0 home, 1 next target, 2 reload
      int driveTo[6] = {19, 35, 33, 31, 32, 34};      // stripe locations for 6 targets
    
    // Variables for AtTarget
      int writeToServo[] = {140,110,130,90,120,80};

    // Variables for demo 3
      float xTargetVec[6] = {0.7, 0.8, 0.9, 1.0, 1.1, 1.2};
      float alpha = 38.4;
      float beta = 0.015;
      float thetaL0 = 11.77;
      float k = 3.279;
      float lambda = -0.0022;

    // Variables to for turn motor off function changeable
    int reverseDelay = 5;
    

      
     
/********************
 ** Setup Function **
 ********************/  
void setup(void){
  // PUT YOUR SETUP CODE HERE, TO RUN ONCE:

  // *** Initialize Serial Communication ***
  Serial.begin(9600);
 
  // *** Configure Digital Pins & Attach Servos ***
  // IR Pin 
  pinMode(irPin, OUTPUT);             // irPin output setup

  // Switch Pin
  pinMode(switchL, INPUT_PULLUP);      // Left switch pin setup
  pinMode(switchR, INPUT_PULLUP);      // Right switch pin setup

  // DC Motor Pin
  pinMode(pinDirectDc, OUTPUT);
  pinMode(pinPwrDc, OUTPUT);

  // Attatching Launcher Servo Pin to Launcher Servo
  launcherServo.attach(launcherServoPin);

  // Solenoid Direction Pin
  pinMode(solenoidDirectPin, OUTPUT);

  // Attatching Reloader Servo pin top Reloader Servo
  reloaderServo.attach(reloaderServoPin);
  
  
  // *** Take Initial Readings ***

  black = GetEncoderBoolean();
  
  // *** Move Hardware to Desired Initial Positions ***
  
  reloaderServo.write(holdAngle);
  
}// end setup() function

/*******************
 ** Loop Function **
 *******************/
void loop(void){
  //PUT YOUR MAIN CODE HERE, TO RUN REPEATEDLY
  //Serial.print(Serial.available());
  //Serial.println( " bytes available to read");
  
  if (Serial.available() >=2){
  userInput = Serial.read();
  Serial.read();
  Serial.print(F("User entered "));
  Serial.println(userInput);
  newUserInput = 1;
  }
  
  switch(userInput){
     /* case 'a':
      // do something once
      if (newUserInput == 1){
        // CODE HERE(once)
        newUserInput = 0; // DO NOTE DELETE!!
      }
      // do something ever and over
      // CODE HERE (over and over)
      break;*/
    
    case 'a':
    // do something once
    if (newUserInput == 1){
      Serial.println(F("Test a: Check that IR LED is blinking"));
      newUserInput = 0; // DO NOTE DELETE!!
    }
    // call testing function
    TestIRLED();
    break;

    case 'b':
    if (newUserInput == 1){
      Serial.println(F("Test b: Press the switches to test"));
      newUserInput = 0; // DO NOTE DELETE!!
    }
    TestSwitches();
    break;

    case 'c':
    if (newUserInput == 1){
      Serial.println(F("Test b: Press the buttons to test"));
      newUserInput = 0; // DO NOTE DELETE!!
    }
    TestButtons();
    break;
    
    case 'd':
      if (newUserInput == 1){
        Serial.println(F("Press the left and right buttons to test the motor"));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestMotor();
      // CODE HERE (over and over)
      break;
      
    case 'e':
      if (newUserInput == 1){
        Serial.println(F("Press the left and right buttons to test the motor and sensor"));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestMotor();
      // CODE HERE (over and over)
      break;

    case 'f':
      if (newUserInput == 1){
        Serial.println(F("Press the left and right buttons to test the motor and encoder"));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestMotor();
      // CODE HERE (over and over)
      break;

    case 'g':
      if (newUserInput == 1){
        Serial.println(F("Press the left and right buttons to count stripes."));
        Serial.println(F("Press the up and down buttons to increment counts."));
        Serial.println(F("Press the select button to set counts to 24."));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestMotor();
      // CODE HERE (over and over)
      break;

    case 'h':
      if (newUserInput == 1){
        startMotion = 0;
        Serial.println(F("Press the left and right buttons to increment desiredPosition."));
        Serial.println(F("Press the up and down buttons to increment counts."));
        Serial.println(F("Press the select button to send the launcher to the desired position."));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestMoveLauncher();
      // CODE HERE (over and over)
      break;

    case 'i':
      if (newUserInput == 1){
        Serial.println(F("Press the up/down/left/right buttons to increment the desired servo angle."));
        Serial.println(F("Press the select button to command the servo and fire the solenoid."));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestAimFire();
      // CODE HERE (over and over)
      break;

      case 'j':
      if (newUserInput == 1){
        Serial.println(F("Press the select button to reload a ball."));
        newUserInput = 0; // DO NOTE DELETE!!
      }
      TestReloader();
      // CODE HERE (over and over)
      break;

      case 'k':
      if (newUserInput == 1){
        Serial.println(F("Press the left and right buttons to increment headed."));
        Serial.println(F("Press the up and down buttons to increment target."));
        Serial.println(F("Press the select button to start Demo 1."));
        newUserInput = 0; // DO NOTE DELETE!!
        startMotion = 0;
      }
      Demo1();
      // CODE HERE (over and over)
      break;

     case 's': // will get data from MATLAB
     Serial.println(F("Getting data from MATLAB"));
     GetDataFromMATLAB();
     userInput = 'x';
     Serial.println(F("done"));
     break;

     
     case 't': // will get data from MATLAB
     GetDataFromMATLAB();
     ComputeStuff();
     userInput = 'x';
     Serial.println(F("done"));
     break;

      case 'v':
      if (newUserInput == 1){
        Serial.println(F("Running Demo 4/competition code"));
        newUserInput = 0; // DO NOTE DELETE!!
        GetDataFromMATLAB();
        state = 1;
        startMotion = 1;
      }
      Demo1();
      break;
     
     case 'z':
    // do something once
    if (newUserInput == 1){
      PrintMenu();
      newUserInput = 0; // DO NOTE DELETE!!
    }
    break;
    
    default:
    // do something once
    if (newUserInput == 1){
      Serial.println(F("Waiting for a valid user input"));
      Serial.println(F("Enter z to print menu"));
      newUserInput = 0; // DO NOTE DELETE!!
      if (motorOn == 1){
        TurnMotorOff(reverseDelay);
        Serial.println(F("Killing motion"));
        startMotion = 0;
        headed = 0;
        target = 0;
      }
    }
    // do something ever and over
    // CODE HERE (over and over)
    break;
  }
} // end loop() function

/****************************
 ** User-Defined Functions **
 ****************************/
// create custom headers as necessary to clearly organize your sketch
// e.g., Button functions, DC Motor functions, Servo functions, etc.

//TurnMotorOn
    //Inputs: none
    //Outputs: none
    void TurnMotorOn(void){
        if(motorOn == 0){
          digitalWrite(pinDirectDc, motorRight);
          analogWrite(pinPwrDc, motorPwr);
          motorOn = 1; 
        }
        if(counts < 40 && headed == 2){
        
        launcherServo.write(receiveAngle);
        }
     
    }

//TurnMotorOff
    //Inputs: int reverseTime
    //Outputs: none
    void TurnMotorOff(int reverseTime){
        if(motorOn == 1){
          analogWrite(pinPwrDc, 0);
          motorOn = 0;
          delay(10);
          if (motorRight == 1){
            digitalWrite(pinDirectDc, !motorRight);
            analogWrite(pinPwrDc, motorPwr);
            delay(reverseTime);
            analogWrite(pinPwrDc, 0);
            motorOn = 0;
          }
          else{
            digitalWrite(pinDirectDc, !motorRight);
            analogWrite(pinPwrDc, motorPwr);
            delay(reverseTime);
            analogWrite(pinPwrDc, 0);
            motorOn = 0;
          }
        }
    }

// Function GetEncoderBoolean
    //Inputs: none
    //Outputs: boolean value
    // Reads the IR sensor value and returns: 1 (true) if the IR sensor is over a BLACK stripe
                                          //  0 (false) if the IR sensor is over a WHITE stripe
    bool GetEncoderBoolean(void){
      irSensorValue = analogRead(irSensor);
      if(black == 1 && irSensorValue < lowThreshold){
        return 0;
      }
      else if(black == 0 && irSensorValue > highThreshold){
      return 1; 
      }
      else{
      return black;
    }
    }

// Function CountStripes
    //Inputs: none
    //Outputs: none
    //Increments a counter variable (counts) each time the IR sensor moves from a white stripe to a black stripe or vice versa.
    void CountStripes(void){    
      int prevBlack = black;
      black = GetEncoderBoolean();
      timeSinceLastStripeChange = millis() - stripeChangeTime;
      if(black != prevBlack){
        stripeChangeTime = millis();
        if(motorRight == 1){
          counts = counts + 1;
        }
        else{
          counts = counts - 1;
        }
        Serial.print(F("Stripe # "));
        Serial.print(counts);
        Serial.print(F(" tslsc is "));
        Serial.println(timeSinceLastStripeChange);
      }
    }

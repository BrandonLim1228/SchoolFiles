#include <SoftwareSerial.h>

SoftwareSerial mySerial(2, 3); // RX, TX
float t_old = 0;
int LEDval = 0;
float servoAngle = 0;
float t_ms = 0;
float t = 0;

void setup()  
{
  // Open serial communications with computer and wait for port to open:
  Serial.begin(9600);

  // Print a message to the computer through the USB
  Serial.println("Hello Computer!");

  // Open serial communications with the other Arduino board
  mySerial.begin(9600);

  // Send a message to the other Arduino board
  mySerial.print("Hello other Arduino!");
}

void loop() // run over and over
{

  // if(Serial.available()){
  //   mySerial.println(Serial.readStringUntil('\n'));
  // }

  // if(mySerial.available()){
  //   Serial.println(mySerial.readStringUntil('\n'));
  // }
  
  // Definining data to be sent
  t_ms = millis();
  t = float(t_ms)/1000.0;
  if(t-t_old>1){
    if(LEDval == 0){
      LEDval = 1; 
    } 
    else { 
      LEDval = 0;
    }
    t_old = t;
  }
  servoAngle = int(125*sin(t)) + 127;

  // Sending data
  mySerial.write(255);
  mySerial.write(LEDval);
  mySerial.write(servoAngle);
  delay(20);
}

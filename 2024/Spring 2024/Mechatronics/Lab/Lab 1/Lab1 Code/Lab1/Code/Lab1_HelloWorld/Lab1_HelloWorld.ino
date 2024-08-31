unsigned long time = 0;
unsigned long timeold = 0;

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
time = millis();
if(time-timeold >= 2000){
  Serial.print("Hello World - ");
  Serial.print(float(time)/1000);
  Serial.println(" sec");
  timeold = time;
}
}

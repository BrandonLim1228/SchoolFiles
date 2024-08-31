void GetDataFromMATLAB (void){
  Serial.println(F("ready for data"));               //  print special message to trigger action in MATLAB
  Serial.println(F("Getting data from MatLab"));
  for(int target = 0; target<=5; ++target){
      
      String dataString1 = Serial.readStringUntil('\n'); // read first string sent from MATLAB
      String dataString2 = Serial.readStringUntil('\n'); // read second string sent from MATLAB
      int stripeInt = dataString1.toInt();               // convert first string to integer
      float targetFloat = dataString2.toFloat();         // convert second string to float
      
      driveTo[target] = stripeInt;
      xTargetVec[target] = targetFloat; 
      
      Serial.print(F("For target "));
      Serial.print(target);
      Serial.print(F(", "));
      Serial.print("Drive to stripe ");
      // Serial.print(dataString1);
      Serial.print(driveTo[target]);
      Serial.print(F(" and aim for "));
      // Serial.print(dataString2);
      Serial.print(xTargetVec[target], 3);
      Serial.println(F(" m"));
  }
  target = 0;
  
  // get linkage parameters from MATLAB
  String paramString = Serial.readStringUntil('\n');
  alpha = paramString.toFloat();
  paramString = Serial.readStringUntil('\n');
  beta = paramString.toFloat();
  paramString = Serial.readStringUntil('\n');
  thetaL0 = paramString.toFloat();
 
  /* Serial.print(F("alpha =  "));
   Serial.print(alpha,3);
   Serial.print(F("; beta = "));
   Serial.print(beta,3);
   Serial.print(F("; thetaL0 = "));
   Serial.println(thetaL0,3);*/

  // get velocity coefficents from MATLAB
  String coeffString = Serial.readStringUntil('\n');
  k = coeffString.toFloat();
  coeffString = Serial.readStringUntil('\n');
  lambda = coeffString.toFloat();
 
   /*Serial.print(F("Kappa is = "));
   Serial.print(k,4);
   Serial.print(F("; lambda = "));
   Serial.println(lambda,4);*/
  
}

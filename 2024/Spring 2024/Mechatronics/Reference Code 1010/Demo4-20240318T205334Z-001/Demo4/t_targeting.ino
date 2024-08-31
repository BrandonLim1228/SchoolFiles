void ComputeStuff(void){
     Serial.println(F("Performing target calculations"));
     float d[] = {0.0400, 0.1583, 0.0553}; // m
     float H[] = {0.1301, 0.0960, 0.0880, 0.0465}; // m    
     TargetServoAngles( d,  k, lambda, H,alpha, beta, thetaL0, xTargetVec);
     for(int n=0; n <=5; ++n){
      Serial.print(F("To hit a target at "));
      Serial.print(xTargetVec[n]);
      Serial.print(F(" m, command the servo to "));
      Serial.print(writeToServo[n]);
      Serial.println(F(" deg."));
    }
     
}

float Deg2Rad(float angleDeg) {                                                      // degrees to radians conversion function
        float angleRad = angleDeg * (M_PI / 180.0);
         return angleRad;
      }
      
      float Rad2Deg(float angleRad) {                                                      // radians to degrees conversion function
        float angleDeg = angleRad * (180.0 / M_PI );
         return angleDeg;
      }
      
      float Quadratic(float a, float b, float c, int plusOrMinus){                          // quadratic function which returns a positive or negative root 
        float root = (-b + (plusOrMinus) * sqrt(pow(b, 2.0) - 4.0 * a * c)) / (2.0 * a);    // minus returns valid root
        return root;
      }
      
      float LandingDistance(float d[],float k,float lambda, float thetaL){
        float g = 9.81;  // m/s^2
        int plusOrMinus = -1; 
        float x0 = d[1] * cos(Deg2Rad(thetaL)) - d[2] * sin(Deg2Rad(thetaL));             //initial x
        float y0 = d[0] + d[1] * sin(Deg2Rad(thetaL)) + d[2] * cos(Deg2Rad(thetaL));        // initial y
        float v0 = k + lambda * thetaL;
        float v0x = v0 * cos(Deg2Rad(thetaL));                                        // initial x velocity
        float v0y = v0 * sin(Deg2Rad(thetaL));                                        // initial y velocity
        float tLand = Quadratic(-g / 2.0, v0y, y0, -1);                               // computes time to land
        float xLand = x0 + v0x * tLand;                                               // computes horizontal distance
       return xLand; 
      }
      
      float RangeAngle(float d[],float k, float lambda){
        float thetaL = 0;                                           // initializes 0 degree launch angle, this will increase throughout the loop
        float rangeAngle = 0;                                       // creates the output variable
        float range = 0;                                            // creates the range variable
          while(thetaL <= 90){                                      // while loop starts from 0 degrees and runs to 90 degrees
            float xLand = LandingDistance(d, k,lambda, thetaL);  // calls landing distance function to find current distance and assigns it xLand variable
              if(xLand >=range){                                    // if statement makes sure the current xLand is equal or greater than range   
                range = xLand;                                      // rewrites range with current xLand
                rangeAngle = thetaL;                                // rewrites rangeAngle with thetaL
                
              }
          thetaL = thetaL + .5;                                   // .25 is the best time with most accuracy
          }
      return rangeAngle;
      }
      
      float LaunchAngle(float d[],float k, float lambda,float xTarget){                  // function to find a launch angle for a given target distance
        float thetaL = RangeAngle(d, k, lambda);                                   // creates variable thetaL and calls the RangeAngle function to incrementally find the max range to find the "steep" angle
        float xLand = LandingDistance(d, k,lambda, thetaL);                  // creates xLand and calls LandingDistance for the current distance
        while(xLand >= xTarget){                                            // loops until Xland is less and or equal to Xtarget
            thetaL = thetaL + 0.5;                                         // .25 is the best time with most accuracy
            xLand = LandingDistance(d, k,lambda, thetaL);                         // updates xLand with the current landing distance with the new incremental thetaL
        }
      return(thetaL);                                                       //function output returns correct launch angle for target
      }
      float ThetaServo(float H[], float thetaL, float alpha, float beta, float thetaL0){
        thetaL = Deg2Rad(thetaL);
        alpha = Deg2Rad(alpha);
        thetaL0 = Deg2Rad(thetaL0);
        float theta2 = thetaL - thetaL0;
        float k1 = H[0] / H[1];
        float k2 = H[0] / H[3];
        float k3 = (pow(H[0], 2) + pow(H[1], 2) - pow(H[2], 2) + pow(H[3], 2)) / (2 * H[1] * H[3]);
        float a = cos(theta2) - k1 - k2 * cos(theta2) + k3;
        float b = -2 * sin(theta2);
        float c = k1 - (k2 + 1) * cos(theta2) + k3;
        float theta4 = 2 * atan(Quadratic(a, b, c, -1));
        float thetaS = (theta4 + alpha) / (1 - beta);
        thetaS = Rad2Deg(thetaS);
        return thetaS;
      }

   void TargetServoAngles(float d[], float k,float lambda, float H[], float alpha, float beta, float thetaL0, float xTargetVec[]){
    float vecLaunchAngles[6];
    float vecServoAngles[6];
    for(int n = 0; n <= 5; ++n){
      Serial.print(F("Computing target "));
      Serial.println(n);
      vecLaunchAngles[n] = LaunchAngle( d, k,lambda, xTargetVec[n]);
      vecServoAngles[n] = ThetaServo(H, vecLaunchAngles[n], alpha, beta, thetaL0);
      writeToServo[n] = int(round(vecServoAngles[n]));  
      /*Serial.print(F("xTarget [m] = "));
      Serial.print(xTargetVec[n]);
      Serial.print(F(" --> thetaL [deg] = "));
      Serial.print(vecLaunchAngles[n]);
      Serial.print(F(" --> thetaS [deg] = "));
      Serial.print(vecServoAngles[n]);
      Serial.print(F(" --> Rounded thetaS [deg] = "));
      Serial.println(writeToServo[n]);*/
    }
    return;
   }

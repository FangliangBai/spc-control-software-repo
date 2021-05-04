/*

  Dave's Matlab triggered anologue read
  Based on Serial Event example
  Averaged sampling
  Sampling triggered by a new line in Matlab
  v1 28/7/15
  
  Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
*/

String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
unsigned int lux = 0;  // light level
const int numReadings = 100;
float total_lux = 0;
float av_lux = 0;
const int timingPin =  12;      // the number of the timing pin


void setup() {
  // initialize serial:
  Serial.begin(115200);
  Serial.println("SPC");
  // reserve 200 bytes for the inputString:
  inputString.reserve(20);
  analogReference(DEFAULT);
}

void loop() {
  // print the string when a newline arrives:
  if (stringComplete) {
    // loop from the lowest pin to the highest:
    for (int x = 0; x < 100; x++) {
      // Take a reading
      lux = analogRead(A0);
      // Add the reading to the total
      total_lux = total_lux + lux;
    }
    av_lux = total_lux / numReadings;
    Serial.println(av_lux);
    delayMicroseconds(50); // Optional delay for stability
    // digitalWrite(timingPin, LOW); // timing pin goes low
    stringComplete = false;
    total_lux = 0;
  }
}

/*
  SerialEvent occurs whenever a new data comes in the
  hardware serial RX.  This routine is run between each
  time loop() runs, so using delay inside loop can delay
  response.  Multiple bytes of data may be available.
*/
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // Trigger the main loop with a new line:
    if (inChar == '\n') {
      stringComplete = true;
      // digitalWrite(timingPin, HIGH); // timing pin goes high
    }
  }
}

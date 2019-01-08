#include "IRremote.h"

/*
IR receiver code in decimal
0 16750695
1 16753245
2 16736925
3 16769565
4 16720605
5 16712445
6 16761405
7 16769055
8 16754775
9 16748655
* 16738455
# 16756815
UP 16718055
RIGHT 16734885
LEFT 16716015
DOWN 16730805
OK 16726215
*/
#define num_buttons  17
// The number of buttons found in the remote
long remote_val[num_buttons] = { 16750695,16753245,16736925,16769565,
                                  16720605,16712445,16761405,16769055,
                                  16754775,16748655,16738455,16756815,
                                  16718055,16734885,16716015,16730805,
                                  16726215
                                  };
// Button names array that keeps the name of each receiver code button
String button_names[num_buttons] = {"0", "1","2","3",
                                    "4", "5", "6", "7",
                                    "8", "9", "*","#",
                                    "UP", "RIGHT","LEFT", "DOWN",
                                    "OK"
                                   };
// receiver pin for the IR remote arduino
int RECV_PIN = 8;
// Create an object for the receiver where the results are stored in an object called results
IRrecv irrecv(RECV_PIN);
decode_results results;

void setup()
{
  Serial.begin(9600);
  // Set the serial at a baud rate of 9600. Note that it shares with the common serial port used by the arduino during upload hence need to disconnect the HC-05 RX and TX pins during upload any upload
  Serial.println("Ready");
  // Indicate that the serial monitor is ready. This will reflect on the hc-05 or the serial monitor depending on who is connected first.
  // Also used can be used to diagnose whether the bluetooth is sending communication properly. The println operates like a normal print function
  irrecv.enableIRIn(); // Start the receiver or enable
}

void loop()
{
  // Constant loop
  if (irrecv.decode(&results)) // if any results is present from the receiver then carry out the next statements
  {
    Serial.println(results.value);
    // Print the results value. Note the object has a variable named value that has a long data type.
    if (translateIR(results.value) != "None registered button"){ 
      // Check whether the code received is within the lookup table declared from above array
      // if so print the translated results
      Serial.print(translateIR(results.value));// pass the long value to the function and return the button name
    }
    irrecv.resume(); // Receive the next value
  }
}


String translateIR(long val) {
  String button_name; // Create a button name string variable
  boolean finished = false; // loop condition that is set to false at the start of the loop to indicate whether the receiver code matches the array,if it matches the loop is stopped and returns the button name
  //Serial.println(val);
  for (int i = 0; i < num_buttons && finished == false; i++) {
      // run a loop that checks the receiver code with the lookup table created at the start. 
      if (val == remote_val[i] ) {
        // If they match state that the loop is finished by setting it to true and the button name is assigned
        finished = true;
        button_name = button_names[i];
      }
      if (finished == false && i == num_buttons-1){
        // If the receiver code does not match and the loop is at its end the button name is set to none registered button and exits loop
        button_name = "None registered button";
      }
  }
  return button_name;
  // Close the function by returning the button name
}

// Note that this program is written in java and uses the processing ide
// Inorder to run this program effectively please download processing
PImage img;  // Used to create image

int num_buttons = 17; // Set the number of buttons to 17

int[][] button_position = new int[num_buttons][2]; /* The image has buttons represented, so as i don't know their positions off head
and i was lazy to  find their exact positions, i created an array to store where they are as i set them with a click on them individually*/

// In java creating arrays is done this way also unlike c++
// button name array similar to that in arduino
String[] button_name = { "0","1","2", "3",
                                    "4", "5", "6", "7",
                                    "8", "9", "*", "#",
                                    "UP", "RIGHT", "LEFT", "DOWN",
                                    "OK"};

// Create an array of objects called circles which will act as an indicator to show which button has been clicked
// The class is in the next file labeled CIRCLE
Circle[] C = new Circle[num_buttons];
int c_width = 20; // Set the width of the circle used in highlight at 20 pixels

long start_time = millis(); // Record the start time of the program. This will be used to the program from reading bluetooth signals if no data has been sent


boolean buttons_set = false; // Used to set false where the circle positions are set
int b_num=0;  // Record the number of button positions on the image
String serial_input="", temp=""; // Store the serial data from bluetooth in two variables where serial_input is unprocessed input
//and temp is the final processed input for printing on the computer
boolean read = false;

void setup(){
  
  size(360,762); // Set the canvas size to 360 pixels width and 762 pixels height. this is the same size as the image file
  img = loadImage("IR_remote fixed.jpg"); // load the image to the variable img. Note the file has to be set in the processing directory for this to work
   String portName = Serial.list()[0]; // List the serial com ports. Important if you want to use usb instead of bluetooth
  myPort = new Serial(this, "COM7", 9600);     // For my computer the bluetooth com port was "COM7" and baud rate 9600 same as the one on the arduino
}

void draw(){
  // Constand draw loop where the image is drawn first at the canvas starting at 0,0 (the top of the canvas) and end at where the canvas ends
  // width and height are processing variables of the canvas width and height
  image(img, 0,0, width, height);
  if ( myPort.available() > 0) {  // If data is available, from the serial port
    read = false; // Set it to false so to start the reading
    start_time = millis(); // register when it started the read
    val = myPort.read();         // read it and store it in val    
  }  
  if (millis() - start_time <10){
    // To prevent the serial port to hold back the program awaiting input we give it a 10 milliseconds to send the data or we go to the next portion of the program
    // If there are the data is available before the timeout, then store the data. Note the data is set one byte at a time
    // So if a string such as hello world has been set we have to add all individual characters to make up the string
    serial_input = serial_input + (char) val;
    
  }
  else  {
    if (read == false){
      // if the timeout occurs then print the sent charactes only if it has not been read
      println(serial_input);
      temp = serial_input;
      // Store the processed string in temp and set read to true 
      read= true;
      serial_input = ""; // Clear the serial input for new processing of the serial data
      
    }
    
  }
  if ( buttons_set == true){
    // In order to highlight on the image ensure that you have configured where each button exists on the image
      boolean found = false;
     // run a loop where it checks whether the button clicked by the IR remote matches the button names in java
      for (int i=0; i<num_buttons; i++){
        if (temp.toLowerCase().equals(button_name[i].toLowerCase())){
          // if they are equal draw a small circle on the image of the button that matches the button name
          //println("Equal");
          fill(255,0,0); // Set the colour of the circle to red as RGB where R=255 and G=0,and B=0
           textSize(15); // Set the text size to 15 pixels
          text(temp,width/2, 20); // Print the button clicked at position half the width and 20 pixels away from the top
          ellipse(C[i].x, C[i].y, c_width,c_width); // draw an ellipse matching where the circle object was set
        }
      }
    }
}

void mousePressed(){
  // in the event someone clicks the mouse
  if (buttons_set == false ){
    // If you haven't configured the position of the buttons on the image
    if (mousePressed){
        if (mouseButton == LEFT && b_num<17){
          // if its a left click and not all buttons were registered then store the button position on the circle object array
         // mouseX is the where the mouse is positioned on the x axis and mouseY at the y axis
          println("Button ",button_name[b_num],"entered:",mouseX,mouseY); // Indicate to the user which button has been registered
          C[b_num] = new Circle(); // create a new object of the button number
          C[b_num].x = mouseX;
          C[b_num].y = mouseY;
          button_position[b_num][0] = mouseX;
          button_position[b_num][1] = mouseY;
          b_num++;
        }
        else if (mouseButton == RIGHT && b_num>0){
          //delete the position by right click
           b_num--;
          println("Deleted button ", button_name[b_num]);
        }
    }
  }
  if (b_num >=17){
    // if all buttons are registered then state that every button has been set
    buttons_set = true;
    println(buttons_set);
  }
}
void keyPressed(){
  if (key == 'R'){
    // delete all positions if R on the event that R is pressed
      b_num=0;
      buttons_set = false;
      println("erased all positions");
  }
}
void highlight_circle(int x,int y){
  
}

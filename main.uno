// ---------------------------------------------------------------- //
// Arduino Ultrasoninc Sensor HC-SR04 with ROS
// by Muhammad Alhaddad
// ---------------------------------------------------------------- //
#include <ros.h>
#include <ros/time.h>
#include <std_msgs/Float32.h>
#define echoPin 2 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 3 //attach pin D3 Arduino to pin Trig of HC-SR04


long duration; // variable for the duration of sound wave travel
int distance; // variable for the distance measurement
//Set up the ros node and publisher
std_msgs::Float32 sonar_msg;
ros::Publisher pub_sonar("sonar", &sonar_msg);
ros::NodeHandle nh;
void setup() {
  nh.initNode();
  nh.advertise(pub_sonar);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an OUTPUT
  pinMode(echoPin, INPUT); // Sets the echoPin as an INPUT

}
long publisher_timer;
void loop() {
  if (millis() > publisher_timer) {
  // Clears the trigPin condition
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)
  
  sonar_msg.data = distance;
  pub_sonar.publish(&sonar_msg);
  publisher_timer = millis() + 4000; //publish once a second
  }
   nh.spinOnce();
}

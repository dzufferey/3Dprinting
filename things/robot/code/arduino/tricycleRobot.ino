#include <Wire.h>
#include <AccelStepper.h>
#include <Adafruit_MotorShield.h>
#include <Servo.h>
#include "string_functions.h"

///////////
// ports //
///////////

//for the IR sensor
#define sensorPin A2
#define sensorPort 33
#define period 500

//for the servo on which the sensor is mounted
#define servoPin 9
#define servoPort 16

//for the motor
#define motorPin 11
#define motorPort 4

//how often to check the IO
#define inputPeriod 20

////////////
// motors //
////////////

int expires = 0;
boolean motorAttached = false;
Servo motorServo;

///////////////
// IR sensor //
///////////////

int lastPublished = period;
Servo irServo;

///////////////
// bluetooth //
///////////////

int last = 0;
int lastInput = 0;

///////////////
// main loop //
///////////////

void setup() 
{  
  
  Serial.begin(9600);
  Serial.flush();
  
  pinMode(sensorPin, INPUT);
 
  irServo.attach(servoPin);
  irServo.write(90);
  
  /*
  motorServo.attach(motorPin);
  motorServo.write(90);
  motorAttached = true;
  */
  
  last = millis();
}

void loop()
{
  int t = millis();
  int dt = t - last;
  last = t;
  
  //lastInput -= dt;

  //if (lastInput < 0) {
  //  lastInput = inputPeriod;
    processBluetoothData();
  //}


  expires -= dt;
  expires = max(-255, expires);

  if (expires < 0) {
    motorServo.write(90);
    if (expires < -100 && motorAttached) {
      motorServo.detach();
      motorAttached = false;
    }
  }

  //IR sensor
  lastPublished -= dt;
  if (lastPublished < 0) {
    lastPublished = period;
    int value = analogRead(sensorPin);
    sendData(value, sensorPort);
  }
}

void processData(char* data, int inputID)
{
  //sendChar(data, inputID);
  int value = length(data) > 0 ? atoi(data) : 0;
  //sendData(value, inputID);
  
  if (inputID == motorPort) {
    value = (value*90/100) + 90;
    if(!motorAttached) {
      motorServo.attach(motorPin);
      motorAttached = true;
    }
    motorServo.write(value);
    expires = 10000;
    
  } else if (inputID == servoPort) {
    value = (value*90/100) + 90;
    irServo.write(value);
  }

}


char bluetoothData[50];

bool getBluetoothData()
{
  if(!Serial.available())
    return false;
  int index = length(bluetoothData);
  bool terminated = false;
  while(Serial.available() && !terminated && index < 50)
  {
    bluetoothData[index++] = Serial.read();
    //Serial.write(bluetoothData[index-1]);//DEBUG
    terminated = (bluetoothData[index-1] == '\0');
  }
  return terminated;
}

#define dataCommand "DATA"
#define dataRequest "GET"

void processBluetoothData()
{
  if(!getBluetoothData())
    return;
  //DEBUG
  //Serial.print(bluetoothData);
  //Serial.write('\0');
  // Parse data
  bool isRequest = false;
  char data[10];  data[0] = '\0';
  if(indexOf(bluetoothData, dataCommand) >= 0)
    isRequest = false;
  else if(indexOf(bluetoothData, dataRequest) >= 0)
    isRequest = true;
  else
    return;
  char outputIDChar[3]; outputIDChar[0] = '\0';
  char inputIDChar[3]; inputIDChar[0] = '\0';
  int index = 0;
  int btLength = length(bluetoothData);
  for(; index < btLength && bluetoothData[index] != '$'; index++);
  index++; // get passed first dollar sign
  if(!isRequest)
  {
    int dataIndex = 0;
    while(index < btLength && bluetoothData[index] != '$')
      data[dataIndex++] = bluetoothData[index++];
    data[dataIndex] = '\0';
    index++; // get passed second dollar sign
  }
  int idIndex = 0;
  while(index < btLength && bluetoothData[index] != '$')
    outputIDChar[idIndex++] = bluetoothData[index++];
  outputIDChar[idIndex] = '\0';
  index++;
  idIndex = 0;
  while(index < btLength && bluetoothData[index] != '$')
    inputIDChar[idIndex++] = bluetoothData[index++];
  inputIDChar[idIndex] = '\0';

  int outputID = length(outputIDChar) > 0 ? atoi(outputIDChar) : -1;
  int inputID = length(inputIDChar) > 0 ? atoi(inputIDChar) : -1;

  if(isRequest)
  {
  }
  else
  {
    processData(data, inputID);
  }
  
  for (int i = 0; i < 50; i++) {
    bluetoothData[i] = '\0';
  }
}

void sendData(int data, int source)
{
  char toSend[50]; toSend[0] = '\0';
  strcpy(dataCommand, toSend, 50);
  concat(toSend, "$", toSend, 50);
  concatInt(toSend, data, toSend, 50);
  concat(toSend, "$", toSend, 50);
  concatInt(toSend, source, toSend, 50);
  concat(toSend, "$", toSend, 50);
  Serial.print(toSend);
  Serial.write('\0');
}

void sendChar(char* data, int source)
{
  char toSend[50]; toSend[0] = '\0';
  strcpy(dataCommand, toSend, 50);
  concat(toSend, "$", toSend, 50);
  concat(toSend, data, toSend, 50);
  concat(toSend, "$", toSend, 50);
  concatInt(toSend, source, toSend, 50);
  concat(toSend, "$", toSend, 50);
  Serial.print(toSend);
  Serial.write('\0');
}

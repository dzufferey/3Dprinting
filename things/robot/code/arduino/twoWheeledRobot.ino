#include <Wire.h>
#include <AccelStepper.h>
#include <Adafruit_MotorShield.h>
#include <Servo.h>
#include "string_functions.h"
#include "robot.h"

////////////
// motors //
////////////

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 

Adafruit_StepperMotor *motorLeft = AFMS.getStepper(200, 1);
Adafruit_StepperMotor *motorRight = AFMS.getStepper(200, 2);

//https://github.com/adafruit/AccelStepper/blob/master/examples/AFMotor_MultiStepper/AFMotor_MultiStepper.pde
// SINGLE, DOUBLE, INTERLEAVE, or MICROSTEP

int stepFactor = 1;
void forwardstep1() { motorLeft->onestep(FORWARD, SINGLE); }
void backwardstep1() { motorLeft->onestep(BACKWARD, SINGLE); }
void forwardstep2() { motorRight->onestep(FORWARD, SINGLE); }
void backwardstep2() { motorRight->onestep(BACKWARD, SINGLE); }


/*
int stepFactor = 2;
void forwardstep1() { motorLeft->onestep(FORWARD, INTERLEAVE); }
void backwardstep1() { motorLeft->onestep(BACKWARD, INTERLEAVE); }
void forwardstep2() { motorRight->onestep(FORWARD, INTERLEAVE); }
void backwardstep2() { motorRight->onestep(BACKWARD, INTERLEAVE); }
*/

/*
int stepFactor = 16;
void forwardstep1() { motorLeft->onestep(FORWARD, MICROSTEP); }
void backwardstep1() {  motorLeft->onestep(BACKWARD, MICROSTEP); }
void forwardstep2() { motorRight->onestep(FORWARD, MICROSTEP); }
void backwardstep2() { motorRight->onestep(BACKWARD, MICROSTEP); }
*/

//wrap the motors in an accel stepper
AccelStepper stepperLeft(forwardstep1, backwardstep1);
AccelStepper stepperRight(forwardstep2, backwardstep2);


void clamp(int* value, int minValue, int maxValue) {
  *value = min(max(*value, minValue), maxValue);
}

int maxSpeed = stepFactor * 1000;
float accel = stepFactor * 1000;

int nbrStepsLeft = 0;
int nbrStepsRight = 0;
int expires = 0;
int released = 0;

void updateSpeedLeft(int newSpeed) {
  newSpeed *= stepFactor;
  clamp(&newSpeed, -maxSpeed, maxSpeed);
  if (newSpeed != nbrStepsLeft) {
    nbrStepsLeft = newSpeed;
    stepperLeft.setSpeed(newSpeed);
  }
}

void updateSpeedRight(int newSpeed) {
  newSpeed *= stepFactor;
  clamp(&newSpeed, -maxSpeed, maxSpeed);
  if (newSpeed != nbrStepsRight) {
    nbrStepsRight = newSpeed;
    stepperRight.setSpeed(newSpeed);
  }
}

///////////////
// IR sensor //
///////////////

int lastPublished = period;
Servo irServo;

///////////////
// bluetooth //
///////////////

//http://www.seeedstudio.com/wiki/images/e/e8/BTSoftware_Instruction.pdf
//https://github.com/Seeed-Studio/Bluetooth_Shield_Demo_Code/blob/master/examples/
#define RxD 0
#define TxD 1

//SoftwareSerial blueToothSerial(RxD,TxD);

void setupBlueToothConnection()
{
  pinMode(RxD, INPUT);
  pinMode(TxD, OUTPUT);
  Serial.begin(38400);
  Serial.print("\r\n+STWMOD=0\r\n"); // set the bluetooth work in slave mode
  Serial.print("\r\n+STNA=SeeedBTSlave\r\n"); // set the bluetooth name as "SeeedBTSlave"
  Serial.print("\r\n+STOAUT=1\r\n"); // Permit Paired device to connect me
  Serial.print("\r\n+STAUTO=0\r\n"); // Auto-connection should be forbidden here
  delay(2000); // This delay is required.
  Serial.print("\r\n+INQ=1\r\n"); // make the slave bluetooth inquirable
  //Serial.println("The slave bluetooth is inquirable!");
  delay(2000); // This delay is required.
  Serial.flush();
}

int last = 0;
int lastInput = 0;

///////////////
// main loop //
///////////////

void setup() 
{  
  
  //setupBlueToothConnection();
  Serial.begin(9600);
  //Serial.begin(38400);
  Serial.flush();
  
  pinMode(sensorPin, INPUT);
  
  AFMS.begin();  // create with the default frequency 1.6KHz
 
  irServo.attach(servoPin);
  irServo.write(90);
  
  // Change the i2c clock to 400KHz (instead of 100Khz)
  TWBR = ((F_CPU /400000l) - 16) / 2;
  //if we need to go faster:
  //http://forums.adafruit.com/viewtopic.php?f=31&t=57041&start=15#p292119
  //http://forums.adafruit.com/viewtopic.php?f=31&t=57041&start=30#p308248
 
  stepperLeft.setMaxSpeed(maxSpeed * 1.0f);
  stepperLeft.setAcceleration(accel);
  stepperLeft.setSpeed(0.0);
  
  stepperRight.setMaxSpeed(maxSpeed * 1.0f);
  stepperRight.setAcceleration(accel);
  stepperRight.setSpeed(0.0);
  
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
    updateSpeedLeft(0);
    updateSpeedRight(0);
    if (expires < -100) {
      if (released == 0) {
        motorLeft->release();
        motorRight->release();
        released = 1;
      }
    }
  } else {
    stepperLeft.runSpeed();
    stepperRight.runSpeed();
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
  
  if (inputID == leftPort) {
    updateSpeedLeft(value);
    released = 0;
    expires = 10000;
    
  } else if (inputID == rightPort) {
    updateSpeedRight(value);
    released = 0;
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

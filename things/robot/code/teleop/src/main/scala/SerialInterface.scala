package teleop

import jssc._
import java.lang.AutoCloseable


class SerialInterface(
  port: String,
  baudRate: Int = SerialPort.BAUDRATE_9600,
  dataBits: Int = SerialPort.DATABITS_8, 
  stopBits: Int = SerialPort.STOPBITS_1,
  parity: Int = SerialPort.PARITY_NONE) extends AutoCloseable
{

  //port
  private var opened = false
  private val serialPort = new SerialPort(port)

  def initialize() {
    if (!opened) {
      opened = true
      serialPort.openPort()
      serialPort.setParams(baudRate, dataBits, stopBits, parity) 
      serialPort.addEventListener(listener)
    }
  }

  def close() {
    if (opened) {
      serialPort.closePort();
      opened = false
    }
  }

  private def makeByteSeq(i1: Int, i2: Int, i3: Int): Array[Byte] = {

    @inline def b0(v: Int): Byte = (v & 0xff).toByte
    @inline def b1(v: Int): Byte = ((v >> 8) & 0xff).toByte
    @inline def b2(v: Int): Byte = ((v >> 16) & 0xff).toByte
    @inline def b3(v: Int): Byte = ((v >> 24) & 0xff).toByte

    Array[Byte](
      b0(i1), b1(i1),// b2(i1), b3(i1),
      b0(i2), b1(i2),// b2(i2), b3(i2),
      b0(i3), b1(i3)//, b2(i3), b3(i3)
    )
  }

  def write(left: Int, right: Int, duration: Int) {
    if (opened) {
      val bytes = makeByteSeq(left, right, duration)
      //Console.println("sending " + bytes.mkString(", "))
      serialPort.writeBytes(bytes)
    }
  }

  //https://code.google.com/p/java-simple-serial-connector/wiki/jSSC_examples
  val listener = new SerialPortEventListener {

    var acc = 0
    var i = 0
 
    def push(byte: Byte) {
      acc = (acc >> 8) & 0xFF;
      acc |= (byte.toInt << 8) & 0xFF00;
      i += 1
      if (i >= 2) {
        println("received: " + acc)
        acc = 0
        i = 0
      }
    }

    def push(bytes: Array[Byte]) {
      bytes foreach push
    }

    def serialEvent(event: SerialPortEvent) {
      if(event.isRXCHAR()){//If data is available
        val size = event.getEventValue()
        val buffer = serialPort.readBytes(size);
        //buffer foreach push
        for (b <- buffer) Console.print(b.asInstanceOf[Char])
      } else {
        println("some other event ...")
      }
    }
  }

}

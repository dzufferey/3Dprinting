package teleop

import javax.swing._
import java.awt._
import java.awt.event._

class GUI extends JFrame {

  private var robot: Option[SerialInterface] = None

  setTitle("teleop control")

  val portLabel = new JLabel("port:")
  val portTextField = new JTextField("/dev/ttyACM0", 20)
  val connect = new JButton("connect")

  val lTF = new JFormattedTextField(0)
  val rTF = new JFormattedTextField(0)
  val dTF = new JFormattedTextField(0)
  val move = new JButton("move")

  val status = new JLabel("")

  private def initGUI {
    setLayout(new BorderLayout())

    val topRow = new JPanel()
    topRow.setLayout(new FlowLayout())
    topRow.add(portLabel)
    topRow.add(portTextField)
    topRow.add(connect)
    
    val centerPane = new JPanel

    val moveRow = new JPanel()
    moveRow.setLayout(new FlowLayout())
    moveRow.add(new JLabel("l:"))
    lTF.setColumns(4)
    moveRow.add(lTF)
    moveRow.add(new JLabel("r:"))
    rTF.setColumns(4)
    moveRow.add(rTF)
    moveRow.add(new JLabel("d:"))
    dTF.setColumns(4)
    moveRow.add(dTF)
    moveRow.add(move)
    centerPane.add(moveRow)

    centerPane.add(Box.createVerticalGlue())
    centerPane.add(new JLabel("..."))
    centerPane.add(Box.createVerticalGlue())


    add(topRow, BorderLayout.NORTH)
    add(centerPane, BorderLayout.CENTER)
    add(status, BorderLayout.SOUTH)

    setSize(600, 400);
    //pack();
  }

  addWindowListener(new WindowAdapter() {
    override def windowClosing(evt: WindowEvent) {
      robot.map(_.close)
      System.exit(0)
    }
  })

  connect.addActionListener(new ActionListener() {
    def actionPerformed(e: ActionEvent) {
      try {
        if (robot.isDefined) {
          robot.map(_.close)
          robot = None
          connect.setText("connect")
        } else {
          val a= new SerialInterface(portTextField.getText().trim())
          a.initialize
          robot = Some(a)
          connect.setText("disconnect")
        }
      } catch {
        case err: Exception =>
          status.setText(err.getMessage())
      }
    }
  })

  private val linCoeff = 50
  private val rotCoeff = 50

  private def dispatch(lin: Int, rot: Int) {
    try {
      val l = linCoeff * lin - rotCoeff * rot
      var r = linCoeff * lin + rotCoeff * rot
      val d = 100
      robot.map(_.write(l, r, d))
      status.setText("sent command: ("+l+", "+r+", "+d+")")
    } catch {
      case err: Exception =>
        status.setText(err.getMessage())
    }
  }

  private class Key(x: Int, y: Int) extends AbstractAction {
    def actionPerformed(e: ActionEvent) {
      dispatch(x,y)
    }
  }
  private def setAction(key: String, action: AbstractAction) {
    status.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(key), key)
    status.getActionMap().put(key, action)
  }
  setAction("UP", new Key(4, 0))
  setAction("DOWN", new Key(-4, 0))
  setAction("LEFT", new Key(0, 1))
  setAction("RIGHT", new Key(0, -1))

  val mouse = new MouseAdapter() {

    val speed = 5
    var x = 0
    var y = 0

    override def mousePressed(e: MouseEvent) {
      if (e.getButton() == MouseEvent.BUTTON1) {
        x = e.getX()
        y = e.getY()
      }
    }

    override def mouseClicked(e: MouseEvent) {
      if (e.getButton() == MouseEvent.BUTTON3) {
      }
    }

    override def mouseDragged(e: MouseEvent) {
      val mask = InputEvent.BUTTON1_DOWN_MASK;
        if ((e.getModifiersEx() & mask) == mask) {
          val x2 = e.getX()
          val y2 = e.getY()
          val dx = (x2 - x) / speed
          val dy = (y2 - y) / speed
          if(dx != 0) x = x2
          if(dy != 0) y = y2
          dispatch(-dy, dx)
        }
      }

    override def mouseWheelMoved(e: MouseWheelEvent) {
    }
  }

  addMouseListener(mouse)
  addMouseMotionListener(mouse)
  addMouseWheelListener(mouse)
                                                                                                                 
  move.addActionListener(new ActionListener() {
    def actionPerformed(e: ActionEvent) {
      try {
        val x = lTF.getText().toInt
        val y = rTF.getText().toInt
        val z = dTF.getText().toInt
        robot.map(_.write(x, y, z))
        status.setText("sent command: ("+x+", "+y+", "+z+")")
      } catch {
        case err: Exception =>
          status.setText(err.getMessage())
      }
    }
  })

  initGUI
  setVisible(true)

}

object GUI {

  def main(args: Array[String]) {
    new GUI
  }

}



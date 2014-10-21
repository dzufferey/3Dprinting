name := "2 wheeled robot teleop"

version := "0.1-SNAPSHOT"

scalaVersion := "2.11.2"

scalacOptions in Compile ++= Seq("-unchecked", "-deprecation")

libraryDependencies ++=  Seq(
    "org.scalatest" %% "scalatest" % "2.2.0" % "test",
    "commons-codec" % "commons-codec" % "1.9",
    "org.scream3r" % "jssc" % "2.8.0"
)

logBuffered in Test := false

parallelExecution in Test := false

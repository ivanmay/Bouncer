name := """Bouncer"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayJava)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  cache,
  "org.postgresql" % "postgresql" % "9.4.1212.jre7",
  "com.typesafe.play" %% "anorm"  % "2.4.0",
  "io.github.nremond" %% "pbkdf2-scala" % "0.5"
)

package models

sealed trait Entity

object Entity {
  private val values = Seq(USER, SERVICE)

  case object USER extends Entity

  case object SERVICE extends Entity

  def from (name: String) = values.find(_.toString == name.toUpperCase).
    getOrElse(throw new IllegalArgumentException(s"Not a valid entity: $name"))
}

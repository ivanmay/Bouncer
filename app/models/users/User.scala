package models.users

import models.roles.Roles
import anorm._

case class User (
  id: Long,
  primaryId: String,
  secondaryIds: List[String],
  roles: List[Roles]
)

object User {
  def create (primaryId: Long, password: String): Int = {

  }
}
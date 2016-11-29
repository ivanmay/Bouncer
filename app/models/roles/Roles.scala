package models.roles

case class Roles (
  id: Long,
  description: String,
  children: List[Roles]
)
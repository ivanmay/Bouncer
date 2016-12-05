package models.entities

import anorm._

/**
  * Created by ivanmay on 2016/11/30.
  */
case class Entity (
  id: Long,
  primaryLogin: String,
  entityType: Entity
)

object Entity {

  def create (primaryLogin: String, entityType: Entity): Int = {
    SQL"""
      INSERT INTO
      VALUES
      """
  }
}

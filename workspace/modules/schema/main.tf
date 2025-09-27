resource "snowflake_schema" "schemas" {
  for_each  = var.workspace_map
  database  = var.database_name
  name      = upper(each.value.name)
  comment   = "Workspace schema for ${each.value.name}"
}

# Tech roles
resource "snowflake_role" "writer" {
  for_each = var.workspace_map
  name     = "_WORKSPACE__${upper(each.value.name)}__WRITER"
}

resource "snowflake_role" "reader" {
  for_each = var.workspace_map
  name     = "_WORKSPACE__${upper(each.value.name)}__READER"
}

output "schemas" {
  value = [for s in snowflake_schema.schemas : s.name]
}

variable "workspace_map" {
  type = map(object({
    name                        = string
    relationship_service_reader = list(string)
    relationship_service_writer = list(string)
    relationship_team_reader    = list(string)
    relationship_team_writer    = list(string)
  }))
}

variable "database_name" {}

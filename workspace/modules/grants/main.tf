# Writer grants
resource "snowflake_role_grants" "writers" {
  for_each = var.workspace_map

  role_name = "_WORKSPACE__${upper(each.value.name)}__WRITER"
  roles     = [
    for w in concat(each.value.relationship_team_writer, var.all_workspace_team_writer) :
    "WORKSPACE_${upper(w)}_ROLE"
  ]
}

# Reader grants
resource "snowflake_role_grants" "readers" {
  for_each = {
    for k, v in var.workspace_map : k => v if length(v.relationship_team_reader) > 0
  }

  role_name = "_WORKSPACE__${upper(each.value.name)}__READER"
  roles     = [for r in each.value.relationship_team_reader : "WORKSPACE_${upper(r)}_ROLE"]
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

variable "all_workspace_team_writer" {
  type = list(string)
}

variable "database_name" {}

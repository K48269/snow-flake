

resource "snowflake_database" "workspace" {
  name                         = "WORKSPACE"
  data_retention_time_in_days = 1
}

resource "snowflake_schema" "workspace_schema" {
  for_each   = var.workspace
  name       = each.value.name
  database   = snowflake_database.workspace.name
  is_managed = true
}

resource "snowflake_role" "writer" {
  for_each = var.workspace
  name     = "_WORKSPACE__${each.value.name}__WRITER"
}

resource "snowflake_role" "reader" {
  for_each = var.workspace
  name     = "_WORKSPACE__${each.value.name}__READER"
}

resource "snowflake_schema_grant" "writer_grant" {
  for_each          = var.workspace
  database_name     = snowflake_database.workspace.name
  schema_name       = each.value.name
  privilege         = "USAGE"
  roles             = [snowflake_role.writer[each.key].name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "reader_grant" {
  for_each          = var.workspace
  database_name     = snowflake_database.workspace.name
  schema_name       = each.value.name
  privilege         = "USAGE"
  roles             = [snowflake_role.reader[each.key].name]
  with_grant_option = false
}

resource "snowflake_role_grants" "grant_writer_to_team" {
  for_each = var.workspace

  role_name = snowflake_role.writer[each.key].name
  roles     = concat(each.value.relationship_team_writer, var.all_workspace_team_writer)
}

resource "snowflake_role_grants" "grant_reader_to_team" {
  for_each = var.workspace

  role_name = snowflake_role.reader[each.key].name
  roles     = each.value.relationship_team_reader
}

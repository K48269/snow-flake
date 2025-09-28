

resource "snowflake_database" "workspace" {
  name                         = "WORKSPACE_NEW"
  data_retention_time_in_days = 1
  
  lifecycle {
    prevent_destroy = true
    # ignore_changes = all
}
}

resource "snowflake_schema" "workspace_schema" {
  for_each   = var.workspace
  name       = each.value.name
  database   = snowflake_database.workspace.name
  }

resource "snowflake_role" "writer" {
  for_each = var.workspace
  name     = "_WORKSPACE__${each.value.name}__WRITER"
}

resource "snowflake_role" "reader" {
  for_each = var.workspace
  name     = "_WORKSPACE__${each.value.name}__READER"
}

resource "snowflake_grant_privileges_to_account_role" "writer_grant" {
  for_each          = var.workspace
  database_name     = snowflake_database.workspace.name
  schema_name       = each.value.name
  privilege         = "USAGE"
  roles             = [snowflake_role.writer[each.key].name]
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_account_role" "reader_grant" {
  for_each          = var.workspace
  database_name     = snowflake_database.workspace.name
  schema_name       = each.value.name
  privilege         = "USAGE"
  roles             = [snowflake_role.reader[each.key].name]
  with_grant_option = false
}


resource "snowflake_grant_account_role" "grant_writer_to_team" {
  for_each = {
    for k, v in var.workspace : k => v
    if length(concat(v.relationship_team_writer, var.all_workspace_team_writer)) > 0
  }

  role_name = snowflake_role.writer[each.key].name
  roles     = concat(each.value.relationship_team_writer, var.all_workspace_team_writer)
}



resource "snowflake_grant_account_role" "grant_reader_to_team" {
  for_each = {
    for k, v in var.workspace : k => v
    if length(v.relationship_team_reader) > 0
  }

  role_name = snowflake_role.reader[each.key].name
  roles     = each.value.relationship_team_reader
}

resource "snowflake_role" "team_roles" {
  for_each = toset([
    "DIGITALDA",
    "FPNA",
    "SALESMKTG",
    "RISK_STRATEGY",
    "WORKSPACE_CREDIT_RISK",
    "DIGITALDA_STAGE",
    "DIGITALDA_DBT_STAGE",
    "DIGITALDA_DBT",
    "SALESMKTG_STAGE",
    "PENG",
    "CREDIT_RISK"
  ])
  name = each.key
}



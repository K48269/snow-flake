# Create the database
resource "snowflake_database" "workspace" {
  name                         = "WORKSPACE_NEW"
  data_retention_time_in_days = 1

  lifecycle {
    prevent_destroy = true
  }
}

# Create schemas for each workspace entry
resource "snowflake_schema" "workspace_schema" {
  for_each = var.workspace

  name     = each.value.name
  database = snowflake_database.workspace.name
}

# Create writer account roles for each schema
resource "snowflake_account_role" "writer" {
  for_each = var.workspace

  name = "_WORKSPACE__${each.value.name}__WRITER"
}

# Create reader account roles for each schema
resource "snowflake_account_role" "reader" {
  for_each = var.workspace

  name = "_WORKSPACE__${each.value.name}__READER"
}

# Grant USAGE privilege on schema to writer roles
resource "snowflake_grant_privileges_to_account_role" "writer_grant" {
  for_each = var.workspace

  account_role_name = snowflake_account_role.writer[each.key].name
  privileges        = ["USAGE"]

  on_schema {
    database_name = snowflake_database.workspace.name
    schema_name   = each.value.name
  }
}

# Grant USAGE privilege on schema to reader roles
resource "snowflake_grant_privileges_to_account_role" "reader_grant" {
  for_each = var.workspace

  account_role_name = snowflake_account_role.reader[each.key].name
  privileges        = ["USAGE"]

  on_schema {
    database_name = snowflake_database.workspace.name
    schema_name   = each.value.name
  }
}

# Create team roles
resource "snowflake_account_role" "team_roles" {
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

# Local values to build flattened role relationships
locals {
  writer_grants = flatten([
    for k, v in var.workspace : [
      for team_role in concat(v.relationship_team_writer, var.all_workspace_team_writer) : {
        child_role  = snowflake_account_role.writer[k].name
        parent_role = team_role
      }
    ]
  ])

  reader_grants = flatten([
    for k, v in var.workspace : [
      for team_role in v.relationship_team_reader : {
        child_role  = snowflake_account_role.reader[k].name
        parent_role = team_role
      }
    ]
  ])
}

# Grant writer roles to team roles
resource "snowflake_grant_account_role" "grant_writer_to_team" {
  for_each = {
    for idx, grant in local.writer_grants :
    "${grant.child_role}-${grant.parent_role}" => grant
  }

  account_role_name = each.value.child_role
  parent_role_name  = each.value.parent_role
}

# Grant reader roles to team roles
resource "snowflake_grant_account_role" "grant_reader_to_team" {
  for_each = {
    for idx, grant in local.reader_grants :
    "${grant.child_role}-${grant.parent_role}" => grant
  }

  account_role_name = each.value.child_role
  parent_role_name  = each.value.parent_role
}

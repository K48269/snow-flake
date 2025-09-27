resource "snowflake_database" "this" {
  name                        = var.db_name
  data_retention_time_in_days = var.retention_days
  comment                     = "Workspace Database"
}

output "database_name" {
  value = snowflake_database.this.name
}

variable "db_name" {}
variable "retention_days" {
  default = 1
}

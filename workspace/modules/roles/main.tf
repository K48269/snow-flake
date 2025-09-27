locals {
  all_roles = distinct(concat(var.workspace_developer_roles, var.additional_roles))
}

resource "snowflake_role" "workspace_roles" {
  for_each = toset(local.all_roles)
  name     = "WORKSPACE_${each.key}_ROLE"
}

variable "workspace_developer_roles" {
  type = list(string)
}
variable "additional_roles" {
  type    = list(string)
  default = []
}

output "workspace_roles" {
  value = [for r in snowflake_role.workspace_roles : r.name]
}

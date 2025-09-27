variable "workspace" {
  description = "Map of workspace schemas and their relationships"
  type = map(object({
    name                        = string
    relationship_service_reader = list(string)
    relationship_service_writer = list(string)
    relationship_team_reader    = list(string)
    relationship_team_writer    = list(string)
  }))
}

variable "all_workspace_team_writer" {
  description = "List of team roles that should receive writer access across all workspace schemas"
  type        = list(string)
}

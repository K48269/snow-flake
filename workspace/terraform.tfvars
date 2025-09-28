all_workspace_team_writer = ["PENG"]

#snowflake_region = "ap-south-1"

workspace = {
  DIGITALDA = {
    name                        = "DIGITALDA"
    relationship_service_reader = []
    relationship_service_writer = ["SALESMKTG_SVC"]
    relationship_team_reader    = ["SALESMKTG"]
    relationship_team_writer    = ["DIGITALDA"]
  }
  DIGITALDA_DBT = {
    name                        = "DIGITALDA_DBT"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = ["SALESMKTG"]
    relationship_team_writer    = ["DIGITALDA"]
  }
  DIGITALDA_DBT_STAGE = {
    name                        = "DIGITALDA_DBT_STAGE"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = []
    relationship_team_writer    = ["DIGITALDA"]
  }
  DIGITALDA_STAGE = {
    name                        = "DIGITALDA_STAGE"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = []
    relationship_team_writer    = ["DIGITALDA"]
  }
  FPNA = {
    name                        = "FPNA"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = []
    relationship_team_writer    = ["FPNA"]
  }
  RISK_STRATEGY = {
    name                        = "RISK_STRATEGY"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = []
    relationship_team_writer    = ["RISK_STRATEGY"]
  }
  SALESMKTG = {
    name                        = "SALESMKTG"
    relationship_service_reader = []
    relationship_service_writer = ["SALESMKTG_SAS"]
    relationship_team_reader    = []
    relationship_team_writer    = ["SALESMKTG", "DIGITALDA"]
  }
  SALESMKTG_STAGE = {
    name                        = "SALESMKTG_STAGE"
    relationship_service_reader = []
    relationship_service_writer = ["SALESMKTG_SAS"]
    relationship_team_reader    = []
    relationship_team_writer    = ["SALESMKTG", "DIGITALDA"]
  }
  WORKSPACE_CREDIT_RISK = {
    name                        = "WORKSPACE_CREDIT_RISK"
    relationship_service_reader = []
    relationship_service_writer = []
    relationship_team_reader    = []
    relationship_team_writer    = ["CREDIT_RISK"]
  }
}

terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.60.0" # or latest stable version
    }
  }
}


provider "snowflake" {
  # Authentication methods: username/password, OAuth, or key-pair
  account  = "ZTDMUTS-GJ03540"   # e.g., "xy12345.ap-southeast-1"
  username = "KIRAN123"
  password = "Qawsedrf@@@131"
  role     = "ACCOUNTADMIN"      # optional, defaults to PUBLICs
#  region   = var.snowflake_region    # optional if account includes region
}
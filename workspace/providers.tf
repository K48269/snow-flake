terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "0.97.0"  # check for latest stable
    }
  }
}


provider "snowflake" {
  # Authentication methods: username/password, OAuth, or key-pair
  account  = "ZTDMUTS-GJ03540"   # e.g., "xy12345.ap-southeast-1"
  username = "KIRAN123"
  password = "Qawsedrf@@@131"
  role     = "ACCOUNTADMIN"      # optional, defaults to PUBLICs
  #region   = var.snowflake_region    # optional if account includes region
}
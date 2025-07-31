module "azure" {
  source              = "./azure"
  # pass vars...
}

module "snowflake" {
  source              = "./snowflake"
  azure_pe_id         = module.azure.private_endpoint_id
  # other snowflake vars...
}


provider "azurerm" {
  features = {}
}

resource "azurerm_private_dns_zone" "snowflake" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "snowflake" {
  name                = var.pe_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.pe_name}-connection"
    private_connection_resource_id = var.snowflake_resource_id
    is_manual_connection           = true
    subresource_names              = ["blob"]  # or "sql" based on usage
  }
}

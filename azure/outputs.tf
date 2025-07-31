output "dns_zone_name" {
  value = azurerm_private_dns_zone.snowflake.name
}

output "private_endpoint_id" {
  value = azurerm_private_endpoint.snowflake.id
}


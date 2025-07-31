resource "null_resource" "authorize_privatelink" {
  provisioner "local-exec" {
    command = <<EOT
      snowsql -a ${var.snowflake_account} -u ${var.snowflake_user} \
        --private-key-path ${var.private_key_path} \
        -q "ALTER NETWORK RULE ${var.network_rule_name} SET ALLOWED_PRIVATELINK_ENDPOINTS = ('${var.azure_pe_id}');"
    EOT
  }
}


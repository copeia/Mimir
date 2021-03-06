provider "vault" {
  # This will default to using $VAULT_ADDR

  token = var.vault_token
}

terraform {
  required_providers {
    vault = "< 3.0.0"
  }
}
# This is where the auth mehtod gets mapped to its policy.  In this
# case we have a cert auth method getting mapped to a service(app) specific
# policy that has the correct permissions for a service(app) to be able to
# use the secret backends that have been configured.

# After this has completed and the policy exists in vault an application has
# been onboarded to vault.  You can used the certificate to authenticate and
# it will return a token that is mapped to the service(app) policy.
resource "vault_cert_auth_backend_role" "cert" {
  name                 = var.app
  certificate          = file("../../../config/${var.app}/ca-cert.pem")
  backend              = "cert"
  allowed_common_names = ["${var.app}.com"]
  token_ttl            = 300
  token_max_ttl        = 2628000

  token_policies = ["${var.app}-policy"]
}
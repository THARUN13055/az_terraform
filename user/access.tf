resource "azuread_user" "userA" {
  user_principal_name = "userA@learncloud13055gmail.onmicrosoft.com"
  display_name        = "tharun"
  password            = "SecretP@sswd99!"

}


resource "azurerm_role_assignment" "roleassign" {
  scope                = azurerm_resource_group.learning.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.userA.object_id
}
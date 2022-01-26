data "google_client_config" "current" {}

output "id" {
  value = data.google_client_config.current.id
}

output "region" {
  value = data.google_client_config.current.region
}

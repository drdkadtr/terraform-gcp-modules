variable "region" { type = string }
variable "project_id" { type = string }
#variable "name" { type = string }

variable "number_of_alocated_ip_addresses" {
  type = number
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_address" "static_ips" {
  count  = var.number_of_alocated_ip_addresses
  region = var.region
  name   = format("%s-nat-external-address-%s", var.project_id, count.index)
}

output "self_link" {
  value = [for s in data.google_compute_address.static_ips.*.self_link : s]
}

output "status" {
  value = [for s in data.google_compute_address.static_ips.*.status : s]
}

output "id" {
  value = [for s in data.google_compute_address.static_ips.*.id : s]
}

output "address" {
  value = [for s in data.google_compute_address.static_ips.*.address : s]
}

provider "google" {
  project = local.project_id
  region  = local.region
}

variable "project_id" { type = string }

locals {
  region     = "europe-west2"
  project_id = var.project_id


  status    = flatten(module.static_ips[*].status)
  self_link = flatten(module.static_ips[*].self_link)
  reserved = keys({
    # Note order of args: 
    #... "If the same value appears multiple times in keyslist then the value with the highest index is used in the resulting map."
    for i, v in zipmap(local.self_link, local.status) : i => v
    if contains([v], "RESERVED")
  })

  in_use = keys({
    # Note order of args: 
    #... "If the same value appears multiple times in keyslist then the value with the highest index is used in the resulting map."
    for i, v in zipmap(local.self_link, local.status) : i => v
    if contains([v], "IN_USE")
  })
}

module "static_ips" {
  source = "./data_google_compute_address"
  # Note: resource name is hardcoded in submodule
  number_of_alocated_ip_addresses = 12
  project_id                      = local.project_id
  region                          = local.region
}

output "self_link_reserved" {
  description = "The URI of the RESERVED address"
  value       = local.reserved
}

output "self_link_in_use" {
  description = "The URI of the IN_USE address"
  value       = local.in_use
}

output "address" {
  description = "All IPs in the pool (with satus RESERVED and IN_USE)"
  value       = flatten(module.static_ips[*].address)
}

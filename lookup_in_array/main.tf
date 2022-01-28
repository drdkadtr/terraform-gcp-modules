# https://discuss.hashicorp.com/t/filter-elements-from-object/34826/3
locals {
  self_link = [
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-0",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-1",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-2",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-3",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-4",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-5",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-6",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-7",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-8",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-9",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-10",
    "https://www.googleapis.com/compute/v1/projects/foo/regions/europe-west2/addresses/foo-nat-external-address-11",
  ]
  status = [
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "IN_USE",
    "IN_USE",
    "IN_USE",
    "IN_USE",
    "IN_USE",
    "IN_USE",
    "RESERVED",
    "RESERVED",
  ]

  reserved = keys({
    for i, v in local.self_link : v => local.status[i]
    if local.status[i] == "RESERVED"
  })

  in_use = keys({
    for i, v in local.self_link : v => local.status[i]
    if contains([local.status[i]], "IN_USE")
  })
}

output "reserved" {
  description = "The URI of the RESERVED address"
  value       = local.reserved
}

output "in_use" {
  description = "The URI of the IN_USE address"
  value       = local.in_use
}

output "all" {
  value = { for i, link in local.self_link : link => local.status[i] }
}

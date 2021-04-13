## Enable Service

resource "google_project_service" "artifact_registry_service" {
  for_each = toset(var.services_list)

  project = var.project_id
  service = "${each.key}.googleapis.com"

  disable_dependent_services = true
}


## KMS

resource "google_kms_key_ring" "artifact_registry" {
  name = "${var.project_id}-artifact-registry-keyring"

  project  = var.project_id
  location = var.region
}

resource "google_kms_crypto_key" "instance_key" {
  for_each = var.registry_config

  name     = "${each.key}-repo-key"
  key_ring = google_kms_key_ring.artifact_registry.id

  rotation_period = "2592000s"

}

## Artifact Reg

resource "google_artifact_registry_repository" "repo" {
  for_each = var.registry_config

  provider = google-beta
  project  = var.project_id
  location = lookup(each.value, "location", var.region)
  labels   = lookup(each.value, "labels", { "environment_prefix" : var.environment_prefix })

  repository_id = "${var.project_id}-${each.key}"
  format        = each.value.format

  depends_on = [
    google_project_service.artifact_registry_service
  ]
}

## IAM

data "google_iam_policy" "registry_iam" {

  dynamic "binding" {
    for_each = var.iam_policy
    content {
      role    = "roles/artifactregistry.${binding.key}"
      members = binding.value
    }
  }

}


resource "google_artifact_registry_repository_iam_policy" "iam_policy" {
  provider = google-beta
  for_each = var.registry_config

  project     = var.project_id
  repository  = google_artifact_registry_repository.repo[each.key].name
  location    = google_artifact_registry_repository.repo[each.key].location
  policy_data = data.google_iam_policy.registry_iam.policy_data
}

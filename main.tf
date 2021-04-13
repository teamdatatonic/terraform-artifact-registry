module "artifact-registry" {
  source = "./modules/artifact_registry"

  project_id         = var.project_id
  region             = var.region
  environment_prefix = var.environment_prefix
  registry_config    = var.registry_config
}

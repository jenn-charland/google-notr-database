module "gke-hub" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-hub?ref=v18.0.0"

  project_id = var.project_id

 clusters = {
    demo-cassandra-gcp-cluster = module.cassandra-gcp-cluster.id
  }

 features = {
    appdevexperience             = false
    configmanagement             = true
    identityservice              = false
    multiclusteringress          = null
    servicemesh                  = false
    multiclusterservicediscovery = false
  }
    configmanagement_templates = {
      default = {
        binauthz = true
        config_sync = {
            git = {
              gcp_service_account_email = null
              https_proxy               = null
              policy_dir                = "config-management/overlays/gcp"
              secret_type               = "none"
              source_format             = "unstructured"
              sync_branch               = "main"
              sync_repo                 = var.configsync_repo
              sync_rev                  = null
              sync_wait_secs            = null

            }
          prevent_drift = false
          source_format = "unstructured"
        }
      hierarchy_controller = null
      policy_controller    =  {
        audit_interval_seconds     = 120
        exemptable_namespaces      = []
        log_denies_enabled         = true
        referential_rules_enabled  = true
        template_library_installed = true
      }
      version              = "1.12.2"
    }
  }
    configmanagement_clusters = {
    "default" = [ "demo-cassandra-gcp-cluster"]
  }

  depends_on = [
    module.cassandra-gcp-cluster-nodepool,

  ]
}